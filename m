Return-Path: <SRS0=eAV2=DZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B381BC433E7
	for <linux-crypto@archiver.kernel.org>; Sun, 18 Oct 2020 20:01:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A26D2226B
	for <linux-crypto@archiver.kernel.org>; Sun, 18 Oct 2020 20:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603051282;
	bh=aXSL56NO64/b6gwekUk0tX3AXp5hEhmLjEQ5cVnUrtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=KZI9REvjJ1jexkmvw3UM2wz7yqP6cXPCRGAVUMDWQ8NWwfUi888/ymb0YUv4BRorT
	 uUUQ23CXuPJHOl2saVwOwNRAl8aG0f+hxpsPhqSM7FVPIXJo2IAS3bX6JIVnSwDIEg
	 Q3mU709sY9OmEabD1n2sVCyGeDad2SqoQA67OdLc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388836AbgJRUBS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 18 Oct 2020 16:01:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727333AbgJRTSN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 18 Oct 2020 15:18:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0066A22274;
        Sun, 18 Oct 2020 19:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048692;
        bh=aXSL56NO64/b6gwekUk0tX3AXp5hEhmLjEQ5cVnUrtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aEofq5TawnFo+flY+/0VS71pmtt/Ay3d66tbJ6E0NSPZXpsuN3o9OzZt9DuCrCCX3
         6zDPUWeBeu+4fsN30wHRYW3MuVdQRp02l3/Cyq+sDWHWwSG11Fg9HXUZVq/E7HHRN4
         lWfoU7hrqBtnlTgL6FDWYYq8ML15knusAQPGTFPI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Machek <pavel@denx.de>, John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 004/111] crypto: ccp - fix error handling
Date:   Sun, 18 Oct 2020 15:16:20 -0400
Message-Id: <20201018191807.4052726-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018191807.4052726-1-sashal@kernel.org>
References: <20201018191807.4052726-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Pavel Machek <pavel@denx.de>

[ Upstream commit e356c49c6cf0db3f00e1558749170bd56e47652d ]

Fix resource leak in error handling.

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
Acked-by: John Allen <john.allen@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/ccp-ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index bd270e66185e9..40869ea1ed20f 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -1744,7 +1744,7 @@ ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 			break;
 		default:
 			ret = -EINVAL;
-			goto e_ctx;
+			goto e_data;
 		}
 	} else {
 		/* Stash the context */
-- 
2.25.1

