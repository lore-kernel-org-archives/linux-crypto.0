Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE1D3C4332F
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Oct 2022 08:28:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbiJDI2V (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Oct 2022 04:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbiJDI2T (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Oct 2022 04:28:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6621F22BD5
        for <linux-crypto@vger.kernel.org>; Tue,  4 Oct 2022 01:28:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A87D4B81919
        for <linux-crypto@vger.kernel.org>; Tue,  4 Oct 2022 08:28:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A19C43470
        for <linux-crypto@vger.kernel.org>; Tue,  4 Oct 2022 08:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664872094;
        bh=KqsrzYor1IDL/G5WqsCeBXOgqDBaPz5BJOPsr1Ggbuo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=pngbARxco8iNl6GM133fTehcx9wHc8W181B8vvWchhR0dgyTbhfiZpKkAX08J2b//
         AHc7TSIWWdUGLjxYrIwcgkFH2/OP5SW/ooTZDoM5u9VJEY0LWu/aXHyDRkAuVPouvN
         7h2PUbWCI8K/2p4bU81BtBECJlBdV/h4fhml6jjmEfUWBcXknr8l4Axe2wzE8G9ZDe
         1mrnLYMkHRX/yb5ZYFKK32kHqEgUxVv0/XvXb1aYH0cNTSZm0FmoJ42uU+Y7Yo+LMt
         204oZo0X1rZVCfbD/xYaVVNkPkv++QntIUWlWCGe8Pc/Tr9X1w6hvGGgOMGe2q4yQO
         o5IWnxn6RqO0g==
Received: by mail-lf1-f47.google.com with SMTP id 25so9802741lft.9
        for <linux-crypto@vger.kernel.org>; Tue, 04 Oct 2022 01:28:14 -0700 (PDT)
X-Gm-Message-State: ACrzQf2BV4UQ5dF+QW+g80nHSsczPxVWyE7Flu4FZGQyVVO2sZ671zeZ
        WYw+Vs2kkWUIOilSKiFNqG1sTjKfl14zeUvGIbM=
X-Google-Smtp-Source: AMsMyM6Jdx+JGklrwcx//VuqSh26sEGPJqdwSXbCRiEHwgQLVVyVHkN8DwAuv0y08RYoEmUXPQ/xYI5Aq2QVxkNR7zo=
X-Received: by 2002:a05:6512:150e:b0:492:d9fd:9bdf with SMTP id
 bq14-20020a056512150e00b00492d9fd9bdfmr8274973lfb.583.1664872092433; Tue, 04
 Oct 2022 01:28:12 -0700 (PDT)
MIME-Version: 1.0
References: <c6fb9b25-a4b6-2e4a-2dd1-63adda055a49@amd.com> <CAMj1kXF2sfsXhE9dq5b77nnzHEZHkMa+b2VUCCw7gtRL6mEwEw@mail.gmail.com>
In-Reply-To: <CAMj1kXF2sfsXhE9dq5b77nnzHEZHkMa+b2VUCCw7gtRL6mEwEw@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 4 Oct 2022 10:28:01 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGzKO8=F2RzFBObPYb7J-hSj-esHJ8oCC-1fsV-B028EQ@mail.gmail.com>
Message-ID: <CAMj1kXGzKO8=F2RzFBObPYb7J-hSj-esHJ8oCC-1fsV-B028EQ@mail.gmail.com>
Subject: Re: Early init for few crypto modules for Secure Guests
To:     "Nikunj A. Dadhania" <nikunj@amd.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>, ketanch@iitk.ac.in
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 4 Oct 2022 at 10:24, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Tue, 4 Oct 2022 at 06:41, Nikunj A. Dadhania <nikunj@amd.com> wrote:
> >
> > Hi!
> >
> > We are trying to implement Secure TSC feature for AMD SNP guests [1]. During the boot-up of the
> > secondary cpus, SecureTSC enabled guests need to query TSC info from Security processor (PSP).
> > This communication channel is encrypted between the security processor and the guest,
> > hypervisor is just the conduit to deliver the guest messages to the security processor.
> > Each message is protected with an AEAD (AES-256 GCM).
> >
> > As the TSC info is needed during the smpboot phase, few crypto modules need to be loaded early
> > to use the crypto api for encryption/decryption of SNP Guest messages.
> >
> > I was able to get the SNP Guest messages working with initializing few crypto modules using
> > early_initcall() instead of subsys_initcall().
> >
> > Require suggestion/inputs if this is acceptable. List of modules that was changed
> > to early_initcall:
> >
> > early_initcall(aes_init);
> > early_initcall(cryptomgr_init);
> > early_initcall(crypto_ctr_module_init);
> > early_initcall(crypto_gcm_module_init);
> > early_initcall(ghash_mod_init);
> >
>
> I understand the need for this, but I think it is a bad idea. These
> will run even before SMP bringup, and before pure initcalls, which are
> documented as

/*
 * A "pure" initcall has no dependencies on anything else, and purely
 * initializes variables that couldn't be statically initialized.
 */

So basically, you should not be relying on any global infrastructure
to have been initialized. This is also something that may cause
different problems on different architectures, and doing this only for
x86 seems like a problem as well.

Can you elaborate a bit on the use case? AES in GCM mode seems like a
thing that we might be able to add to the crypto library API without
much hassle (which already has a minimal implementation of AES)
