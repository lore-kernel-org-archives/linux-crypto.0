Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 948C4C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Sep 2021 06:43:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C7F7611AD
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Sep 2021 06:43:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbhIJGow (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Sep 2021 02:44:52 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:44990 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbhIJGou (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Sep 2021 02:44:50 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 340FC20209;
        Fri, 10 Sep 2021 06:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1631256219; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ho5DpRbvH9SAMQnxKwkauGos06CLIp7YKDV0R315tdw=;
        b=Vzo7zWPegs/HDgKWrigfYfdK1QSlTnj8W2BNRzYEriLKFThoPuVzE8J4q2gpYGRg8ghrnz
        JBHKNq4QDwH/OFRX29ixSWLEtSqRV7JxFCvW+BcAHZtLbFa/xbldZSB2Vfj+NmqDs/z8/h
        n8H14bRRIKry7DdkvobQtKBPt9pq5bY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1631256219;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ho5DpRbvH9SAMQnxKwkauGos06CLIp7YKDV0R315tdw=;
        b=ffdsOwu3EIBMXtcFpBOOPmWX5dwnhw1SHdTTZ2XVpcJ+zA/UKFh/pfCB9OK+64FpK+kWk+
        tvlqZDkMN0u16CBg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 272ABA3BAC;
        Fri, 10 Sep 2021 06:43:39 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id A935B518E326; Fri, 10 Sep 2021 08:43:36 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/12] nvme-fabrics: decode 'authentication required' connect error
Date:   Fri, 10 Sep 2021 08:43:16 +0200
Message-Id: <20210910064322.67705-7-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210910064322.67705-1-hare@suse.de>
References: <20210910064322.67705-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The 'connect' command might fail with NVME_SC_AUTH_REQUIRED, so we
should be decoding this error, too.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/nvme/host/fabrics.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index 668c6bb7a567..9a8eade7cd23 100644
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

