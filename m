Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B224AECE58C
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 18:42:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8098320684
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 18:42:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IBXC2WwK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbfJGSml (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 14:42:41 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42423 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728079AbfJGSml (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 14:42:41 -0400
Received: by mail-qt1-f193.google.com with SMTP id w14so20665585qto.9;
        Mon, 07 Oct 2019 11:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7eEfovKGT46NPkty4JePi34eFTOmFxf7gPHZxEXtsdU=;
        b=IBXC2WwKi3QN6sBAJ4L5gDIFg5ktB2q/zo2DunyriDZv+n6ba3AO8GILev10cvpUmc
         GCns9+0/8VqT/aE0c31pKZOF1HX8ww/6RQeg8CCpOggrROsRwvL0LdhyQ99PelDY86dZ
         zSYRlTxKU+Pza259j89of/6t+yrHKOkP2dN1FKi4S5/8bxSxfvAib3sr6WfU5DrDw2bx
         A3n40ODFVKqYcPP08aDweYEv3XYow3AwkA6rvuU73RWjVdzYDaRY0gS+8gagEnNFPFl2
         vGFgB3WNO8DFmKny0/PbUskjIboj8ZjGn+S4Nn6kGmD18iLA8kzodx7d8xy6XXXfxtsL
         yCrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=7eEfovKGT46NPkty4JePi34eFTOmFxf7gPHZxEXtsdU=;
        b=tF/SXJveKLf8zqj/xwGp12fHoASvHvFldKz/7LIN0EyAQY59cmFg+W+3nfBpjt4dZL
         k1BC6Kf7chmN2TAqw8mmP2GygdOLDXotsi6mCRrFwC4csiDyPYOkRRvfpQjJpOwGW2Ts
         qeJ9qf/EBeWrOr/E3/fP8BGp3NDq0jX8yjS3BPdI/YzHEU79oicH8u77kJbn1p9Y9LG9
         GLWmKVDS6hOduU/GZsuYlAOvn8OwapBDJJ8MDf/OC5GkyOSd3htxxTU06LWLBsKXFJ28
         VzjYFJOM6Y+MFSGIuQcj2f9G44p86fhLEA/l+eziroL8ZFs05+qvfw3LXRuL0jufCjiZ
         FzPg==
X-Gm-Message-State: APjAAAXPWP4chCR1iXI43IPcTuRgsqA3RJtSPzw7WaacyuaWz/9gqg10
        zDuUjd/NtBIvQKCAB904xGM=
X-Google-Smtp-Source: APXvYqzbbgBi/bv0ZZ7NWkBJeVKwGJFA/yXvlLTha+iFhjktc/Zk/+4t9LOdiKeNsu18ePInaRnizg==
X-Received: by 2002:aed:3522:: with SMTP id a31mr32079589qte.69.1570473759713;
        Mon, 07 Oct 2019 11:42:39 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id 200sm8302542qkf.65.2019.10.07.11.42.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 11:42:39 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Mon, 7 Oct 2019 14:42:37 -0400
To:     Ingo Molnar <mingo@kernel.org>
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Hans de Goede <hdegoede@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Stephan Mueller <smueller@chronox.de>,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 5.4 regression fix] x86/boot: Provide memzero_explicit
Message-ID: <20191007184237.GB13589@rani.riverdale.lan>
References: <20191007134724.4019-1-hdegoede@redhat.com>
 <20191007140022.GA29008@gmail.com>
 <1dc3c53d-785e-f9a4-1b4c-3374c94ae0a7@redhat.com>
 <20191007142230.GA117630@gmail.com>
 <2982b666-e310-afb7-40eb-e536ce95e23d@redhat.com>
 <20191007144600.GB59713@gmail.com>
 <20191007152049.GA384920@rani.riverdale.lan>
 <20191007154007.GA96929@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="H+4ONPRPur6+Ovig"
Content-Disposition: inline
In-Reply-To: <20191007154007.GA96929@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--H+4ONPRPur6+Ovig
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Mon, Oct 07, 2019 at 05:40:07PM +0200, Ingo Molnar wrote:
> 
> * Arvind Sankar <nivedita@alum.mit.edu> wrote:
> 
> > With the barrier in there, is there any reason to *not* inline the
> > function? barrier_data() is an asm statement that tells the compiler
> > that the asm uses the memory that was set to zero, thus preventing it
> > from removing the memset even if nothing else uses that memory later. A
> > more detailed comment is there in compiler-gcc.h. I can't see why it
> > wouldn't work even if it were inlined.
> > 
> > If the function can indeed be inlined, we could just make the common
> > implementation a macro and avoid duplicating it? As mentioned in another
> > mail, we otherwise will likely need another duplicate implementation for
> > arch/s390/purgatory as well.
> 
> I suspect macro would be justified in this case. Mind sending a v3 patch 
> to demonstrate how it would all look like?
> 
> I'll zap v2 if the macro solution looks better.
> 
> Thanks,
> 
> 	Ingo

Patch attached to turn memzero_explicit into inline function.

--H+4ONPRPur6+Ovig
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0001-lib-string-make-memzero_explicit-inline-instead-of-e.patch"

From 25834b8040eff72478489be0bd8a2ff549af7f94 Mon Sep 17 00:00:00 2001
From: Arvind Sankar <nivedita@alum.mit.edu>
Date: Mon, 7 Oct 2019 14:34:24 -0400
Subject: [PATCH] lib/string: make memzero_explicit inline instead of external

With the use of the barrier implied by barrier_data(), there is no need
for memzero_explicit to be extern. Making it inline saves the overhead
of a function call, and allows the code to be reused in arch/*/purgatory
without having to duplicate the implementation.

Fixes: 906a4bb97f5d ("crypto: sha256 - Use get/put_unaligned_be32 to get input, memzero_explicit")
Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
---
 include/linux/string.h | 21 ++++++++++++++++++++-
 lib/string.c           | 21 ---------------------
 2 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/include/linux/string.h b/include/linux/string.h
index b2f9df7f0761..b6ccdc2c7f02 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -227,7 +227,26 @@ static inline bool strstarts(const char *str, const char *prefix)
 }
 
 size_t memweight(const void *ptr, size_t bytes);
-void memzero_explicit(void *s, size_t count);
+
+/**
+ * memzero_explicit - Fill a region of memory (e.g. sensitive
+ *		      keying data) with 0s.
+ * @s: Pointer to the start of the area.
+ * @count: The size of the area.
+ *
+ * Note: usually using memset() is just fine (!), but in cases
+ * where clearing out _local_ data at the end of a scope is
+ * necessary, memzero_explicit() should be used instead in
+ * order to prevent the compiler from optimising away zeroing.
+ *
+ * memzero_explicit() doesn't need an arch-specific version as
+ * it just invokes the one of memset() implicitly.
+ */
+static inline void memzero_explicit(void *s, size_t count)
+{
+	memset(s, 0, count);
+	barrier_data(s);
+}
 
 /**
  * kbasename - return the last part of a pathname.
diff --git a/lib/string.c b/lib/string.c
index cd7a10c19210..08ec58cc673b 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -748,27 +748,6 @@ void *memset(void *s, int c, size_t count)
 EXPORT_SYMBOL(memset);
 #endif
 
-/**
- * memzero_explicit - Fill a region of memory (e.g. sensitive
- *		      keying data) with 0s.
- * @s: Pointer to the start of the area.
- * @count: The size of the area.
- *
- * Note: usually using memset() is just fine (!), but in cases
- * where clearing out _local_ data at the end of a scope is
- * necessary, memzero_explicit() should be used instead in
- * order to prevent the compiler from optimising away zeroing.
- *
- * memzero_explicit() doesn't need an arch-specific version as
- * it just invokes the one of memset() implicitly.
- */
-void memzero_explicit(void *s, size_t count)
-{
-	memset(s, 0, count);
-	barrier_data(s);
-}
-EXPORT_SYMBOL(memzero_explicit);
-
 #ifndef __HAVE_ARCH_MEMSET16
 /**
  * memset16() - Fill a memory area with a uint16_t
-- 
2.21.0


--H+4ONPRPur6+Ovig--
