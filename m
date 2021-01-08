Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 313B4C433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jan 2021 11:32:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2646239FD
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jan 2021 11:32:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbhAHLcx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Jan 2021 06:32:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:43208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725884AbhAHLcx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Jan 2021 06:32:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99A5A23A00
        for <linux-crypto@vger.kernel.org>; Fri,  8 Jan 2021 11:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610105531;
        bh=c6jM7BxEkbXQt0qqWY6nRcpdgEpLC6C773iyzf611Zo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=K3m7E75lqxtYAyVpstC/xPnhFJ+L2gS6TKTnkE6AuLOUVB6lV/eBkfENFRO+4zJgy
         snkHxjErnu1AcBCLoV2Nxm82RLNEUmQ+MoidSeHRJdtTnBve6KaKWUn5QGlcEjmLjf
         mvy+5RA5RJEz8C+AIbiL/fzwtX8g+XNDhHM8cI+Eece5TXqu7KFe0y3nob7rbfFtn3
         pPOtt+jeLlBO8oLSizD26NyW5MsJ0W3wmwcOr0BgGQjb3g37bajzsddKoy4Zafoal+
         fzAoQv/uPiQU92t6Uj7/BhjHKBwx6GK1V98PxJ9dxs0MUin2XExGI3hycHMQDyuDEo
         7Oa/ImYNxsHyg==
Received: by mail-oi1-f173.google.com with SMTP id x13so10995371oic.5
        for <linux-crypto@vger.kernel.org>; Fri, 08 Jan 2021 03:32:11 -0800 (PST)
X-Gm-Message-State: AOAM532ZZHu3nMhyaQk/twa38EGPm6EuEnvJCvjyv9RvOoAFFT0TobIz
        GrzcjoSdV952jDOYRmv10cl7nj6NXLDmNCJWFbQ=
X-Google-Smtp-Source: ABdhPJykOGzCN/ymQf3RLlwBtaT+ame5mwn5nkNBeSfl5o5Ox8CDUD/ANRZfoD7gA+7U1jFtbp1VtlDNVX1lbZHn2jY=
X-Received: by 2002:aca:d98a:: with SMTP id q132mr2018373oig.33.1610105530820;
 Fri, 08 Jan 2021 03:32:10 -0800 (PST)
MIME-Version: 1.0
References: <20210107124128.19791-1-ardb@kernel.org> <X/daxUIwf8iXkbxr@gmail.com>
 <CAMj1kXE_qHkuk0zmhS=F4uFYWHnZumEB_XWyzo4SYXj1vjqKmg@mail.gmail.com>
 <20210108092246.GA13460@gondor.apana.org.au> <CAK8P3a2k_bdhxKUnrae__OpmN807qeJpXHGB1zgAzFqLVZEZuQ@mail.gmail.com>
 <20210108104447.GA13760@gondor.apana.org.au> <CAK8P3a0W0jcqrt1Vp_+qf11y6P5Wy9--f+ou1gEwivizpTShaA@mail.gmail.com>
In-Reply-To: <CAK8P3a0W0jcqrt1Vp_+qf11y6P5Wy9--f+ou1gEwivizpTShaA@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 8 Jan 2021 12:31:59 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEeOwj5G_nFU6H_u8V7J9dD+yD7LGaH9FidYtfi-syT1A@mail.gmail.com>
Message-ID: <CAMj1kXEeOwj5G_nFU6H_u8V7J9dD+yD7LGaH9FidYtfi-syT1A@mail.gmail.com>
Subject: Re: [PATCH] crypto - shash: reduce minimum alignment of shash_desc structure
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 8 Jan 2021 at 11:59, Arnd Bergmann <arnd@kernel.org> wrote:
>
> On Fri, Jan 8, 2021 at 11:44 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > On Fri, Jan 08, 2021 at 11:42:53AM +0100, Arnd Bergmann wrote:
> > >
> > > How does this work for kernels with CONFIG_VMAP_STACK?
> > > I remember some other subsystems (usb, hid) adding workarounds
> > > for that, but I don't see those in drivers/crypto
> >
> > I'm referring to the situation in general and not the subject of
> > this thread.
> >
> > For shash_desc of course it doesn't happen since it sync only.
>
> Ah, got it.
>

I can fold in the following

--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -151,9 +151,12 @@
  * The macro CRYPTO_MINALIGN_ATTR (along with the void * type in the actual
  * declaration) is used to ensure that the crypto_tfm context structure is
  * aligned correctly for the given architecture so that there are no alignment
- * faults for C data types.  In particular, this is required on platforms such
- * as arm where pointers are 32-bit aligned but there are data types such as
- * u64 which require 64-bit alignment.
+ * faults for C data types.  On architectures that support non-cache coherent
+ * DMA, such as ARM or arm64, it also takes into account the minimal alignment
+ * that is required to ensure that the context struct member does not share any
+ * cachelines with the rest of the struct. This is needed to ensure that cache
+ * maintenance for non-coherent DMA does not affect data that may be accessed
+ * by the CPU concurrently.
  */
 #define CRYPTO_MINALIGN ARCH_KMALLOC_MINALIGN


(or send it as a separate patch)

Note that the comment about 64-bit alignment for 64-bit types on ARM
is incorrect.
