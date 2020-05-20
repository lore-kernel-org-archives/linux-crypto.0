Return-Path: <SRS0=Eyne=7C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 685E6C433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 07:09:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33137206BE
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 07:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589958597;
	bh=4sY4q9CroctrXjv/UwpUkw02mR25DQOr6OzfqIelbjE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=gzOXbPEjhT/dXN9fHV15exysvh1tavGH4sZKBiwe851Yzfs8JaNCGKSq6A+hGH83B
	 x76BImQS0izDgUL1k4Njtya8kJujYWX4yT/jbhCikph3XVVIyfq256JhjatTsGyttW
	 q1gnDdlSguW60XIx0j5lui4ZqJgWiF8SSVqsfxB0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgETHJ4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 May 2020 03:09:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:52146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725998AbgETHJ4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 May 2020 03:09:56 -0400
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BCEC206BE
        for <linux-crypto@vger.kernel.org>; Wed, 20 May 2020 07:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589958595;
        bh=4sY4q9CroctrXjv/UwpUkw02mR25DQOr6OzfqIelbjE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=RJO6YFoh2r5xPKUS6+X6N3myoxI8Wb9pyEgiYSYFMZF8Rp6LabwukwbmDBcQofqA1
         c9JyndZq0tRfuaoGNGRYAkvPltuf4oeg5/BA9O4tA3yILprA1eofYt718Ob2Shbe6h
         9sC95/7QYTZgKKPwqpNa2CwHm3f1k4WZ1EKysEAw=
Received: by mail-io1-f41.google.com with SMTP id x5so2033756ioh.6
        for <linux-crypto@vger.kernel.org>; Wed, 20 May 2020 00:09:55 -0700 (PDT)
X-Gm-Message-State: AOAM530QjXg2IxE2Cq+uSor5vGBYK/y31u2gPdCehbskImiOsJjCMBhM
        pVM7YjuvEFd8WelGNPBqpL4JU1QVIkiK7kkl/Aw=
X-Google-Smtp-Source: ABdhPJyOXjsFOkYhmYHT7iFdcXVegTXxIRAIBTriQ0zKyf5yT8sidmor3hf/bZlBjVkaEA/C8+qtSjXgUCVFcgWgCcE=
X-Received: by 2002:a05:6638:41b:: with SMTP id q27mr2996869jap.68.1589958594942;
 Wed, 20 May 2020 00:09:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200519190211.76855-1-ardb@kernel.org> <16394356.0UTfFWEGjO@tauon.chronox.de>
 <CAMj1kXF=Duh1AsAQy+aLWMcJPQ4RFL5p9-Mnmn-XAiCkzyGFbg@mail.gmail.com> <2010567.jSmZeKYv2B@tauon.chronox.de>
In-Reply-To: <2010567.jSmZeKYv2B@tauon.chronox.de>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 20 May 2020 09:09:44 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGNqo=d-hgK=0zBZCoJYgSxxhhm=Jdk2gAGXPo1-KSCgA@mail.gmail.com>
Message-ID: <CAMj1kXGNqo=d-hgK=0zBZCoJYgSxxhhm=Jdk2gAGXPo1-KSCgA@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH 0/2] crypto: add CTS output IVs for arm64 and testmgr
To:     Stephan Mueller <smueller@chronox.de>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 20 May 2020 at 09:01, Stephan Mueller <smueller@chronox.de> wrote:
>
> Am Mittwoch, 20. Mai 2020, 08:54:10 CEST schrieb Ard Biesheuvel:
>
> Hi Ard,
>
> > On Wed, 20 May 2020 at 08:47, Stephan Mueller <smueller@chronox.de> wrote:
...
> > > The state of all block chaining modes we currently have is defined with
> > > the
> > > IV. That is the reason why I mentioned it can be implemented stateless
> > > when I am able to get the IV output from the previous operation.
> >
> > But it is simply the same as the penultimate block of ciphertext. So
> > you can simply capture it after encrypt, or before decrypt. There is
> > really no need to rely on the CTS transformation to pass it back to
> > you via the buffer that is only specified to provide an input to the
> > CTS transform.
>
> Let me recheck that as I am not fully sure on that one. But if it can be
> handled that way, it would make life easier.

Please refer to patch 2. The .iv_out test vectors were all simply
copied from the appropriate offset into the associated .ctext member.
