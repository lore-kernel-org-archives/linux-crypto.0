Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B2AC433F5
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Oct 2022 08:25:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiJDIZL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Oct 2022 04:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbiJDIZI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Oct 2022 04:25:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E25913F25
        for <linux-crypto@vger.kernel.org>; Tue,  4 Oct 2022 01:25:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B36E612B7
        for <linux-crypto@vger.kernel.org>; Tue,  4 Oct 2022 08:25:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C875C43470
        for <linux-crypto@vger.kernel.org>; Tue,  4 Oct 2022 08:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664871906;
        bh=c09apFURTZHi8Ds+drxvHV6zzdwMMRZaOtqtAb0OMeE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=SoumhSBuPaDhfjrF1ejix70xvFZzYu090BPlNa4hh7+svDUjPGPGX8/PLGcUjeeT6
         jwotAsOFbbucv1B1aFPscCP1kogrsxY8eYYGcWI79JGbsL9i4lrYZf/kLyx14ccM0j
         80uzdI4IdO4MEp8MH44Fw6V6W8M18Tp8OxKRLunmwr0ERlBHugIm07MSrOA5xLgRfA
         9xeyFdYiwQ8tnZJrHCSrSACULeanL6FtyZmt4eJbGm5Wc5Ao72g6GzeQxTk9Slq9GE
         pkV8hDFgZ71Z8ds14ggmxUCGuo7lIGIcmLiPtyIp9SywBHK+4/vOFCDG5C/zZ/6Fhr
         uiLUNh2YSmsGA==
Received: by mail-lf1-f44.google.com with SMTP id y5so422179lfl.4
        for <linux-crypto@vger.kernel.org>; Tue, 04 Oct 2022 01:25:06 -0700 (PDT)
X-Gm-Message-State: ACrzQf2nbeQqH4SmcgP/fNnKOlIXu64dfkRRS3ltM4uU7VKD2apcojyR
        5PxXkJCdCUPVAUHq7pE5KiYHHiZXiKH777Wrbmw=
X-Google-Smtp-Source: AMsMyM4eJbI24x/zqTvRkRcrbCGl7NsAG4DQE2flaYzkF3XkzXCUCYn8r0Aemykb+vDk0RXjEQ5QV62WSiI/C/Sesnc=
X-Received: by 2002:a05:6512:261b:b0:4a1:abd7:3129 with SMTP id
 bt27-20020a056512261b00b004a1abd73129mr9105614lfb.637.1664871904526; Tue, 04
 Oct 2022 01:25:04 -0700 (PDT)
MIME-Version: 1.0
References: <c6fb9b25-a4b6-2e4a-2dd1-63adda055a49@amd.com>
In-Reply-To: <c6fb9b25-a4b6-2e4a-2dd1-63adda055a49@amd.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 4 Oct 2022 10:24:53 +0200
X-Gmail-Original-Message-ID: <CAMj1kXF2sfsXhE9dq5b77nnzHEZHkMa+b2VUCCw7gtRL6mEwEw@mail.gmail.com>
Message-ID: <CAMj1kXF2sfsXhE9dq5b77nnzHEZHkMa+b2VUCCw7gtRL6mEwEw@mail.gmail.com>
Subject: Re: Early init for few crypto modules for Secure Guests
To:     "Nikunj A. Dadhania" <nikunj@amd.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>, ketanch@iitk.ac.in
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 4 Oct 2022 at 06:41, Nikunj A. Dadhania <nikunj@amd.com> wrote:
>
> Hi!
>
> We are trying to implement Secure TSC feature for AMD SNP guests [1]. During the boot-up of the
> secondary cpus, SecureTSC enabled guests need to query TSC info from Security processor (PSP).
> This communication channel is encrypted between the security processor and the guest,
> hypervisor is just the conduit to deliver the guest messages to the security processor.
> Each message is protected with an AEAD (AES-256 GCM).
>
> As the TSC info is needed during the smpboot phase, few crypto modules need to be loaded early
> to use the crypto api for encryption/decryption of SNP Guest messages.
>
> I was able to get the SNP Guest messages working with initializing few crypto modules using
> early_initcall() instead of subsys_initcall().
>
> Require suggestion/inputs if this is acceptable. List of modules that was changed
> to early_initcall:
>
> early_initcall(aes_init);
> early_initcall(cryptomgr_init);
> early_initcall(crypto_ctr_module_init);
> early_initcall(crypto_gcm_module_init);
> early_initcall(ghash_mod_init);
>

I understand the need for this, but I think it is a bad idea. These
will run even before SMP bringup, and before pure initcalls, which are
documented as
