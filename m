Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C68FC433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 12:59:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E676D6109D
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 12:59:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235022AbhKLNCc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Nov 2021 08:02:32 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:52586 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234993AbhKLNC3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Nov 2021 08:02:29 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id B3BAB1FD61;
        Fri, 12 Nov 2021 12:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636721977; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nKe1jHofDN4jUyvLkR9rLA2q1fS8E9E+DaGzOmQOUnI=;
        b=Vwv3nZGLrLa00fCwhxyoAk6bfhPsgmYPcyO0WWTVQwW3mt872fK9JaTXOR1BN0unz2DjUf
        izngta6w1eqP8Qyv4hHFOO+hnZkERoN6uToLH4pDoD5mAJ7F6JE++o7aCzVbHe3bU2llbh
        JTy99FgpSkVuVf/pnp0WVboX2Or1QiE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636721977;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nKe1jHofDN4jUyvLkR9rLA2q1fS8E9E+DaGzOmQOUnI=;
        b=9aKC1DC1B+oRmtyInjRK0WazsdOK8ASGiIDJch4UOM1saukaRPCDpqagCPb1qXo+OJhhHx
        9jRWL7vGaXRsIUDA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id A4711A3B91;
        Fri, 12 Nov 2021 12:59:37 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 59774519126B; Fri, 12 Nov 2021 13:59:36 +0100 (CET)
From:   Hannes Reinecke <hare@suse.de>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/12] nvmet-auth: expire authentication sessions
Date:   Fri, 12 Nov 2021 13:59:28 +0100
Message-Id: <20211112125928.97318-13-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211112125928.97318-1-hare@suse.de>
References: <20211112125928.97318-1-hare@suse.de>
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
index 7486077ca33e..58f11ccaecee 100644
--- a/drivers/nvme/target/auth.c
+++ b/drivers/nvme/target/auth.c
@@ -237,6 +237,7 @@ int nvmet_setup_auth(struct nvmet_ctrl *ctrl)
 
 void nvmet_auth_sq_free(struct nvmet_sq *sq)
 {
+	cancel_delayed_work(&sq->auth_expired_work);
 	kfree(sq->dhchap_c1);
 	sq->dhchap_c1 = NULL;
 	kfree(sq->dhchap_c2);
diff --git a/drivers/nvme/target/fabrics-cmd-auth.c b/drivers/nvme/target/fabrics-cmd-auth.c
index 51955fbc6c55..2beaacedf2b6 100644
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
@@ -305,8 +318,13 @@ void nvmet_execute_auth_send(struct nvmet_req *req)
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
index e2864310a048..e13dad05f387 100644
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

