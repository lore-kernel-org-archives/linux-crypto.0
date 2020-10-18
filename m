Return-Path: <SRS0=eAV2=DZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06C97C433DF
	for <linux-crypto@archiver.kernel.org>; Sun, 18 Oct 2020 19:33:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAEA62137B
	for <linux-crypto@archiver.kernel.org>; Sun, 18 Oct 2020 19:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603049622;
	bh=j2k1YZyoVsRQzQcrqyCwjUzNt94R8oW0p3YZnR0Yn8I=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=lJ197euBnqMxlOhu4er5TMkJupRwbHQy09MyqA4wgFMxnWYhQOqyYiBRBDRb7YKdZ
	 1D9AmsvZitOWWlFepPDfku2vtXH7oqrSitHKYFTV4Z/y/bFqJSmR8NM1lxyGyZFLci
	 /lnL3C0hHvLcl8S6TZKUl5wnrkzNHdxOyGMbB9z4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731777AbgJRT0i (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 18 Oct 2020 15:26:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731701AbgJRT0i (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 18 Oct 2020 15:26:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE23720791;
        Sun, 18 Oct 2020 19:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049197;
        bh=j2k1YZyoVsRQzQcrqyCwjUzNt94R8oW0p3YZnR0Yn8I=;
        h=From:To:Cc:Subject:Date:From;
        b=oC9F0nEnSNJ+F6NpixuoBMJFV6zZgG3BC/szEOpmbNN0lyCrv/STevdUYwNbs03p5
         zR+jiL7y+kHGzmXZeoTNewwwGJRah0QdH5KHuiuibS57C+Mxnj7rczLQ10bvZ72aIf
         ZtIj5dFtcoQoWwZW5W5sMin4S0P3y+lrKSEgQSwI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Machek <pavel@denx.de>, John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 01/41] crypto: ccp - fix error handling
Date:   Sun, 18 Oct 2020 15:25:55 -0400
Message-Id: <20201018192635.4056198-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
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
index c3f13d6505e15..0aa18c1164bfb 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -1195,7 +1195,7 @@ static int ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
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

