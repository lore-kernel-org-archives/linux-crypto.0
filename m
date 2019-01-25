Return-Path: <SRS0=/CTJ=QB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8E31C282C0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 09:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 856AA218E2
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 09:36:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="B2MKYAdG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfAYJgf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jan 2019 04:36:35 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39131 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbfAYJgf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jan 2019 04:36:35 -0500
Received: by mail-wr1-f65.google.com with SMTP id t27so9517871wra.6
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jan 2019 01:36:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=K82b4u0JeOxmjCgmJBy7RDWk5mZMmmjLdOOMm2/dRP8=;
        b=B2MKYAdGHJazbaVbP1PZkrkDcNSrjKTR9v9WP3oBqkyUr6SUSazVYMaosXXVikDsfR
         t4YjVHBbU8r5IYt/yd5oHVJCQgGr8sVR+m96D0lZEtfaExFlXcYaLhgFXYhbI3hckG4b
         Ee5yhVanr/Oj1fQZj1n9da4GuFiwD1cNSY7Ro=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=K82b4u0JeOxmjCgmJBy7RDWk5mZMmmjLdOOMm2/dRP8=;
        b=rNE1esXsFNuiPitG3nWyA6Lwu+HqAlCZrV0xIACBvGXUOz8dAD169K/Wpp3w/WN8DT
         jHH2WV/gNxR22mInkqWFq7YnOEKSUuje6HjMkAKpXz8F0QwR0kYU76bpukI8Gm3i29z5
         dPajd9qWYCD3KCnHwfoTXPrpr+TPvAaTxJe4OqOEc5uF6Bc26ni3yeLvJV8SvhBZClem
         pkphgZhF+DFbL1HJpypZj5cRPxJ84cFYDKGw2mTtCSKPQMH1Hw+ecpMwIWGD9KfMYLoo
         vM6Bso02i+kPFdqelFvUdHGVBUTr3zoUVt1i++WX2QsGcL/EbRiazo3TgbBy+MB+pCaq
         Ufpg==
X-Gm-Message-State: AJcUukfN9024iFZGRPj3XvfGNpNowyT5dJugNzTdjABx2dqvwhXnFwOb
        fM6nJXFUOh6TwGIi7d9CyJvJ742y9JBiPA==
X-Google-Smtp-Source: ALg8bN4eEFs0NiKZlfzz0vEKISQvY8Vmh6IoOT7PLzLliyKHbVNwE+FHVkOmm7pHuMj626GWI2sl/Q==
X-Received: by 2002:adf:dbcb:: with SMTP id e11mr11066521wrj.58.1548408993535;
        Fri, 25 Jan 2019 01:36:33 -0800 (PST)
Received: from dogfood.home ([2a01:cb1d:112:6f00:bcd4:806e:230a:673e])
        by smtp.gmail.com with ESMTPSA id w80sm92323955wme.38.2019.01.25.01.36.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Jan 2019 01:36:32 -0800 (PST)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 0/2] crypto: arm64 - expose PMULL variants as separate algos
Date:   Fri, 25 Jan 2019 10:36:25 +0100
Message-Id: <20190125093627.14288-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Both the GHASH and the CRC-T10DIF SIMD routines are based on 64-bit
polynomial multiplication, but fall back to the slower 8-bit polynomial
instructions if the optional 64-bit PMULL instruction is not implemented.

This means we can only ever test one of the two on a single system,
which is unfortunate. So instead, register both versions on hardware
that supports them, and let the crypto API decide which is the preferred
one based on priorities. That way, both will be tested, but only the
fastest available one will be used.

Ard Biesheuvel (2):
  crypto: arm64/crct10dif - register PMULL variants as separate algos
  crypto: arm64/ghash - register PMULL variants as separate algos

 arch/arm64/crypto/crct10dif-ce-glue.c |  54 +++++++--
 arch/arm64/crypto/ghash-ce-glue.c     | 118 +++++++++++++++-----
 2 files changed, 132 insertions(+), 40 deletions(-)

-- 
2.17.1

