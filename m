From: Colin King <colin.king@canonical.com>
Subject: [PATCH] crypto: chelsio: make arrays sgl_ent_len and dsgl_ent_len static
Date: Thu, 30 Nov 2017 11:32:08 +0000
Message-ID: <20171130113208.3381-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Harsh Jain <harsh@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "avid S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:41091 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752132AbdK3LcP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Nov 2017 06:32:15 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The arrays sgl_ent_len and dsgl_ent_len are local to the source and do
not need to be in global scope, so make them static. Also re-format the
declarations to match the following round_constant array declaration
style.

Cleans up sparse warnings:
drivers/crypto/chelsio/chcr_algo.c:76:14: warning: symbol 'sgl_ent_len'
was not declared. Should it be static?
drivers/crypto/chelsio/chcr_algo.c:81:14: warning: symbol 'dsgl_ent_len'
was not declared. Should it be static?

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/chelsio/chcr_algo.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index e61ec8a46340..b663b93b7d01 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -73,15 +73,19 @@
 
 #define IV AES_BLOCK_SIZE
 
-unsigned int sgl_ent_len[] = {0, 0, 16, 24, 40, 48, 64, 72, 88,
-				96, 112, 120, 136, 144, 160, 168, 184,
-				192, 208, 216, 232, 240, 256, 264, 280,
-				288, 304, 312, 328, 336, 352, 360, 376};
-
-unsigned int dsgl_ent_len[] = {0, 32, 32, 48, 48, 64, 64, 80, 80,
-				112, 112, 128, 128, 144, 144, 160, 160,
-				192, 192, 208, 208, 224, 224, 240, 240,
-				272, 272, 288, 288, 304, 304, 320, 320};
+static unsigned int sgl_ent_len[] = {
+	0, 0, 16, 24, 40, 48, 64, 72, 88,
+	96, 112, 120, 136, 144, 160, 168, 184,
+	192, 208, 216, 232, 240, 256, 264, 280,
+	288, 304, 312, 328, 336, 352, 360, 376
+};
+
+static unsigned int dsgl_ent_len[] = {
+	0, 32, 32, 48, 48, 64, 64, 80, 80,
+	112, 112, 128, 128, 144, 144, 160, 160,
+	192, 192, 208, 208, 224, 224, 240, 240,
+	272, 272, 288, 288, 304, 304, 320, 320
+};
 
 static u32 round_constant[11] = {
 	0x01000000, 0x02000000, 0x04000000, 0x08000000,
-- 
2.14.1
