Return-Path: <SRS0=mrTw=BP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 495ADC433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Aug 2020 16:54:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2389922CF7
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Aug 2020 16:54:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SHN1TG21"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbgHEQyE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Aug 2020 12:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728031AbgHEQvs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Aug 2020 12:51:48 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D767C061A18;
        Wed,  5 Aug 2020 04:17:45 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id m19so5453637ejd.8;
        Wed, 05 Aug 2020 04:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zrjr0dNIkt2m1+BKksioKrys5J6KBI+9icWKSKASiQk=;
        b=SHN1TG21dBGpPDpmZDXULtggAM4kaiv43xS6oAJLmNcm3wiHUt0uyMIJ2efXc7Dz3U
         1loP3SEVKBdQHzAAo0BEYhA3XNPVaD0D7RnpAEJjeAI9vRM41eLRDJIkvTlJdCcFFqgo
         G3iE+vR3obJTi+dGEocJAoRu9ygaMehpQqxbluSIDxyQi89yDaCy6USwoXEOEO7XOZ3e
         09gHNdkDEaM/7ZTMEKYcOSytDHa5pf1RPJiqiGjzT8I3tsS4jiPQ3C/OoZXVXk1zBLPS
         85KrJ3qpYbfSzblpmvQ/X6HExulYyEZCBGgwcQpeFLjPqpxpMpOoC2OIAnDBNcX4wvQh
         ORMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zrjr0dNIkt2m1+BKksioKrys5J6KBI+9icWKSKASiQk=;
        b=Bclkv5amVbzQRFcw0btg/zIVf/hPkFJ3PRKPSnsbwdrftXPxXhbcdqv/36qx2S/ZvA
         44QMDRoYiPtEWNxOpi1FGDdkcaF2jahX6GzTrLUhrQ+ehokKuaW5zj50WwjzO4OJ8R+U
         uzFmtve8z3YAid+PRe8PP59ihc1nQz14GtdOAtpQ4g2sHiMt4TLtyjQRTwi4TX6FZYQ2
         BatM0QWE8UncyzMqzqkGQgIyjrN8yFLzoqQc2FkQPN81KXrocH0CTox1SIAfEcxFTrl2
         7BQta3SWTL5z7P07R00ZpfoCqwIFrJ8X1CxBVZHxvAZ4FGN3jWdYYsjE2jQYHnjFOTmx
         zDeg==
X-Gm-Message-State: AOAM533VTbRh1l1202PZ9AceGATiNlavEuf7ASov/XwnQ5w4qR+FLP3X
        3lC9Of5VY3SwyfEcnRIlojg8yiml+/U=
X-Google-Smtp-Source: ABdhPJy3wSby5htQ9GdIMsy5COTpu5Y7etCDMcTnWVGpzGRoH63LMsgYqXDMlsFRZ2p1TFTevDreBw==
X-Received: by 2002:a17:906:4157:: with SMTP id l23mr2610722ejk.491.1596626263446;
        Wed, 05 Aug 2020 04:17:43 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id y9sm1247694edt.34.2020.08.05.04.17.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 04:17:42 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v2] crypto/x86: Use CRC32 mnemonic in crc32c-intel_glue.c
Date:   Wed,  5 Aug 2020 13:17:29 +0200
Message-Id: <20200805111729.359078-1-ubizjak@gmail.com>
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

v2: Introduce CRC32_INST define.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: Borislav Petkov <bp@alien8.de>
CC: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/crypto/crc32c-intel_glue.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/arch/x86/crypto/crc32c-intel_glue.c b/arch/x86/crypto/crc32c-intel_glue.c
index d2d069bd459b..feccb5254c7e 100644
--- a/arch/x86/crypto/crc32c-intel_glue.c
+++ b/arch/x86/crypto/crc32c-intel_glue.c
@@ -28,9 +28,9 @@
 #define SCALE_F	sizeof(unsigned long)
 
 #ifdef CONFIG_X86_64
-#define REX_PRE "0x48, "
+#define CRC32_INST "crc32q %1, %q0"
 #else
-#define REX_PRE
+#define CRC32_INST "crc32l %1, %0"
 #endif
 
 #ifdef CONFIG_X86_64
@@ -48,11 +48,8 @@ asmlinkage unsigned int crc_pcl(const u8 *buffer, int len,
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
 
@@ -66,11 +63,8 @@ static u32 __pure crc32c_intel_le_hw(u32 crc, unsigned char const *p, size_t len
 	unsigned long *ptmp = (unsigned long *)p;
 
 	while (iquotient--) {
-		__asm__ __volatile__(
-			".byte 0xf2, " REX_PRE "0xf, 0x38, 0xf1, 0xf1;"
-			:"=S"(crc)
-			:"0"(crc), "c"(*ptmp)
-		);
+		asm(CRC32_INST
+		    : "+r" (crc) : "rm" (*ptmp));
 		ptmp++;
 	}
 
-- 
2.26.2

