Return-Path: <SRS0=h947=VT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08B76C76190
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 16:43:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0DF021901
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 16:43:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Vt87YFse"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbfGVQnj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Jul 2019 12:43:39 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34266 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbfGVQnj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jul 2019 12:43:39 -0400
Received: by mail-wr1-f66.google.com with SMTP id 31so40174426wrm.1
        for <linux-crypto@vger.kernel.org>; Mon, 22 Jul 2019 09:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MIdqlZwnQsiCZkqxnBzXBVU/BqiAySwrkah4DJx6Pt4=;
        b=Vt87YFseIsomZU/WR2vERqmTlk+XfjSGIUUzIn5ZQwU9rlNu/4Y/WN/Q5qAijXpLVa
         dDYM7CLA7QTLgGZeV27jloCba2uyY7pUmR6DR7FYH0KcEW0I5tmFY98Dsqg/O3JilBD+
         MdBq/gBs/4VdD0BUhBURZmwG6udN6u0oXN0ZjQTfVebNqF54JTCgvkbFAUcXgwmevNXi
         UHevgnVRYTPbUE8p3LCNjiltixDDfgT43C3cBO3jYFl2KgjiEpJTnJdt8VvfKU7AnWw2
         rN5oyZw7BZRlwQksKo4b4dDS9TSHVivJ33E+grZbhwtDT1bWIUW4Y8m0yx7YxXKebnKb
         jUmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MIdqlZwnQsiCZkqxnBzXBVU/BqiAySwrkah4DJx6Pt4=;
        b=GXwFggAyi3f9prc3e3KaFYe1sSDPVVQM4D7/92DoopxSyVpBrYjNkHCLzaIbno+Jp6
         7hwXqMUTQoTEkuyqsiovuOl/W+K7Ko3PFpDAxYvuZe3jjFCzp8T3s+W7CQ25CI3VfR7j
         viVucb4yT14hk4VMS+HKeQNkpcnq+e8p6AmNJNwgktzevekMQNgU7EGcNXMwloGNBjyo
         l9z50G7ZgmzB1sBDWT3a0UbP9+oZdnUhk0hEH+wANwMQs7RDchCzl7uv8OwcD26s2/r7
         Vo5Jrwb+T7pHRoLkOO4Fj9YWPZgjYTqJM6mHApedfkqhdnC4BpE6QPPQKs1M5FSMRgGe
         l4XQ==
X-Gm-Message-State: APjAAAX/ZYZxlJv2QEpn22qX9iyXoaRe4IqGBxVbxIYUP31pTSviDBBO
        CgJ92lkgfaeXeaM56Xdh3Ok2EwMZ++SQUTs8F+WFbw==
X-Google-Smtp-Source: APXvYqywlyx4chr86bc3GtnU8p2jHmfeRD7VjwD4hFUAKoQjSxq7rHN24uInXHs3pItROSRAtpiU1Tc7Vh8lKzFTYC0=
X-Received: by 2002:adf:9ccf:: with SMTP id h15mr59617441wre.241.1563813816772;
 Mon, 22 Jul 2019 09:43:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190716221639.GA44406@gmail.com> <VI1PR0402MB34857BBB18C2BB8CBA2DEC7198C90@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190717172823.GA205944@gmail.com> <CAKv+Gu__offPaWvyURJr8v56ig58q-Deo16QhP26EJ32uf5m3w@mail.gmail.com>
 <20190718065223.4xaefcwjoxvujntw@gondor.apana.org.au> <CAKv+Gu9-EWNpJ9viSsjhYRdOZb=7a=Mpddmyt8SLEq9aFtawjg@mail.gmail.com>
 <20190718072154.m2umem24x4grbf6w@gondor.apana.org.au> <36e78459-1594-6d19-0ab4-95b03a6de036@gmail.com>
 <MN2PR20MB2973E61815F069E8C7D74177CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
 <b042649c-db98-9710-b063-242bdf520252@gmail.com> <20190720065807.GA711@sol.localdomain>
 <0d4d6387-777c-bfd3-e54a-e7244fde0096@gmail.com> <CAKv+Gu9UF+a1UhVU19g1XcLaEqEaAwwkSm3-2wTHEAdD-q4mLQ@mail.gmail.com>
 <MN2PR20MB2973B9C2DDC508A81AF4A207CAC40@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB2973B9C2DDC508A81AF4A207CAC40@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 22 Jul 2019 19:43:25 +0300
