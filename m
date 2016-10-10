From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH] crypto: ccp - change bitfield type to unsigned ints
Date: Mon, 10 Oct 2016 10:34:24 -0500
Message-ID: <20161010153424.28762.94016.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0051.outbound.protection.outlook.com ([104.47.34.51]:1728
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752920AbcJJQJX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Oct 2016 12:09:23 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Bit fields are not sensitive to endianness, so use
a transparent standard data type

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev.h |   42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index da5f4a6..0d996fe 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -541,23 +541,23 @@ static inline u32 ccp_addr_hi(struct ccp_dma_info *info)
  * word 7: upper 16 bits of key pointer; key memory type
  */
 struct dword0 {
-	__le32 soc:1;
-	__le32 ioc:1;
-	__le32 rsvd1:1;
-	__le32 init:1;
-	__le32 eom:1;		/* AES/SHA only */
-	__le32 function:15;
-	__le32 engine:4;
-	__le32 prot:1;
-	__le32 rsvd2:7;
+	unsigned int soc:1;
+	unsigned int ioc:1;
+	unsigned int rsvd1:1;
+	unsigned int init:1;
+	unsigned int eom:1;		/* AES/SHA only */
+	unsigned int function:15;
+	unsigned int engine:4;
+	unsigned int prot:1;
+	unsigned int rsvd2:7;
 };
 
 struct dword3 {
-	__le32 src_hi:16;
-	__le32 src_mem:2;
-	__le32 lsb_cxt_id:8;
-	__le32 rsvd1:5;
-	__le32 fixed:1;
+	unsigned int  src_hi:16;
+	unsigned int  src_mem:2;
+	unsigned int  lsb_cxt_id:8;
+	unsigned int  rsvd1:5;
+	unsigned int  fixed:1;
 };
 
 union dword4 {
@@ -567,18 +567,18 @@ union dword4 {
 
 union dword5 {
 	struct {
-		__le32 dst_hi:16;
-		__le32 dst_mem:2;
-		__le32 rsvd1:13;
-		__le32 fixed:1;
+		unsigned int  dst_hi:16;
+		unsigned int  dst_mem:2;
+		unsigned int  rsvd1:13;
+		unsigned int  fixed:1;
 	} fields;
 	__le32 sha_len_hi;
 };
 
 struct dword7 {
-	__le32 key_hi:16;
-	__le32 key_mem:2;
-	__le32 rsvd1:14;
+	unsigned int  key_hi:16;
+	unsigned int  key_mem:2;
+	unsigned int  rsvd1:14;
 };
 
 struct ccp5_desc {
