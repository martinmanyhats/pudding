class PdfsController < ApplicationController
  before_action :set_pdf, only: %i[ show edit update destroy ]

  # GET /pdfs or /pdfs.json
  def index
    @pdfs = Pdf.all
  end

  # GET /pdfs/1 or /pdfs/1.json
  def show
  end

  # GET /pdfs/new
  def new
    @pdf = Pdf.new
  end

  # GET /pdfs/1/edit
  def edit
  end

  # POST /pdfs or /pdfs.json
  def create
    @pdf = Pdf.new(pdf_params)
    pdf_file = params["pdf_file"]
    @pdf.owner = @pdf.uploaded_by = Current.user
    @pdf.uploaded_filename = pdf_file.original_filename
    @pdf.uploaded_at = DateTime.now
    @pdf.page_count = 42
    p "!!! @pdf #{@pdf.inspect} pdf_file #{@pdf.pdf_file.inspect}"

    respond_to do |format|
      if @pdf.save
        format.html { redirect_to @pdf, notice: "Pdf was successfully created." }
        format.json { render :show, status: :created, location: @pdf }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pdf.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pdfs/1 or /pdfs/1.json
  def update
    respond_to do |format|
      if @pdf.update(pdf_params)
        format.html { redirect_to @pdf, notice: "Pdf was successfully updated." }
        format.json { render :show, status: :ok, location: @pdf }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pdf.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pdfs/1 or /pdfs/1.json
  def destroy
    @pdf.destroy!

    respond_to do |format|
      format.html { redirect_to pdfs_path, status: :see_other, notice: "Pdf was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pdf
      @pdf = Pdf.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def pdf_params
      params.expect(pdf: [ :name, :owner_id, :version, :description, :pdf_file, :page_count, :first_page_number,
                           :uploaded_filename, :uploaded_at, :uploaded_by_id ])
    end
end
