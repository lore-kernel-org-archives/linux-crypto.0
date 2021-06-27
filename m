Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8865C48BC2
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Jun 2021 16:36:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9334D61A0F
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Jun 2021 16:36:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbhF0Qi1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 27 Jun 2021 12:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbhF0Qi0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 27 Jun 2021 12:38:26 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A722C061574
        for <linux-crypto@vger.kernel.org>; Sun, 27 Jun 2021 09:36:02 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id u20so4411523wmq.4
        for <linux-crypto@vger.kernel.org>; Sun, 27 Jun 2021 09:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ib.tc; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=omimQxIzOAwhYkeMRubnROCdKPxWEo2EeSbQ3aFOPYs=;
        b=SRcB0HiWAFayqaSdVoP0s2EJBzWf+dFcE3HNr/j0q87Zj9O+aGGMOMw1iHbuoq7ibi
         /A1YrLRtN88xCQC76USOjH6SMwDxfp4ewFQGMfW/scb8V4X2nQHuRIhJos14gWtEEjRE
         G4XdVcgDn2LhmJsogq/j0IhfnCvjTKC45Ap7A7wSsdqcApH6NPVPHUxYlEJtppDp3uvm
         ZtarmzDO5wtkou+YSEiLZZqKEo6TB13+F0+z4mnilnG+wC+8UveyN9wb81y9RHj2f2uR
         llmUsYx5K7RrOPm7r2kkgIXxeCgb84ruSGjqcSF58oWytZKHeJfswIf4I5GsleElr2Jv
         okbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=omimQxIzOAwhYkeMRubnROCdKPxWEo2EeSbQ3aFOPYs=;
        b=juYgLt9NKBP65zeqru6nA620dPzg7bV7dAYsoDz191dpWB/Ykg7/Xww9vz0Dfr0u0I
         aRi/N62hdIy/vTRyUwiB8FAGmAo3MqAhPvX+LDF4F48sCXHM2YTaj6JTN34yINIvEo/+
         tyXnOraW2GL/cgWrCZePduhgRggDVN58pNR9TMBLxU+weU52yLW8XX6mVrxrl+LvXfHc
         GvqJyO8vSPHHNMWmr2jlahh3BOVmF5iJ3TYAnaBUkvKYX3bgzpjIzOXFX/Cf4f5JIMo1
         txqf//YdlVMprBRmLD+gPWVvfeY0+ibRZcUyk/6JoIiSMBN/fJDIMFe5llsCnGg7wyRV
         idfQ==
X-Gm-Message-State: AOAM531kqEs7OSJKK7616T9pcAN4sHApxPVQV9UmZqCjVlnht0/SEz1f
        0Qy9R5m1cf/YLdMICoTdCSjmIxr3fn3C0SD6bXmeQ6LUaWuAAQ==
X-Google-Smtp-Source: ABdhPJygb1g9MbfmCSjPqWY09EtTpxXLbPlbbEeieF/v5Xme9UFdd95juud59IRk7t+U0hdE5f5XL61ZHc9yiodwIlI=
X-Received: by 2002:a05:600c:2512:: with SMTP id d18mr22309346wma.85.1624811760467;
 Sun, 27 Jun 2021 09:36:00 -0700 (PDT)
MIME-Version: 1.0
References: <CALFqKjSnOWyFjp7NQZKMXQ+TfzXMCBS=y8xnv5GE56SHVr5tCg@mail.gmail.com>
 <CACXcFmnRAkrj0Q3uFjyLu7RaWQh0VPbmErkj+cUaxZMb=YiGCw@mail.gmail.com>
 <CACXcFmmW+tCUf8JS=a=wJEnBY2JojP8VwEGLncYcGLZqiU+5Jw@mail.gmail.com> <CALFqKjTAHvORw_U3sGe0ZRvAH8kTVKCdgVKQu+SK6h=C7B-jbA@mail.gmail.com>
In-Reply-To: <CALFqKjTAHvORw_U3sGe0ZRvAH8kTVKCdgVKQu+SK6h=C7B-jbA@mail.gmail.com>
From:   Mike Brooks <m@ib.tc>
Date:   Sun, 27 Jun 2021 09:35:46 -0700
Message-ID: <CALFqKjRW7b1vay5Zk3Ux=g6bcr4VsYXMWoc1pVSmwtupJFgfgA@mail.gmail.com>
Subject: Re: Lockless /dev/random - Performance/Security/Stability improvement
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

I apologize for my late reply - an erroneous email filter hid these
messages from me.

I'd like to take the time to thank you for all of your responses and
let me address any of the questions that were brought up on this
thread.

To reply to Sandy Harris.  The code on github is a suggested
/dev/random and /dev/urandom replacement and it has some interesting
tradeoffs from the incumbent implementation.  There are always rooms
for improvements, and I am exploring what it means to have a lockless
entropy store for Linux.

