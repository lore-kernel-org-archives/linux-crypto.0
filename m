Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D45BC433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Nov 2022 06:45:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbiKKGpL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Nov 2022 01:45:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233087AbiKKGpJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Nov 2022 01:45:09 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11AE8725D7
        for <linux-crypto@vger.kernel.org>; Thu, 10 Nov 2022 22:45:07 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id h193so3692215pgc.10
        for <linux-crypto@vger.kernel.org>; Thu, 10 Nov 2022 22:45:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VB9aQQVhkngMF6yPb3IGC/N/KLSjVlwZg6ggvs61LyA=;
        b=mxQqK5C9GZ13tBDmw9e8RpoNkPLy2Bi+XN+Uqs7cI/giF5bgNh+r/K/f6zxA85Pzug
         C9tt5t4ApUuP0EQSrwcZT8mndjN4C5TOkF4mu8XhaOHvSUnw+akg3gttseJDct+D3pPw
         FvL1nWJ+CEa4Q/IWQG8zImy+uSbITEtcLZ4ql2tSXTEDiNLzT5HRBtJpcj5QKEiq6Wd1
         qJwzSIJxVitY0ZWI0V5hc0XUCM9vjscIxI/cxGopRWN/z5JlRgQLvkDtNheaGa+VN2wv
         lwSrx+vEY2yYKaq4sQEEZOZwtJ+Rm84O2Vs9fh/ZJpD0hLnUV//nVNP2vasd3auVyk6e
         ifag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VB9aQQVhkngMF6yPb3IGC/N/KLSjVlwZg6ggvs61LyA=;
        b=YAb7ZlF/kcHnG4xh+FLYh+Ht/IW3aM35LB+k04wfYQvnQll7ypjWJpEt7hv74RxcTO
         21FxruAPDIGWsMJiMfbfPV8Ih5Ejlc6/fk1xMtmzN0oPOP4ymBAWm89MrYqvsSmBiosA
         eJvyelKnXY0hAsxdP4prbCIuZ7oeM50pPDHwS9IUIz7ayqFeiWIeKYe1EIlPCPNA2XLb
         E4FEjUNcIHCxrzFLDt1BAliUmV6Z3DqTNCOZmOimWwspWbSiOhGvtHd3Hi/6vJZUjWku
         UlULPq4IPC9rT0lqT8OmDjCwB/R6b8HReCowvoL+x0KklvUeUk3enYq2WR9zWlqbgijF
         WC3Q==
X-Gm-Message-State: ANoB5pmkvmvwc/wVbxjkuf/rfRqJ5VhBYTPmB0Fc6FQmYlCc3WpdK5Tk
        byZgnALrDfC/qZOcsUM6eRA=
X-Google-Smtp-Source: AA0mqf7gvrnE24zrK5fpos3fNuNSKAtlbCVfc+cenESGr23AJwaKNhMceNJwW5wPWexJfs+uyQODmA==
X-Received: by 2002:a63:4f25:0:b0:460:633b:5702 with SMTP id d37-20020a634f25000000b00460633b5702mr541469pgb.9.1668149106487;
        Thu, 10 Nov 2022 22:45:06 -0800 (PST)
Received: from [192.168.0.48] ([222.117.241.38])
        by smtp.gmail.com with ESMTPSA id a4-20020a170902ecc400b001869f2120a5sm856676plh.34.2022.11.10.22.45.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 22:45:05 -0800 (PST)
Message-ID: <318ca852-4962-be3a-fd60-499bbc4a0546@gmail.com>
Date:   Fri, 11 Nov 2022 15:45:00 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.0
Subject: Re: [PATCH v3 2/4] crypto: aria: do not use magic number offsets of
 aria_ctx
To:     "Elliott, Robert (Servers)" <elliott@hpe.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "richard@nod.at" <richard@nod.at>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "jpoimboe@kernel.org" <jpoimboe@kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "jussi.kivilinna@iki.fi" <jussi.kivilinna@iki.fi>
References: <20221106143627.30920-1-ap420073@gmail.com>
 <20221106143627.30920-3-ap420073@gmail.com>
 <MW5PR84MB18422C6DB5DDFAE158BAF459AB019@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <MW5PR84MB18422C6DB5DDFAE158BAF459AB019@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Elliott,
Thank you so much for your review!

