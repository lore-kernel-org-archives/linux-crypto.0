Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A5A1C433E9
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Feb 2021 15:48:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB93B64DD6
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Feb 2021 15:48:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbhBBPrL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Feb 2021 10:47:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:38256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234897AbhBBPNf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Feb 2021 10:13:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3A7A64F96;
        Tue,  2 Feb 2021 15:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278439;
        bh=oJfyoLsy9Z5KwuKPh05Zd9pPRALtStDgdIMxx2am3yQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qb7nODvTH8JHJY5YfT7WT87h5ctUnEXQBhqX9T862Zm0RoOJ8QSQoUxU4GGFPbD1M
         CUurK0ZFBAcTbxRgqaHF65u+ix+giuMKV/DXngH38UAd63e33330Iqol100NgghPU6
         G8nDLCRWKXF5CC4m47Phn0dk6w5Dl1PDn3RlDhg5MZmQbrx5wDGkdgysXxfIO7FODs
         IJtRHBXmLKjsyRqDXQYKcBTMnorR2txyveylDrqNBFyWST3y5L4VMhPMC+Oq6h+EWm
         0XhHBFRUbHmQ2GSm51fptzuOq+/kTO2RAvovsLHD3hBx/2dm+As+PT3+NbGlCTTvGL
         iPoKtS/mXF3sg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pan Bian <bianpan2016@163.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 03/10] chtls: Fix potential resource leak
Date:   Tue,  2 Feb 2021 10:07:07 -0500
Message-Id: <20210202150715.1864614-3-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202150715.1864614-1-sashal@kernel.org>
References: <20210202150715.1864614-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit b6011966ac6f402847eb5326beee8da3a80405c7 ]

The dst entry should be released if no neighbour is found. Goto label
free_dst to fix the issue. Besides, the check of ndev against NULL is
redundant.

Signed-off-by: Pan Bian <bianpan2016@163.com>
Link: https://lore.kernel.org/r/20210121145738.51091-1-bianpan2016@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/crypto/chelsio/chtls/chtls_cm.c
index fd3092a4378e4..08ed3ff8b255f 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -1051,11 +1051,9 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 	tcph = (struct tcphdr *)(iph + 1);
 	n = dst_neigh_lookup(dst, &iph->saddr);
 	if (!n || !n->dev)
-		goto free_sk;
+		goto free_dst;
 
 	ndev = n->dev;
-	if (!ndev)
-		goto free_dst;
 	if (is_vlan_dev(ndev))
 		ndev = vlan_dev_real_dev(ndev);
 
@@ -1117,7 +1115,8 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 free_csk:
 	chtls_sock_release(&csk->kref);
 free_dst:
-	neigh_release(n);
+	if (n)
+		neigh_release(n);
 	dst_release(dst);
 free_sk:
 	inet_csk_prepare_forced_close(newsk);
-- 
2.27.0

