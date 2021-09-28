Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74B75C4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 06:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 621E5611CE
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 06:05:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239131AbhI1GGk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Sep 2021 02:06:40 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:45380 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239518AbhI1GFr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Sep 2021 02:05:47 -0400
Received: from relay1.suse.de (relay1.suse.de [149.44.160.133])
        by smtp-out2.suse.de (Postfix) with ESMTP id CD0B0201C0;
        Tue, 28 Sep 2021 06:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1632809047; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BCgZ0I21op2rmk/0qxbb2ua4ccLEQtSuTqpSWY9TiDk=;
        b=FaIXWAgfNZPKXHk4bG9Bm6Z8RmZaxmEiFozjCroBudwYZwU0FvtT/V4iT2LIl0l0Q9BzCf
        yNtxleGUmQlhEs9FPTTJSQ/UP0SgGTRhbn9wVIbHWsxapIEm54yVQf99yffBFAGXJTGq+r
        12a577CV7H6HTq0zzk1eKZNsQuxYiOs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1632809047;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BCgZ0I21op2rmk/0qxbb2ua4ccLEQtSuTqpSWY9TiDk=;
        b=A762eSe3plZ1InwbMgHrGXVqcuHx9QAvazsbWfPejCgYhZF/9TF+/H5YBmt2aLbg8yr9pE
        WM/DhZmBX7M0OHDw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay1.suse.de (Postfix) with ESMTP id C352625E6B;
        Tue, 28 Sep 2021 06:04:07 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 6B462518EE30; Tue, 28 Sep 2021 08:04:06 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/12] nvmet: Parse fabrics commands on all queues
Date:   Tue, 28 Sep 2021 08:03:53 +0200
Message-Id: <20210928060356.27338-10-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210928060356.27338-1-hare@suse.de>
References: <20210928060356.27338-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fabrics commands might be sent to all queues, not just the admin one.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/nvme/target/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index b8425fa34300..6e253c3c5e0f 100644
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

