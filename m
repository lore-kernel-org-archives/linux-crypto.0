Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35F31C83019
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 22:03:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBE5020709
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 22:03:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="cL98H4cx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388514AbgLAWC5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Dec 2020 17:02:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:59910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404317AbgLAWCv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Dec 2020 17:02:51 -0500
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD39C2085B
        for <linux-crypto@vger.kernel.org>; Tue,  1 Dec 2020 22:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606860130;
        bh=2318cJi0XM6B1EqVKiFaQn4nvxQOBf6NLR3H7/R83Ik=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cL98H4cxcSkmBUB6m1jvTsL4gAshvkrvx0F8v1a/mE8rDj5qItNC6fSp7ghUyK5P8
         pL9l3xYYsB3mY8b0pKtRuV87eUpzSICrFFfEICW9VZATZxQjiXFl2AB/AMi1Ay5BYd
         lxKbX4XOYR0s0+5w0zC1W1F8Ku/rSEuakxExfiTs=
Received: by mail-oi1-f171.google.com with SMTP id f11so3496623oij.6
        for <linux-crypto@vger.kernel.org>; Tue, 01 Dec 2020 14:02:09 -0800 (PST)
X-Gm-Message-State: AOAM533XukJdsrjQc9J+BjSmSf7t0KxB3WBKBJrgslILH7gZTRhIjzEp
        eleYx9d1qmWElkmGMmDWnblnun0xlVPZI0zb1BA=
X-Google-Smtp-Source: ABdhPJzbTO4Zwu4vMuduil2ypvFANMOMropXJnTTT7/FzTE4wnJAr6GnaPclEQ4bIwNROf6dG3BGJGpXmw5HUPAdqSw=
X-Received: by 2002:aca:dd0b:: with SMTP id u11mr3237948oig.47.1606860129096;
 Tue, 01 Dec 2020 14:02:09 -0800 (PST)
MIME-Version: 1.0
References: <20201201194556.5220-1-ardb@kernel.org> <20201201215722.GA31941@gondor.apana.org.au>
In-Reply-To: <20201201215722.GA31941@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 1 Dec 2020 23:01:57 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHb27ugTWuQZhPD0DvjtgYC8t_pj+igqK7dNfh+WsUS4w@mail.gmail.com>
Message-ID: <CAMj1kXHb27ugTWuQZhPD0DvjtgYC8t_pj+igqK7dNfh+WsUS4w@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: aesni - add ccm(aes) algorithm implementation
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ben Greear <greearb@candelatech.com>,
        Steve deRosier <derosier@cal-sierra.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 1 Dec 2020 at 22:57, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Tue, Dec 01, 2020 at 08:45:56PM +0100, Ard Biesheuvel wrote:
> > Add ccm(aes) implementation from linux-wireless mailing list (see
> > http://permalink.gmane.org/gmane.linux.kernel.wireless.general/126679).
> >
> > This eliminates FPU context store/restore overhead existing in more
> > general ccm_base(ctr(aes-aesni),aes-aesni) case in MAC calculation.
> >
> > Suggested-by: Ben Greear <greearb@candelatech.com>
> > Co-developed-by: Steve deRosier <derosier@cal-sierra.com>
> > Signed-off-by: Steve deRosier <derosier@cal-sierra.com>
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> > v2: avoid the SIMD helper, as it produces an CRYPTO_ALG_ASYNC aead, which
> >     is not usable by the 802.11 ccmp driver
>
> Sorry, but this is not the way to go.  Please fix wireless to
> use the async interface instead.
>

This is not the first time this has come up. The point is that CCMP in
the wireless stack is not used in 99% of the cases, given that any
wifi hardware built in the last ~10 years can do it in hardware. Only
in exceptional cases, such as Ben's, is there a need for exercising
this interface.

Also, care to explain why we have synchronous AEADs in the first place
if they are not supposed to be used?