On 2022. 11. 10. 오후 12:55, Elliott, Robert (Servers) wrote:
 >
 >
 >> -----Original Message-----
 >> From: Taehee Yoo <ap420073@gmail.com>
 >> Sent: Sunday, November 6, 2022 8:36 AM
 >> To: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au;
 >> davem@davemloft.net; tglx@linutronix.de; mingo@redhat.com; bp@alien8.de;
 >> dave.hansen@linux.intel.com; hpa@zytor.com;
 >> kirill.shutemov@linux.intel.com; richard@nod.at; 
viro@zeniv.linux.org.uk;
 >> sathyanarayanan.kuppuswamy@linux.intel.com; jpoimboe@kernel.org; 
Elliott,
 >> Robert (Servers) <elliott@hpe.com>; x86@kernel.org; 
jussi.kivilinna@iki.fi
 >> Cc: ap420073@gmail.com
 >> Subject: [PATCH v3 2/4] crypto: aria: do not use magic number offsets of
 >> aria_ctx
 >>
 >> aria-avx assembly code accesses members of aria_ctx with magic number
 >> offset. If the shape of struct aria_ctx is changed carelessly,
 >> aria-avx will not work.
 >> So, we need to ensure accessing members of aria_ctx with correct
 >> offset values, not with magic numbers.
 >>
 >> It adds ARIA_CTX_enc_key, ARIA_CTX_dec_key, and ARIA_CTX_rounds in the
 >> asm-offsets.c So, correct offset definitions will be generated.
 >> aria-avx assembly code can access members of aria_ctx safely with
 >> these definitions.
 >>
 >> diff --git a/arch/x86/crypto/aria-aesni-avx-asm_64.S
 > ...
 >>
 >>   #include <linux/linkage.h>
 >>   #include <asm/frame.h>
 >> -
 >> -/* struct aria_ctx: */
 >> -#define enc_key 0
 >> -#define dec_key 272
 >> -#define rounds 544
 >
 > That structure also has a key_length field after the rounds field.
 > aria_set_key() sets it, but no function ever seems to use it.
 > Perhaps that field should be removed?

Okay, I will remove that fields in a separate patch.

 >
 >> +#include <asm/asm-offsets.h>
 >
 > That makes the offsets flexible, which is good.
 >
 > The assembly code also implicitly assumes the size of each of those 
fields
 > (e.g., enc_key is 272 bytes, dec_key is 272 bytes, and rounds is 4 
bytes).
 > A BUILD_BUG_ON confirming those assumptions might be worthwhile.

You're right,
I didn't consider the size of the fields.
I will contain BUILD_BUG_ON() to check the size.

 >
 >> diff --git a/arch/x86/kernel/asm-offsets.c 
b/arch/x86/kernel/asm-offsets.c
 >> index cb50589a7102..32192a91c65b 100644
 >> --- a/arch/x86/kernel/asm-offsets.c
 >> +++ b/arch/x86/kernel/asm-offsets.c
 >> @@ -7,6 +7,7 @@
 >>   #define COMPILE_OFFSETS
 >>
 >>   #include <linux/crypto.h>
 >> +#include <crypto/aria.h>
 >
 > Is it safe to include .h files for a large number of crypto modules
 > in one C file? It seems like they could easily include naming conflicts.
 >
 > However, this set does seem to compile cleanly:
 >

Thanks for this check.
Sorry, I'm not sure about the side effects of a large number of header 
in .c file.

 > +// no .h for aegis, but ctx is simple
 > +#include <crypto/aes.h>
 > +#include <crypto/aria.h>
 > +#include <crypto/blake2s.h>
 > +#include <crypto/blowfish.h>
 > +// no .h for camellia in crypto; it is in arch/x86/crypto
 > +#include <crypto/cast5.h>
 > +#include <crypto/cast6.h>
 > +#include <crypto/chacha.h>
 > +// no .h for crc32c, crc32, crct10dif, but no ctx structure to worry 
about
 > +#include <crypto/curve25519.h>
 > +#include <crypto/des.h>
 > +#include <crypto/ghash.h>
 > +#include <crypto/nhpoly1305.h>
 > +#include <crypto/poly1305.h>
 > +#include <crypto/polyval.h>
 > +#include <crypto/serpent.h>
 > +#include <crypto/sha1.h>
 > +#include <crypto/sha2.h>
 > +#include <crypto/sm3.h>
 > +#include <crypto/twofish.h>
 >

Thanks a lot!
Taehee Yoo
