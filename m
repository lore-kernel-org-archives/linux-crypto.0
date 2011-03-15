From: Dan Carpenter <error27@gmail.com>
Subject: [patch] crypto: caam - ARRAY_SIZE() vs sizeof()
Date: Tue, 15 Mar 2011 09:59:55 +0300
Message-ID: <20110315065955.GP2008@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Steve Cornelius <sec@pobox.com>,
	Kim Phillips <kim.phillips@freescale.com>,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58497 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab1COHAN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Mar 2011 03:00:13 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

ARRAY_SIZE() was intended here instead of sizeof().  sizeof() is four
times larger than ARRAY_SIZE().  outstr is normally 256 chars so 
printing garbage to it could overfill the buffer and corrupt memory.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index bd57a68..7e2d54b 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -73,7 +73,7 @@ static void report_ccb_status(u32 status, char *outstr)
 
 	report_jump_idx(status, outstr);
 
-	if (cha_id < sizeof(cha_id_list)) {
+	if (cha_id < ARRAY_SIZE(cha_id_list)) {
 		SPRINTFCAT(outstr, "%s: ", cha_id_list[cha_id],
 			   strlen(cha_id_list[cha_id]));
 	} else {
@@ -81,7 +81,7 @@ static void report_ccb_status(u32 status, char *outstr)
 			   cha_id, sizeof("ff"));
 	}
 
-	if (err_id < sizeof(err_id_list)) {
+	if (err_id < ARRAY_SIZE(err_id_list)) {
 		SPRINTFCAT(outstr, "%s", err_id_list[err_id],
 			   strlen(err_id_list[err_id]));
 	} else {
@@ -198,11 +198,11 @@ static void report_deco_status(u32 status, char *outstr)
 
 	report_jump_idx(status, outstr);
 
-	for (i = 0; i < sizeof(desc_error_list); i++)
+	for (i = 0; i < ARRAY_SIZE(desc_error_list); i++)
 		if (desc_error_list[i].value == desc_error)
 			break;
 
-	if (i != sizeof(desc_error_list) && desc_error_list[i].error_text) {
+	if (i != ARRAY_SIZE(desc_error_list) && desc_error_list[i].error_text) {
 		SPRINTFCAT(outstr, "%s", desc_error_list[i].error_text,
 			   strlen(desc_error_list[i].error_text));
 	} else {
