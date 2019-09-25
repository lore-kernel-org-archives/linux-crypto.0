Return-Path: <SRS0=gkGi=XU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4C75C432C2
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Sep 2019 22:15:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7EA021D7A
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Sep 2019 22:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569449756;
	bh=3rLFjLJPqWnlbntXrCBPePflpci/jn1S+U0qjkb9Ojc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=tgUWt4wSh59sXSZ4JMsSSHy9L68qa0gijjwtxZPg4bnfW8sX86xlcuZI/rbB7qtXJ
	 EWJ5Lf7gvNBnksfObzXqtqnW/BUi1o5na6SkNCesiO0J0+K8JC72ydYFNjuqSwDFiz
	 INztNI5btJRxd4X4rhTzxJNsBdNmELKjfDOqnUKk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729023AbfIYWPz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Sep 2019 18:15:55 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42170 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729015AbfIYWPz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Sep 2019 18:15:55 -0400
Received: by mail-lj1-f196.google.com with SMTP id y23so7489lje.9
        for <linux-crypto@vger.kernel.org>; Wed, 25 Sep 2019 15:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q6rnzFynrN+pSeGnR7/tGRjyet/+hxqle5CmHd7xYJk=;
        b=HxnimenHWTMNeNCGuD7LMOv0S2WRtXkK1gwrLqAj5ojqup2bH3tBj26KVIAaMSJ16I
         oqDYp/UgKk7dHAiRP7RP+4QaK5+DYzCzBK89mV562txZaDl/x2geGE/NEyOB2XBNx9RR
         D/nQagUEh8NbBSmaHcL5Cz24qvBwP16UT7LdE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q6rnzFynrN+pSeGnR7/tGRjyet/+hxqle5CmHd7xYJk=;
        b=swulfLDPqVHT8bulg0o/DBH0s9ePeZMHLDVAkoXEbAoqfusedEdqWq+3S4MM36r62N
         rqVzLjmr1PNBZaYFHgXp832KqV2zeP2Hiaq213GiPTG0WKnPYPNC6zA9KuYg4Lk0fBfa
         NrL2Pl5O2TPXWQmNbA6mbvBHnxoVek/48PwticK/nLLphTSPHYufBtmR04xnj/h7cTfQ
         xFfhZSmiTrKLGSKR3aWFMKCVrfW2dQd/DBWbTWooxsdDCIV0j2c0iqOj/1eCgcQ/w0Z+
         JBxMTcMOHpTLqRZQHeEDY+/ArBZeB+tPzhkIfvnWtFO+O2A1dhHmtmlyRnNT5+c78hTw
         aQzw==
X-Gm-Message-State: APjAAAUdZTAj4IRCtXZ4dFtlEMpiPH18iDqvlCSEH8KN7yLx7CjUJuIo
        xHlk//xOmuynAZpdJTkv4swukv1mE1o=
X-Google-Smtp-Source: APXvYqx0OLySuW4kYCUwK3NqvWwvYX2/WcAlXB1Ybg5AfRvcX6eu1j0rQvzEqCQGp0UXZNjEbU0nhw==
X-Received: by 2002:a2e:1614:: with SMTP id w20mr331060ljd.159.1569449751655;
        Wed, 25 Sep 2019 15:15:51 -0700 (PDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id g10sm69494lfb.76.2019.09.25.15.15.50
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2019 15:15:50 -0700 (PDT)
Received: by mail-lf1-f49.google.com with SMTP id r22so165985lfm.1
        for <linux-crypto@vger.kernel.org>; Wed, 25 Sep 2019 15:15:50 -0700 (PDT)
X-Received: by 2002:a19:7d55:: with SMTP id y82mr159667lfc.106.1569449749917;
 Wed, 25 Sep 2019 15:15:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org> <20190925161255.1871-19-ard.biesheuvel@linaro.org>
In-Reply-To: <20190925161255.1871-19-ard.biesheuvel@linaro.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 25 Sep 2019 15:15:34 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjYsbxSiV_XKWV3BwGvau_hUvQiQHLOoc7vLUZt0Wqzfw@mail.gmail.com>
Message-ID: <CAHk-=wjYsbxSiV_XKWV3BwGvau_hUvQiQHLOoc7vLUZt0Wqzfw@mail.gmail.com>
Subject: Re: [RFC PATCH 18/18] net: wireguard - switch to crypto API for
 packet encryption
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 25, 2019 at 9:14 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> Replace the chacha20poly1305() library calls with invocations of the
> RFC7539 AEAD, as implemented by the generic chacha20poly1305 template.

Honestly, the other patches look fine to me from what I've seen (with
the small note I had in a separate email for 11/18), but this one I
consider just nasty, and a prime example of why people hate those
crypto lookup routines.

