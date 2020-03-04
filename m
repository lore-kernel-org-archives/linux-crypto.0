Return-Path: <SRS0=WWUc=4V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC36EC3F2D1
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Mar 2020 13:49:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC0E22166E
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Mar 2020 13:49:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="aSsRYRkm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729461AbgCDNtB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Mar 2020 08:49:01 -0500
Received: from mail-vk1-f196.google.com ([209.85.221.196]:41055 "EHLO
        mail-vk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729138AbgCDNtB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Mar 2020 08:49:01 -0500
Received: by mail-vk1-f196.google.com with SMTP id y201so557163vky.8
        for <linux-crypto@vger.kernel.org>; Wed, 04 Mar 2020 05:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bjIqzNtbLDluldH86tN+A6cKSOXYcpHj7iqgrGX2u9Q=;
        b=aSsRYRkml7xmSJkdReWG+LtFzO6SXXltkxNfsYYs8jeMD708jVuf1k9ZkSSte1WuHG
         rYuYZmkxP9ekNsF12Owz3OWcL2Nd1QktjKQjojrgO4Vikc/jLRW7W2tIRzWwaxnW+/1m
         BpIfhfPHagu2E5rdF8wB766Ci+1Zz8uVuM72JXxWIpxZ7qhpWLXIlof66jaTX1USvmZ8
         VQ5L2hOmvqtOFStjMcl4skOdrZZtlpY1yxx90ROu9SnDj1AuBkqRjVKBNtRPMDffPFof
         Xw9rbl7buYnsYnShnDsJfa7gMaYK8Xh3v/SeTyUPV2GufdCh+1OwIxjNg3AlTKXNZJrp
         HtEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bjIqzNtbLDluldH86tN+A6cKSOXYcpHj7iqgrGX2u9Q=;
        b=aK5GOQ6i7ajJ1yfRS8iZCzGJGT97GVchcWQXZ/Tdg899PfDQwB1uRMS/3v6fH1uUvh
         DlUWYdtUfXfALY4Oq2eMAhOrolkuBl9BK7M9MQiGybt/iqur0yolZdkaKs0IYNARnWpX
         l0pNEAKk6uKv8o+4i85TbaVbaVrhXO1nmMtIg1k9pEnq8mftNjJIXgad+IyRO3zqIsF1
         5mhibespYFULRXPcLlaNSKutcSvei6prW19qR6G8oVoHv+Xcl/L5d/ZaaIX6eBhbhBrd
         LcQ4ZUVz3UC+Di1cUCYaYZLZyE15dHRGyBfRAkNCVQdo4/ZJ3Q6ozIIa5gWlBv4mqwdZ
         I22Q==
X-Gm-Message-State: ANhLgQ1VL8dw8ySF62n1Rzn67p67JPY+X2EE2q4YmV+pcCCBl0msZOrZ
        qg3r5EAX3xzx0FFMBgnoFpFzn2YZ4XZoyjDcdFjFqg==
X-Google-Smtp-Source: ADFU+vvoF/S1C8h9A5Im5xw4Vs7/0s0k+y8QNSIVSeSdg+S7j85qxtjIEaRVsjzMAeYPqqLTGrERlOWGKgHn2FWDNGg=
X-Received: by 2002:a1f:5e17:: with SMTP id s23mr572459vkb.100.1583329738480;
 Wed, 04 Mar 2020 05:48:58 -0800 (PST)
MIME-Version: 1.0
References: <20200303120925.12067-1-gilad@benyossef.com> <20200304000606.GB89804@sol.localdomain>
In-Reply-To: <20200304000606.GB89804@sol.localdomain>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Wed, 4 Mar 2020 15:48:47 +0200
Message-ID: <CAOtvUMd6Ak3n-ABO1h440BoDASJUvh+-9PwEGFi-WzA=g84kLg@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: testmgr - sync both RFC4106 IV copies
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On Wed, Mar 4, 2020 at 2:06 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Tue, Mar 03, 2020 at 02:09:25PM +0200, Gilad Ben-Yossef wrote:
> > RFC4106 AEAD ciphers the AAD is the concatenation of associated
> > authentication data || IV || plaintext or ciphertext but the
> > random AEAD message generation in testmgr extended tests did
> > not obey this requirements producing messages with undefined
> > behaviours. Fix it by syncing the copies if needed.
> >
> > Since this only relevant for developer only extended tests any
> > additional cycles/run time costs are negligible.
> >
> > This fixes extended AEAD test failures with the ccree driver
> > caused by illegal input.
> >
> > Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> > Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > Cc: Eric Biggers <ebiggers@kernel.org>
> > ---
> >
> >  crypto/testmgr.c | 35 ++++++++++++++++++++++++++---------
> >  1 file changed, 26 insertions(+), 9 deletions(-)
> >
> > diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> > index 88f33c0efb23..379bd1c7dd5b 100644
> > --- a/crypto/testmgr.c
> > +++ b/crypto/testmgr.c
> > @@ -91,10 +91,16 @@ struct aead_test_suite {
> >       unsigned int einval_allowed : 1;
> >
> >       /*
> > -      * Set if the algorithm intentionally ignores the last 8 bytes of the
> > -      * AAD buffer during decryption.
> > +      * Set if the algorithm includes a copy of the IV (last 8 bytes)
> > +      * in the AAD buffer but does not include it in calculating the ICV
> >        */
> > -     unsigned int esp_aad : 1;
> > +     unsigned int skip_aad_iv : 1;
>
> "Authentication tag" would be easier to understand than "ICV" and would match
> the rest of the code.  "ICV" is an idiosyncrasy used in certain RFCs only.

Sure.

>
> > +
> > +     /*
> > +      * Set if the algorithm includes a copy of the IV (last 8 bytes)
> > +      * in the AAD buffer and does include it when calculating the ICV
> > +      */
> > +     unsigned int auth_aad_iv : 1;
> >  };
> >
> >  struct cipher_test_suite {
> > @@ -2167,14 +2173,20 @@ struct aead_extra_tests_ctx {
> >   * here means the full ciphertext including the authentication tag.  The
> >   * authentication tag (and hence also the ciphertext) is assumed to be nonempty.
> >   */
> > -static void mutate_aead_message(struct aead_testvec *vec, bool esp_aad)
> > +static void mutate_aead_message(struct aead_testvec *vec,
> > +                             const struct aead_test_suite *suite)
> >  {
> > -     const unsigned int aad_tail_size = esp_aad ? 8 : 0;
> > +     const unsigned int aad_ivsize = 8;
>
> We should use the algorithm's actual IV size instead of hard-coding 8 bytes.

Yes, I was following the original code example but I agree it would be
better to pass the IV size.

>
> > +     const unsigned int aad_tail_size = suite->skip_aad_iv ? aad_ivsize : 0;
> >       const unsigned int authsize = vec->clen - vec->plen;
> >
> >       if (prandom_u32() % 2 == 0 && vec->alen > aad_tail_size) {
> >                /* Mutate the AAD */
> >               flip_random_bit((u8 *)vec->assoc, vec->alen - aad_tail_size);
> > +             if (suite->auth_aad_iv)
> > +                     memcpy((u8 *)vec->iv,
> > +                            (vec->assoc + vec->alen - aad_ivsize),
> > +                            aad_ivsize);
>
> Why sync the IV copies here?  When 'auth_aad_iv', we assume the copy of the IV
> in the AAD (which was just corrupted) is authenticated.  So we already know that
> decryption should fail, regardless of the other IV copy.

Nope. We know there needs to be a copy of the IV in the AAD and we know the IV
should be included in calculating in the authentication tag. We don't know which
copy of the IV will be used by the implementation.

Case in point - the ccree driver actually currently uses the copy of
the IV passed via
req->iv for calculating the IV contribution to the authentication tag,
not the one in the AAD.

And what happens then if you don't do this copy than is that you get
an unexpected
decryption success where the test expects failure, because the driver
fed the HW the
none mutated copy of the IV from req->iv and not the mutated copy
found in the AAD.

> Also, the code doesn't currently mutate vec->iv for any AEAD.  So mutating it
> for one specific algorithm is a bit odd.  IMO, it would make more sense to do a
> separate patch later that mutates vec->iv for all AEADs.

That's fine, in that case we should avoid mutating either copies of
the IV at all
in the case of RFC 4543 just as we do with RFC 4106 and friends - as
indeed your patch
does.

> >               if (prandom_u32() % 2 == 0)
> >                       return;
> >       }
> > @@ -2208,6 +2220,10 @@ static void generate_aead_message(struct aead_request *req,
> >       /* Generate the AAD. */
> >       generate_random_bytes((u8 *)vec->assoc, vec->alen);
> >
> > +     if (suite->auth_aad_iv && (vec->alen > ivsize))
> > +             memcpy(((u8 *)vec->assoc + vec->alen - ivsize), vec->iv,
> > +                    ivsize);
>
> Shouldn't this be >= ivsize, not > ivsize?
Indeed.

> And doesn't the IV need to be synced
> in both the skip_aad_iv and auth_aad_iv cases?

Nope, because in the skip_aad_iv case we never mutate the IV, so no
point in copying.

>
> There are also unnecessary parentheses here; the memcpy() could be one line.
>
>
> How about the following patch instead?

Works for me.

Tested-by: Gilad Ben-Yossef <gilad@benyossef.com?

Thanks!
Gilad
