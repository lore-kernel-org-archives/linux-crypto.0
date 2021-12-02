Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63D14C4332F
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Dec 2021 15:24:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358901AbhLBP1c (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Dec 2021 10:27:32 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:42100 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358939AbhLBP1c (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Dec 2021 10:27:32 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id A6A8E1FE01;
        Thu,  2 Dec 2021 15:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1638458648; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UjO/egNmFWNNFKjv3uGJ3izNgDQ97ZLf0CHakF8xt+4=;
        b=iuC7kWVldIehjY/ZWSvG4WIETeDuDzlRdGp317DBRwDP+SHYUQ9c+wygrD7OCtjlyjyrHX
        C+eDiMGGLjGcyrTvWe7vPIrbox/wjhmmMnmxouIGgDXY8huf1YC/ztoI8mzZlTY3d8W4PK
        T/4JqpeH+u7YldjSt6RxVFYXgTfUcoM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1638458648;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UjO/egNmFWNNFKjv3uGJ3izNgDQ97ZLf0CHakF8xt+4=;
        b=SzZXbLUf5h7uTzYl4VcH1fqRp43iyDYDu4TDVmXEzNKrMy1Svs5GI8lf8ou4RjjvVNd372
        ayofLEiLMXV4NsAA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 984DAA3B8F;
        Thu,  2 Dec 2021 15:24:08 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 4C6605191DFA; Thu,  2 Dec 2021 16:24:07 +0100 (CET)
From:   Hannes Reinecke <hare@suse.de>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/12] nvmet: parse fabrics commands on io queues
Date:   Thu,  2 Dec 2021 16:23:55 +0100
Message-Id: <20211202152358.60116-10-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211202152358.60116-1-hare@suse.de>
References: <20211202152358.60116-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some fabrics commands can be sent via io queues, so add a new
function nvmet_parse_fabrics_io_cmd() and rename the existing
nvmet_parse_fabrics_cmd() to nvmet_parse_fabrics_admin_cmd().

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/nvme/target/core.c        |  4 ++++
 drivers/nvme/target/fabrics-cmd.c | 17 ++++++++++++++++-
 drivers/nvme/target/nvmet.h       |  3 ++-
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 5119c687de68..745c4e28a845 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -863,8 +863,12 @@ static inline u16 nvmet_io_cmd_check_access(struct nvmet_req *req)
 
 static u16 nvmet_parse_io_cmd(struct nvmet_req *req)
 {
+	struct nvme_command *cmd = req->cmd;
 	u16 ret;
 
+	if (nvme_is_fabrics(cmd))
+		return nvmet_parse_fabrics_io_cmd(req);
+
 	ret = nvmet_check_ctrl_status(req);
 	if (unlikely(ret))
 		return ret;
diff --git a/drivers/nvme/target/fabrics-cmd.c b/drivers/nvme/target/fabrics-cmd.c
index 70fb587e9413..f23c28729908 100644
--- a/drivers/nvme/target/fabrics-cmd.c
+++ b/drivers/nvme/target/fabrics-cmd.c
@@ -82,7 +82,7 @@ static void nvmet_execute_prop_get(struct nvmet_req *req)
 	nvmet_req_complete(req, status);
 }
 
-u16 nvmet_parse_fabrics_cmd(struct nvmet_req *req)
+u16 nvmet_parse_fabrics_admin_cmd(struct nvmet_req *req)
 {
 	struct nvme_command *cmd = req->cmd;
 
@@ -103,6 +103,21 @@ u16 nvmet_parse_fabrics_cmd(struct nvmet_req *req)
 	return 0;
 }
 
+u16 nvmet_parse_fabrics_io_cmd(struct nvmet_req *req)
+{
+	struct nvme_command *cmd = req->cmd;
+
+	switch (cmd->fabrics.fctype) {
+	default:
+		pr_debug("received unknown capsule type 0x%x\n",
+			cmd->fabrics.fctype);
+		req->error_loc = offsetof(struct nvmf_common_command, fctype);
+		return NVME_SC_INVALID_OPCODE | NVME_SC_DNR;
+	}
+
+	return 0;
+}
+
 static u16 nvmet_install_queue(struct nvmet_ctrl *ctrl, struct nvmet_req *req)
 {
 	struct nvmf_connect_command *c = &req->cmd->connect;
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index af193423c10b..496faea41149 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -418,7 +418,8 @@ u16 nvmet_file_parse_io_cmd(struct nvmet_req *req);
 u16 nvmet_bdev_zns_parse_io_cmd(struct nvmet_req *req);
 u16 nvmet_parse_admin_cmd(struct nvmet_req *req);
 u16 nvmet_parse_discovery_cmd(struct nvmet_req *req);
-u16 nvmet_parse_fabrics_cmd(struct nvmet_req *req);
+u16 nvmet_parse_fabrics_admin_cmd(struct nvmet_req *req);
+u16 nvmet_parse_fabrics_io_cmd(struct nvmet_req *req);
 
 bool nvmet_req_init(struct nvmet_req *req, struct nvmet_cq *cq,
 		struct nvmet_sq *sq, const struct nvmet_fabrics_ops *ops);
-- 
2.29.2

