Return-Path: <SRS0=R0fc=5X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CAE2C2BB55
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Apr 2020 10:29:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3922220644
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Apr 2020 10:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586255343;
	bh=kbZl1uDjGDqe9P85bbeC5tlO3WXKxc6I56W8sgaOY54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=gvcPOpva7piuDqGclrdoDPrLGpuwosR7nahP9z3/z8Goem5caUa+Gz4aUsgYy7inv
	 XxyD/WGjyqe/nBzVrUdqVr6WKag03x+Hk4Dt047iP2Vjdht7ixXxI+XKtAm6d4unsE
	 l+G4g0VC9iGbu4XRtrI4AV/SC26a1IdWxcp0Qh0I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbgDGKYc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Apr 2020 06:24:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728727AbgDGKY2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Apr 2020 06:24:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BED82074F;
        Tue,  7 Apr 2020 10:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255067;
        bh=kbZl1uDjGDqe9P85bbeC5tlO3WXKxc6I56W8sgaOY54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C7ZA8P+F1wM/Zwvg3hVVuKJm40PLWedTkOn6Gb9bM4HiFDN58BDqdmr03vuIvc6/+
         p25bSMeLcnhimWz25nMI5dTdw4azOVTI7tgVlhofr4J/PmYWjizdD028qsS1uozYyu
         LwleJr5i1bEA3hHpEKE8vWbsr5BPqk3qq1s0zS/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 17/46] padata: fix uninitialized return value in padata_replace()
Date:   Tue,  7 Apr 2020 12:21:48 +0200
Message-Id: <20200407101501.345016605@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407101459.502593074@linuxfoundation.org>
References: <20200407101459.502593074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Daniel Jordan <daniel.m.jordan@oracle.com>

[ Upstream commit 41ccdbfd5427bbbf3ed58b16750113b38fad1780 ]

According to Geert's report[0],

  kernel/padata.c: warning: 'err' may be used uninitialized in this
    function [-Wuninitialized]:  => 539:2

Warning is seen only with older compilers on certain archs.  The
runtime effect is potentially returning garbage down the stack when
padata's cpumasks are modified before any pcrypt requests have run.

Simplest fix is to initialize err to the success value.

[0] http://lkml.kernel.org/r/20200210135506.11536-1-geert@linux-m68k.org

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Fixes: bbefa1dd6a6d ("crypto: pcrypt - Avoid deadlock by using per-instance padata queues")
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/padata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index fda7a7039422d..7bd37dd9ec55b 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -516,7 +516,7 @@ static int padata_replace(struct padata_instance *pinst)
 {
 	int notification_mask = 0;
 	struct padata_shell *ps;
-	int err;
+	int err = 0;
 
 	pinst->flags |= PADATA_RESET;
 
-- 
2.20.1