Some of it is just the fundamental and pointless silly indirection,
that just makes things harder to read, less efficient, and less
straightforward.

That's exemplified by this part of the patch:

>  struct noise_symmetric_key {
> -       u8 key[NOISE_SYMMETRIC_KEY_LEN];
> +       struct crypto_aead *tfm;

which is just one of those "we know what we want and we just want to
use it directly" things, and then the crypto indirection comes along
and makes that simple inline allocation of a small constant size
(afaik it is CHACHA20POLY1305_KEY_SIZE, which is 32) be another
allocation entirely.

And it's some random odd non-typed thing too, so then you have that
silly and stupid dynamic allocation using a name lookup:

   crypto_alloc_aead("rfc7539(chacha20,poly1305)", 0, CRYPTO_ALG_ASYNC);

to create what used to be (and should be) a simple allocation that was
has a static type and was just part of the code.

It also ends up doing other bad things, ie that packet-time

+       if (unlikely(crypto_aead_reqsize(key->tfm) > 0)) {
+               req = aead_request_alloc(key->tfm, GFP_ATOMIC);
+               if (!req)
+                       return false;

thing that hopefully _is_ unlikely, but that's just more potential
breakage from that whole async crypto interface.

This is what people do *not* want to do, and why people often don't
like the crypto interfaces.

It's exactly why we then have those "bare" routines as a library where
people just want to access the low-level hashing or whatever directly.

So please don't do things like this for an initial import.

Leave the thing alone, and just use the direct and synchronous static
crypto library interface tjhat you imported in patch 14/18 (but see
below about the incomplete import).

Now, later on, if you can *show* that some async implementation really
really helps, and you have numbers for it, and you can convince people
that the above kind of indirection is _worth_ it, then that's a second
phase. But don't make code uglier without those actual numbers.

Because it's not just uglier and has that silly extra indirection and
potential allocation problems, this part just looks very fragile
indeed:

> The nonce related changes are there to address the mismatch between the
> 96-bit nonce (aka IV) that the rfc7539() template expects, and the 64-bit
> nonce that WireGuard uses.
...
>  struct packet_cb {
> -       u64 nonce;
> -       struct noise_keypair *keypair;
>         atomic_t state;
> +       __le32 ivpad;                   /* pad 64-bit nonce to 96 bits */
> +       __le64 nonce;
> +       struct noise_keypair *keypair;
>         u32 mtu;
>         u8 ds;
>  };

The above is subtle and silently depends on the struct layout.

It really really shouldn't.

Can it be acceptable doing something like that? Yeah, but you really
should be making it very explicit, perhaps using

  struct {
        __le32 ivpad;
        __le64 nonce;
   } __packed;

or something like that.

Because right now you're depending on particular layout of those fields:

> +       aead_request_set_crypt(req, sg, sg, skb->len,
> +                              (u8 *)&PACKET_CB(skb)->ivpad);

but honestly, that's not ok at all.

Somebody makes a slight change to that struct, and it might continue
to work fine on x86-32 (where 64-bit values are only 32-bit aligned)
but subtly break on other architectures.

Also, you changed how the nonce works from being in CPU byte order to
be explicitly LE. That may be ok, and looks like it might be a
cleanup, but honestly I think it should have been done as a separate
patch.

So could you please update that patch 14/18 to also have that
synchronous chacha20poly1305_decrypt_sg() interface, and then just
drop this 18/18 for now?

That would mean that

 (a) you wouldn't need this patch, and you can then do that as a
separate second phase once you have numbers and it can stand on its
own.

 (b) you'd actually have something that *builds* when  you import the
main wireguard patch in 15/18

because right now it looks like you're not only forcing this async
interface with the unnecessary indirection, you're also basically
having a tree that doesn't even build or work for a couple of commits.

And I'm still not convinced (a) ever makes sense - the overhead of any
accelerator is just high enought that I doubt you'll have numbers -
performance _or_ power.

But even if you're right that it might be a power advantage on some
platform, that wouldn't make it an advantage on other platforms. Maybe
it could be done as a config option where you can opt in to the async
interface when that makes sense - but not force the indirection and
extra allocations when it doesn't. As a separate patch, something like
that doesn't sound horrendous (and I think that's also an argument for
doing that CPU->LE change as an independent change).

Yes, yes, there's also that 17/18 that switches over to a different
header file location and Kconfig names but that could easily be folded
into 15/18 and then it would all be bisectable.

Alternatively, maybe 15/18 could be done with wireguard disabled in
the Kconfig (just to make the patch identical), and then 17/18 enables
it when it compiles with a big note about how you wanted to keep 15/18
pristine to make the changes obvious.

Hmm?

I don't really have a dog in this fight, but on the whole I really
liked the series. But this 18/18 raised my heckles, and I think I
understand why it might raise the heckles of the wireguard people.

Please?

     Linus
