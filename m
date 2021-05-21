Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D82D9C433ED
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 02:58:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4A1061244
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 02:58:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233755AbhEUDAK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 May 2021 23:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232758AbhEUDAK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 May 2021 23:00:10 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23283C061574
        for <linux-crypto@vger.kernel.org>; Thu, 20 May 2021 19:58:47 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id v4so14395791qtp.1
        for <linux-crypto@vger.kernel.org>; Thu, 20 May 2021 19:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s82gU0CvYVEzMfDJUYBwwm+dkoLpB7QNQtjnELQGLks=;
        b=Z0cO3HPKhIbRrcfBJkLD12io9fn2JH+0LemiiV2AxbExD7drmX9OoFmxisHlHfNJ+P
         YZwr0JNxxPH1si+dQU+Pk326rxvR7RmVxYHzANZcxQ3LUGw9H5uRN8hSWq2HvUFygRjC
         T35Iv/Nlna7vMHPtZlZJrujL/H5e9QXalyReocZ23ofwIznkbxFzfKgKSHPcWdJnDxuf
         HjOC1QxXlPgHQnBD5p6S4EL7pylJk6Ubr1kKeWeYy2HGkUcSGRenBqbN2kePOoAdcKJN
         GHBPc+Jyp/11sFSPX9qLj472gmyYZnc9pVpCGte1/9ApZf2/4NFZwhVl5Y2aykBSer7c
         Ceng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s82gU0CvYVEzMfDJUYBwwm+dkoLpB7QNQtjnELQGLks=;
        b=Iq51AFb4zEBa6QYnuXFSSYPmUXUKGG1r3FOSXRM8P+30mx601WrVcNqbw52/UCwZ3N
         rvKBjYOWIXfhUaCab3794q7Fr6Vexrsn0F0iEzsUjGXtmMFvAp3pq4gb+7Rrxc1bGHmK
         4movLxMiOxGepIbudfOe3/rp94UVUmNfxixY9PSMQKDuzNGJWV8vBYtpNAFMwylSYtmB
         vuJv5M/VloT5cDrqfEn+iXvTc+NPM2gz71H/opU1It+g6puakuaw2TyXUr/62Il9L393
         0H+UrKm9n8hqpzSgABUWbamcaZB2tMAmuLfmGwZAfbEouyzuzHdek3i668/S5YnxZ+Vo
         IEKg==
X-Gm-Message-State: AOAM531IgtaO9M4DHYg2gAQQL/cK2/POjacoo56fw5hmoWpXiyzo8nZJ
        OT3n0621ywcdhKBCdmZBLKgWJw==
X-Google-Smtp-Source: ABdhPJzDgY0jE0nSA6dmpv9KCPnaZhfPLBueYtnDCaRB46wjOODRYcxATmF8Uu0HUhndQXeGpIpS8w==
X-Received: by 2002:aed:3071:: with SMTP id 104mr7349289qte.119.1621565925970;
        Thu, 20 May 2021 19:58:45 -0700 (PDT)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id a10sm3510534qtg.40.2021.05.20.19.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 19:58:45 -0700 (PDT)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH] MAINTAINERS: Add maintainer for Qualcomm crypto drivers
Date:   Thu, 20 May 2021 22:58:44 -0400
Message-Id: <20210521025844.1239294-1-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There is no maintainer for Qualcomm crypto drivers and we are seeing more
development in this area. Add myself as the maintainer so that I can help
in reviewing the changes submitted to these drivers.

Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6df5a401ff92..d478f44be7ce 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15136,6 +15136,13 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/opp/qcom-nvmem-cpufreq.txt
 F:	drivers/cpufreq/qcom-cpufreq-nvmem.c
 
+QUALCOMM CRYPTO DRIVERS
+M:	Thara Gopinath <thara.gopinath@linaro.org>
+L:	linux-crypto@vger.kernel.org
+L:	linux-arm-msm@vger.kernel.org
+S:	Maintained
+F:	drivers/crypto/qce/
+
 QUALCOMM EMAC GIGABIT ETHERNET DRIVER
 M:	Timur Tabi <timur@kernel.org>
 L:	netdev@vger.kernel.org
-- 
2.25.1

