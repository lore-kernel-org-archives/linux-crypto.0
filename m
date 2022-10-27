Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72AF0FA3740
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Oct 2022 19:36:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235842AbiJ0TgD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Oct 2022 15:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235760AbiJ0TgB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Oct 2022 15:36:01 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83062578A6
        for <linux-crypto@vger.kernel.org>; Thu, 27 Oct 2022 12:35:55 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id h18so1688822ilq.9
        for <linux-crypto@vger.kernel.org>; Thu, 27 Oct 2022 12:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GE4BrpJENipHT6Wm0Dra1scB+E+dY7XL7G0oLdHDLCY=;
        b=gNK/tmSFOOjCMCFtwB0WnoFMM4QlCpiO/5q4uTfYA8SIlDTV5wffYTx4mLbT8P4eR8
         OrMggnMHTV1AnkACQl0FsoexexPp5UmWwN0U4ixBKOW6G9dghzAbJcS1waK7aW0WayJ3
         c0DlAtFlmeCigZ2RUx/x/SYg2dDxuC4MKtMLJxi2a3pT0VcMEFC8gOEu/PQs7RRQ7+uY
         BFG/LvcAqvUw1YGZaupVNKugwTrKe4n888C/hueF7or1S+3IR6JJbuOMwqu9NUH9wp1a
         trXp0vkGCMSmnokS4aQW//ZknQUOlcifdRzoQcXuj+nVHCTmuD8cCPHwLmDQmtk8EmGQ
         oydA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GE4BrpJENipHT6Wm0Dra1scB+E+dY7XL7G0oLdHDLCY=;
        b=so1hV3xKYg6bYiclL/SI7AsbrgrKAiaYIGO2anh/JlT6V0e1HSguOLLZyNC/qoYJHj
         1JfgIizhDpF4/AqxxiLHkBYdPQ4KPWtGS743Nd/ZpityWcPZ+VgksLMYTnZPRLvLAWRg
         a4BZifgV+syjFJWN/JXNoa3JQiAlgUzk/56H0VjHbruDRY/SRRpSRuK45VN/bHfQ7ysJ
         eFYN3VCYhxLaErjb1OcgsS/SYGDGPrd5spAQAk7ai3oiCx22AJC+Fam1wi7NiPTJAI1K
         hL4Urjq+89L+9KigHVfFTvKM9MWcu0BN7qfMZKKki1UOl8OU6dUGviDSp9A/jIEO4DiP
         X3dA==
X-Gm-Message-State: ACrzQf3OlihZ52R1LzRQi8KG/m0nroZAkVwsFCsoDUeukLOOAJMpHcA8
        KgSo/TIz08VqpRtxqruxxYtENI7e9w66gQ==
X-Google-Smtp-Source: AMsMyM5udbp6cMGNgKSuRmLi8e8X5VJGTrA1EDiRr26I3LMTyn/zOxwyZvDB3fS4b4NaHbPUCr0UIQ==
X-Received: by 2002:a05:6e02:180f:b0:300:2f31:a1f1 with SMTP id a15-20020a056e02180f00b003002f31a1f1mr10312476ilv.179.1666899354815;
        Thu, 27 Oct 2022 12:35:54 -0700 (PDT)
Received: from maple.netwinder.org (rfs.netwinder.org. [206.248.184.2])
        by smtp.gmail.com with ESMTPSA id a42-20020a02942d000000b003633748c95dsm872059jai.163.2022.10.27.12.35.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 12:35:54 -0700 (PDT)
From:   Ralph Siemsen <ralph.siemsen@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ralph Siemsen <ralph.siemsen@linaro.org>
Subject: [PATCH] crypto: devel-algos.rst: use correct function name
Date:   Thu, 27 Oct 2022 15:35:44 -0400
Message-Id: <20221027193544.68632-1-ralph.siemsen@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The hashing API does not have a function called .finish()

Signed-off-by: Ralph Siemsen <ralph.siemsen@linaro.org>
---
 Documentation/crypto/devel-algos.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/crypto/devel-algos.rst b/Documentation/crypto/devel-algos.rst
index f225a953ab4b..3506899ef83e 100644
--- a/Documentation/crypto/devel-algos.rst
+++ b/Documentation/crypto/devel-algos.rst
@@ -172,7 +172,7 @@ Here are schematics of how these functions are called when operated from
 other part of the kernel. Note that the .setkey() call might happen
 before or after any of these schematics happen, but must not happen
 during any of these are in-flight. Please note that calling .init()
-followed immediately by .finish() is also a perfectly valid
+followed immediately by .final() is also a perfectly valid
 transformation.
 
 ::
-- 
2.25.1