But you bring up a very important question - is AES required?  Or why
not use a hand-crafted routine to access bits.  There are two
responses to this.  The first being evident by the use of dieharder.
A naive method of shifting bits to pull out data from the entropy pool
will be detected with the 'dieharder' test suite.   The implementation
on github will write a sample file, and any assessors that pull data
from the entropy pool need to be susceptible to an avalanche. We need
a method that is quantifiable, and one that is widely accepted as
being ideal. So could a fast, but less than ideal hash function like
sha1 be used?  Absolutely,  but AES-NI is still faster on platforms
that enable it...

And this is where Stephan M=C3=BCller's post comes into play. Given the
diversity of hardware platforms, and the varying levels of dependency
on /dev/random  - there is a need on behalf of admins to tailor the
performance of this interface as it impacts *every* syscall because
each interrupt is an entropy source.  the base default should be good
enough for anyone, I agree strongly with your view on a secure by
default system.

Consider an HFT trading bot - you don't want to penalize any
interrupt.  It would be great to have a NIST-Compliant Random Number
Generator that has this interrupt-taxation as optional - but disabling
it shouldn't cause anyone to be compromised, but if you are paranoid
then additional sources can be added as further hardening.

Ultimately I'd like to make a patch file for this implementation and
run benchmarks to show the efficacy of the design.  Thank you all for
your feedback, and I'm happy to consider alternate lockless-designs.

Best regards,
Michael Brooks


On Sat, Jun 26, 2021 at 1:24 PM Mike Brooks <m@ib.tc> wrote:
>
> I apologize for my late reply - an erroneous email filter hid these messa=
ges from me.
>
> I'd like to take the time to thank you for all of your responses and let =
me address any of the questions that were brought up on this thread.
>
> To reply to Sandy Harris.  The code on github is a suggested /dev/random =
and /dev/urandom replacement and it has some interesting tradeoffs from the=
 incumbent implementation.  There are always rooms for improvements, and I =
am exploring what it means to have a lockless entropy store for Linux.
>
> But you bring up a very important question - is AES required?  Or why not=
 use a hand-crafted routine to access bits.  There are two responses to thi=
s.  The first being evident by the use of dieharder.  A naive method of shi=
fting bits to pull out data from the entropy pool will be detected with the=
 'dieharder' test suite.   The implementation on github will write a sample=
 file, and any assessors that pull data from the entropy pool need to be su=
sceptible to an avalanche. We need a method that is quantifiable, and one t=
hat is widely accepted as being ideal. So could a fast, but less than ideal=
 hash function like sha1 be used?  Absolutely,  but AES-NI is still faster =
on platforms that enable it...
>
> And this is where Stephan M=C3=BCller's post comes into play. Given the d=
iversity of hardware platforms, and the varying levels of dependency on /de=
v/random  - there is a need on behalf of admins to tailor the performance o=
f this interface as it impacts *every* syscall because each interrupt is an=
 entropy source.  the base default should be good enough for anyone, I agre=
e strongly with your view on a secure by default system.
>
> Consider an HFT trading bot - you don't want to penalize any interrupt.  =
It would be great to have a NIST-Compliant Random Number Generator that has=
 this interrupt-taxation as optional - but disabling it shouldn't cause any=
one to be compromised, but if you are paranoid then additional sources can =
be added as further hardening.
>
> Ultimately I'd like to make a patch file for this implementation and run =
benchmarks to show the efficacy of the design.  Thank you all for your feed=
back, and I'm happy to consider alternate lockless-designs.
>
> Best regards,
> Michael Brooks
>
> On Fri, Jun 11, 2021 at 2:44 AM Sandy Harris <sandyinchina@gmail.com> wro=
te:
>>
>> Sandy Harris <sandyinchina@gmail.com> wrote:
>>
>> > The basic ideas here look good to me; I will look at details later.
>>
>> Looking now, finding some things questionable.
>>
>> Your doc has:
>>
>> " /dev/random needs to be fast, and in the past it relied on using a
>> cryptographic primitive for expansion of PNRG to fill a given request
>>
>> " urandom on the other hand uses a cryptographic primitive to compact
>> rather than expand,
>>
>> This does not seem coherent to me & as far as I can tell, it is wrong as=
 well.
>> /dev/random neither uses a PRNG nor does expansion.
>> /dev/urandom does both, but you seem to be saying the opposite.
>>
>> " We can assume AES preserves confidentiality...
>>
>> That is a reasonable assumption & it does make the design easier, but
>> is it necessary? If I understood some of Ted's writing correctly, one
>> of his design goals was not to have to trust the crypto too much. It
>> seems to me that is a worthy goal. One of John Denker's papers has
>> some quite nice stuff about using a hash function to compress input
>> data while preserving entropy. It needs only quite weak assumptions
>> about the hash.
>> https://www.av8n.com/turbid/
>>
>> You want to use AES in OFB mode. Why? The existing driver uses ChaCha,
>> I think mainly because it is faster.
>>
>> The classic analysis of how to use a block cipher to build a hash is
>> Preneel et al.
>> https://link.springer.com/content/pdf/10.1007%2F3-540-48329-2_31.pdf
>> As I recall, it examines 64 possibilities & finds only 9 are secure. I
>> do not know if OFB, used as you propose, is one of those. Do you?
