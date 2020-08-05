Return-Path: <SRS0=mrTw=BP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8E7DC433E1
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Aug 2020 19:51:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF4F42076E
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Aug 2020 19:51:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bVFSImkw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgHETux (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Aug 2020 15:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728242AbgHEQxB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Aug 2020 12:53:01 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB306C06179F;
        Wed,  5 Aug 2020 03:39:52 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id l23so18421245edv.11;
        Wed, 05 Aug 2020 03:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qyFh0B+qFmeaq1ZmytjXM93bJReydW1Q9ZU9edq9NSw=;
        b=bVFSImkw00AL0eXqqbm3McDE84S5/SUhPXauKRgX+RjQFLzzEOAeh1BxV0FJ3xAAJ8
         1m9bTe46ht4zUL8tAAqdHoPyHHhXwgxz57qLRYZBkP1rOpXqwVPYcAxOgvpR3o1XZCvd
         bKQ02Q/qe51m5JtFTL8dGAPE9LdxItd2sC82ekIWLriM37yTWvtT9wqaonMYVBxGcQsw
         +zI+CvFrLgHWC4r5ucuH1UgeKusLtLEaaKkIAdpnL07hRj4ecHa4FRkTefDBklwy016F
         SmZCH5u8fNVjpgNpY4T9v0gNPH7uqjlKD/oYpEbSz/QWj6hUWqWda6kBf+oHuX5ddoK0
         OAgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qyFh0B+qFmeaq1ZmytjXM93bJReydW1Q9ZU9edq9NSw=;
        b=XBS4pGdKUI13EAWBJI9b4qky93AVJszjKtxtykJrhXF0Y7Am3bzhsftJioSQDO2msx
         xRA3nCjNpNuo7emfTZM0JKWlKHPInQnTamyXs0kQkmzsUbNpJoxpBdusq3MEVlKUTePr
         mKTQHxag0JTUtTxvCvCsjVtWCefvSO0+HyFhHCdz1BlQUtBby2UJnBTsQho9GCpNuUCi
         6BdiGRbkShhNKOscHob/nd8DBJeIT7va5xzmEPKraXLlJE2U31usgs9RYNhY0XrWyJA0
         HSB1INe+wXze4IPuKnjpLaZ7fmYax0m0NnpIN05c0vRMJnrXk6SEXxs9at/wVve3oCBI
         Q9cg==
X-Gm-Message-State: AOAM533Z6iQuredxtrVG37hAGEG/fqtZgqUDj/z3GDz0R5T6IfNkaReH
        RXMlwOxvtc4OtLTS5tXKmT4/3VAkfYI=
X-Google-Smtp-Source: ABdhPJy1V19vqtue79NewqfTmzf1nPJGkjGZEOewMpAdzyXd2UkFmYEa3u7VhPr+z0BqzwARa9XAKw==
X-Received: by 2002:a05:6402:17c2:: with SMTP id s2mr2105104edy.188.1596623990966;
        Wed, 05 Aug 2020 03:39:50 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id ec20sm1260116ejb.61.2020.08.05.03.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 03:39:50 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] crypto/x86: Use CRC32 mnemonic in crc32c-intel_glue.c
Date:   Wed,  5 Aug 2020 12:39:32 +0200
Message-Id: <20200805103932.255524-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Current minimum required version of binutils is 2.23,
which supports CRC32 instruction mnemonic.

Replace the byte-wise specification of CRC32 with this proper mnemonic.
The compiler is now able to pass memory operand to the instruction,
so there is no need for a temporary register anymore.

Some examples of the improvement:

 12a:	48 8b 08             	mov    (%rax),%rcx
 12d:	f2 48 0f 38 f1 f1    	crc32q %rcx,%rsi
 133:	48 83 c0 08          	add    $0x8,%rax
 137:	48 39 d0             	cmp    %rdx,%rax
 13a:	75 ee                	jne    12a <crc32c_intel_update+0x1a>

to:

 125:	f2 48 0f 38 f1 06    	crc32q (%rsi),%rax
 12b:	48 83 c6 08          	add    $0x8,%rsi
 12f:	48 39 d6             	cmp    %rdx,%rsi
 132:	75 f1                	jne    125 <crc32c_intel_update+0x15>

and:

 146:	0f b6 08             	movzbl (%rax),%ecx
 149:	f2 0f 38 f0 f1       	crc32b %cl,%esi
 14e:	48 83 c0 01          	add    $0x1,%rax
 152:	48 39 d0             	cmp    %rdx,%rax
 155:	75 ef                	jne    146 <crc32c_intel_update+0x36>

to:

 13b:	f2 0f 38 f0 02       	crc32b (%rdx),%eax
 140:	48 83 c2 01          	add    $0x1,%rdx
 144:	48 39 ca             	cmp    %rcx,%rdx
 147:	75 f2                	jne    13b <crc32c_intel_update+0x2b>

As the compiler has some more freedom w.r.t. register allocation,
there is also a couple of reg-reg moves removed.

There are no hidden states for CRC32 insn, so there is no need to mark
assembly as volatile.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: Borislav Petkov <bp@alien8.de>
CC: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/crypto/crc32c-intel_glue.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/arch/x86/crypto/crc32c-intel_glue.c b/arch/x86/crypto/crc32c-intel_glue.c
index d2d069bd459b..3a34b2351559 100644
--- a/arch/x86/crypto/crc32c-intel_glue.c
+++ b/arch/x86/crypto/crc32c-intel_glue.c
@@ -27,12 +27,6 @@
 
 #define SCALE_F	sizeof(unsigned long)
 
-#ifdef CONFIG_X86_64
-#define REX_PRE "0x48, "
-#else
-#define REX_PRE
-#endif
-
 #ifdef CONFIG_X86_64
 /*
  * use carryless multiply version of crc32c when buffer
@@ -48,11 +42,8 @@ asmlinkage unsigned int crc_pcl(const u8 *buffer, int len,
 static u32 crc32c_intel_le_hw_byte(u32 crc, unsigned char const *data, size_t length)
 {
 	while (length--) {
-		__asm__ __volatile__(
-			".byte 0xf2, 0xf, 0x38, 0xf0, 0xf1"
-			:"=S"(crc)
-			:"0"(crc), "c"(*data)
-		);
+		asm("crc32b %1, %0"
+		    : "+r" (crc) : "rm" (*data));
 		data++;
 	}
 
@@ -66,11 +57,12 @@ static u32 __pure crc32c_intel_le_hw(u32 crc, unsigned char const *p, size_t len
 	unsigned long *ptmp = (unsigned long *)p;
 
 	while (iquotient--) {
-		__asm__ __volatile__(
-			".byte 0xf2, " REX_PRE "0xf, 0x38, 0xf1, 0xf1;"
-			:"=S"(crc)
-			:"0"(crc), "c"(*ptmp)
-		);
+#ifdef CONFIG_X86_64
+		asm("crc32q %1, %q0"
+#else
+		asm("crc32l %1, %0"
+#endif
+		    : "+r" (crc) : "rm" (*ptmp));
 		ptmp++;
 	}
 
-- 
2.26.2

