Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56ABBC43219
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 12:59:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E7F5610A0
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 12:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235015AbhKLNCc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Nov 2021 08:02:32 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:44888 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234998AbhKLNC3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Nov 2021 08:02:29 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id AB71A2198E;
        Fri, 12 Nov 2021 12:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636721977; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1zZyw8NwtXnSiSNYLJJ4fkzknabcyKR3fhKhdFcUFyo=;
        b=vZKINxYpY37Kok6MscpJlzhjyfWupezSOO+zId4mLVjfdPGP742CB9X11GMnJknpyboLWu
        RBy1WPQFA+vLy2q32PhBL8wzgRT0LNzaJ6kwOLhP6DiR3t2jEi6gowkCvZqz0sIIARi5/f
        +CMUGQwW6LekNnTJSG4LRnvL2T9Mqpw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636721977;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1zZyw8NwtXnSiSNYLJJ4fkzknabcyKR3fhKhdFcUFyo=;
        b=uw1tm/BlaFCXm9eKyBDqHcwE8gNGj0/ADYHoJwKolhUbtLQS93w4MeKOaZr9WJzNuPZTA7
        /qOtO+cLpvg29FBg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 9B301A3B8C;
        Fri, 12 Nov 2021 12:59:37 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 3766C519125F; Fri, 12 Nov 2021 13:59:36 +0100 (CET)
From:   Hannes Reinecke <hare@suse.de>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH 06/12] nvme-fabrics: decode 'authentication required' connect error
Date:   Fri, 12 Nov 2021 13:59:22 +0100
Message-Id: <20211112125928.97318-7-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211112125928.97318-1-hare@suse.de>
References: <20211112125928.97318-1-hare@suse.de>
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

