Return-Path: <SRS0=fFzG=7R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33971C433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jun 2020 03:32:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEA54206DC
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jun 2020 03:32:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oOxhcsvV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbgFDDcS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jun 2020 23:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgFDDcS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jun 2020 23:32:18 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1820C03E96D
        for <linux-crypto@vger.kernel.org>; Wed,  3 Jun 2020 20:32:17 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id k2so471879pjs.2
        for <linux-crypto@vger.kernel.org>; Wed, 03 Jun 2020 20:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cIQNiSwo2zh6B6Kdp7Ix9xordB73NniypCevPw5WnEI=;
        b=oOxhcsvVz/mOwc4x4AFo8LBYfoYOzgK0UI1I0WFHclj8ueojMzkJupjaA2XX+eB1Kv
         EuBF0inVDuWFb78orLxaQGeTqez4tMfKQyfG4scRXxYyKkGbTHdX9kUgaVjoJNKGA5mh
         z8tnF6HXe5v3lRjORS4sQGF6iXLYYfapnIIGiOsyhOfrIe5n7mponbiBE3ETzPpx/jj5
         lX/X3Xq9WB+IU+YCyHRH2uroe17NNyyg4uYIBBagaF7wwC7B4qS8FGqerABwOrrwia89
         FCpiGaPdeKl8L8tfFeG26MKKbYPu37HmA0JEvf8/3Le2Ey4vdAbejHitdWwxxd2rPUoE
         Ypxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cIQNiSwo2zh6B6Kdp7Ix9xordB73NniypCevPw5WnEI=;
        b=SFANe4LEPTGhVbX5vm63BvygPt9KS8ch1SsWaaUk3dAkfFl/uzULUO+ENeieNnTHYl
         EyPeZPLGfoF8ddS97ajUl2utnkFAHIv5PH4WU3tVVA5TYAq7TtqnnmEPVv458bMMOVGL
         QrA+e2CLxxo/Fdmx4a9nMWFHAtnpPsu0keVRFpq7eE/T0bqv4LcnSXX87nsruWflw59c
         D3lGFEsCbxpw8d/q/l3gs/KQu2r+rlL7QHAUt1YxIQY5AiuSLT9B6sjFknQQvn2kSDcr
         3I4juGL5KTqGoTwN5a3t1FpJBqP/TO2nTwIo1pTnPUi6qwH+dO2EmIvNL2QMRtG7xunV
         whug==
X-Gm-Message-State: AOAM533ZJGZ9NjU/YHEsFINX3IonhRXWNoIrZXuIuTUm+JafYWIDrPR0
        f8XWmkvJP4LgMpZxvtWmtUhmMA==
X-Google-Smtp-Source: ABdhPJxDUpLaGd8Ah2EOUk/6YEhH5sLPNm4vSSGbi/SDOch1uipUoFtOMqN+TKKRkLDkVMSI2IM3LQ==
X-Received: by 2002:a17:90b:3105:: with SMTP id gc5mr3497133pjb.36.1591241537050;
        Wed, 03 Jun 2020 20:32:17 -0700 (PDT)
Received: from localhost.localdomain ([45.135.186.21])
        by smtp.gmail.com with ESMTPSA id r24sm2689658pgm.25.2020.06.03.20.32.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jun 2020 20:32:16 -0700 (PDT)
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
To:     =?UTF-8?q?=C2=A0Herbert=20Xu=C2=A0?= <herbert@gondor.apana.org.au>,
        =?UTF-8?q?=C2=A0Greg=20Kroah-Hartman=C2=A0?= 
        <gregkh@linuxfoundation.org>,
        =?UTF-8?q?=C2=A0Jonathan=20Cameron=C2=A0?= 
        <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?=C2=A0wangzhou1=C2=A0?= <wangzhou1@hisilicon.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        kbuild-all@lists.01.org, Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH] crypto: hisilicon - fix strncpy warning with strlcpy
Date:   Thu,  4 Jun 2020 11:32:04 +0800
Message-Id: <1591241524-6452-1-git-send-email-zhangfei.gao@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <202006032110.BEbKqovX%lkp@intel.com>
References: <202006032110.BEbKqovX%lkp@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use strlcpy to fix the warning
warning: 'strncpy' specified bound 64 equals destination size
         [-Wstringop-truncation]

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
---
 drivers/crypto/hisilicon/qm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index f795fb5..224f3e2 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -1574,7 +1574,7 @@ static int qm_alloc_uacce(struct hisi_qm *qm)
 		.ops = &uacce_qm_ops,
 	};
 
-	strncpy(interface.name, pdev->driver->name, sizeof(interface.name));
+	strlcpy(interface.name, pdev->driver->name, sizeof(interface.name));
 
 	uacce = uacce_alloc(&pdev->dev, &interface);
 	if (IS_ERR(uacce))
-- 
2.7.4

