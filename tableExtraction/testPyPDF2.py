import PyPDF2
import requests

PDFfilename = "./data/ScannedTables.pdf"  # filename of your PDF/directory where your PDF is stored


def pdfToTable(PDFfilename, apiKey, fileExt, downloadDir):
    fileData = (PDFfilename, open(PDFfilename, 'rb'))
    files = {'f': fileData}
    postUrl = "https://pdftables.com/api?key={0}&format={1}".format(apiKey, fileExt)
    response = requests.post(postUrl, files=files)
    response.raise_for_status()
    with open(downloadDir, "wb") as f:
        f.write(response.content)


pdfToTable(PDFfilename, "ingkehd6bl8s", "csv", "example2.csv")
