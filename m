Return-Path: <SRS0=ZPJC=3D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A095DC33CB1
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jan 2020 14:00:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75FF12467A
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jan 2020 14:00:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vf0d1GFb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729145AbgANOAd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Jan 2020 09:00:33 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37401 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728909AbgANN7y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Jan 2020 08:59:54 -0500
Received: by mail-wr1-f65.google.com with SMTP id w15so12304724wru.4;
        Tue, 14 Jan 2020 05:59:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vXhhnXKXoxYSpa1+LXBS7VNs2uspXwnX5jIhIQmwFrM=;
        b=vf0d1GFbo08+NG6G7zxZJeTZMiLIJ81itsHNzneSbCkxlMw9PSK/5EefhFcFVz9UQt
         opn2DFmB99e8fxSV8zDeioxOunCEPA1JwLFUV1JZ7tohx4yS9VeIx8szZELtTSaUVi8e
         MpWVfqUzXzlqC8OzVcKJK0ejjOuekOA7kfio69OKQHzwuuBCoSSJilnH5swyZxmwDZJF
         tN3p1UTmeFTOKAHtBkIz5KeyE9Q4FZuzTOg9R23HG9C9cgjdnkGH0O/sF2p6DB0IkmgJ
         U5ZD/0/mbzXaXbqd6FkEoMNCPZqXCdUeNLQe5nz7k+II0heYxnrX1j0mMKgnkq6aGLYT
         cx4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vXhhnXKXoxYSpa1+LXBS7VNs2uspXwnX5jIhIQmwFrM=;
        b=Oy7B2bqjPKt3JraVLq+uRzyqxAQ+oq1+bZQRKVEb9acahUDnzYz6RYg0EahBGWJC54
         XF70JortqoD97HwErlkrFyPa1MsByZvV/YiscIxclzu1wUBV7vgCOib0EmUlpB/lB+YC
         Rwlmjuad+RxWwJYv4RNQzWU1EVQqAaWDxN0YH1wrsQ3HdSERoOvFdW4wdNeF6pW+P4eQ
         geC62V7fs6qg4iJw0tgBG1n5YIwk16WrmKLmWFpJZ/V50sBTiUorDtUTLUoFvnVZvPqB
         9WDwceEDDJiJB8CK6tVKKkKlfZDPARo0lYeJda4GinAEy1/rCKN62s8rzU7wcOFvyrsi
         ixsw==
X-Gm-Message-State: APjAAAUCBWmJx19grPHAOvID7IXwC5JqNXR8kEznfFcMxAhcAB/nnNVo
        3wnixloHzpZJLBDEDxIDD0c=
X-Google-Smtp-Source: APXvYqzIL5QDAbPSLYL8aOpzAthE16eu5faMIOdeePz7IfOOcLviaBT2dTkTsFRl6NklQxS0c9Fjhw==
X-Received: by 2002:a5d:6703:: with SMTP id o3mr26238015wru.235.1579010392992;
        Tue, 14 Jan 2020 05:59:52 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id 4sm17854448wmg.22.2020.01.14.05.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 05:59:52 -0800 (PST)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     alexandre.torgue@st.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, mcoquelin.stm32@gmail.com,
        mripard@kernel.org, wens@csie.org, iuliana.prodan@nxp.com,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH RFC 02/10] crypto: sun8i-ce: increase task list size
Date:   Tue, 14 Jan 2020 14:59:28 +0100
Message-Id: <20200114135936.32422-3-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114135936.32422-1-clabbe.montjoie@gmail.com>
References: <20200114135936.32422-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The CE can handle more than 1 task at once, so this patch increase the size of
the task list up to 8.
For the moment I did not see more gain beyong this value.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 4 ++--
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h      | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index f72346a44e69..e8bf7bf31061 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -321,7 +321,7 @@ static void sun8i_ce_free_chanlist(struct sun8i_ce_dev *ce, int i)
 	while (i >= 0) {
 		crypto_engine_exit(ce->chanlist[i].engine);
 		if (ce->chanlist[i].tl)
-			dma_free_coherent(ce->dev, sizeof(struct ce_task),
+			dma_free_coherent(ce->dev, sizeof(struct ce_task) * MAXTASK,
 					  ce->chanlist[i].tl,
 					  ce->chanlist[i].t_phy);
 		i--;
@@ -356,7 +356,7 @@ static int sun8i_ce_allocate_chanlist(struct sun8i_ce_dev *ce)
 			goto error_engine;
 		}
 		ce->chanlist[i].tl = dma_alloc_coherent(ce->dev,
-							sizeof(struct ce_task),
+							sizeof(struct ce_task) * MAXTASK,
 							&ce->chanlist[i].t_phy,
 							GFP_KERNEL);
 		if (!ce->chanlist[i].tl) {
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index 49507ef2ec63..049b3175d755 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -73,6 +73,7 @@
 #define CE_MAX_CLOCKS 3
 
 #define MAXFLOW 4
+#define MAXTASK 8
 
 /*
  * struct ce_clock - Describe clocks used by sun8i-ce
-- 
2.24.1

