Return-Path: <SRS0=JV5w=NB=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42466 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726980AbeJUROQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Oct 2018 13:14:16 -0400
In-Reply-To: <CAKv+Gu_aUASeSpO4MA0ay2Zko4k6=1avTP4eU-2Ka3YX1-U+Jg@mail.gmail.com>
References: <20181019230153.28201-1-dbaryshkov@gmail.com> <CAKv+Gu8eiFXoC2MWjGUG_AgDNq5rduWQN0CC4Q4BM0pjWW3B-w@mail.gmail.com> <1540109262.3023.6.camel@HansenPartnership.com> <CAKv+Gu_aUASeSpO4MA0ay2Zko4k6=1avTP4eU-2Ka3YX1-U+Jg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 1/2] crypto: fix cfb mode decryption
From: James Bottomley <James.Bottomley@Hansenpartnership.com>
Date: Sun, 21 Oct 2018 10:00:10 +0100
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable <stable@vger.kernel.org>
Message-ID: <dd71f78f-5773-4996-b319-68e7fb78c514@email.android.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

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
