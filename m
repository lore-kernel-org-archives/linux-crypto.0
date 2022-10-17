Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 702E4C4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Oct 2022 22:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbiJQW0u (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Oct 2022 18:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbiJQW0s (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Oct 2022 18:26:48 -0400
Received: from mail-ua1-x949.google.com (mail-ua1-x949.google.com [IPv6:2607:f8b0:4864:20::949])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81BFB814DC
        for <linux-crypto@vger.kernel.org>; Mon, 17 Oct 2022 15:26:36 -0700 (PDT)
Received: by mail-ua1-x949.google.com with SMTP id q9-20020ab04a09000000b003dfecbdc5cdso5287468uae.15
        for <linux-crypto@vger.kernel.org>; Mon, 17 Oct 2022 15:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dRicd/TKDtSX5fV7ZkBHSh0LxgTerLvjz+IosqKnncg=;
        b=nbbZgCLvSbeQnr9DFO2lGFN8HoAT1h71+nkYVU5gZmbaOLcGw4gmSj5tGOaO0r9Cb9
         fw0FKgCdqJZ9Yon01ODdpHRth5FVd8tLdjV+9Mg+XxP+Xama2h31sQMYarHIOvNwndOy
         XJkj3ETnpYIa2VgOgJbVmAKoE32Zlq1AKzxozeHF8JULsPCSalVAveBFS5YjjGojdJFB
         TKQM+UMgOchftcxegbqETwWfK7ba9q13nTTn3EcPEtwyr2R8g4wicI+aHVCEwd0zw34W
         GU+YFBdFEX6pb/1q0m7BJLirI+7f87/XnfAcKv2K1o2X+W5jwovymasUe4lvF35/oZ0P
         m7Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dRicd/TKDtSX5fV7ZkBHSh0LxgTerLvjz+IosqKnncg=;
        b=HrnL2ArHLh8XdkhjPEA4ZE/8EyhW3iK/9Z6w8yRaO8fWyfD/GenQ//yUjvMOWDUveW
         gV7CAbZUyU63dcxOxX99h9TONAoslrN8qjGEwO2EmDE3H1XG5RSCaYaYCGvxQziaKPAX
         dIiPTVg+p0s9ay+i7kbAtHU4f6d/lXkRB9d7iFI5LoHGHoGvAxKOk1vc6fKt7gqbTCKU
         +5Frvl/g/gBkm2cPKIDAlVuxUhBeyguxl4BCsfbqH/Hy2P2CvVubc9+sBrLgOZqBvPaD
         D+AlGqqKEJoA5IkjkOj5/R7mMoDOc+SbOKGt/tr5NNQx2BhiFBzmtOqR8y7v0Nel2cGn
         hYhQ==
X-Gm-Message-State: ACrzQf2nITpBhfNxcZUue8Na1EHXdu6MVBJzQ4vja+i4YqIerWzrjXWo
        q4tCsBRqZs+i98SegiObrAt4HX87eQ==
X-Google-Smtp-Source: AMsMyM4gH43JTYwwxDkHG+XUs6CobCsKkbrcZ3sxBeU//UGVSxmNUJnRBye8LkmKPa0ZiD5wfZ9peAS2FQ==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a05:6102:1c6:b0:3a9:6160:c467 with SMTP id
 s6-20020a05610201c600b003a96160c467mr18407vsq.49.1666045595002; Mon, 17 Oct
 2022 15:26:35 -0700 (PDT)
Date:   Mon, 17 Oct 2022 15:26:20 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221017222620.715153-1-nhuck@google.com>
Subject: [PATCH] crypto: x86/polyval - Fix crashes when keys are not 16-byte aligned
From:   Nathan Huckleberry <nhuck@google.com>
Cc:     Nathan Huckleberry <nhuck@google.com>,
        Bruno Goncalves <bgoncalv@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The key_powers array is not guaranteed to be 16-byte aligned, so using
movaps to operate on key_powers is not allowed.

Switch movaps to movups.

Fixes: 34f7f6c30112 ("crypto: x86/polyval - Add PCLMULQDQ accelerated implementation of POLYVAL")
Reported-by: Bruno Goncalves <bgoncalv@redhat.com>
Signed-off-by: Nathan Huckleberry <nhuck@google.com>
---
 arch/x86/crypto/polyval-clmulni_asm.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/crypto/polyval-clmulni_asm.S b/arch/x86/crypto/polyval-clmulni_asm.S
index a6ebe4e7dd2b..32b98cb53ddf 100644
--- a/arch/x86/crypto/polyval-clmulni_asm.S
+++ b/arch/x86/crypto/polyval-clmulni_asm.S
@@ -234,7 +234,7 @@
 
 	movups (MSG), %xmm0
 	pxor SUM, %xmm0
-	movaps (KEY_POWERS), %xmm1
+	movups (KEY_POWERS), %xmm1
 	schoolbook1_noload
 	dec BLOCKS_LEFT
 	addq $16, MSG
-- 
2.38.0.413.g74048e4d9e-goog

