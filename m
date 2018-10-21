Return-Path: <SRS0=JV5w=NB=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-it1-f193.google.com ([209.85.166.193]:35411 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727095AbeJURLm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Oct 2018 13:11:42 -0400
Received: by mail-it1-f193.google.com with SMTP id p64-v6so9142168itp.0
        for <linux-crypto@vger.kernel.org>; Sun, 21 Oct 2018 01:58:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1540109262.3023.6.camel@HansenPartnership.com>
References: <20181019230153.28201-1-dbaryshkov@gmail.com> <CAKv+Gu8eiFXoC2MWjGUG_AgDNq5rduWQN0CC4Q4BM0pjWW3B-w@mail.gmail.com>
 <1540109262.3023.6.camel@HansenPartnership.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Sun, 21 Oct 2018 10:58:04 +0200
Message-ID: <CAKv+Gu_aUASeSpO4MA0ay2Zko4k6=1avTP4eU-2Ka3YX1-U+Jg@mail.gmail.com>
Subject: Re: [PATCH 1/2] crypto: fix cfb mode decryption
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

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
