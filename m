Return-Path: <SRS0=eAV2=DZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F73FC4363A
	for <linux-crypto@archiver.kernel.org>; Sun, 18 Oct 2020 19:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E638E222E9
	for <linux-crypto@archiver.kernel.org>; Sun, 18 Oct 2020 19:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603048958;
	bh=euSlTIDisOskMB5UgyqLeAfOkw/u0PxXEldvc7fiz98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ksf4yXlgoAlLtbxXodLLP2akFsn5NGDDRRMzoRqsMzLUdf0x1iokxmw9oZp3AFoMj
	 KLA0b0UgqulqYp2HadbptEp8zaLcRyXgi9jP9bPiwUeEDbjc+iVfV31GJIfSviMshg
	 pP54nMwbmZbnVHv/CVcfeMaUKaR4BxZTQJm94xOs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729908AbgJRTWh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 18 Oct 2020 15:22:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729877AbgJRTWg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 18 Oct 2020 15:22:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7781220791;
        Sun, 18 Oct 2020 19:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048956;
        bh=euSlTIDisOskMB5UgyqLeAfOkw/u0PxXEldvc7fiz98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rgOf83ul0M4qS6fZXEjkSGaYPN6a1tesTegJbK1s4E1g2dOpxzEJGa/JoWSoDOIw9
         6afXtGZTl1nmqRbQ7N47Cey/g80Wqm1gqDptxCuvdHNsAdDxZ1ArkI3KEtGF1teITW
         EH8wXnsno/FSbs3cg+8qC8FhNZAka6gctFp7dhsY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Machek <pavel@denx.de>, John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 03/80] crypto: ccp - fix error handling
Date:   Sun, 18 Oct 2020 15:21:14 -0400
Message-Id: <20201018192231.4054535-3-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192231.4054535-1-sashal@kernel.org>
References: <20201018192231.4054535-1-sashal@kernel.org>
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
index 64112c736810e..7234b95241e91 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -1746,7 +1746,7 @@ ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
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

