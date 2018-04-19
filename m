From: Varsha Rao <rvarsha016@gmail.com>
Subject: [RESEND PATCH v2] crypto: cavium: zip: Remove unnecessary parentheses
Date: Thu, 19 Apr 2018 21:19:43 +0530
Message-ID: <20180419154943.21983-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Julia Lawall <julia.lawall@lip6.fr>, Joe Perches <joe@perches.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        cocci <cocci@systeme.lip6.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Nicholas Mc Guire <der.herr@hofr.at>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch fixes the clang warning of extraneous parentheses, with the
following coccinelle script.

@@
identifier i;
constant c;
expression e;
@@
(
!((e))
|
-((
\(i == c\|i != c\|i <= c\|i < c\|i >= c\|i > c\)
-))
)

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
Changes in v2:
 - Modified coccinelle script

 drivers/crypto/cavium/zip/zip_regs.h | 42 ++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/cavium/zip/zip_regs.h b/drivers/crypto/cavium/zip/zip_regs.h
index d0be682305c1..874e0236c87e 100644
--- a/drivers/crypto/cavium/zip/zip_regs.h
+++ b/drivers/crypto/cavium/zip/zip_regs.h
@@ -443,7 +443,7 @@ union zip_corex_bist_status {
 
 static inline u64 ZIP_COREX_BIST_STATUS(u64 param1)
 {
-	if (((param1 <= 1)))
+	if (param1 <= 1)
 		return 0x0520ull + (param1 & 1) * 0x8ull;
 	pr_err("ZIP_COREX_BIST_STATUS: %llu\n", param1);
 	return 0;
@@ -537,7 +537,7 @@ union zip_dbg_corex_inst {
 
 static inline u64 ZIP_DBG_COREX_INST(u64 param1)
 {
-	if (((param1 <= 1)))
+	if (param1 <= 1)
 		return 0x0640ull + (param1 & 1) * 0x8ull;
 	pr_err("ZIP_DBG_COREX_INST: %llu\n", param1);
 	return 0;
@@ -568,7 +568,7 @@ union zip_dbg_corex_sta {
 
 static inline u64 ZIP_DBG_COREX_STA(u64 param1)
 {
-	if (((param1 <= 1)))
+	if (param1 <= 1)
 		return 0x0680ull + (param1 & 1) * 0x8ull;
 	pr_err("ZIP_DBG_COREX_STA: %llu\n", param1);
 	return 0;
@@ -599,7 +599,7 @@ union zip_dbg_quex_sta {
 
 static inline u64 ZIP_DBG_QUEX_STA(u64 param1)
 {
-	if (((param1 <= 7)))
+	if (param1 <= 7)
 		return 0x1800ull + (param1 & 7) * 0x8ull;
 	pr_err("ZIP_DBG_QUEX_STA: %llu\n", param1);
 	return 0;
@@ -817,7 +817,7 @@ union zip_msix_pbax {
 
 static inline u64 ZIP_MSIX_PBAX(u64 param1)
 {
-	if (((param1 == 0)))
+	if (param1 == 0)
 		return 0x0000838000FF0000ull;
 	pr_err("ZIP_MSIX_PBAX: %llu\n", param1);
 	return 0;
@@ -846,7 +846,7 @@ union zip_msix_vecx_addr {
 
 static inline u64 ZIP_MSIX_VECX_ADDR(u64 param1)
 {
-	if (((param1 <= 17)))
+	if (param1 <= 17)
 		return 0x0000838000F00000ull + (param1 & 31) * 0x10ull;
 	pr_err("ZIP_MSIX_VECX_ADDR: %llu\n", param1);
 	return 0;
@@ -875,7 +875,7 @@ union zip_msix_vecx_ctl {
 
 static inline u64 ZIP_MSIX_VECX_CTL(u64 param1)
 {
-	if (((param1 <= 17)))
+	if (param1 <= 17)
 		return 0x0000838000F00008ull + (param1 & 31) * 0x10ull;
 	pr_err("ZIP_MSIX_VECX_CTL: %llu\n", param1);
 	return 0;
@@ -900,7 +900,7 @@ union zip_quex_done {
 
 static inline u64 ZIP_QUEX_DONE(u64 param1)
 {
-	if (((param1 <= 7)))
+	if (param1 <= 7)
 		return 0x2000ull + (param1 & 7) * 0x8ull;
 	pr_err("ZIP_QUEX_DONE: %llu\n", param1);
 	return 0;
@@ -925,7 +925,7 @@ union zip_quex_done_ack {
 
 static inline u64 ZIP_QUEX_DONE_ACK(u64 param1)
 {
-	if (((param1 <= 7)))
+	if (param1 <= 7)
 		return 0x2200ull + (param1 & 7) * 0x8ull;
 	pr_err("ZIP_QUEX_DONE_ACK: %llu\n", param1);
 	return 0;
@@ -950,7 +950,7 @@ union zip_quex_done_ena_w1c {
 
 static inline u64 ZIP_QUEX_DONE_ENA_W1C(u64 param1)
 {
-	if (((param1 <= 7)))
+	if (param1 <= 7)
 		return 0x2600ull + (param1 & 7) * 0x8ull;
 	pr_err("ZIP_QUEX_DONE_ENA_W1C: %llu\n", param1);
 	return 0;
@@ -975,7 +975,7 @@ union zip_quex_done_ena_w1s {
 
 static inline u64 ZIP_QUEX_DONE_ENA_W1S(u64 param1)
 {
-	if (((param1 <= 7)))
+	if (param1 <= 7)
 		return 0x2400ull + (param1 & 7) * 0x8ull;
 	pr_err("ZIP_QUEX_DONE_ENA_W1S: %llu\n", param1);
 	return 0;
@@ -1004,7 +1004,7 @@ union zip_quex_done_wait {
 
 static inline u64 ZIP_QUEX_DONE_WAIT(u64 param1)
 {
-	if (((param1 <= 7)))
+	if (param1 <= 7)
 		return 0x2800ull + (param1 & 7) * 0x8ull;
 	pr_err("ZIP_QUEX_DONE_WAIT: %llu\n", param1);
 	return 0;
@@ -1029,7 +1029,7 @@ union zip_quex_doorbell {
 
 static inline u64 ZIP_QUEX_DOORBELL(u64 param1)
 {
-	if (((param1 <= 7)))
+	if (param1 <= 7)
 		return 0x4000ull + (param1 & 7) * 0x8ull;
 	pr_err("ZIP_QUEX_DOORBELL: %llu\n", param1);
 	return 0;
@@ -1058,7 +1058,7 @@ union zip_quex_err_ena_w1c {
 
 static inline u64 ZIP_QUEX_ERR_ENA_W1C(u64 param1)
 {
-	if (((param1 <= 7)))
+	if (param1 <= 7)
 		return 0x3600ull + (param1 & 7) * 0x8ull;
 	pr_err("ZIP_QUEX_ERR_ENA_W1C: %llu\n", param1);
 	return 0;
@@ -1087,7 +1087,7 @@ union zip_quex_err_ena_w1s {
 
 static inline u64 ZIP_QUEX_ERR_ENA_W1S(u64 param1)
 {
-	if (((param1 <= 7)))
+	if (param1 <= 7)
 		return 0x3400ull + (param1 & 7) * 0x8ull;
 	pr_err("ZIP_QUEX_ERR_ENA_W1S: %llu\n", param1);
 	return 0;
@@ -1120,7 +1120,7 @@ union zip_quex_err_int {
 
 static inline u64 ZIP_QUEX_ERR_INT(u64 param1)
 {
-	if (((param1 <= 7)))
+	if (param1 <= 7)
 		return 0x3000ull + (param1 & 7) * 0x8ull;
 	pr_err("ZIP_QUEX_ERR_INT: %llu\n", param1);
 	return 0;
@@ -1150,7 +1150,7 @@ union zip_quex_err_int_w1s {
 
 static inline u64 ZIP_QUEX_ERR_INT_W1S(u64 param1)
 {
-	if (((param1 <= 7)))
+	if (param1 <= 7)
 		return 0x3200ull + (param1 & 7) * 0x8ull;
 	pr_err("ZIP_QUEX_ERR_INT_W1S: %llu\n", param1);
 	return 0;
@@ -1179,7 +1179,7 @@ union zip_quex_gcfg {
 
 static inline u64 ZIP_QUEX_GCFG(u64 param1)
 {
-	if (((param1 <= 7)))
+	if (param1 <= 7)
 		return 0x1A00ull + (param1 & 7) * 0x8ull;
 	pr_err("ZIP_QUEX_GCFG: %llu\n", param1);
 	return 0;
@@ -1204,7 +1204,7 @@ union zip_quex_map {
 
 static inline u64 ZIP_QUEX_MAP(u64 param1)
 {
-	if (((param1 <= 7)))
+	if (param1 <= 7)
 		return 0x1400ull + (param1 & 7) * 0x8ull;
 	pr_err("ZIP_QUEX_MAP: %llu\n", param1);
 	return 0;
@@ -1236,7 +1236,7 @@ union zip_quex_sbuf_addr {
 
 static inline u64 ZIP_QUEX_SBUF_ADDR(u64 param1)
 {
-	if (((param1 <= 7)))
+	if (param1 <= 7)
 		return 0x1000ull + (param1 & 7) * 0x8ull;
 	pr_err("ZIP_QUEX_SBUF_ADDR: %llu\n", param1);
 	return 0;
@@ -1276,7 +1276,7 @@ union zip_quex_sbuf_ctl {
 
 static inline u64 ZIP_QUEX_SBUF_CTL(u64 param1)
 {
-	if (((param1 <= 7)))
+	if (param1 <= 7)
 		return 0x1200ull + (param1 & 7) * 0x8ull;
 	pr_err("ZIP_QUEX_SBUF_CTL: %llu\n", param1);
 	return 0;
-- 
2.14.3
