Return-Path: <SRS0=XJfk=6W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8091BC38A2A
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 22:35:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F1F8218AC
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 22:35:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SAYhGdmD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgEHWf2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 May 2020 18:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727787AbgEHWfR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 May 2020 18:35:17 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F41C061A0C;
        Fri,  8 May 2020 15:35:16 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id x73so2677573lfa.2;
        Fri, 08 May 2020 15:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dYc56LJyuVcayFnX36x0pkl73s/6indFmZNsggUQ4ms=;
        b=SAYhGdmDQrAhpmP3CUHndhAvMr/GwCFKy7hVmLOPb6rqLMzy8XW2kKTBFKqx2P8tco
         m2YUByA8D4IdvKBJbTGSahkpVnr4nhvjO8HEBjN26UrCfVV/RQN+uMetMyqHn7SHw2V/
         av1I4l1enHmHWPc0Lw9N2UlZPbFIIFxBt2MxK+jxwEwJ/MizwEW9TrtfeT0PluCvXNkq
         esJgS+EaBPpORl1Y1fSbI8qJ2Cr8hD/iMiTwCcT9bRQR8+bzd/e5/8wyguEGbNh/NwZ1
         qNM/ViBZbvZIiEcBOzQPUkd8r8aGpg0dcNmzND0ZirxY1ZcLoSkWw6EubAib9VN9NQIb
         P70g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dYc56LJyuVcayFnX36x0pkl73s/6indFmZNsggUQ4ms=;
        b=IXC+u0HDjS0wNB4gIOUT2VHA5m+uy7SOUzoAQKGApsmcmkWhYVJwEqYrX2T6HUqx6q
         EoiCBh0RJBF2kcVMfv2i3dSlylC3YfCD0j/yIsJMlssVh86KZ8De99b0RnZFG9jVrBkr
         Hv7w6Wp/3sNVIykZjUF3X5xdKueV/z6WUhpmsL8wttTbxERy8SOnXFWoCLfd4z/d21jR
         WEhGKVeq55IqDAEwYh6wOeqmVm/yLuAHYqphOM/scjSHSxRjW0SiO1JFrGTsdmlHa5eD
         snSsHWlUlAq8RfqHNO+X0Cp5kltw48o8+BOhKE3rLg3e0GERXuWJ1VIABwGVkcvQ5Fv+
         H/Dw==
X-Gm-Message-State: AOAM531v3Mi/u8S+3g60rUVJmRmgk0NYpg7OEfF+JZDiUUNK3PwL+QYg
        AbI3pcZCaeG7seiDgF87R2Y=
X-Google-Smtp-Source: ABdhPJydtn4ZuoPfD3YzzL9eEKvyCdTln8yjZD+F8iN8tJnIgzsIYjWfd45PhYzPRB4F0mpBMq/bRw==
X-Received: by 2002:a05:6512:44d:: with SMTP id y13mr3300679lfk.118.1588977315527;
        Fri, 08 May 2020 15:35:15 -0700 (PDT)
Received: from localhost.localdomain (h-158-174-22-22.NA.cust.bahnhof.se. [158.174.22.22])
        by smtp.gmail.com with ESMTPSA id s11sm2316501lfo.86.2020.05.08.15.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 15:35:15 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     Zaibo Xu <xuzaibo@huawei.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: [PATCH 2/4] crypto: hisilicon/hpre - constify struct debugfs_reg32
Date:   Sat,  9 May 2020 00:35:00 +0200
Message-Id: <20200508223502.7258-3-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508223502.7258-1-rikard.falkeborn@gmail.com>
References: <20200508223502.7258-1-rikard.falkeborn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

hpre_cluster_dfx_regs and hpre_com_dfx_regs are never changed and can
therefore be made const.

This allows the compiler to put it in the text section instead of the
data section.

Before:
   text    data     bss     dec     hex filename
  16455    6288     480   23223    5ab7 drivers/crypto/hisilicon/hpre/hpre_main.o

After:
   text    data     bss     dec     hex filename
  16839    5904     480   23223    5ab7 drivers/crypto/hisilicon/hpre/hpre_main.o

Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 0d63666ba373..840e16c14570 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -134,7 +134,7 @@ static const u64 hpre_cluster_offsets[] = {
 		HPRE_CLSTR_BASE + HPRE_CLUSTER3 * HPRE_CLSTR_ADDR_INTRVL,
 };
 
-static struct debugfs_reg32 hpre_cluster_dfx_regs[] = {
+static const struct debugfs_reg32 hpre_cluster_dfx_regs[] = {
 	{"CORES_EN_STATUS          ",  HPRE_CORE_EN_OFFSET},
 	{"CORES_INI_CFG              ",  HPRE_CORE_INI_CFG_OFFSET},
 	{"CORES_INI_STATUS         ",  HPRE_CORE_INI_STATUS_OFFSET},
@@ -142,7 +142,7 @@ static struct debugfs_reg32 hpre_cluster_dfx_regs[] = {
 	{"CORES_IS_SCHD               ",  HPRE_CORE_IS_SCHD_OFFSET},
 };
 
-static struct debugfs_reg32 hpre_com_dfx_regs[] = {
+static const struct debugfs_reg32 hpre_com_dfx_regs[] = {
 	{"READ_CLR_EN          ",  HPRE_CTRL_CNT_CLR_CE},
 	{"AXQOS                   ",  HPRE_VFG_AXQOS},
 	{"AWUSR_CFG              ",  HPRE_AWUSR_FP_CFG},
-- 
2.26.2

