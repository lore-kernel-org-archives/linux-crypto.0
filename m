Return-Path: <SRS0=ziyG=YE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CC58C47404
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 17:09:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E673B2084C
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 17:09:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TJlaeQWi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbfJKRJa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Oct 2019 13:09:30 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36695 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728086AbfJKRJa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Oct 2019 13:09:30 -0400
Received: by mail-wr1-f67.google.com with SMTP id y19so12756564wrd.3
        for <linux-crypto@vger.kernel.org>; Fri, 11 Oct 2019 10:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kZD/slGPT+HURYuc4jWGCyYNKABVQeEvONTiAAt2BlM=;
        b=TJlaeQWiw+rm/0HShaNai1fxJWuC7DNfKVSt3cNH3e/lPFzqKpow7XdQ+CN6hrPe3Q
         u7R8v+HJQVWuTT7x9Lo6AdEgH2T3QfwxM2+t/dSL/jHchu2/MCFHXNd2wlsk7Z/JeCjx
         vCUELlAKszmHdPSRkhQ0zwqK88EMwW6F+dP3pwYNUmKcRfbAO4WR8ZEomP8iAJNd/Xaq
         bRTxOpvui7Glx9S3bdTcl6GbMqt4IbeD1tU0n7p87LaFjFfl6GMTXC+cEhaeXIPriZs0
         gjoBP79sVfVYg8+Kh0s0jyLqWvgqiGsppTbOr8gxEJOPQ+hr1GjkvrmkbhA2KuEhLtOk
         AR2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kZD/slGPT+HURYuc4jWGCyYNKABVQeEvONTiAAt2BlM=;
        b=ooB3dG6GZLRI4Ee40nfhDgcmMZT7O8QZuBLwYF0OZzph284xktMK3o0/YfoGBfUCDC
         OUzARfQLZtaLukgdD9df4zfUpHUM828BPs+NH7GfK8VplFymmd4olmUglg2X49HBd0/y
         SDyimTMPsCKV+lIQEy4R4JVyjdx17BCTsWAsbpr163RxdFiTbcF7ASXIPcLLJCGL5GwO
         JF/czjBo3sk+SW9joujR+DI7Gelyg/2FD3LTtyCshgYAAj6+L8Lf2bCZckZBgB0w30NC
         MzpAeuQS6ufknliJAJ5+R3li0FWdun8JzUyJAuvlq9zN5b1x6UHmoyStXyIZ9/LGZ8Nm
         aM+g==
X-Gm-Message-State: APjAAAXEieYJcDx6Pm/PDDZ1klsXY8VEXALWophWSorMyHHx7pDvWbD5
        l1dDu8S+sJvOngvWO4fHXYhzmgElO8ciOQ==
X-Google-Smtp-Source: APXvYqx+AinXmXrqVF+PPFAOtYaBKjKMwZsF2oXux9p9r13CenuQJ0Xno3u34QkatlluV5fjC1P2dQ==
X-Received: by 2002:a05:6000:18d:: with SMTP id p13mr143885wrx.396.1570813768349;
        Fri, 11 Oct 2019 10:09:28 -0700 (PDT)
Received: from localhost.localdomain (91-167-84-221.subs.proxad.net. [91.167.84.221])
        by smtp.gmail.com with ESMTPSA id f9sm11876875wre.74.2019.10.11.10.09.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 10:09:27 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH 0/2] crypto: aegis128 SIMD improvements
Date:   Fri, 11 Oct 2019 19:08:21 +0200
Message-Id: <20191011170823.6713-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Refactor the aegis128 code to get rid of indirect calls, and implement
SIMD versions of the init() and final() hooks. This results in a ~2x
speedup on ARM Cortex-A57 for ~1500 byte inputs.

Cc: Ondrej Mosnacek <omosnace@redhat.com>

Ard Biesheuvel (2):
  crypto: aegis128 - avoid function pointers for parameterization
  crypto: aegis128 - duplicate init() and final() hooks in SIMD code

 crypto/aegis128-core.c       | 125 ++++++++++----------
 crypto/aegis128-neon-inner.c |  49 ++++++++
 crypto/aegis128-neon.c       |  22 ++++
 3 files changed, 134 insertions(+), 62 deletions(-)

-- 
2.20.1

