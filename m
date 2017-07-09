From: sleepingzucchini@gmail.com
Subject: [PATCH 1/5] staging: ccree: remove redudant semicolons
Date: Sun,  9 Jul 2017 17:10:43 -0400
Message-ID: <a128c361d828cfc1fc1a5468d61f152b4900d539.1499608047.git.sleepingzucchini@gmail.com>
References: <cover.1499608047.git.sleepingzucchini@gmail.com>
Cc: gregkh@linuxfoundation.orgc, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org,
        Tyler Olivieri <sleepingzucchini@gmail.com>
To: gilad@benyossef.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:33209 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752707AbdGIWPz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Jul 2017 18:15:55 -0400
Received: by mail-qt0-f194.google.com with SMTP id c20so10703774qte.0
        for <linux-crypto@vger.kernel.org>; Sun, 09 Jul 2017 15:15:55 -0700 (PDT)
In-Reply-To: <cover.1499608047.git.sleepingzucchini@gmail.com>
In-Reply-To: <cover.1499608047.git.sleepingzucchini@gmail.com>
References: <cover.1499608047.git.sleepingzucchini@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Tyler Olivieri <sleepingzucchini@gmail.com>

Patch to remove checkpatch warning:
WARNING: Statements terminations use 1 semicolon

Signed-off-by: Tyler Olivieri <sleepingzucchini@gmail.com>
---
 drivers/staging/ccree/ssi_buffer_mgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index b35871e..c05cd67 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -150,7 +150,7 @@ static inline int ssi_buffer_mgr_render_buff_to_mlli(
 	u32 **mlli_entry_pp)
 {
 	u32 *mlli_entry_p = *mlli_entry_pp;
-	u32 new_nents;;
+	u32 new_nents;
 
 	/* Verify there is no memory overflow*/
 	new_nents = (*curr_nents + buff_size / CC_MAX_MLLI_ENTRY_SIZE + 1);
-- 
2.9.4
