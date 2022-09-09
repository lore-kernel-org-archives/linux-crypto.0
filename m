Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C499ECAAD3
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Sep 2022 09:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiIIJ6z (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Sep 2022 05:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiIIJ6W (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Sep 2022 05:58:22 -0400
Received: from mail-ed1-x54a.google.com (mail-ed1-x54a.google.com [IPv6:2a00:1450:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D9E129C7E
        for <linux-crypto@vger.kernel.org>; Fri,  9 Sep 2022 02:58:21 -0700 (PDT)
Received: by mail-ed1-x54a.google.com with SMTP id t13-20020a056402524d00b0043db1fbefdeso915103edd.2
        for <linux-crypto@vger.kernel.org>; Fri, 09 Sep 2022 02:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=kCUum3/Q0kMRGABgSdJa++Yx/m9FJ7EZUjHqNypROSw=;
        b=P3JahIbVpkXfXsADRpve4JTx7jId2xVWFPXYOH82WLKc5va0xx+X5STtLxX8OVqrfN
         EJm+A8hqB2/z3VQn+VtPImzXbrqr0jPAPwlq16X9VkLN96Mt3QJuxRia+lAzX8EAeQHh
         kFLoNt8MJhjeeCQRR4LOMNdAd2+RNY+Z9yAdxU5OKCAK2aURMwlCR2UfWhZ8tma0gpBb
         kdjcRR8QoM2RmC1s7QHHYJzU86JsjeJxR8RE8LBuK5FcctojzJi9lIEJNl3NG+3/mSC1
         MrtaPhT24WuhUEdDQQn3nLIvnDjtXVCn41ZN1LNLoKtdiq177+GOQpy7aCcQnfJaABb4
         XFzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=kCUum3/Q0kMRGABgSdJa++Yx/m9FJ7EZUjHqNypROSw=;
        b=oDnoh+lcIRomlQjAG4cCB++JquGiiXYsaDJGuq7eCcjje7L/WwXrcOKdkbxsyKkU3J
         cMQu6kuYHVP5qJ1tr9FVsVQZT6QK8paHDLVwv8IibcTivBB747iwlV2I88y1JB/lTvKe
         ut+SQCs4hLjga8w8d6txNpLE5zaGz+5Nyg2GpYn5tGEGFYbH8XkHwZXHOH5Nqx35mgKb
         QQ69GlKqRhxtSrEguur22s4Aqj991vdHoA/nPncnEEuWTDQt09rFU0VVhZ0Y/abTKHOh
         pCkX2fgdd+E+kYwZwhUvWvQ9OGzS0XUXM8cE3KlT2M+ziV+gMPD+yTb+3JgYqd67xU21
         1aAQ==
X-Gm-Message-State: ACgBeo2Wt6zMyKk2hzX2z6A6FzzrA07PUWBji+0W/a9sFf2LsYdgZPk3
        4kqx3vINt5Ktz6yTfddCq0Z4BBdWYao=
X-Google-Smtp-Source: AA6agR5AZ7lsTIN+wX/bYUcoT5/o9+gSgZoAysLoufNMyGicwV2HoH62TmxnJD614NfbcWF+/PHAhUW2M+g=
X-Received: from glider.muc.corp.google.com ([2a00:79e0:9c:201:eaa4:a143:fbdd:a2d1])
 (user=glider job=sendgmr) by 2002:a05:6402:550c:b0:443:7d15:d57f with SMTP id
 fi12-20020a056402550c00b004437d15d57fmr10666201edb.147.1662717499654; Fri, 09
 Sep 2022 02:58:19 -0700 (PDT)
Date:   Fri,  9 Sep 2022 11:58:11 +0200
In-Reply-To: <20220909095811.2166073-1-glider@google.com>
Mime-Version: 1.0
References: <20220909095811.2166073-1-glider@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220909095811.2166073-2-glider@google.com>
Subject: [PATCH -next 2/2] crypto: x86: kmsan: disable accelerated configs in
 KMSAN builds
From:   Alexander Potapenko <glider@google.com>
To:     glider@google.com
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Robert Elliott <elliott@hpe.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

KMSAN is unable to understand when initialized values come from assembly.
Disable accelerated configs in KMSAN builds to prevent false positive
reports.

Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Robert Elliott <elliott@hpe.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-next@vger.kernel.org
---
 crypto/Kconfig | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 40423a14f86f5..4a2915bd40d1f 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1430,7 +1430,9 @@ endif
 if SPARC
 source "arch/sparc/crypto/Kconfig"
 endif
-if X86
+# KMSAN is unable to understand when initialized values come from assembly.
+# Disable accelerated configs to prevent false positive reports.
+if X86 && !KMSAN
 source "arch/x86/crypto/Kconfig"
 endif
 
-- 
2.37.2.789.g6183377224-goog

