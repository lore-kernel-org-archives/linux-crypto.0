Return-Path: <SRS0=eAV2=DZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F9DDC43457
	for <linux-crypto@archiver.kernel.org>; Sun, 18 Oct 2020 19:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24A79206CA
	for <linux-crypto@archiver.kernel.org>; Sun, 18 Oct 2020 19:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603050064;
	bh=maqoZSVQAjmQq5Ak1k2jmwjOBlOlVlYDoIXSuF4W+VY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=xMq8DiSDTUMvmMBRWyRgxmqDjesMDlsEPg0W8ROWKJPf4Jaw7H16GF+5soGgR/u+6
	 DIYr2XEFZe27d5UJGT10oeYhCiUIq4QA3Es7AqxlYHoDB0dnA6ig/apj6E/gP6HPes
	 0yb/R5XqRMmuoLO9A97QL8A/VdWAbSkED9EugGCg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730805AbgJRTk6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 18 Oct 2020 15:40:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730709AbgJRTYV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 18 Oct 2020 15:24:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE0BE20791;
        Sun, 18 Oct 2020 19:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049060;
        bh=maqoZSVQAjmQq5Ak1k2jmwjOBlOlVlYDoIXSuF4W+VY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oJ3owKBKLZ3CQYUFKbVos4q5ruSDM65YX2gEwAo+BMrAcnkFXkQ0QruICvjneW7Q/
         EIYgQyXy5vUEWavNc4UWxkgeqmuKFqNHvskm+KwvKWJCQ4Nzpnq9OWLzf/mEw9yKzl
         kBqD+MlMigjQCg+ErPUXyD8+6+RIBWB+o27g2y+o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Machek <pavel@denx.de>, John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/56] crypto: ccp - fix error handling
Date:   Sun, 18 Oct 2020 15:23:23 -0400
Message-Id: <20201018192417.4055228-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192417.4055228-1-sashal@kernel.org>
References: <20201018192417.4055228-1-sashal@kernel.org>
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
index 626b643d610eb..20ca9c9e109e0 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -1752,7 +1752,7 @@ ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
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

