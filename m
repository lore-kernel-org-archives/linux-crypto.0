Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06353C433F5
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Oct 2021 21:28:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D39B861248
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Oct 2021 21:28:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbhJCVa0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 3 Oct 2021 17:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbhJCVa0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 3 Oct 2021 17:30:26 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69996C0613EC
        for <linux-crypto@vger.kernel.org>; Sun,  3 Oct 2021 14:28:38 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id e7so14696393pgk.2
        for <linux-crypto@vger.kernel.org>; Sun, 03 Oct 2021 14:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=callas.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=O64yFNzRxMCFIqaKtb9/o/52Ls+IyQ0ND4eptoq4yb0=;
        b=bZACYU0KnOVgYCPXsNkny2fG5Nwo9QIYzQe4OYdxyEus4DE8wiCglqpOsYYxWiht/L
         xP16FJimELXCkAMz8xa+wKy97KSrnRI6+DY4hA6+cZevn/Rs+04ylDWFM6gn/u8Wpi+i
         0CHj9VtVLFWKnNJ8fTxXy5Dii5t0ydMrNmTYth80YW3s+uOtdn2lmfZ+gfmY3YO5UWa7
         nY/4TMH4R+nZrE/eSIt4HHO+BtktQYMHzH605d6rnGyuPjsp7IuK1YuzIrBAY+z5R7Mt
         W+n8TZAhYLc6SEFoa1G/hLrcmusFVSSNjEvpRwRmJFxieT3C0LDbCiK7PubRWobdDIJM
         Vt3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=O64yFNzRxMCFIqaKtb9/o/52Ls+IyQ0ND4eptoq4yb0=;
        b=D0jMH4eqw91MYwUdCh2Ty6/3DKApwDPbR3Xr055TyOGhtZM5Fejj0n4wIY3wxTMZjZ
         F4G2RMlycifuyWCZzFjWiXAxk4h+P49e4eBXV++mJFU91dBfqZeOMWtURwlhIuycss4Z
         RGkd3lLE6PCL4QAyq+rzPNgBD62r4xuh9/fuK6SFuQT9KsFcIz82mSaRuXstVJmRoiSQ
         6r7LEoPzcK0CtlBKp4FiUfTjY5oOqSmrWydMmGjUiFAb1Num5b1j99iGwYQZrcibRn2G
         eIASC7Evr5sNSLwXoOsGPUReAaX1U94wgcg2A8WtxkwwWH4/irjGj4XVxW2ES111sCLg
         OOTA==
X-Gm-Message-State: AOAM5303bGa4A7f2tL5f0FExUgJZn0Yo463oQWLwok7/Tbae3Y3/1QsD
        E531HXmmBvw9on7NzHTJZxWqVhafpbyUCUK8
X-Google-Smtp-Source: ABdhPJxwTGIDu3XOU1N7fF12ULOTsmVuXz4KsqetQBBCQKJ+0MwUaUp2YhjnCaa/kThzTbvVbhvz2A==
X-Received: by 2002:a62:1ac3:0:b0:44b:85d0:5a98 with SMTP id a186-20020a621ac3000000b0044b85d05a98mr22731280pfa.18.1633296517834;
        Sun, 03 Oct 2021 14:28:37 -0700 (PDT)
Received: from smtpclient.apple ([2600:1700:38c4:12bf:b553:2d38:d1e0:adbb])
        by smtp.gmail.com with ESMTPSA id o2sm11722764pgc.47.2021.10.03.14.28.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Oct 2021 14:28:37 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [Cryptography] [RFC] random: add new pseudorandom number
 generator
From:   Jon Callas <jon@callas.org>
In-Reply-To: <CACXcFm=40HCSvhkagsFn0WFnjrjbhk+Ah7Y=3tfFf5xxOW6A8g@mail.gmail.com>
Date:   Sun, 3 Oct 2021 14:28:36 -0700
Cc:     Jon Callas <jon@callas.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Cryptography <cryptography@metzdowd.com>,
        Ted Ts'o <tytso@mit.edu>
Content-Transfer-Encoding: quoted-printable
Message-Id: <AA432273-13B7-4592-8137-3EB566850A59@callas.org>
References: <CACXcFm=-E_wnDdRPztKJwDo8hvt6ENf84D90iFUXReuw2s0kuQ@mail.gmail.com>
 <378733E4-D976-4E2D-BE14-AD900C901CE8@callas.org>
 <CACXcFm=40HCSvhkagsFn0WFnjrjbhk+Ah7Y=3tfFf5xxOW6A8g@mail.gmail.com>
To:     Sandy Harris <sandyinchina@gmail.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> On Oct 3, 2021, at 00:04, Sandy Harris <sandyinchina@gmail.com> wrote:
>=20
> I'm using counter mode inside an Even-Mansour XOR-permutation-XOR
> structure which, among other things, makes it non-invertible.
>=20

And also takes care of other quibbles that were rattling around in my =
head.=20

>=20
> I'm doing this within the Linux random(4) driver which iterates chacha
> to generate output. This prng will only generate values for internal
> use, like rekeying chacha or dumping data into the input pool. In
> fact, if an instruction like Intel RDRAND or a hardware rng exist the
> code mostly uses those, only injecting xtea output once in a while to
> avoid tructing the other source completely or falling back to xtea if
> the other fails.

Then the constraints are even better. If that output isn't directly =
exposed, it can be a bit sloppier.=20

>=20
>> XTEA is an okay block cipher. Not great, okay. Probably good enough =
for a PRNG.
>=20
> With the Even-Mansour construction it seems good enough to me. [...]

Yeah, I was thinking it would be direct output. If it's direct output, =
then a ciphertext-only attack on the cipher is an attack on the PRNG. =
The way you're using it, it's a cheap way to provide another safety net. =
Remember, though, that E-M assumes a PRP, and many breaks on ciphers =
imply that it's not a PRP, and yet you don't care about any of that. =
Sounds fine to me.


>> But -- why wouldn't you use AES? An obvious answer is that you don't =
have it in hardware ...
>=20
> I wanted something that would be reasonably fast on anything Linux
> runs on & wanted to avoid using kernel memory for the S-box & round
> keys.

The speed aspect on low-end CPUs is what I was thinking of. Most =
importantly, you are doing something inside the whole box, so it doesn't =
even really need full pseudorandomness.=20

Overall, sounds fine to me.

	Jon


