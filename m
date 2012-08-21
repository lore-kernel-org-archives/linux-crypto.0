From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH] crypto: caam - static constify error lookup tables
Date: Tue, 21 Aug 2012 18:02:36 -0500
Message-ID: <20120821180236.b67897fa435a24a6984139e9@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:22732
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751198Ab2HUXEt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Aug 2012 19:04:49 -0400
Received: from mail32-va3 (localhost [127.0.0.1])	by mail32-va3-R.bigfish.com
 (Postfix) with ESMTP id 72CDD1E00E6	for <linux-crypto@vger.kernel.org>; Tue,
 21 Aug 2012 23:04:48 +0000 (UTC)
Received: from VA3EHSMHS032.bigfish.com (unknown [10.7.14.254])	by
 mail32-va3.bigfish.com (Postfix) with ESMTP id E6A4938009B	for
 <linux-crypto@vger.kernel.org>; Tue, 21 Aug 2012 23:04:45 +0000 (UTC)
Received: from x9.am.freescale.net (x9.am.freescale.net [10.82.120.9])	by
 tx30smr01.am.freescale.net (8.14.3/8.14.0) with SMTP id q7LN4fMj028310	for
 <linux-crypto@vger.kernel.org>; Tue, 21 Aug 2012 16:04:41 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

checkstack reports report_deco_status(), report_ccb_status() as
particularly excessive stack users.  Move error lookup tables
off the stack and put them in .rodata.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/error.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index 9955ed9..497c1c2 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -36,7 +36,7 @@ static void report_jump_idx(u32 status, char *outstr)
 
 static void report_ccb_status(u32 status, char *outstr)
 {
-	char *cha_id_list[] = {
+	static const char *cha_id_list[] = {
 		"",
 		"AES",
 		"DES",
@@ -51,7 +51,7 @@ static void report_ccb_status(u32 status, char *outstr)
 		"ZUCE",
 		"ZUCA",
 	};
-	char *err_id_list[] = {
+	static const char *err_id_list[] = {
 		"No error.",
 		"Mode error.",
 		"Data size error.",
@@ -69,7 +69,7 @@ static void report_ccb_status(u32 status, char *outstr)
 		"Invalid CHA combination was selected",
 		"Invalid CHA selected.",
 	};
-	char *rng_err_id_list[] = {
+	static const char *rng_err_id_list[] = {
 		"",
 		"",
 		"",
@@ -119,7 +119,7 @@ static void report_jump_status(u32 status, char *outstr)
 
 static void report_deco_status(u32 status, char *outstr)
 {
-	const struct {
+	static const struct {
 		u8 value;
 		char *error_text;
 	} desc_error_list[] = {
@@ -247,7 +247,7 @@ static void report_cond_code_status(u32 status, char *outstr)
 
 char *caam_jr_strstatus(char *outstr, u32 status)
 {
-	struct stat_src {
+	static const struct stat_src {
 		void (*report_ssed)(u32 status, char *outstr);
 		char *error;
 	} status_src[] = {
-- 
1.7.11.4