Message-ID: <CAKv+Gu9C2AEbb++W=QTVWbeA_88Fo57NcOwgU5R8HBvzFwXkJw@mail.gmail.com>
Subject: Re: [dm-devel] xts fuzz testing and lack of ciphertext stealing support
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Milan Broz <gmazyland@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Horia Geanta <horia.geanta@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 22 Jul 2019 at 12:44, Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:
>
> > -----Original Message-----
> > From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Sent: Sunday, July 21, 2019 11:50 AM
> > To: Milan Broz <gmazyland@gmail.com>
> > Cc: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>; Herbert Xu <herbert@gondor.apana.org.au>; dm-devel@redhat.com; linux-
> > crypto@vger.kernel.org; Horia Geanta <horia.geanta@nxp.com>
> > Subject: Re: [dm-devel] xts fuzz testing and lack of ciphertext stealing support
> >
> > On Sat, 20 Jul 2019 at 10:35, Milan Broz <gmazyland@gmail.com> wrote:
> > >
> > > On 20/07/2019 08:58, Eric Biggers wrote:
> > > > On Thu, Jul 18, 2019 at 01:19:41PM +0200, Milan Broz wrote:
> > > >> Also, I would like to avoid another "just because it is nicer" module dependence (XTS->XEX->ECB).
> > > >> Last time (when XTS was reimplemented using ECB) we have many reports with initramfs
> > > >> missing ECB module preventing boot from AES-XTS encrypted root after kernel upgrade...
> > > >> Just saying. (Despite the last time it was keyring what broke encrypted boot ;-)
> > > >>
> > > >
> > > > Can't the "missing modules in initramfs" issue be solved by using a
> > > > MODULE_SOFTDEP()?  Actually, why isn't that being used for xts -> ecb already?
> > > >
> > > > (There was also a bug where CONFIG_CRYPTO_XTS didn't select CONFIG_CRYPTO_ECB,
> > > > but that was simply a bug, which was fixed.)
> > >
> > > Sure, and it is solved now. (Some systems with a hardcoded list of modules
> > > have to be manually updated etc., but that is just bad design).
> > > It can be done properly from the beginning.
> > >
> > > I just want to say that that switching to XEX looks like wasting time to me
> > > for no additional benefit.
> > >
> > > Fully implementing XTS does make much more sense for me, even though it is long-term
> > > the effort and the only user, for now, would be testmgr.
> > >
> > > So, there are no users because it does not work. It makes no sense
> > > to implement it, because there are no users... (sorry, sounds like catch 22 :)
> > >
> > > (Maybe someone can use it for keyslot encryption for keys not aligned to
> > > block size, dunno. Actually, some filesystem encryption could have use for it.)
> > >
> > > > Or "xts" and "xex" could go in the same kernel module xts.ko, which would make
> > > > this a non-issue.
> > >
> > > If it is not available for users, I really see no reason to introduce XEX when
> > > it is just XTS with full blocks.
> > >
> > > If it is visible to users, it needs some work in userspace - XEX (as XTS) need two keys,
> > > people are already confused enough that 256bit key in AES-XTS means AES-128...
> > > So the examples, hints, man pages need to be updated, at least.
> > >
> >
> > OK, consider me persuaded. We are already exposing xts(...) to
> > userland, and since we already implement a proper subset of true XTS,
> > it will be simply a matter of making sure that the existing XTS
> > implementations don't regress in performance on the non-CTS code
> > paths.
> >
> > It would be useful, though, to have some generic helper functions,
> > e.g., like the one we have for CBC, or the one I recently proposed for
> > CTS, so that existing implementations (such as the bit sliced AES) can
> > easily be augmented with a CTS code path (but performance may not be
> > optimal in those cases). For the ARM implementations based on AES
> > instructions, it should be reasonably straight forward to implement it
> > close to optimally by reusing some of the code I added for CBC-CTS
> > (but I won't get around to doing that for a while). If there are any
> > volunteers for looking into the generic or x86/AES-NI implementations,
> > please come forward :-) Also, if any of the publications that were
> > quoted in this thread have suitable test vectors, that would be good
> > to know.
>
> Unfortunately, these algorithm & protocol specifications tend to be very frugal when it
> comes to providing test vectors, barely scratching the surface of any corner cases, but
> at least there is one non-multiple-of-16 vector in the original IEEE P1619 / D16
> specification in Annex B Test Vectors (last vector, "XTS-AES-128 applied for a data unit
> that is not a multiple of 16 bytes")
>

Actually, that spec has a couple of test vectors. Unfortunately, they
are all rather short (except the last one in the 'no multiple of 16
bytes' paragraph, but unfortunately, that one is in fact a multiple of
16 bytes)

I added them here [0] along with an arm64 implementation for the AES
instruction based driver. Could you please double check that these
work against your driver? That would establish a ground truth against
which we can implement the generic version as well.

[0] https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=xts-cts

> Besides that, I'd be happy to generate some testvectors from our defacto-standard
> implementation ;-)
>

One or two larger ones would be useful, yes.
