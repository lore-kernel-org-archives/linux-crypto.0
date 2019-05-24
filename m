Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 773EEC072B5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 05:24:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E4002175B
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 05:24:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ttSxMJce"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731853AbfEXFYp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 01:24:45 -0400
Received: from mail-it1-f169.google.com ([209.85.166.169]:51057 "EHLO
        mail-it1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbfEXFYp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 01:24:45 -0400
Received: by mail-it1-f169.google.com with SMTP id a186so3909889itg.0
        for <linux-crypto@vger.kernel.org>; Thu, 23 May 2019 22:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qYKlTun87BB28KFX+J1wKhnCdsCyPYuYD82Ti9tSWvI=;
        b=ttSxMJceRlGZ1zh4SfXTmDEFysv7ChITkRgV1jgowKmQJuoR0LzRVZbYqLP5ViSUmu
         TTb5FkAsTG0kYtKajaa76eQYVb/oAqgV+NGE34SDDvbP46BKd8QUSMF5IA3dlhaEppEV
         l20kKmkpa1QSjpxWR8/eiQOI3+tMMOpf4KMskYatBIn8pe2tAC+iXDs7LiEYqzy7ylUq
         hsNuFSnQBsvgC8Et3FjMgOBvCwfrxggl4sKjYFIYE/f9PAVdRFkV8vxlnJnfW/br6iI6
         5PHFwWUnyFituyKVE8NAgLn9/V+Of8qXU3J1gw9BbKiNAiwTBe8fvnqPZ8B3xwB83g3V
         P6mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qYKlTun87BB28KFX+J1wKhnCdsCyPYuYD82Ti9tSWvI=;
        b=YhmJBD3pAMlefl6kzSaAfN4rB5ff7gVEz9kXkh/N2cTeDnMW6YEKmDJjDmXj6emtOE
         0DSI9DEEQkSECi4eu82O5tNzZR9ajsZckDfySMXeEKIT7RM5poftHO67vDCB0pc98Czk
         hxIBJ2HIvIKw+kq6wYhb6eq/tocwwdS0XwO7Lyn39GbxPizgvfk6gHJqIEwaIhLCH2R1
         5vEYP3P4W9oRw6eaLZfawL8m7eTh9G4xSt6CAbEsO/DVcsy4K32OkbCIFw3aweuZRHps
         failcTjBD9gdIVHTLZQnwxND2oiHdn9aQ0td1B6seMxewSI6EU3uyb4LqSrb6rb1FU83
         pFPg==
X-Gm-Message-State: APjAAAVYgYGxO5J1T7r6K11wDCdUVJtdPLuJR4crcUnqPfOLRTRFVOz6
        9RqCyweni47bhxzaj0EZHU4DgL0wSMpSGZuJxEnMmUVnBhw=
X-Google-Smtp-Source: APXvYqwD243hSGQvCoe8Tf0/2f6Eli55vkpTUSXgYZHTRnZ1eEDkOrAxPnYrp8zmcXPFnVUD+6u0CTC0HwLfHTA6G44=
X-Received: by 2002:a24:910b:: with SMTP id i11mr17629160ite.76.1558675484386;
 Thu, 23 May 2019 22:24:44 -0700 (PDT)
MIME-Version: 1.0
References: <AM6PR09MB3523CED0B1587FCBDE4095A0D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523185833.GA243994@google.com> <AM6PR09MB3523749B0306103E8D2D8315D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523200557.GA248378@gmail.com> <AM6PR09MB3523DB255516D35B595AEA50D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
In-Reply-To: <AM6PR09MB3523DB255516D35B595AEA50D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 24 May 2019 06:24:30 +0100
Message-ID: <CAKv+Gu9F8EcDE8GRSyHFUh_pPXPJDziw7hXO=G4nA31PomDZ1g@mail.gmail.com>
Subject: Re: another testmgr question
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 23 May 2019 at 22:44, Pascal Van Leeuwen
<pvanleeuwen@insidesecure.com> wrote:
>
> > -----Original Message-----
> > From: Eric Biggers [mailto:ebiggers@kernel.org]
> > Sent: Thursday, May 23, 2019 10:06 PM
> > To: Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
> > Cc: linux-crypto@vger.kernel.org
> > Subject: Re: another testmgr question
> >
> > On Thu, May 23, 2019 at 01:07:25PM +0000, Pascal Van Leeuwen wrote:
> > > Eric,
> > >
> > > I'm running into some trouble with some random vectors that do *zero*
> > > length operations. Now you can go all formal about how the API does
> > > not explictly disallow this, but how much sense does it really make
> > > to essentially encrypt, hash or authenticate absolutely *nothing*?
> > >
> > > It makes so little sense that we never bothered to support it in any
> > > of our hardware developed over the past two decades ... and no
> > > customer has ever complained about this, to the best of my knowledge.
> > >
> > > Can't you just remove those zero length tests?
> > >
> >
> > For hashes this is absolutely a valid case.  Try this:
> >
> > $ touch file
> > $ sha256sum file
> > e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855  file
> >
> > That shows the SHA-256 digest of the empty message.
> >
> Valid? A totally fabricated case, if you ask me. Yes, you could do that,
> but is it *useful* at all? Really?

Yes, really. The likelihood of a test vector occurring in practice is
entirely irrelevant. What matters is that the test vectors provide
known outputs for known inputs, and many algorithm specifications
explicitly contain the empty message as one of the documented test
vectors.

In fact, given the above, I am slightly shocked that your hardware
does not handle empty messages correctly. Are you sure it is a
hardware problem and not a driver problem?

In any case, as Eric points out as well, nothing is stopping you from
adding a special case to your driver that falls back to the software
implementation for known broken test cases.

Removing test cases from the set because of broken hardware is out of
the question IMO. It doesn't actually fix the problem, and it may
actually result in breakage, especially for h/w accelerated crypto
exposed to userland, of which we have no idea whatsoever how it is
being used, and whether correct handling of zero length vectors is
likely to break anything or not.

> No, it's not because a file of length 0 is a file of length 0, the length
> in itself is sufficient guarantee of its contents. The hash does not add
> *anything* in this case. It's a constant anyway, the same value for *any*
> zero-length file. It doesn't tell you anything you didn't already know.
> IMHO the tool should just return a message stating "hashing an empty file
> does not make any sense at all ...".
>

You are making assumptions about how the crypto is being used at a
higher level. Eric's example may not make sense to you, but arguing
that *any* use of sha256sum on empty files is guaranteed to be
non-sensical in all imaginable cases is ridiculous.


> >
> > For AEADs it's a valid case too.  You still get an authenticated ciphertext
> > even
> > if the plaintext and/or AAD are empty, telling you that the (plaintext, AAD)
> > pair is authentically from someone with the key.
> >
> Again, you could *theoretically* do that, but I don't know of any *practicle*
> use  case (protocol, application) where you can have *and* 0 length AAD *and*
> 0 length payload (but do correct me when I'm wrong there!)
> In any case, that would result in a value *only* depending on the key (same
> thing applies to zero-length HMAC), which is likely some sort of security
> risk anyway.
>
> As I mentioned before, we made a lot of hashing and authentication hardware
> over the past 20+ years that has never been capable of doing zero-length
> operations and this has *never* proved to be a problem to *anyone*. Not a
> single support question has *ever* been raised on the subject.
>

Again, that is shocking to me, since it means nobody has ever bothered
to run, e.g., the documented SHA-xxx test vectors on them. Weird.

> >
> > It's really only skciphers (length preserving encryption) where it's
> > questionable, since for those an empty input can only map to an empty output.
> >
> True, although that's also the least problematic case to handle.
> Doing nothing at all is not so hard ...
>
> > Regardless of what we do, I think it's really important that the behavior is
> > *consistent*, so users see the same behavior no matter what implementation of
> > the algorithm is used.
> >
> Consistency should only be required for *legal* ranges of input parameters.
> Which then obviously need to be properly specified somewhere.
> It should be fair to put some reasonable restrictions on these inputs as to
> not burden implementions with potentially difficult to handle fringe cases.
>
> > Allowing empty messages works out naturally for most skcipher
> > implementations,
> > and it also conceptually simplifies the length restrictions of the API (e.g.
> > for
> > most block cipher modes: just need nbytes % blocksize == 0, as opposed to
> > that
> > *and* nbytes != 0).  So that seems to be how we ended up with it.
> >
> I fail to see the huge burden of the extra len>0 restriction.
> Especially if you compare it to the burden of adding all the code for
> handling such useless exception cases to all individual drivers.
>
> > If we do change this, IMO we need to make it the behavior for all
> > implementations, not make it implementation-defined.
> >
> I don't see how disallowing 0 length inputs would affect implementations that
> ARE capable of processing them. Unless you would require them to start
> throwing errors for these cases, which I'm not suggesting.
>
> > Note that it's not necessary that your *hardware* supports empty messages,
> > since you can simply do this in the driver instead:
> >
> >       if (req->cryptlen == 0)
> >               return 0;
> >
> For skciphers, yes, it's not such a problem. Neither for basic hash.
> (And thanks for the code suggestion BTW, this will be a lot more efficient
> then what I'm doing now for this particular case :-)
> For HMAC, however, where you would have to return a value depending on the
> key ... not so easy to solve. I don't have a solution for that yet :-(
>
> And I'm pretty sure this affects all Inside Secure HW drivers in the tree:
> inside-secure, amcc, mediatek and omap ...
>
> Regards,
> Pascal van Leeuwen
> Silicon IP Architect, Multi-Protocol Engines, Inside Secure
> www.insidesecure.com
