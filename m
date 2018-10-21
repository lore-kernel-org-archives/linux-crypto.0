Return-Path: <SRS0=JV5w=NB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EF53ECDE43
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Oct 2018 08:58:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E187820869
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Oct 2018 08:58:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="V0aKzxkG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E187820869
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbeJURLm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Oct 2018 13:11:42 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:35411 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727095AbeJURLm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Oct 2018 13:11:42 -0400
Received: by mail-it1-f193.google.com with SMTP id p64-v6so9142168itp.0
        for <linux-crypto@vger.kernel.org>; Sun, 21 Oct 2018 01:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=i059F8hY/MMWwqs+DzPZSfqiCYaJceE2NbJ2G1PkiGg=;
        b=V0aKzxkGQYsJX+b+FRrbrPYxIogH1A5PS44HABCt2vyTRqc6yUdOpNZomDK5gLmhXj
         emk2/xX0L8ohVjV3mLt5CiK9+glGq1PjXIit4GD0gXr712NGwZxa0tSBdsFU96ItlCeA
         pClTZyObzicMX1iPaFoDs1DaTEukmdAh6KIZo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=i059F8hY/MMWwqs+DzPZSfqiCYaJceE2NbJ2G1PkiGg=;
        b=Hw0/XcE+nI8L9PM9viPgQ27aYuACgiTU7Z9gHxwkKL1RwhSKMe3PJpfVUdpqs3da9q
         kb8+gxYd9gU11VZfvO9n70ix1kJCdJPdpf9zsjc8NhwKaDCnfZiBPN+Il8v4cbsj+hs5
         goZBh4VazS5+lcHOh5MUMoaIxEjJ7hxoyciQcMo7h2yzjXD7cblrTN92NnSvL5zXT45y
         PM8jjJ7901AlYmwyY4soz5tOxN6frYm4hJnRnH3KaTWUF84A34yClU2M3i39dO54jHww
         uVb4S++ghXR9HiLjePP9v3J9e9xRXnoc+nNO79dOzpmeLVOQxtzTthUJ4mcdI96dqu+r
         ttbg==
X-Gm-Message-State: ABuFfogcNJcFlAjxc7WNhpqOK+KeSOR/Cyr+hUcB1ICnwEQYcPj+nPWP
        Z5KiQVTVVwIYq87i+Jw1Yp5P2oZwhpM+DI42CRc9OA==
X-Google-Smtp-Source: ACcGV63V1MMBKihJyRKGiRCZQWgbFGXdLDcyRIBzU7S7Aj6/wMTGDmLFFEWyWVRBZ/6wqkA6Obhm/zZpXGrWrJE2/OQ=
X-Received: by 2002:a02:5147:: with SMTP id s68-v6mr28847630jaa.62.1540112285078;
 Sun, 21 Oct 2018 01:58:05 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a6b:5910:0:0:0:0:0 with HTTP; Sun, 21 Oct 2018 01:58:04
 -0700 (PDT)
In-Reply-To: <1540109262.3023.6.camel@HansenPartnership.com>
References: <20181019230153.28201-1-dbaryshkov@gmail.com> <CAKv+Gu8eiFXoC2MWjGUG_AgDNq5rduWQN0CC4Q4BM0pjWW3B-w@mail.gmail.com>
 <1540109262.3023.6.camel@HansenPartnership.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sun, 21 Oct 2018 10:58:04 +0200
Message-ID:
 <CAKv+Gu_aUASeSpO4MA0ay2Zko4k6=1avTP4eU-2Ka3YX1-U+Jg@mail.gmail.com>
Subject: Re: [PATCH 1/2] crypto: fix cfb mode decryption
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181021085804.yNYdG9UpN33im2hO8lI2pYloLModwor0f2aWjz69aGs@z>

On 21 October 2018 at 10:07, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Sun, 2018-10-21 at 09:05 +0200, Ard Biesheuvel wrote:
>> (+ James)
>
> Thanks!
>
>> On 20 October 2018 at 01:01, Dmitry Eremin-Solenikov
>> <dbaryshkov@gmail.com> wrote:
>> > crypto_cfb_decrypt_segment() incorrectly XOR'ed generated keystream
>> > with
>> > IV, rather than with data stream, resulting in incorrect
>> > decryption.
>> > Test vectors will be added in the next patch.
>> >
>> > Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
>> > Cc: stable@vger.kernel.org
>> > ---
>> >  crypto/cfb.c | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > diff --git a/crypto/cfb.c b/crypto/cfb.c
>> > index a0d68c09e1b9..fd4e8500e121 100644
>> > --- a/crypto/cfb.c
>> > +++ b/crypto/cfb.c
>> > @@ -144,7 +144,7 @@ static int crypto_cfb_decrypt_segment(struct
>> > skcipher_walk *walk,
>> >
>> >         do {
>> >                 crypto_cfb_encrypt_one(tfm, iv, dst);
>> > -               crypto_xor(dst, iv, bsize);
>> > +               crypto_xor(dst, src, bsize);
>
> This does look right.  I think the reason the TPM code works is that it
> always does encrypt/decrypt in-place, which is a separate piece of the
> code which appears to be correct.
>

Yeah I figured that.

So where is the TPM code that actually uses this code?
