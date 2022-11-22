Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 040E3C4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Nov 2022 22:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234981AbiKVWzk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Nov 2022 17:55:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235307AbiKVWzP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Nov 2022 17:55:15 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED241244
        for <linux-crypto@vger.kernel.org>; Tue, 22 Nov 2022 14:54:55 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id q98-20020a17090a1b6b00b00218c081f92bso2982666pjq.8
        for <linux-crypto@vger.kernel.org>; Tue, 22 Nov 2022 14:54:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CPjzMg27nsggyssWlNTVqAdofNU6F96gO6p2IIRQk5M=;
        b=SGVC0BD1YliTiWMIJWZXNMQlsIXRWnLU/5veN8ZD5UKOWOyjuM7aLFNgGBiAbylFp2
         9mChjb2FfHD+O5dctg1wpnQo3WYZjL3KTkA/8zz2mfvkQHjQARf5v5XpYemA+e/SkNpD
         UisNmhrXN1j40KoZ0rNhD/FNprmaAXBrf2URzOJhZCqVZmoJ8c7J/JpBh6WLoupZgd3n
         X41sQDiTK6defUGTdcoOcjhnQ6vAN5AYkhE53vi8+m9qwmjD2r0OWqwN59peD96l/97d
         MWyxzkhYLtTpuBKUSmnM7iFJZVDIu3iqxD7molmaEdDyFu44ulprv+qY5X8l0IT53VoS
         mmQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CPjzMg27nsggyssWlNTVqAdofNU6F96gO6p2IIRQk5M=;
        b=wSlm+cJF/ErarCmiJIxNGTBXO2CQcUrxRbcBS5eyvX0P+iNBcP0KmB7wMhhXi581xR
         vtBb1p8l3X0eAmyCw3VGjqt83S16CnQPR4GA+cQ5b6dmDmoGFAFGoUNjXrerHZ3TElDG
         2gn89pbc9efjbz11QXG1A09ySdOlwmPaRrdidTQoSJLRJF28nPk/wCPMZrXpYRQHAh9c
         DNRLKUnYDOq30jhNOqns4wJMuqj6+6r1wGCgviPVD3NfxTDVdE33ECWozhJU+K5at098
         QUJVfzHXqWNAgyX3LfjpTKTHghy0XIQYD7szUPrtdUP5BGxz47sVEYGodSGnpHaJyv1p
         29sQ==
X-Gm-Message-State: ANoB5pkoNHV59cbtbF0g/TBqUTtHw0hPfL1NpM0EdCz8NanUMKWsrNf8
        N782kir2bX6LfdulD3NccFvyncfPun4T6Ac=
X-Google-Smtp-Source: AA0mqf6dt/I3YMYEPf//iDeyEt8ma9uMDG8TKQr0w1uAP4PK1B8ZTSUxRuz7gesc9hX5Jp6Mgo01SqoODZHFnQA9
X-Received: from joefradley-custom-96.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:831])
 (user=joefradley job=sendgmr) by 2002:a17:902:6505:b0:172:7a15:9a61 with SMTP
 id b5-20020a170902650500b001727a159a61mr9143392plk.71.1669157695439; Tue, 22
 Nov 2022 14:54:55 -0800 (PST)
Date:   Tue, 22 Nov 2022 14:54:49 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221122225450.789234-1-joefradley@google.com>
Subject: [PATCH] crypto: x86/curve25519 - disable gcov
From:   Joe Fradley <joefradley@google.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     kernel-team@android.com, Joe Fradley <joefradley@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

curve25519-x86_64.c fails to build when CONFIG_GCOV_KERNEL is enabled.
The error is "inline assembly requires more registers than available"
thrown from the `fsqr()` function. Therefore, excluding this file from
GCOV profiling until this issue is resolved. Thereby allowing
CONFIG_GCOV_PROFILE_ALL to be enabled for x86.

Signed-off-by: Joe Fradley <joefradley@google.com>
---
 arch/x86/crypto/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 3b1d701a4f6c..3e7a329235bd 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -107,3 +107,6 @@ quiet_cmd_perlasm = PERLASM $@
       cmd_perlasm = $(PERL) $< > $@
 $(obj)/%.S: $(src)/%.pl FORCE
 	$(call if_changed,perlasm)
+
+# Disable GCOV in odd or sensitive code
+GCOV_PROFILE_curve25519-x86_64.o := n
-- 
2.38.1.584.g0f3c55d4c2-goog

