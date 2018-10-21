Return-Path: <SRS0=JV5w=NB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61A0FECDE43
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Oct 2018 09:00:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2719D2064A
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Oct 2018 09:00:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="ohAweHj+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2719D2064A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=Hansenpartnership.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbeJUROQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Oct 2018 13:14:16 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42466 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726980AbeJUROQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Oct 2018 13:14:16 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 112368EE27E;
        Sun, 21 Oct 2018 02:00:39 -0700 (PDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id uWgjkrLaYI2F; Sun, 21 Oct 2018 02:00:38 -0700 (PDT)
Received: from [100.93.245.118] (94.197.121.245.threembb.co.uk [94.197.121.245])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id ECA5E8EE02B;
        Sun, 21 Oct 2018 02:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1540112438;
        bh=vOlYy2UkwyfN/ijysl8aMmieiumAjq4a6ea7fCHLWas=;
        h=In-Reply-To:References:Subject:From:Date:To:CC:From;
        b=ohAweHj+0oOxdhZu+q7tp1LB0u/+ZREeAFY9tTiEsEDi0RjdkE4pDY70+aiAw9N4Y
         ORlXYHfkIdZGUF+svtcb+4+V9Y76ilhGPA7egjhz+7u5U6c2CR0fX5UtKj73gejdPj
         TaHcpNWpCS3PLBe47gXZmoHYj0F0KeqaQaF4/+sY=
User-Agent: K-9 Mail for Android
In-Reply-To: <CAKv+Gu_aUASeSpO4MA0ay2Zko4k6=1avTP4eU-2Ka3YX1-U+Jg@mail.gmail.com>
References: <20181019230153.28201-1-dbaryshkov@gmail.com> <CAKv+Gu8eiFXoC2MWjGUG_AgDNq5rduWQN0CC4Q4BM0pjWW3B-w@mail.gmail.com> <1540109262.3023.6.camel@HansenPartnership.com> <CAKv+Gu_aUASeSpO4MA0ay2Zko4k6=1avTP4eU-2Ka3YX1-U+Jg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [PATCH 1/2] crypto: fix cfb mode decryption
From:   James Bottomley <James.Bottomley@Hansenpartnership.com>
Date:   Sun, 21 Oct 2018 10:00:10 +0100
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable <stable@vger.kernel.org>
Message-ID: <dd71f78f-5773-4996-b319-68e7fb78c514@email.android.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181021090010.sjL3AmUCPPuwY2b6ImaFB152wg2pIQjc3jAzu9JbS04@z>

On October 21, 2018 9:58:04 AM GMT, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>On 21 October 2018 at 10:07, James Bottomley
><James.Bottomley@hansenpartnership.com> wrote:
>> On Sun, 2018-10-21 at 09:05 +0200, Ard Biesheuvel wrote:
>>> (+ James)
>>
>> Thanks!
>>
>>> On 20 October 2018 at 01:01, Dmitry Eremin-Solenikov
>>> <dbaryshkov@gmail.com> wrote:
>>> > crypto_cfb_decrypt_segment() incorrectly XOR'ed generated
>keystream
>>> > with
>>> > IV, rather than with data stream, resulting in incorrect
>>> > decryption.
>>> > Test vectors will be added in the next patch.
>>> >
>>> > Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
>>> > Cc: stable@vger.kernel.org
>>> > ---
>>> >  crypto/cfb.c | 2 +-
>>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>>> >
>>> > diff --git a/crypto/cfb.c b/crypto/cfb.c
>>> > index a0d68c09e1b9..fd4e8500e121 100644
>>> > --- a/crypto/cfb.c
>>> > +++ b/crypto/cfb.c
>>> > @@ -144,7 +144,7 @@ static int crypto_cfb_decrypt_segment(struct
>>> > skcipher_walk *walk,
>>> >
>>> >         do {
>>> >                 crypto_cfb_encrypt_one(tfm, iv, dst);
>>> > -               crypto_xor(dst, iv, bsize);
>>> > +               crypto_xor(dst, src, bsize);
>>
>> This does look right.  I think the reason the TPM code works is that
>it
>> always does encrypt/decrypt in-place, which is a separate piece of
>the
>> code which appears to be correct.
>>
>
>Yeah I figured that.
>
>So where is the TPM code that actually uses this code?

It was posted to the integrity list a while ago.  I'm planning a repost  shortly.

James


-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
