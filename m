Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A16D9C4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Nov 2021 12:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234758AbhKWMlZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Nov 2021 07:41:25 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:59676 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236400AbhKWMlX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Nov 2021 07:41:23 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 3A7AB218F0;
        Tue, 23 Nov 2021 12:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637671094; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WrgCh25NwnVfz4gld5vXX6xGM5yqU1dka6lj5KLnPE4=;
        b=imV33gbU2ZDoKOMn/DR9MwwGxFf7GryObwVYnFwd4YgcISRncxaHGCUDfmQVShRKifpmM+
        /hBGvUxiZvpBx5n6gYAiHbmk2VuorlQHFFgBt+aW9jArc2Muehju4J0JbN3zNVwOju6Eg0
        MAzM2Qr+e8C8nEpNSdkRX6vx9iYhkwI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637671094;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WrgCh25NwnVfz4gld5vXX6xGM5yqU1dka6lj5KLnPE4=;
        b=t7kmnBiWnl0n3tjgj0rEe4jxumSxg9E9MKauAGTCmzQrQjYC3kPNlI6+uoSvXKcqhpUQVZ
        ag6DvmytJ4NzXMCA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 2C6DFA3B8E;
        Tue, 23 Nov 2021 12:38:14 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id ADC2551918C6; Tue, 23 Nov 2021 13:38:12 +0100 (CET)
From:   Hannes Reinecke <hare@suse.de>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.org>,
        linux-crypto@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH 06/12] nvme-fabrics: decode 'authentication required' connect error
Date:   Tue, 23 Nov 2021 13:37:55 +0100
Message-Id: <20211123123801.73197-7-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211123123801.73197-1-hare@suse.de>
References: <20211123123801.73197-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The 'connect' command might fail with NVME_SC_AUTH_REQUIRED, so we
should be decoding this error, too.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/nvme/host/fabrics.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index c5a2b71c5268..a1343a0790f6 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -332,6 +332,10 @@ static void nvmf_log_connect_error(struct nvme_ctrl *ctrl,
 		dev_err(ctrl->device,
 			"Connect command failed: host path error\n");
 		break;
+	case NVME_SC_AUTH_REQUIRED:
+		dev_err(ctrl->device,
+			"Connect command failed: authentication required\n");
+		break;
 	default:
 		dev_err(ctrl->device,
 			"Connect command failed, error wo/DNR bit: %d\n",
-- 
2.29.2

