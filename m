Return-Path: <SRS0=sEgb=BN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EFC0C433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Aug 2020 15:10:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36F15207FB
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Aug 2020 15:10:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="mbF0GFL4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgHCPKL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Aug 2020 11:10:11 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.21]:24228 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgHCPKL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Aug 2020 11:10:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1596467409;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=9gVOvKOEzWL/0OOHvsxWHzzMdk8kO5gegmDOzKRPDeY=;
        b=mbF0GFL43sqv0E95W2jUXukGKNZXrpAAiQRBKNxEzz5TbyR/G+E2N4XDAWgMCKOG4r
        zCZ0L9s3DqIR5mS/eLBuyHcEkVs9nY8jni/Iq/NQCfpNhp4E2lLCIKgnOeXjkerU7MlL
        XKR3lp7YKXcH0A9oWteLvsgnLS5nsZgFXGAkUcgoViIvIvk292Z3QvoRNinz8XFBPQyr
        TE8u7V4i6C0VGng00YlveRox13hQtAa8N/WeY1TILZVGbvOl+j2yk2SgYNRdIpzPJ8rC
        kHr38NCGAjE4R7y5r7BbPUkk2btFFYnoyvS5LJXPiWemv1E8IJ2K3oelceAUTediLMk/
        hTYQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZJPSfIqEh"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.10.5 DYNA|AUTH)
        with ESMTPSA id y0546bw73FA4f9t
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 3 Aug 2020 17:10:04 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Elena Petrova <lenaptr@google.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jeffrey Vander Stoep <jeffv@google.com>
Subject: Re: [PATCH v4] crypto: af_alg - add extra parameters for DRBG interface
Date:   Mon, 03 Aug 2020 17:10:03 +0200
Message-ID: <4818892.iTQEcLzFEP@tauon.chronox.de>
In-Reply-To: <CABvBcwY-F6Euo2SAY6MKpT0KP7OtyswLhUmShPNPfB0qqL6heQ@mail.gmail.com>
References: <20200729154501.2461888-1-lenaptr@google.com> <20200731072338.GA17285@gondor.apana.org.au> <CABvBcwY-F6Euo2SAY6MKpT0KP7OtyswLhUmShPNPfB0qqL6heQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Montag, 3. August 2020, 16:48:02 CEST schrieb Elena Petrova:

Hi Elena,

> On Fri, 31 Jul 2020 at 08:27, Herbert Xu <herbert@gondor.apana.org.au> 
wrote:
> > Eric Biggers <ebiggers@kernel.org> wrote:
> > > lock_sock() would solve the former.  I'm not sure what should be done
> > > about
> > > rng_recvmsg().  It apparently relies on the crypto_rng doing its own
> > > locking, but maybe it should just use lock_sock() too.
> > 
> > The lock_sock is only needed if you're doing testing.  What I'd
> > prefer is to have a completely different code-path for testing.
> 
> sendmsg is used for "Additional Data" input, and unlike entropy, it
> could be useful outside of testing. But if you confirm it's not
> useful, then yes, I can decouple the testing parts.

Nobody has requested it for now - so why not only compiling it when the DRBG 
test config value is set? If for some reason there is a request to allow 
setting the additional data from user space, we may simply take the ifdef 
away.

My approach is to have only interfaces into the kernel that are truly 
requested and needed.

Ciao
Stephan


