Return-Path: <SRS0=C62c=C3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D37BC43464
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 07:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE1DE21973
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 07:23:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="15Lw0w/D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgIRHXh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Sep 2020 03:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbgIRHXf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Sep 2020 03:23:35 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41AF1C061788
        for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2020 00:23:34 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id e17so4293324wme.0
        for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2020 00:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=thgOsxp+Xq4BrFvbMKlBsMkOaotb5Mf5M65feuQsl1g=;
        b=15Lw0w/Dv1oD9BPmxmyBukpkJeQWTO9fcY1tUj7eh0sOyFr8HK20/cOzmL9U9v/fAS
         gZdeCmUpmD6AmP/hXZSf9zElisfE7iSbWXr0MRv765Zy4EoMOzzGbwkdWnlC9Vk24KDl
         y9AHI2A/OGRnm/8JptKsDnJBBHQL8sinwF+qdVmr0lhIQzlLRBPCScV2AbuWbHWpnTYo
         mze28Rs0v0NpD6rz7WnRKSHB/nlQh99FwDeuXE8TIWf1QP/PMOH1dL+/D6qQ8uKSez0B
         GmU9ITp7m+KtRnoH9K1c/EizvzaS398ZFqs8IcNwIBU53pkk+fjWNejs4ESLSQCvIowG
         B94Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=thgOsxp+Xq4BrFvbMKlBsMkOaotb5Mf5M65feuQsl1g=;
        b=ryKr+K+rePCNmwNElIjxSmf1b+xON6w/c5ehaHYWnhrqhUdNQxEVrM+E6NZRm1SN+a
         ftxi9PVsSCKh0mspBlRZiZFpzWZ6DAT6j4o9BU4JXIdq+RqS9Neu+vBiZtOFD8LFvSuo
         StkguJikf9k3/yJ5XzHV/Q84TRqX+rfuLMbaidfPzlvcgkA3xLySVsrnDnv6YCuBQQsC
         9Kxrrvrz+t2vBOlqhKG8aNXHrL3ke0nvPdegat8eK8k4OxsXa9BG32gvL9TytAKswJ71
         o3oPcibrgukbkivVVftiTnMPCo827kS6AnPGfu0ejW+ynsk5IPWLrrafffiJbeYX8EUp
         4cog==
X-Gm-Message-State: AOAM533fOo3uGabOVhTLpyuysRbBc4hrpkSeOcZWjUxST5txIzy82WoH
        Jt2PJKUgDfomF/rnPLh/aaLZsw==
X-Google-Smtp-Source: ABdhPJzZ6lmTRQWpdoOt6MPjdP2mXcVZoxwSWh5PFOqfTuKO1P6x8PWE+OyeHa79wKYuUwb+VGRPfg==
X-Received: by 2002:a1c:3985:: with SMTP id g127mr14614813wma.32.1600413812991;
        Fri, 18 Sep 2020 00:23:32 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id z19sm3349546wmi.3.2020.09.18.00.23.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Sep 2020 00:23:32 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v7 07/17] crypto: sun8i-ce: handle endianness of t_common_ctl
Date:   Fri, 18 Sep 2020 07:23:05 +0000
Message-Id: <1600413795-39256-8-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600413795-39256-1-git-send-email-clabbe@baylibre.com>
References: <1600413795-39256-1-git-send-email-clabbe@baylibre.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

t_common_ctl is LE32 so we need to convert its value before using it.
This value is only used on H6 (ignored on other SoCs) and not handling
the endianness cause failure on xRNG/hashes operations on H6 when running BE.

Fixes: 06f751b61329 ("crypto: allwinner - Add sun8i-ce Crypto Engine")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index 138759dc8190..08ed1ca12baf 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -120,7 +120,10 @@ int sun8i_ce_run_task(struct sun8i_ce_dev *ce, int flow, const char *name)
 	/* Be sure all data is written before enabling the task */
 	wmb();
 
-	v = 1 | (ce->chanlist[flow].tl->t_common_ctl & 0x7F) << 8;
+	/* Only H6 needs to write a part of t_common_ctl along with "1", but since it is ignored
+	 * on older SoCs, we have no reason to complicate things.
+	 */
+	v = 1 | ((le32_to_cpu(ce->chanlist[flow].tl->t_common_ctl) & 0x7F) << 8);
 	writel(v, ce->base + CE_TLR);
 	mutex_unlock(&ce->mlock);
 
-- 
2.26.2

