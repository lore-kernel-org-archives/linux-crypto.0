Return-Path: <SRS0=/CTJ=QB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78E62C282C0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 08:49:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 431412184B
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 08:49:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="YGFcznkG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfAYItW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jan 2019 03:49:22 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39142 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726402AbfAYItW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jan 2019 03:49:22 -0500
Received: by mail-wm1-f66.google.com with SMTP id y8so5769509wmi.4
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jan 2019 00:49:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=xATq3/fy0c4eTzVipTFkHmC1O94IHtmhyA8aNY8Z5gM=;
        b=YGFcznkGQl85fQXyhF+3kGpAt1GohZCrt4sGhIGMqfkVeI0UB2cV75Uy+m9BrztM3E
         zO+gNgWSIO1sMMsMITpy8EOTbRWcx9a9CfasGgnQkL2pcF492nmIjmN6GSQex3govA1/
         51lwywEaIescOGlZrwONQ34Z3T54dNJJROhLU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xATq3/fy0c4eTzVipTFkHmC1O94IHtmhyA8aNY8Z5gM=;
        b=WEbhX68SrpNVeOyUtU2UdDjYpT9m+dV+I5GUtn31DXTEoiexRpHHuupI/SVvUWtHcQ
         hksuj97WOTsPqHKVnEFhiryTH8Ehh3CPNU+gTmniId9JuAUDLYGn48cJsxW8X0bwiH/9
         rDdK1WDFc8VS+pjSqUfLOfVvIqqOkniUUx4VyjLmu5sMlBuYaoDx8mpOMTJh9zAbsVwi
         OEvldZs+OY/x1vKvTkxoHLxyMBlkcAUlfIQZwK6ofcE/gy3/A+qaEbajM65/9lhT/EVc
         ORxqVb0cze6yhH6gS7TZiZBOsZ9dkanuZyHB8OOGHPe2isWOzo573EAnRrohO8Q80C1m
         DHDg==
X-Gm-Message-State: AJcUukcFQxfl0yiggGdcmv/+XUbmtWuB4OC/d4+qeflk7M9kkWUw7LJ5
        Cfiw7nq44IPp4yODwW7Xw1RwtC8t/XKD2Q==
X-Google-Smtp-Source: ALg8bN5CIqXCZM/orVMFojC0bcJA0bIpWt5s1xxW7/W/6KvqBqonjkiFQMEabf/ChaLPruJ6YjTS3Q==
X-Received: by 2002:a7b:c315:: with SMTP id k21mr5718422wmj.145.1548406159966;
        Fri, 25 Jan 2019 00:49:19 -0800 (PST)
Received: from dogfood.home ([2a01:cb1d:112:6f00:bcd4:806e:230a:673e])
        by smtp.gmail.com with ESMTPSA id 125sm112594574wmm.26.2019.01.25.00.49.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Jan 2019 00:49:18 -0800 (PST)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 0/4] crypto: fix crct10dif for ARM and arm64
Date:   Fri, 25 Jan 2019 09:49:11 +0100
Message-Id: <20190125084915.25411-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix the issues in both NEON implementations of the CRC-T10DIF routines,
that were reported by Eric's new testing code.

v2:
- keep alignment specifiers where possible (#1)
- clarify/fix commit log (#2)
- add fixes/cc-stable/etc tags
- add patches that drop the now unreacheable code (#3 - #4)

Ard Biesheuvel (4):
  crypto: arm/crct10dif - revert to C code for short inputs
  crypto: arm64/crct10dif - revert to C code for short inputs
  crypto: arm/crct10dif - remove dead code
  crypto: arm64/crct10dif - remove dead code

 arch/arm/crypto/crct10dif-ce-core.S   | 27 +++++---------------
 arch/arm/crypto/crct10dif-ce-glue.c   | 23 +++++------------
 arch/arm64/crypto/crct10dif-ce-core.S | 11 --------
 arch/arm64/crypto/crct10dif-ce-glue.c | 25 +++++-------------
 4 files changed, 19 insertions(+), 67 deletions(-)

-- 
2.17.1

