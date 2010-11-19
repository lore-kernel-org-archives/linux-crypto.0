From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCH v3 0/8] omap-sham: OMAP SHA1/MD5 driver fixes and improvements
Date: Fri, 19 Nov 2010 16:04:21 +0200
Message-ID: <cover.1290174993.git.dmitry.kasatkin@nokia.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: herbert@gondor.hengli.com.au
Return-path: <linux-omap-owner@vger.kernel.org>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

Here is a set of patches which provides fixes and improvements.

Based on Herbert feedback it also includes fixes so that calling final()
is not mandatory.

BR, Dmitry

Dmitry Kasatkin (8):
  omap-sham: uses digest buffer in request context
  omap-sham: DMA initialization fixes for off mode
  omap-sham: error handling improved
  omap-sham: removed redundunt locking
  omap-sham: crypto_ahash_final() now not need to be called.
  omap-sham: hash-in-progress is stored in hw format
  omap-sham: FLAGS_FIRST is redundant and removed
  omap-sham: zero-copy scatterlist handling

 drivers/crypto/omap-sham.c |  379 +++++++++++++++++++++++++-------------------
 1 files changed, 218 insertions(+), 161 deletions(-)

