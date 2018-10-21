Return-Path: <SRS0=JV5w=NB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93F36ECDE43
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Oct 2018 08:07:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C5E520843
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Oct 2018 08:07:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="AGEIsr2Y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C5E520843
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbeJUQVR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Oct 2018 12:21:17 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42168 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727110AbeJUQVR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Oct 2018 12:21:17 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id CF3B78EE0D7;
        Sun, 21 Oct 2018 01:07:47 -0700 (PDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id vze1MqTsiXCc; Sun, 21 Oct 2018 01:07:47 -0700 (PDT)
Received: from [10.9.38.243] (host-80-195-152-82.static.cable.virginmedia.com [80.195.152.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id E74088EE0CC;
        Sun, 21 Oct 2018 01:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1540109267;
        bh=qJ5raPLqxTaFuGCXpc5tmIZCqHBiRylAO+z5IqjON/Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=AGEIsr2Yr1kHik5O4Qs0ArjSPs1t5vsNwffNar3BJYtQoBt5gdqLS2hKWWugKKpNz
         KTmzCrpEVUWdA3fctk5QYenAM/NVtzhkC+DrjMuiY0hxpDCKipYOKKvm80FciRnl6d
         BorMdmvRrvpDPzb+BTtjwGcMy4wugttTfy99Sdg8=
Message-ID: <1540109262.3023.6.camel@HansenPartnership.com>
Subject: Re: [PATCH 1/2] crypto: fix cfb mode decryption
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable <stable@vger.kernel.org>
Date:   Sun, 21 Oct 2018 09:07:42 +0100
In-Reply-To: <CAKv+Gu8eiFXoC2MWjGUG_AgDNq5rduWQN0CC4Q4BM0pjWW3B-w@mail.gmail.com>
References: <20181019230153.28201-1-dbaryshkov@gmail.com>
         <CAKv+Gu8eiFXoC2MWjGUG_AgDNq5rduWQN0CC4Q4BM0pjWW3B-w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181021080742.-1vuM8TOcdhXm4M1EPU5drag23a8TCUYwLVcRMxUo94@z>

On Sun, 2018-10-21 at 09:05 +0200, Ard Biesheuvel wrote:
> (+ James)

Thanks!

> On 20 October 2018 at 01:01, Dmitry Eremin-Solenikov
> <dbaryshkov@gmail.com> wrote:
> > crypto_cfb_decrypt_segment() incorrectly XOR'ed generated keystream
> > with
> > IV, rather than with data stream, resulting in incorrect
> > decryption.
> > Test vectors will be added in the next patch.
> > 
> > Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> > Cc: stable@vger.kernel.org
> > ---
> >  crypto/cfb.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/crypto/cfb.c b/crypto/cfb.c
> > index a0d68c09e1b9..fd4e8500e121 100644
> > --- a/crypto/cfb.c
> > +++ b/crypto/cfb.c
> > @@ -144,7 +144,7 @@ static int crypto_cfb_decrypt_segment(struct
> > skcipher_walk *walk,
> > 
> >         do {
> >                 crypto_cfb_encrypt_one(tfm, iv, dst);
> > -               crypto_xor(dst, iv, bsize);
> > +               crypto_xor(dst, src, bsize);

This does look right.  I think the reason the TPM code works is that it
always does encrypt/decrypt in-place, which is a separate piece of the
code which appears to be correct.

James

