Return-Path: <SRS0=0bM2=3R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCFB4C33CB7
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 03:15:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1626F24656
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 03:15:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="AXd0PE4T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgA1DPe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jan 2020 22:15:34 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:19317 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgA1DPe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jan 2020 22:15:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1580181329;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=lJ11o0DcTDvqJFDrY21f/t0VEMjs0mR17MYiJMNSHa8=;
        b=AXd0PE4Tvk5HYxiLI509aL0gy9Pd+83DOwOYZDjBV+X7D9nye54wZYlXM33ss+iNbh
        dh5ffNHYip+e5ETdjvboLE0FN7aS2saMa4AI8+q9CKnFU8s6bt7uj64wrhDJeoZKTYtZ
        ZLr5AvkGCsQasvkddbZya/GUvo+HLji5cIhbfUwsv6zLDyQW9gcI5YNiQcYRb2K2XHqo
        wcfLwIYMOeiUg9FWOx7yeHrJPNJvANzuWQR2emCVTYOfZN7QDFQEKbkzqpE7KDrhLeoi
        MNiWHkvcM3N5qntV3IaCY76t0nJj5r29bY1wE6Ppull/HloyMu7qFrYWr6KGpfp0ZYQa
        GbsA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9ym4dPkYX6am8zHoI"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.1.7 AUTH)
        with ESMTPSA id I05c44w0S3FFLNz
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 28 Jan 2020 04:15:15 +0100 (CET)
From:   Stephan Mueller <smueller@chronox.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Miller <davem@davemloft.net>,
        Ofir Drang <Ofir.Drang@arm.com>
Subject: Re: Possible issue with new inauthentic AEAD in extended crypto tests
Date:   Tue, 28 Jan 2020 04:15:11 +0100
Message-ID: <3730881.07ufDO6WFW@tauon.chronox.de>
In-Reply-To: <20200128023455.GC960@sol.localdomain>
References: <CAOtvUMcwLtwgigFE2mx7LVjhhEgcZsSS4WyR_SQ2gixTZxyBfg@mail.gmail.com> <20200128023455.GC960@sol.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Dienstag, 28. Januar 2020, 03:34:55 CET schrieb Eric Biggers:

Hi Eric,

> On Mon, Jan 27, 2020 at 10:04:26AM +0200, Gilad Ben-Yossef wrote:
> > When both vec->alen and vec->plen are 0, which can happen as
> > generate_random_bytes will happily generate  zero length from time to
> > time,
> > we seem to be getting a scatterlist with the first entry (as well as
> > the 2nd) being a NULL.
> > 
> > This seems to violate the words of wisdom from aead.h and much more
> > important to me crashes the ccree driver :-)
> > 
> > Is there anything I am missing or is this a valid concern?
> 
> My understanding is that all crypto API functions that take scatterlists
> only forbid zero-length scatterlist elements in the part of the scatterlist
> that's actually passed to the API call.  The input to these functions is
> never simply a scatterlist, but rather a (scatterlist, length) pair. 
> Algorithms shouldn't look beyond 'length', so in the case of 'length == 0',
> they shouldn't look at the scatterlist at all -- which may be just a NULL
> pointer.
> 
> If that's the case, there's no problem with this test code.

I agree with your assessment. Not only when looking at cipher or template 
implementations, but also when looking at the scatterwalk API the SGL length 
field is processed first. If the length field is insufficient then the SGL is 
not processed.
> 
> I'm not sure the comment in aead.h is relevant here.  It sounds like it's
> warning about not providing an empty scatterlist element for the AAD when
> it's followed by a nonempty scatterlist element for the plaintext.  I'm not
> sure it's meant to also cover the case where both are empty.

The statement here (and maybe it could be updated) refers to a valid SGL with 
a size > 0, but where the first SGL entry points to a NULL buffer. This is an 
invalid use of an SGL.

Specifically for AEAD, the SGL must have the form of (assoc data || 
plaintext). As the AAD is not required for a successful cipher operation, the 
caller of the crypto API must guarantee the AAD is either non-NULL or the SGL 
must start with the plaintext as the first entry.
> 
> Herbert and Stephan, any thoughts on what was intended?
> 
> - Eric



Ciao
Stephan


