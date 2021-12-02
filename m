Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE06EC4332F
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Dec 2021 15:24:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358962AbhLBP1i (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Dec 2021 10:27:38 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:42160 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358947AbhLBP1d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Dec 2021 10:27:33 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id ACD261FE05;
        Thu,  2 Dec 2021 15:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1638458648; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WrgCh25NwnVfz4gld5vXX6xGM5yqU1dka6lj5KLnPE4=;
        b=WSBaC6fcenKftbVqzpYR1kLRTBABJw+g3S8sO9nNsOOx7WB8B87Rbrh0gBMCXEetENCh0A
        q70SZ6yVt4OG0L9o1prl9oZr6eMzVJZC1rquGNtdCkE0qcP1H/xIgfBg55U6V3ANEAH1oi
        E3D50B4MYjFB1KWeEUGwYxojslCaiGY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1638458648;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WrgCh25NwnVfz4gld5vXX6xGM5yqU1dka6lj5KLnPE4=;
        b=x0qG8tGZZPbVT0uPoiziITRamUCsgttPVQ0tvz2SpDoVEqUvP+pDKWteJm1LfifdsNW+9z
        1Ao+7auP7caiO0BQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 9B604A3B93;
        Thu,  2 Dec 2021 15:24:08 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 3ADE45191DF4; Thu,  2 Dec 2021 16:24:07 +0100 (CET)
From:   Hannes Reinecke <hare@suse.de>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH 06/12] nvme-fabrics: decode 'authentication required' connect error
Date:   Thu,  2 Dec 2021 16:23:52 +0100
Message-Id: <20211202152358.60116-7-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211202152358.60116-1-hare@suse.de>
References: <20211202152358.60116-1-hare@suse.de>
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

