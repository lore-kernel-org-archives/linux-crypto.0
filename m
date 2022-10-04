Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B26ACC433F5
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Oct 2022 17:17:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiJDRRu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Oct 2022 13:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiJDRRu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Oct 2022 13:17:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E9D2496E
        for <linux-crypto@vger.kernel.org>; Tue,  4 Oct 2022 10:17:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6260614DA
        for <linux-crypto@vger.kernel.org>; Tue,  4 Oct 2022 17:17:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B43C433B5
        for <linux-crypto@vger.kernel.org>; Tue,  4 Oct 2022 17:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664903868;
        bh=qRYySLCJcBEU+9HD/P5QGxj9GgZCce6S5LJfaj73mDA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Fwt3OhTm7ucVVI79o6WPKuPhpmSx9tEMU5ZfTHrU+5U7g4ygg2z4yney2D6rEhIXq
         eqtAdxKSKhZxA9VlpsQJ7LpobU0B7Z5vlxvsXx6IwjdFRKvOH4swcnFZYYQKVkCdYx
         hAiz1RIrTTPvVhQYtVpKakKXE1LEcSpApod4cEJo+X9/gNc13zpnLKcaX3Ji4tz7yD
         F4hyEhTwD5hRYKo0Q/OG9iSeEyinfm/b4hCsrS9ZbVRt9ok2hkHF8pnHReeny3a62K
         zA/sOhC9zpf6JSmI+O5hSzrmVw8uco+YJS2hkpu8xpjRHzbqf+a2e5eH1xQhD/3Sql
         ylXO2EY44EYZg==
Received: by mail-lf1-f41.google.com with SMTP id s20so6413170lfi.11
        for <linux-crypto@vger.kernel.org>; Tue, 04 Oct 2022 10:17:48 -0700 (PDT)
X-Gm-Message-State: ACrzQf1DklFcPGwzybL79frH12JNUB6WQWm2nD5zYTAz4QnmbULo6u0T
        /1S7G4mk9dtPrhxBkYNX9pUvsx6GbhFxXOsomDk=
X-Google-Smtp-Source: AMsMyM606+DWB9uo037v6tm5Ljkn1ysBy0swI7KXBDLsbnqddbhC+Hxsv1/eipUmjTt5F1jOFB6mxdH9ear1kxy/X+s=
X-Received: by 2002:ac2:4d1c:0:b0:4a2:4119:f647 with SMTP id
 r28-20020ac24d1c000000b004a24119f647mr3096726lfi.426.1664903866228; Tue, 04
 Oct 2022 10:17:46 -0700 (PDT)
MIME-Version: 1.0
References: <c6fb9b25-a4b6-2e4a-2dd1-63adda055a49@amd.com> <CAMj1kXF2sfsXhE9dq5b77nnzHEZHkMa+b2VUCCw7gtRL6mEwEw@mail.gmail.com>
 <CAMj1kXGzKO8=F2RzFBObPYb7J-hSj-esHJ8oCC-1fsV-B028EQ@mail.gmail.com> <a9ea7eac-0fa4-63dd-42ad-87109c8fe0e4@amd.com>
In-Reply-To: <a9ea7eac-0fa4-63dd-42ad-87109c8fe0e4@amd.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 4 Oct 2022 19:17:34 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHDbnNWb23eXMie1hQaDmX3nR2261eKXbMPW-c9sWRSsg@mail.gmail.com>
Message-ID: <CAMj1kXHDbnNWb23eXMie1hQaDmX3nR2261eKXbMPW-c9sWRSsg@mail.gmail.com>
Subject: Re: Early init for few crypto modules for Secure Guests
To:     "Nikunj A. Dadhania" <nikunj@amd.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>, ketanch@iitk.ac.in
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 4 Oct 2022 at 11:51, Nikunj A. Dadhania <nikunj@amd.com> wrote:
>
> On 04/10/22 13:58, Ard Biesheuvel wrote:
> > On Tue, 4 Oct 2022 at 10:24, Ard Biesheuvel <ardb@kernel.org> wrote:
> >>
> >> On Tue, 4 Oct 2022 at 06:41, Nikunj A. Dadhania <nikunj@amd.com> wrote:
> >>>
> >>> Hi!
> >>>
> >>> We are trying to implement Secure TSC feature for AMD SNP guests [1]. During the boot-up of the
> >>> secondary cpus, SecureTSC enabled guests need to query TSC info from Security processor (PSP).
> >>> This communication channel is encrypted between the security processor and the guest,
> >>> hypervisor is just the conduit to deliver the guest messages to the security processor.
> >>> Each message is protected with an AEAD (AES-256 GCM).
> >>>
> >>> As the TSC info is needed during the smpboot phase, few crypto modules need to be loaded early
> >>> to use the crypto api for encryption/decryption of SNP Guest messages.
> >>>
> >>> I was able to get the SNP Guest messages working with initializing few crypto modules using
> >>> early_initcall() instead of subsys_initcall().
> >>>
> >>> Require suggestion/inputs if this is acceptable. List of modules that was changed
> >>> to early_initcall:
> >>>
> >>> early_initcall(aes_init);
> >>> early_initcall(cryptomgr_init);
> >>> early_initcall(crypto_ctr_module_init);
> >>> early_initcall(crypto_gcm_module_init);
> >>> early_initcall(ghash_mod_init);
> >>>
> >>
> >> I understand the need for this, but I think it is a bad idea. These
> >> will run even before SMP bringup, and before pure initcalls, which are
> >> documented as
> >
> > /*
> >  * A "pure" initcall has no dependencies on anything else, and purely
> >  * initializes variables that couldn't be statically initialized.
> >  */>
> > So basically, you should not be relying on any global infrastructure
> > to have been initialized. This is also something that may cause
> > different problems on different architectures, and doing this only for
> > x86 seems like a problem as well.
> >
> > Can you elaborate a bit on the use case?
>
> Parameters used in TSC value calculation is controlled by
> the hypervisor and a malicious hypervisor can prevent guest from
> moving forward. Secure TSC allows guest to securely use rdtsc/rdtscp
> as the parameters being used now cannot be changed by hypervisor once
> the guest is launched.
>
> For the boot-cpu, TSC_SCALE/OFFSET is initialized as part of the guest
> launch process. During the secure guest boot, boot cpu will start bringing
> up the secondary CPUs. While creation of secondary CPU, TSC_SCALE/OFFSET
> field needs to be initialized appropriately. SNP Guest messages are the
> mechanism to communicate with the PSP to prevent risks from a malicious
> hypervisor snooping.
>
> The PSP firmware provides each guests with four Virtual Machine Platform
> Communication key(VMPCK) and is passed to the guest using a special secrets page
> as part of the guest launch process. The key is either with the guest or the
> PSP firmware.
>
> The messages exchanged between the guest and the PSP firmware is
> encrypted/decrypted using this key.
>
> > AES in GCM mode seems like a
> > thing that we might be able to add to the crypto library API without
> > much hassle (which already has a minimal implementation of AES)
>
> That will be great !
>

Try this branch and see if it works for you

https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=libgcm
