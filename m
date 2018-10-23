Return-Path: <SRS0=BLQr=ND=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10E65C67863
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Oct 2018 10:40:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7E7A20652
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Oct 2018 10:40:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="jRmlsPlM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C7E7A20652
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbeJWTD2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Oct 2018 15:03:28 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:39764 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727757AbeJWTD2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Oct 2018 15:03:28 -0400
Received: by mail-it1-f193.google.com with SMTP id m15so1423161itl.4
        for <linux-crypto@vger.kernel.org>; Tue, 23 Oct 2018 03:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=umVJRm+Q8LyQ43wRvgLS7GmIknwhy36zd2FIlxnBkSQ=;
        b=jRmlsPlMqiVzjkb0tVI9qGV4p4VddLjWwnIfzQLhiZjN1SQtgOXI1UUi4/Bwkqwt+x
         SkvrECsjUkDQUTs7CP//73FG9XMj7eLXSdMcSUjjk3ff7mPgOPWniPgT0nPabFGMZaMd
         LafKZOaBCx8XlF1gxrZxGgwPAsWxAqa4baCWg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=umVJRm+Q8LyQ43wRvgLS7GmIknwhy36zd2FIlxnBkSQ=;
        b=DfSJ2V+ekEaMiIqzI0KtKWf1HHLxr27Dw2J3soAxtL/nUm8OAxn4j8eUQ0DqSXBdbU
         nszUHZd7VXSr9WVi8q+ntUK7T9qqzGcN7AHxCTSVOpMXWYl5b4SrnINlmYVdSQTcju9M
         lNYxf5fT2j4cmt2xnNYcJPcpGXYyyMgFhGMg+HcLmtcMQq+XSDKZ4S42ehzf/9VJLSvY
         WSEtOmNgaiF/6WTexHnvsNmDPD/mzUhTxkUi4rMVHTYo9D9H/KxSCK+5elG7U+Z+bDT3
         SToLzFoqR3YGYXsmxjUD/oTZ5Q4FguWR4ojvL1D/3DnumoPICvXp3irkNWMcIGFTZG4H
         FQhA==
X-Gm-Message-State: ABuFfoiEvFVy7fFBJmyu/b2tGFVgjTkTAeYS1yFYJmB/SrvI3ykRbeue
        rY22O15cvXA9GmaRByuG4CvRz0bBzJxDjO/Yftt7HQ==
X-Google-Smtp-Source: ACcGV61mlKSnCfm9NA6BH3hPIrvyvN3u/GTL93HVlTAhpRtz0tdlSjLKRSwCERDLEGCJxwb1AD5y8FgYaKyhO5l4k0s=
X-Received: by 2002:a05:660c:383:: with SMTP id x3mr10843540itj.121.1540291235318;
 Tue, 23 Oct 2018 03:40:35 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a6b:5910:0:0:0:0:0 with HTTP; Tue, 23 Oct 2018 03:40:34
 -0700 (PDT)
In-Reply-To: <20181020071206.GE876@sol.localdomain>
References: <20181015175424.97147-1-ebiggers@kernel.org> <20181015175424.97147-12-ebiggers@kernel.org>
 <CAKv+Gu9wrOOk-LGPYmxgLbv86uXzMeHN6th3mMEDT3Vg893HWw@mail.gmail.com> <20181020071206.GE876@sol.localdomain>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 23 Oct 2018 07:40:34 -0300
Message-ID:
 <CAKv+Gu9zBKK7ughbBAKkHdfgX2KrBXkF6MhH3xrSdLegrjjYJQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 11/12] crypto: adiantum - add Adiantum support
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Paul Crowley <paulcrowley@google.com>,
        Greg Kaiser <gkaiser@google.com>,
        Michael Halcrow <mhalcrow@google.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <samuel.c.p.neves@gmail.com>,
        Tomer Ashur <tomer.ashur@esat.kuleuven.be>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181023104034.d0LNF0P8Mj4pIbRW4D5hI_exz8g0XgrWbMiWiOSh5RE@z>

