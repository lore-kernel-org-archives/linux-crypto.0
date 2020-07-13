Return-Path: <SRS0=38jD=AY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44812C433E4
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jul 2020 06:05:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 636E820791
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jul 2020 06:05:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="k5Q1DZsi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgGMGFY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Jul 2020 02:05:24 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.51]:26243 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbgGMGFY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Jul 2020 02:05:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1594620322;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=mJQeMpu+X7tSZDlxg/9ft6rInml1bv2pRKLjw+QQc5M=;
        b=k5Q1DZsiPFGRAsxNolWIMjIQqQ6b0KjrqHV383OVzqIr0D8UoptXrN7wpaHIw+pHbz
        n6AraobmH4dAkYs1Ec9z4X4JTZtmSkE77hgM7vUFX6U7UN6xNksEerfmjPa/K7fRyaZy
        cjHIMmysjgrXXjhsq/JhBitf6cf84zYM5wjYkTwyMze30yZ6VuisM+7jVst6t98BLe4X
        3YiGYwYNGFRlIXwesGUG02hhgv325cDc7UU4lbabB+HF8QZwv7MlJb5RMYt24CvOgyqZ
        joH7L3wfL0EqKlHl4oJ0ziVVBd1L+pzBNWh/T22VC5poGzrHGSHQ9F4CJgMFHYDjvpcl
        X6Zw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaIvSfHReW"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 46.10.5 DYNA|AUTH)
        with ESMTPSA id y0546bw6D62kjqn
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 13 Jul 2020 08:02:46 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Stephan Mueller <smueller@chronox.de>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        ard.biesheuvel@linaro.org, nhorman@redhat.com, simo@redhat.com
Subject: Re: [PATCH v2 5/5] crypto: ECDH SP800-56A rev 3 local public key validation
Date:   Mon, 13 Jul 2020 08:02:45 +0200
Message-ID: <5631658.lOV4Wx5bFT@positron.chronox.de>
In-Reply-To: <20200713055950.ibvzogkdwhqxcduc@altlinux.org>
References: <2543601.mvXUDI8C0e@positron.chronox.de> <5856902.DvuYhMxLoT@tauon.chronox.de> <20200713055950.ibvzogkdwhqxcduc@altlinux.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Montag, 13. Juli 2020, 07:59:50 CEST schrieb Vitaly Chikunov:

Hi Vitaly,

> > > > +/* SP800-56A section 5.6.2.3.3 full verification */
> > > 
> > > Btw, 5.6.2.3.3 is partial validation, 5.6.2.3.2 is full validation
> > > routine.
> > 
> > Looking at SP800-56A revision 3 from April 2018 I see:
> > 
> > "5.6.2.3.3 ECC Full Public-Key Validation Routine"
> 
> You are right. I looked at
> 
>  
> https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-56Ar2.pdf
> 
> which is Rev 2. And in Rev 3 they inserted `5.6.2.3.2 FFC Partial Public-Key
> Validation Routine', so ECC paragraph numbers are shifted up.

Thank you for the confirmation.

Ciao
Stephan


