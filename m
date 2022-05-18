Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B65A5C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 18 May 2022 11:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235557AbiERLXD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 May 2022 07:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235413AbiERLW7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 May 2022 07:22:59 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26EAD15E617
        for <linux-crypto@vger.kernel.org>; Wed, 18 May 2022 04:22:55 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 6719421BB0;
        Wed, 18 May 2022 11:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1652872973; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PWW8KtETebgaTkzOWq5LzP/4FDLtdsx7XewVO5qKMns=;
        b=JxW32sgb+WiWx3Je9MXW7jI04xoRtL4+c64n5ZvIfplXw7aR/D9P3zXiq+rGwhitoEcBP1
        oCVitOuoVGzfqJ7LeCPa8BEn9kG+Vaw+FstS2LW9cVAr5SnS4NW8bJZNdgsE6nAICyAWtD
        do5FVICSLv1lOiGpCDCMWd0zKoAaFRY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1652872973;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PWW8KtETebgaTkzOWq5LzP/4FDLtdsx7XewVO5qKMns=;
        b=aIsjNMBHxnhPOCXHfpvlNsgwVUESLcroudcVFF57bSqlvMxr2bRkvBHgtA3msL/FwqX0eF
        4Aw4I7TYvKnXdSDw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 5F0872C152;
        Wed, 18 May 2022 11:22:53 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id B46F9519451B; Wed, 18 May 2022 13:22:52 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/11] nvmet-auth: expire authentication sessions
Date:   Wed, 18 May 2022 13:22:34 +0200
Message-Id: <20220518112234.24264-12-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220518112234.24264-1-hare@suse.de>
References: <20220518112234.24264-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Each authentication step is required to be completed within the
KATO interval (or two minutes if not set). So add a workqueue function
to reset the transaction ID and the expected next protocol step;
this will automatically the next authentication command referring
to the terminated authentication.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/nvme/target/auth.c             |  1 +
 drivers/nvme/target/fabrics-cmd-auth.c | 20 +++++++++++++++++++-
 drivers/nvme/target/nvmet.h            |  1 +
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/auth.c b/drivers/nvme/target/auth.c
index 71e13d7eb511..183af0b24523 100644
--- a/drivers/nvme/target/auth.c
+++ b/drivers/nvme/target/auth.c
@@ -218,6 +218,7 @@ int nvmet_setup_auth(struct nvmet_ctrl *ctrl)
 
 void nvmet_auth_sq_free(struct nvmet_sq *sq)
 {
+	cancel_delayed_work(&sq->auth_expired_work);
 	kfree(sq->dhchap_c1);
 	sq->dhchap_c1 = NULL;
 	kfree(sq->dhchap_c2);
diff --git a/drivers/nvme/target/fabrics-cmd-auth.c b/drivers/nvme/target/fabrics-cmd-auth.c
index 3156b052da4d..0d2571d03272 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -12,9 +12,22 @@
 #include "nvmet.h"
 #include "../host/auth.h"
 
+static void nvmet_auth_expired_work(struct work_struct *work)
+{
+	struct nvmet_sq *sq = container_of(to_delayed_work(work),
+			struct nvmet_sq, auth_expired_work);
+
+	pr_debug("%s: ctrl %d qid %d transaction %u expired, resetting\n",
+		 __func__, sq->ctrl->cntlid, sq->qid, sq->dhchap_tid);
+	sq->dhchap_step = NVME_AUTH_DHCHAP_MESSAGE_NEGOTIATE;
+	sq->dhchap_tid = -1;
+}
+
 void nvmet_init_auth(struct nvmet_ctrl *ctrl, struct nvmet_req *req)
 {
 	/* Initialize in-band authentication */
+	INIT_DELAYED_WORK(&req->sq->auth_expired_work,
+			  nvmet_auth_expired_work);
 	req->sq->authenticated = false;
 	req->sq->dhchap_step = NVME_AUTH_DHCHAP_MESSAGE_NEGOTIATE;
 	req->cqe->result.u32 |= 0x2 << 16;
@@ -326,8 +339,13 @@ void nvmet_execute_auth_send(struct nvmet_req *req)
 	req->cqe->result.u64 = 0;
 	nvmet_req_complete(req, status);
 	if (req->sq->dhchap_step != NVME_AUTH_DHCHAP_MESSAGE_SUCCESS2 &&
-	    req->sq->dhchap_step != NVME_AUTH_DHCHAP_MESSAGE_FAILURE2)
+	    req->sq->dhchap_step != NVME_AUTH_DHCHAP_MESSAGE_FAILURE2) {
+		unsigned long auth_expire_secs = ctrl->kato ? ctrl->kato : 120;
+
+		mod_delayed_work(system_wq, &req->sq->auth_expired_work,
+				 auth_expire_secs * HZ);
 		return;
+	}
 	/* Final states, clear up variables */
 	nvmet_auth_sq_free(req->sq);
 	if (req->sq->dhchap_step == NVME_AUTH_DHCHAP_MESSAGE_FAILURE2)
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 8b239aec3ca2..829fb1d78ee1 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -109,6 +109,7 @@ struct nvmet_sq {
 	u32			sqhd;
 	bool			sqhd_disabled;
 #ifdef CONFIG_NVME_TARGET_AUTH
+	struct delayed_work	auth_expired_work;
 	bool			authenticated;
 	u16			dhchap_tid;
 	u16			dhchap_status;
-- 
2.29.2

