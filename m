Return-Path: <SRS0=xktg=33=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF2FDC352A2
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Feb 2020 12:30:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DA4020720
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Feb 2020 12:30:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="risa1OP3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgBGM37 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Feb 2020 07:29:59 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:16623 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbgBGM37 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Feb 2020 07:29:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1581078597;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=KtjZ/hcfzGexdUOqkVZ3eTpPAhXVGcnWWMQFTkp83LE=;
        b=risa1OP3toCV2WvPPw7/yCF9Vi5ImnDeC05ZGhOmXH6W4k3GZdXkM5gQkaIjnIOh77
        ZiwlHCT8Wh+rKw8SoO2sERkrqJIKRN1CK0T8l4P79ebg88E29MS9RLmHbVJBW/Cfmr73
        DjDpyQ9+5z1MPEUmfXJqef49/g8Oc2kykOoQTn1Z2kGTwtgWmE0qCSYRK4Kfx6DGMDeb
        SBzB5VKZnDBJ4x4E8Nc9lB8FjKObB/5NeGjjK3q9sgME5aCGgECCWGS05UU8uTHR8qWp
        YyKeuu6YfisT72TrXN3/CorBYLSFS8DD31JSGTpmanLLQrSyIOl+EELAOYWcXm+3wak1
        E7gQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaIfScugJ3"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.1.12 DYNA|AUTH)
        with ESMTPSA id 608a92w17CTleTE
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 7 Feb 2020 13:29:47 +0100 (CET)
From:   Stephan Mueller <smueller@chronox.de>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Miller <davem@davemloft.net>,
        Ofir Drang <Ofir.Drang@arm.com>
Subject: Re: Possible issue with new inauthentic AEAD in extended crypto tests
Date:   Fri, 07 Feb 2020 13:29:47 +0100
Message-ID: <6968686.FA8oO0t0Vk@tauon.chronox.de>
In-Reply-To: <CAOtvUMchWrNsvmLJ2D-qiGOAAgbr_yxtt3h81yOHesa7C6ifZQ@mail.gmail.com>
References: <CAOtvUMcwLtwgigFE2mx7LVjhhEgcZsSS4WyR_SQ2gixTZxyBfg@mail.gmail.com> <28236835.Fk5ARk2Leh@tauon.chronox.de> <CAOtvUMchWrNsvmLJ2D-qiGOAAgbr_yxtt3h81yOHesa7C6ifZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 7. Februar 2020, 12:50:51 CET schrieb Gilad Ben-Yossef:

Hi Gilad,

> 
> It is correct, but is it smart?
> 
> Either we require the same IV to be passed twice as we do today, in which
> case passing different IV should fail in a predictable manner OR we should
> define the operation is taking two IV like structures - one as the IV and
> one as bytes in the associated data and have the IPsec code use it in a
> specific way of happen to pass the same IV in both places.
> 
> I don't care either way - but right now the tests basically relies on
> undefined behaviour
> which is always a bad thing, I think.

I am not sure about the motivation of this discussion: we have exactly one 
user of the RFC4106 implementation: IPSec. Providing the IV/AAD is efficient 
as the rfc4106 template intents to require the data in a format that requires 
minimal processing on the IPSec side to bring it in the right format.

On the other hand, the cipher implementation should just do the operation 
regardless of where the data comes from or whether the AAD buffer overlaps 
with the IV buffer. I.e. the cipher should try to interpret the data but just 
do the work.

So, where is it inefficient? Maybe the API for RFC4106 could be a bit nicer, 
but it needs to fit into the overall AEAD API as a specific RFC4106-API seems 
to be overkill.

Ciao
Stephan


