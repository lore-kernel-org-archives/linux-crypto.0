Return-Path: <SRS0=Ahx1=BA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2013AC433E1
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 13:19:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED62320771
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 13:19:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="ddXqwGBm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgGUNTD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jul 2020 09:19:03 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.163]:23276 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbgGUNTD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jul 2020 09:19:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1595337538;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=3wa9df+B6y4GBthgur8zFZ654n8i/8x7FFkbtntW+do=;
        b=ddXqwGBmhMseoT6IX/IlaH6srUdQuLOyvoroM+zg3hkH2ezPKGb9vbjgl6WdFOwRqd
        8jR/hhZ101/2c6Yg2SirbQGsKgy2yDrmysngIgmuHvX5eTdIDJfZiDHBPdnqyFDWJtci
        j9AGZecyyTPJhCmT5lhbiISeplnmecSgRucp8Cv1SVxD6/LJ/Mr1sORl6SlqNEKU1Fgq
        nS5qnhYYhu7lDfWbnSqgWfthO1sjraA/R4LMijaGlAgqc0OxSnJtJTcpbePsmkwq/5sR
        LXBOIHo4+Pcthd0RixQwpvao6v7XHfOu96zSgLHH9zgDMebUsQSdIvU0K7mrvQx10Vmv
        dvhQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZJPScHiDh"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.10.5 DYNA|AUTH)
        with ESMTPSA id y0546bw6LDIsZUe
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 21 Jul 2020 15:18:54 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Elena Petrova <lenaptr@google.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jeffrey Vander Stoep <jeffv@google.com>
Subject: Re: [PATCH v2] crypto: af_alg - add extra parameters for DRBG interface
Date:   Tue, 21 Jul 2020 15:18:54 +0200
Message-ID: <9149882.4vTCxPXJkl@tauon.chronox.de>
In-Reply-To: <CABvBcwZ5mQPVFNpw=mY29cXo8oU8yviW5FZEFdKBNLvaudH6Ow@mail.gmail.com>
References: <CABvBcwY44BPa+TaDwxWaEogpg3Kdkq8o9cR5gSqNGF-o6d3jrw@mail.gmail.com> <13569541.ZYm5mLc6kN@tauon.chronox.de> <CABvBcwZ5mQPVFNpw=mY29cXo8oU8yviW5FZEFdKBNLvaudH6Ow@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Dienstag, 21. Juli 2020, 14:55:14 CEST schrieb Elena Petrova:

Hi Elena,

> > > +#ifdef CONFIG_CRYPTO_CAVS_DRBG
> > > +static int rng_setentropy(void *private, const u8 *entropy, unsigned
> > > int
> > > len) +{
> > > +     struct rng_parent_ctx *pctx = private;
> > > +     u8 *kentropy = NULL;
> > > +
> > > +     if (!capable(CAP_SYS_ADMIN))
> > > +             return -EPERM;
> > > +
> > > +     if (pctx->entropy)
> > > +             return -EINVAL;
> > > +
> > > +     if (len > MAXSIZE)
> > > +             len = MAXSIZE;
> > > +
> > > +     if (len) {
> > > +             kentropy = memdup_user(entropy, len);
> > > +             if (IS_ERR(kentropy))
> > > +                     return PTR_ERR(kentropy);
> > > +     }
> > > +
> > > +     crypto_rng_alg(pctx->drng)->set_ent(pctx->drng, kentropy, len);
> > > +     pctx->entropy = kentropy;
> > 
> > Why do you need to keep kentropy around? For the check above whether
> > entropy was set, wouldn't a boolean suffice?
> 
> I need to keep the pointer to free it after use. Unlike the setting of
> the key, DRBG saves the entropy pointer in one of its internal
> structures, but doesn't do any memory
> management. I had only two ideas on how to prevent memory leaks:
> either change drbg code to deal with the memory, or save the pointer
> somewhere inside the socket. I opted for the latter. But if you know a
> better approach I'm happy to rework my code accordingly.

I was thinking of calling crypto_rng_alg(pctx->drng)->seed() directly after 
set_ent. This call performs a DRBG instantatiate where the entropy buffer is 
used. See crypto_drbg_reset_test for the approach.

But maybe you are right, the test "entropy" buffer inside the DRBG currently 
cannot be reset. So, for sanity purposes, you need to keep it around.

Ciao
Stephan


