Return-Path: <SRS0=JV5w=NB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 420D1ECDE3D
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Oct 2018 09:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 021112083E
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Oct 2018 09:07:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="k03q5GZK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 021112083E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbeJURVL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Oct 2018 13:21:11 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:50823 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727363AbeJURVL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Oct 2018 13:21:11 -0400
Received: by mail-it1-f195.google.com with SMTP id k206-v6so8785362ite.0
        for <linux-crypto@vger.kernel.org>; Sun, 21 Oct 2018 02:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=SmRZi9EzEiqpxJ/Wv0hqJ87C1AX22S7/oLDsuIjPALI=;
        b=k03q5GZKrG+EHWOj4LbwC+AcKYiXa+ufSFGKeUEsFo1H8WvPob1sGr9J+MunV6bBYq
         MfZw47k8FB9PIMhi4+BFLmv+pkTIXR6VGA+XPoSDwIlr1yauzlPDU2X4yK0dFPWKUBy2
         hpKynoPR2oIDT4jULgos9R3qhNkRjjaPR+7Fs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=SmRZi9EzEiqpxJ/Wv0hqJ87C1AX22S7/oLDsuIjPALI=;
        b=bfir4u+Wjn/eMOb/LtZFV5t5yO8/Wve3IWCBdh4WoZafpFopO1TD2YfjfFSXMrWk1B
         6b0IjRoZP9CrWxTqSDP3sqlDvg7Ew134A27UukpjX17Pb8fBBR+l37BHoJ1cG+EX1yLu
         EN1O1Ieytly170YQVCPRtW3iI8LCwSOhvqiltsWkJdGmLaz62gBdSSd3npBmA0Ng7bDX
         6QWi30hMyhHgLTj9vOMDAgUTxJd0nvbJaksE2j/GbDWP6K36R04PcxeWfBblo+EWMkCN
         EMX2TBMKRZWbjSFJsgiDXEFqXM4eu2P849YuXWn3/B1/4eciwre2SjvByP/d0g8YR+bu
         t0OA==
X-Gm-Message-State: ABuFfoi+5yGTi1QlwewjkXav9nRDY//izMr2Za/bgpU65F5HUT7MajPC
        8954hCA0DqZlD3l2x3YMELC2oGvvrOZ6LzkXok1ZRA==
X-Google-Smtp-Source: ACcGV60UY08U7uxhXpa7ng8M7yHIxIxgeE8647qGqCn168j3XYOgSx4kWUtmZRu8IPXKIiaXgksy2MXMnRgF01Ox6qg=
X-Received: by 2002:a24:e08f:: with SMTP id c137-v6mr7393241ith.71.1540112852784;
 Sun, 21 Oct 2018 02:07:32 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a6b:5910:0:0:0:0:0 with HTTP; Sun, 21 Oct 2018 02:07:32
 -0700 (PDT)
In-Reply-To: <dd71f78f-5773-4996-b319-68e7fb78c514@email.android.com>
References: <20181019230153.28201-1-dbaryshkov@gmail.com> <CAKv+Gu8eiFXoC2MWjGUG_AgDNq5rduWQN0CC4Q4BM0pjWW3B-w@mail.gmail.com>
 <1540109262.3023.6.camel@HansenPartnership.com> <CAKv+Gu_aUASeSpO4MA0ay2Zko4k6=1avTP4eU-2Ka3YX1-U+Jg@mail.gmail.com>
 <dd71f78f-5773-4996-b319-68e7fb78c514@email.android.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sun, 21 Oct 2018 11:07:32 +0200
Message-ID:
 <CAKv+Gu_982Suidfm5wkX4ruz4Jfxk=BH1RUm6hg+J6BXqM7aDw@mail.gmail.com>
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
Message-ID: <20181021090732.hO0z8BoTo4joMN__0t2YitPw3iqwG5r3SJf7OHEltPs@z>

On 21 October 2018 at 11:00, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On October 21, 2018 9:58:04 AM GMT, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>>On 21 October 2018 at 10:07, James Bottomley
>><James.Bottomley@hansenpartnership.com> wrote:
>>> On Sun, 2018-10-21 at 09:05 +0200, Ard Biesheuvel wrote:
>>>> (+ James)
>>>
>>> Thanks!
>>>
>>>> On 20 October 2018 at 01:01, Dmitry Eremin-Solenikov
>>>> <dbaryshkov@gmail.com> wrote:
>>>> > crypto_cfb_decrypt_segment() incorrectly XOR'ed generated
>>keystream
>>>> > with
>>>> > IV, rather than with data stream, resulting in incorrect
>>>> > decryption.
>>>> > Test vectors will be added in the next patch.
>>>> >
>>>> > Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
>>>> > Cc: stable@vger.kernel.org
>>>> > ---
>>>> >  crypto/cfb.c | 2 +-
>>>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>>>> >
>>>> > diff --git a/crypto/cfb.c b/crypto/cfb.c
>>>> > index a0d68c09e1b9..fd4e8500e121 100644
>>>> > --- a/crypto/cfb.c
>>>> > +++ b/crypto/cfb.c
>>>> > @@ -144,7 +144,7 @@ static int crypto_cfb_decrypt_segment(struct
>>>> > skcipher_walk *walk,
>>>> >
>>>> >         do {
>>>> >                 crypto_cfb_encrypt_one(tfm, iv, dst);
>>>> > -               crypto_xor(dst, iv, bsize);
>>>> > +               crypto_xor(dst, src, bsize);
>>>
>>> This does look right.  I think the reason the TPM code works is that
>>it
>>> always does encrypt/decrypt in-place, which is a separate piece of
>>the
>>> code which appears to be correct.
>>>
>>
>>Yeah I figured that.
>>
>>So where is the TPM code that actually uses this code?
>
> It was posted to the integrity list a while ago.  I'm planning a repost  shortly.
>

OK, found it. Mind cc'ing me on that repost?
