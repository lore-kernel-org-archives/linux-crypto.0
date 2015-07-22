From: Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH 5/8] crypto: nx - use common code for both NX decompress success cases
Date: Wed, 22 Jul 2015 14:26:35 -0400
Message-ID: <1437589598-23917-6-git-send-email-ddstreet@ieee.org>
References: <1437589598-23917-1-git-send-email-ddstreet@ieee.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Dan Streetman <ddstreet@ieee.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437589598-23917-1-git-send-email-ddstreet@ieee.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Replace the duplicated finishing code (set destination buffer length and
set return code to 0) in the case of decompressing a buffer with no header
with a goto to the success case of decompressing a buffer with a header.

This is a trivial change that allows both success cases to use common code,
and includes the pr_debug() msg in both cases as well.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
---
 drivers/crypto/nx/nx-842-crypto.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/nx/nx-842-crypto.c b/drivers/crypto/nx/nx-842-crypto.c
index 3288a70..51ca168 100644
--- a/drivers/crypto/nx/nx-842-crypto.c
+++ b/drivers/crypto/nx/nx-842-crypto.c
@@ -520,10 +520,7 @@ static int nx842_crypto_decompress(struct crypto_tfm *tfm,
 		if (ret)
 			goto unlock;
 
-		*dlen = p.ototal;
-
-		ret = 0;
-		goto unlock;
+		goto success;
 	}
 
 	if (!hdr->groups) {
@@ -557,6 +554,7 @@ static int nx842_crypto_decompress(struct crypto_tfm *tfm,
 			goto unlock;
 	}
 
+success:
 	*dlen = p.ototal;
 
 	pr_debug("decompress total slen %x dlen %x\n", slen, *dlen);
-- 
2.1.0
