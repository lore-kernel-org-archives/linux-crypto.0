Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89882C001DC
	for <linux-crypto@archiver.kernel.org>; Sat, 29 Jul 2023 08:41:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbjG2IlR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 29 Jul 2023 04:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbjG2Iku (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 29 Jul 2023 04:40:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91231448D
        for <linux-crypto@vger.kernel.org>; Sat, 29 Jul 2023 01:40:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22C0460A50
        for <linux-crypto@vger.kernel.org>; Sat, 29 Jul 2023 08:40:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81732C433C9
        for <linux-crypto@vger.kernel.org>; Sat, 29 Jul 2023 08:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690620039;
        bh=butziwcCrCR0u+L9b0oHe8nH4RZWDpy+vNmO2LQONCA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=YkVSgJk1Tzfe3Zafmi/9gPIyFPI6b9JQmmuW73m68ZMyfWlabru5LnSk12J1iDGN6
         bTx9t8QJLspwyEnZqev6dGA4kwGQS1wKSBJlsMgEzrG4+UvcZv3uxzhTzOyqsbJTNT
         2qqr43Cd8McilWPE/vwFRXfhJ+LFFYrAdYBdAq/9n+hOn80kr7BK9Mv/xTYK5zZcV/
         OoebD9FiIkUcbYql6u+7fKpRzZlslJ3jIqZs9uNBIAlJmjPDd/Tdw1q3mkOzJtSpaf
         a6kenkoq+/40Pdlvy7vP7uzlNhy/Oa2+flQS37kfXuvWGI+2TEQ1F89OBamp7jsthD
         9894TtQjxElPg==
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-4fe1b00fce2so3857650e87.3
        for <linux-crypto@vger.kernel.org>; Sat, 29 Jul 2023 01:40:39 -0700 (PDT)
X-Gm-Message-State: ABy/qLYnun/jQg9Vq6EwOkuUT+M2hxE7KE3RIcc4jf7jrPSOtG/YlUWj
        CmOeCkaOtr5lBr4cMgck2JS4ejNLhzJS9OCLlrw=
X-Google-Smtp-Source: APBJJlFq3d/NtD4UmFTFGPl1iUnedfD+O6WuCQbzO5uGeuFxzQmHEbGwYUhV/Dq644ig2uqio3ZPN69g7yFXCEfZUAc=
X-Received: by 2002:ac2:5f9c:0:b0:4f9:92c7:401d with SMTP id
 r28-20020ac25f9c000000b004f992c7401dmr3089312lfe.30.1690620037547; Sat, 29
 Jul 2023 01:40:37 -0700 (PDT)
MIME-Version: 1.0
References: <fd31dc60-67b2-8ed8-c941-2b5be777070a@metacode.biz>
In-Reply-To: <fd31dc60-67b2-8ed8-c941-2b5be777070a@metacode.biz>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 29 Jul 2023 10:40:25 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFDH+84WJiecBk+nJ+Ko6KuCZMUrbyspP7SrSEjMEYurw@mail.gmail.com>
Message-ID: <CAMj1kXFDH+84WJiecBk+nJ+Ko6KuCZMUrbyspP7SrSEjMEYurw@mail.gmail.com>
Subject: Re: Kernel Crypto exposing asymmetric operations to userland via libkcapi
To:     Wiktor Kwapisiewicz <wiktor@metacode.biz>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Puru Kulkarni <puruk@protonmail.com>,
        Puru Kulkarni <puruk@juniper.net>,
        Roberto Sassu <roberto.sassu@huaweicloud.com>,
        Stephan Mueller <smueller@chronox.de>,
        devel@lists.sequoia-pgp.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 27 Jul 2023 at 14:59, Wiktor Kwapisiewicz <wiktor@metacode.biz> wrote:
>
> Hi Kernel Crypto folks,
>
> I've got a question about the Kernel Crypto API.
>
> I'm working on adding a cryptographic backend based on the Kernel Crypto
> API to Sequoia PGP [0][1]. Sequoia supports several cryptographical
> backends already but using Kernel Crypto would allow us to significantly
> reduce dependencies when running on Linux.
>
> After implementing hashes, AEAD encryption and symmetric ciphers, I
> noticed that the libkcapi API for asymmetric ciphers (and ECDH) is not
> working. The libkcapi maintainer kindly explained [2] that the patches
> that they proposed for inclusion in the kernel [3] were not merged.
>
> I looked up the relevant thread [4], read it thoroughly and from what I
> can see most of the arguments are about private keys not being
> sufficiently protected and extensibility concerns with regards to keys
> stored in hardware security modules (TPMs etc.).
>
> However, these are mostly irrelevant to the Sequoia PGP use case, since
> private keys in software that we read do not need additional protection
> (as they are available for software anyway). We'd still like to use them
> for signing, decryption, verification and encryption. As for keys stored
> in HSMs we handle access to them in userland via our keystore module [5].
>
> My question is: Would it be possible to revisit the decision to expose
> operations with asymmetric keys (including ECDH) in Linux Crypto thus
> allowing libkcapi to work with non-patched kernels?
>
> I'd like to help make this happen and I think there are other projects
> that are interested in a complete cryptographic suite of Kernel Crypto
> functions available in user-land.
>

AF_ALG was never intended to provide a general purpose crypto library
to user space, but only to expose asynchronous hardware crypto
accelerators that are DMA based and managed by the OS.

Exposing the pure-software crypto implementations via AF_ALG was a
mistake IMHO. Making system calls into a privileged environment just
to run some algorithm that could easily run unprivileged as well is a
bad idea both for performance as well as for security/robustness. (On
top of that, SIMD based implementations need to execute with
preemption disabled, increasing scheduling jitter)

Due to the kernel's rigid 'no regressions' policy, AF_ALG will retain
support for the modes and algorithms it supports today, but I don't
think we should extend this support unless we limit it to
implementations provided by hardware accelerators. If it can be done
in software, it should be done in user space, not in the kernel.
