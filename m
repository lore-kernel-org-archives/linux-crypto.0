From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH v2 2/2] v2 crypto: caam - static constify error data
Date: Tue, 26 Mar 2013 18:10:15 -0500
Message-ID: <1364339415-23068-2-git-send-email-kim.phillips@freescale.com>
References: <1364339415-23068-1-git-send-email-kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "David S. Miller" <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1364339415-23068-1-git-send-email-kim.phillips@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

checkstack reports report_deco_status(), report_ccb_status() as
particularly excessive stack users.  Move their lookup tables
off the stack and put them in .rodata.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
v1 posted here:
    http://article.gmane.org/gmane.linux.kernel.cryptoapi/7571
v2: made cha_id_list, err_id_list, and rng_err_id_list
    static const char * const, instead of just static const.

 drivers/crypto/caam/error.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index 30b8f74..9f25f52 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -36,7 +36,7 @@ static void report_jump_idx(u32 status, char *outstr)
 
 static void report_ccb_status(u32 status, char *outstr)
 {
-	char *cha_id_list[] = {
+	static const char * const cha_id_list[] = {
 		"",
 		"AES",
 		"DES",
@@ -51,7 +51,7 @@ static void report_ccb_status(u32 status, char *outstr)
 		"ZUCE",
 		"ZUCA",
 	};
-	char *err_id_list[] = {
+	static const char * const err_id_list[] = {
 		"No error.",
 		"Mode error.",
 		"Data size error.",
@@ -69,7 +69,7 @@ static void report_ccb_status(u32 status, char *outstr)
 		"Invalid CHA combination was selected",
 		"Invalid CHA selected.",
 	};
-	char *rng_err_id_list[] = {
+	static const char * const rng_err_id_list[] = {
 		"",
 		"",
 		"",
@@ -117,7 +117,7 @@ static void report_jump_status(u32 status, char *outstr)
 
 static void report_deco_status(u32 status, char *outstr)
 {
-	const struct {
+	static const struct {
 		u8 value;
 		char *error_text;
 	} desc_error_list[] = {
@@ -245,7 +245,7 @@ static void report_cond_code_status(u32 status, char *outstr)
 
 char *caam_jr_strstatus(char *outstr, u32 status)
 {
-	struct stat_src {
+	static const struct stat_src {
 		void (*report_ssed)(u32 status, char *outstr);
 		char *error;
 	} status_src[] = {
-- 
1.8.1.5
