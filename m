From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 09/12] staging: ccree: avoid unnecessary line continuation
Date: Thu, 13 Jul 2017 11:19:59 +0300
Message-ID: <1499934004-28513-10-git-send-email-gilad@benyossef.com>
References: <1499934004-28513-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1499934004-28513-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Avoid unnecessary line continuation in log function call.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 8a1c408..c6edef0 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -1864,8 +1864,9 @@ static inline void ssi_aead_dump_gcm(
 		SSI_LOG_DEBUG("%s\n", title);
 	}
 
-	SSI_LOG_DEBUG("cipher_mode %d, authsize %d, enc_keylen %d, assoclen %d, cryptlen %d\n", \
-				 ctx->cipher_mode, ctx->authsize, ctx->enc_keylen, req->assoclen, req_ctx->cryptlen);
+	SSI_LOG_DEBUG("cipher_mode %d, authsize %d, enc_keylen %d, assoclen %d, cryptlen %d\n",
+		      ctx->cipher_mode, ctx->authsize, ctx->enc_keylen,
+		      req->assoclen, req_ctx->cryptlen);
 
 	if (ctx->enckey)
 		dump_byte_array("mac key", ctx->enckey, 16);
-- 
2.1.4
