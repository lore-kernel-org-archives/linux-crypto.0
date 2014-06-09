From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] crypto: caam - remove duplicate FIFOST_CONT_MASK define
Date: Mon, 9 Jun 2014 18:19:41 +0300
Message-ID: <20140609151941.GN9600@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Alex Porosanu <alexandru.porosanu@freescale.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The FIFOST_CONT_MASK define is cut and pasted twice so we can delete the
second instance.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
index 7e4500f..d397ff9 100644
--- a/drivers/crypto/caam/desc.h
+++ b/drivers/crypto/caam/desc.h
@@ -321,7 +321,6 @@ struct sec4_sg_entry {
 /* Continue - Not the last FIFO store to come */
 #define FIFOST_CONT_SHIFT	23
 #define FIFOST_CONT_MASK	(1 << FIFOST_CONT_SHIFT)
-#define FIFOST_CONT_MASK	(1 << FIFOST_CONT_SHIFT)
 
 /*
  * Extended Length - use 32-bit extended length that
