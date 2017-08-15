From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 14/22] staging: ccree: fix struct init braces
Date: Tue, 15 Aug 2017 09:26:42 +0300
Message-ID: <1502778412-16255-15-git-send-email-gilad@benyossef.com>
References: <1502778412-16255-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-crypto@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
 devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1502778412-16255-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

Put struct init braces on line of it's own.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_hash.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index e2dc5d8..6baa449 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -41,26 +41,42 @@ struct ssi_hash_handle {
 };
 
 static const u32 digest_len_init[] = {
-	0x00000040, 0x00000000, 0x00000000, 0x00000000 };
+	0x00000040, 0x00000000, 0x00000000, 0x00000000
+};
+
 static const u32 md5_init[] = {
-	SHA1_H3, SHA1_H2, SHA1_H1, SHA1_H0 };
+	SHA1_H3, SHA1_H2, SHA1_H1, SHA1_H0
+};
+
 static const u32 sha1_init[] = {
-	SHA1_H4, SHA1_H3, SHA1_H2, SHA1_H1, SHA1_H0 };
+	SHA1_H4, SHA1_H3, SHA1_H2, SHA1_H1, SHA1_H0
+};
+
 static const u32 sha224_init[] = {
 	SHA224_H7, SHA224_H6, SHA224_H5, SHA224_H4,
-	SHA224_H3, SHA224_H2, SHA224_H1, SHA224_H0 };
+	SHA224_H3, SHA224_H2, SHA224_H1, SHA224_H0
+};
+
 static const u32 sha256_init[] = {
 	SHA256_H7, SHA256_H6, SHA256_H5, SHA256_H4,
-	SHA256_H3, SHA256_H2, SHA256_H1, SHA256_H0 };
+	SHA256_H3, SHA256_H2, SHA256_H1, SHA256_H0
+};
+
 #if (DX_DEV_SHA_MAX > 256)
 static const u32 digest_len_sha512_init[] = {
-	0x00000080, 0x00000000, 0x00000000, 0x00000000 };
+	0x00000080, 0x00000000, 0x00000000, 0x00000000
+};
+
 static const u64 sha384_init[] = {
 	SHA384_H7, SHA384_H6, SHA384_H5, SHA384_H4,
-	SHA384_H3, SHA384_H2, SHA384_H1, SHA384_H0 };
+	SHA384_H3, SHA384_H2, SHA384_H1, SHA384_H0
+};
+
 static const u64 sha512_init[] = {
 	SHA512_H7, SHA512_H6, SHA512_H5, SHA512_H4,
-	SHA512_H3, SHA512_H2, SHA512_H1, SHA512_H0 };
+	SHA512_H3, SHA512_H2, SHA512_H1, SHA512_H0
+};
+
 #endif
 
 static void ssi_hash_create_xcbc_setup(struct ahash_request *areq,
-- 
2.1.4
