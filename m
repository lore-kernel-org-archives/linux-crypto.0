Return-Path: <SRS0=IKCX=CF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C8CDC433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 09:20:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 107462177B
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 09:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbgH0JUO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Aug 2020 05:20:14 -0400
Received: from mout.kundenserver.de ([212.227.126.135]:55035 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbgH0JUN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Aug 2020 05:20:13 -0400
Received: from mail-qk1-f173.google.com ([209.85.222.173]) by
 mrelayeu.kundenserver.de (mreue010 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1Md6hP-1kjjc83ZT9-00aFVM; Thu, 27 Aug 2020 11:20:12 +0200
Received: by mail-qk1-f173.google.com with SMTP id x69so5273932qkb.1;
        Thu, 27 Aug 2020 02:20:11 -0700 (PDT)
X-Gm-Message-State: AOAM5305xN3piQi/USsmKyOIrmb8R/nEk0delK98M3H8rb9bjXGtDcrr
        X05n17qt0ahmVbKzTRvO1lWP8sFVSwlvM8xKKak=
X-Google-Smtp-Source: ABdhPJwys/Ld1ISwBQtGOVjsKOAmmhWUAnLw1tNxLCheE9BdtOHaa/dmwj3anmunhGIn0yb7Bm9gQ59+ubRMyha0700=
X-Received: by 2002:a37:8405:: with SMTP id g5mr17532540qkd.286.1598520010584;
 Thu, 27 Aug 2020 02:20:10 -0700 (PDT)
MIME-Version: 1.0
References: <202008271145.xE8qIAjp%lkp@intel.com> <20200827080558.GA3024@gondor.apana.org.au>
 <CAMj1kXHJrLtnJWYBKBYRtNHVS6rv51+crMsjLEnSqkud0BBaWw@mail.gmail.com>
 <CAK8P3a3tjv78arTj75eKk5zYUhrGkPYRDLiqv3WJJC=U+Jia0Q@mail.gmail.com> <CAMj1kXHhmAdHjK5avXOySw43khzft1g8p48jX7aTeTC0FvS7tQ@mail.gmail.com>
In-Reply-To: <CAMj1kXHhmAdHjK5avXOySw43khzft1g8p48jX7aTeTC0FvS7tQ@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 27 Aug 2020 11:19:54 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1nOL+BbvGAM3-aiH-mfzmFYgfFL2dWJKd8=Rw-WosP=w@mail.gmail.com>
Message-ID: <CAK8P3a1nOL+BbvGAM3-aiH-mfzmFYgfFL2dWJKd8=Rw-WosP=w@mail.gmail.com>
Subject: Re: lib/crypto/chacha.c:65:1: warning: the frame size of 1604 bytes
 is larger than 1024 bytes
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        kernel test robot <lkp@intel.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Kees Cook <keescook@chromium.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        kbuild-all@lists.01.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:coeQkCFQCHOzFYWd/LNBuIApxXKvpdTrY6bcraw/yAhdB4ZJvk9
 ccrXE00WmHGEqhLA/3ZOMLUtP+u7O+lCmWuTbzuXj+zCnC5FUSB7isTXTh3jeBJmvq6fVMD
 CcuTVqdzO+O+dwA09cK7OAS97J9hTa4VHcTBao2L3SilBu607JrbaoMQCZAO/pLwc4gX2Jw
 hSWkhM6KFnTcAMBHOwXIg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:/BpwjMeUJ20=:1Y2w50mFJIsOb/1FZFWZ/E
 ZokFJLxXESgV5uV+xYNXJKOgNLndVl/WpsngjusN5qS3UnLj3akBRiupolgzXGNVZw83kvv1k
 /S9RbKi4owBgIpXUetCF/vHXHtRgClCwSVblLjMreGJVRmfx/aVHSxKziT6LaHQJwVvNQVk72
 b0wBzYNwmYnt9SvoipmyHQ13Q8dmvZR1RLRUK9iUjmHKB199GKUuEcXRrQI6dC/1rpd5UPMIU
 gHaba0v4NUfZ8aCCEd05uvPDKW4WuGdiM7XFqNnz2k6ppQqyDGgg79zc0axEY7MjDTuHQ1J9o
 kfG2r8BPxP4OOd7sXF4cO2rXgAVjz6e3PV30aW0rvBIu/yCiYQYGVJbVEsfJ0C6NXgOHSoENj
 SrfdGBeohT5VrDpUxYMU98ONqFlT3uM+2q3V3kVhQ9vIRUhg35WKqCtRIUAxVxH7L8NAnMihR
 2iaO1022vX8AI/TXITgmzMfchWgZxpvUbNTnd1GKupWnyFGJkFQ+yBKcZ0pCb7rbnC6zAFeG9
 nrxKqmDviASV5NYe7sB81ZmKvi9G0KgxyfGSUikhyIEnHOQMONfNYj6+NaIyXDQkZ74QTeM6I
 ur9cdPY6QWWgE99KmXooIzM/5D+TYKu4uHoipo4DHWb+WyCMX5iV9dbWJVIBVIWgtyUWc2nQU
 ncp9bPqBs7bGNrHRJ0tJJ+YRvDmpC3loORpLUqukG1IIXLwylOhJsUlaV2JmNzuufb0rEc5gu
 YFN7euOs8eGjZyi7/cRpRsM8MsEJZoypLs9cHnLWPzDKWEsyjJuEYJAqLpretWe9NP6FSRtYx
 DlgqkPYjewbXEVTIU9i+m6iFGnpC1fUne/GlwDx1JzUw9rV2DBnfn8KlA5qwhE/v06gml+vPZ
 xVUpWIr4IlmV52G8lEcNzgZhJig6JKFMBhH1ohkN7TcEcnBN/qCDWMk144gCGwnLgxRRetHUu
 OqwqnMbaAdpPOD3mt98BJLSIZLpJqQPO9W9GRzh65tuW4wE4Q8sNT
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 27, 2020 at 10:42 AM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> In that case, I suppose we should simply disable instrumentation for
> chacha_permute()? It is a straight-forward arithmetic transformation
> on a u32[16] array, where ubsan has limited value afaict.

I guess that always works as a last resort, but shouldn't we first try
to figure out why ubsan even makes a difference and whether the
object code without ubsan looks like a reasonable representation
of the source form?

Since it really is a fairly simple transformation, I would have
expected the compiler to not emit any ubsan checks. If gcc
only gets confused about the fixed offsets possibly overflowing
the fixed-length array, maybe it helps to give it a little extra
information like (untested):

--- a/lib/crypto/chacha.c
+++ b/lib/crypto/chacha.c
@@ -13,7 +13,7 @@
 #include <asm/unaligned.h>
 #include <crypto/chacha.h>

-static void chacha_permute(u32 *x, int nrounds)
+static void chacha_permute(u32 x[16], int nrounds)
 {
        int i;

      Arnd
