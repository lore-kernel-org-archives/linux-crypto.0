Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFCC8ECE58C
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 22:00:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CA822173B
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 22:00:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729457AbfJGWAG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 18:00:06 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:43756 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728422AbfJGWAG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 18:00:06 -0400
Received: by mail-qk1-f193.google.com with SMTP id h126so14233221qke.10;
        Mon, 07 Oct 2019 15:00:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZU2lhuzvcrgsM0rNDDAmLSl8Fi5wF3gmf9pM3Bgvdh4=;
        b=nEBqwgpOz0zwXSxFbDBXCbC4ESIEV+bDZlAUMMogxLx9Y+wGfJnjiDCo7S0utspGDV
         +v8cQTtGVPrcfbam54onodMqoRwb89ZfwgA8HiJB8V08ksytcxSXVpOvSkKAZRN9fO3N
         0kF5pczUqDkiU9rin5y9X63ufSMpGDDklfpEVGvXTu5pEF5E4OU5bUk/eoOJyMdx+1hL
         ffu425VEWxO3yDoRSveE85lYrORDZciutBcakcZGuwBod0Gwn/sujwBBVLsaC9QVAJlD
         B0Bw4TbOVKUUSlpLQJgHNHC/OC+1jtP1Qcgvj9yo+Zochv9ZSlLJmRJGwieBomxIFkPK
         +osQ==
X-Gm-Message-State: APjAAAWeMewj9c08lveKGoL70grvi4AHqm7KMtpvRWh2ZFGIT+Wi6EWv
        fSLYwJ9Ud1w3akD0Jl/s4Dhtq/gVF9OVLA==
X-Google-Smtp-Source: APXvYqyxz7pCaCHojodDGLBP1EWQgIU9sNOuMJ+ftpmvqJk91fya1fLMitK2111hM63EVcgElwz42A==
X-Received: by 2002:a05:620a:7ca:: with SMTP id 10mr26285144qkb.410.1570485604791;
        Mon, 07 Oct 2019 15:00:04 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id q200sm7852142qke.114.2019.10.07.15.00.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 15:00:04 -0700 (PDT)
Date:   Mon, 7 Oct 2019 18:00:02 -0400
From:   Arvind Sankar <nivedita@alum.mit.edu>
To:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>
Cc:     linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] lib/string: make memzero_explicit inline instead of external
Message-ID: <20191007220000.GA408752@rani.riverdale.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1d17349e-98ab-b582-6981-b484b0e970b6@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

With the use of the barrier implied by barrier_data(), there is no need
for memzero_explicit to be extern. Making it inline saves the overhead
of a function call, and allows the code to be reused in arch/*/purgatory
without having to duplicate the implementation.

Fixes: 906a4bb97f5d ("crypto: sha256 - Use get/put_unaligned_be32 to get input, memzero_explicit")
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Hans de Goede <hdegoede@redhat.com>
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
