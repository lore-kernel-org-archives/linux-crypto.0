Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6EA5C433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Nov 2021 07:47:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbhKVHut (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Nov 2021 02:50:49 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:57054 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232357AbhKVHus (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Nov 2021 02:50:48 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 1F9731FD4D;
        Mon, 22 Nov 2021 07:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637567261; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vesnEftm40bgE0Mlb2KauB4xABlzfSQSQnBa7DVdpmU=;
        b=cP7OmTrbY/XFfrIjmG2WFW1f/8Mhx3NdVp8KX+FHLW+NTMrRRQan3K2E97IMqgqmJUNw3N
        Q0j5CJLRBd9/WkImdeyu4WfL5go9T0Duts7QKUZZfIK699r4CI9DokvaIg3fHrch7WI+6G
        /35Ndiqr0pgPYKmokIF9kPjzonzJLUg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637567261;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vesnEftm40bgE0Mlb2KauB4xABlzfSQSQnBa7DVdpmU=;
        b=vmr1MTKFoifyFsrY0aqR9nZgh9tYT++0Wt3R3qd7flV/YdaYSvw/U9R7w2J68uZJuoMdDL
        0G+AIEQ8fA1sCUCg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 12E81A3B89;
        Mon, 22 Nov 2021 07:47:41 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 498EF51917E4; Mon, 22 Nov 2021 08:47:40 +0100 (CET)
From:   Hannes Reinecke <hare@suse.de>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herberg@gondor.apana.org.au>,
        David Miller <davem@davemloft.org>,
        linux-crypto@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH 09/12] nvmet: Parse fabrics commands on all queues
Date:   Mon, 22 Nov 2021 08:47:24 +0100
Message-Id: <20211122074727.25988-10-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211122074727.25988-1-hare@suse.de>
References: <20211122074727.25988-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fabrics commands might be sent to all queues, not just the admin one.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/nvme/target/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 5119c687de68..a3abbf50f7e0 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -943,6 +943,8 @@ bool nvmet_req_init(struct nvmet_req *req, struct nvmet_cq *cq,
 	if (unlikely(!req->sq->ctrl))
 		/* will return an error for any non-connect command: */
 		status = nvmet_parse_connect_cmd(req);
+	else if (nvme_is_fabrics(req->cmd))
+		status = nvmet_parse_fabrics_cmd(req);
 	else if (likely(req->sq->qid != 0))
 		status = nvmet_parse_io_cmd(req);
 	else
-- 
2.29.2