On 20 October 2018 at 15:12, Eric Biggers <ebiggers@kernel.org> wrote:
> Hi Ard,
>
> On Sat, Oct 20, 2018 at 12:17:58PM +0800, Ard Biesheuvel wrote:
>> On 16 October 2018 at 01:54, Eric Biggers <ebiggers@kernel.org> wrote:
>> > From: Eric Biggers <ebiggers@google.com>
>> >
>> > Add support for the Adiantum encryption mode.  Adiantum was designed b=
y
>> > Paul Crowley and is specified by our paper:
>> >
>> >     Adiantum: length-preserving encryption for entry-level processors
>> >     (https://eprint.iacr.org/2018/720.pdf)
>> >
>> > See our paper for full details; this patch only provides an overview.
>> >
>> > Adiantum is a tweakable, length-preserving encryption mode designed fo=
r
>> > fast and secure disk encryption, especially on CPUs without dedicated
>> > crypto instructions.  Adiantum encrypts each sector using the XChaCha1=
2
>> > stream cipher, two passes of an =CE=B5-almost-=E2=88=86-universal (=CE=
=B5A=E2=88=86U) hash
>> > function, and an invocation of the AES-256 block cipher on a single
>> > 16-byte block.  On CPUs without AES instructions, Adiantum is much
>> > faster than AES-XTS; for example, on ARM Cortex-A7, on 4096-byte secto=
rs
>> > Adiantum encryption is about 4 times faster than AES-256-XTS encryptio=
n,
>> > and decryption about 5 times faster.
>> >
>> > Adiantum is a specialization of the more general HBSH construction.  O=
ur
>> > earlier proposal, HPolyC, was also a HBSH specialization, but it used =
a
>> > different =CE=B5A=E2=88=86U hash function, one based on Poly1305 only.=
  Adiantum's
>> > =CE=B5A=E2=88=86U hash function, which is based primarily on the "NH" =
hash function
>> > like that used in UMAC (RFC4418), is about twice as fast as HPolyC's;
>> > consequently, Adiantum is about 20% faster than HPolyC.
>> >
>> > This speed comes with no loss of security: Adiantum is provably just a=
s
>> > secure as HPolyC, in fact slightly *more* secure.  Like HPolyC,
>> > Adiantum's security is reducible to that of XChaCha12 and AES-256,
>> > subject to a security bound.  XChaCha12 itself has a security reductio=
n
>> > to ChaCha12.  Therefore, one need not "trust" Adiantum; one need only
>> > trust ChaCha12 and AES-256.  Note that the =CE=B5A=E2=88=86U hash func=
tion is only
>> > used for its proven combinatorical properties so cannot be "broken".
>> >
>>
>> So what happens if the part of the input covered by the block cipher
>> is identical between different generations of the same disk block
>> (whose sector count is used as the 'outer' IV). How are we not in the
>> same boat as before when using stream ciphers for disk encryption?
>>
>
> This is the point of the hash step.  The value encrypted with the block c=
ipher
> to produce the intermediate value C_M (used as the stream cipher nonce) i=
s
> H(T, P_L) + P_R.  (T is the tweak a.k.a the IV, P_L is the plaintext exce=
pt the
> last 16 bytes, P_R is the last 16 bytes.)  A collision in this value occu=
rs iff:
>
>         H(T1, P1_L) + P1_R =3D H(T2, P2_L) + P2_R
> i.e.
>         H(T1, P1_L) - H(T2, P2_L) =3D P2_R - P1_R
>
> If (T1, P1_L) =3D (T2, P2_L) then P1_R !=3D P2_R so the equation has no s=
olutions
> (since we don't consider queries where the whole input is the same; those
> unavoidably produce the same ciphertext).  Otherwise (T1, P1_L) !=3D (T2,=
 P2_L),
> and since the hash function H is =CE=B5-almost-=E2=88=86-universal over i=
ntegers mod 2^128,
> the equation is true for at most a very small proportion '=CE=B5' of hash=
 keys.
> But, the hash key is chosen at random and is unknown to the attacker.
>
> The same applies in the other direction, for chosen ciphertext attacks.
>
> Basically, it's very difficult for an attacker to cause the intermediate =
value
> C_M to be reused, and the outputs will appear random until they do.
>
> Of course, all this is explained much more precisely and comprehensively =
in our
> paper.  See section 5, "Security reduction".
>

Thanks for the explanation. I saw that the result of the AES
encryption was used as the XChaCha nonce, but I failed to spot that
the result of the nhpoly1305 pass is added/subtracted to/from that
particular block first.

In any case, this looks good to me: as far as I can tell, the code
implements the algorithm as described in the paper, and the plumbing
into the crypto API looks correct to me as well.

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Whether the paper is correct is a different matter: it looks
convincing to me but IANAC.

The only request I have is to add a speed test to tcrypt as well so we
can easily benchmark it.
