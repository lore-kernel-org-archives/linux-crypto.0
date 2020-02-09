Return-Path: <SRS0=Lfag=35=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C705CC35250
	for <linux-crypto@archiver.kernel.org>; Sun,  9 Feb 2020 08:05:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 939222080C
	for <linux-crypto@archiver.kernel.org>; Sun,  9 Feb 2020 08:05:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="yG/ZTbcu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbgBIIFM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 9 Feb 2020 03:05:12 -0500
Received: from mail-vs1-f45.google.com ([209.85.217.45]:32943 "EHLO
        mail-vs1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgBIIFL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Feb 2020 03:05:11 -0500
Received: by mail-vs1-f45.google.com with SMTP id n27so2237692vsa.0
        for <linux-crypto@vger.kernel.org>; Sun, 09 Feb 2020 00:05:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UukrQbD4Fgb2HOTXj2n65dHIumKclm6QTeeUOPVcbgM=;
        b=yG/ZTbcun0KjVG+c1C9xzGpG/t4bEFMNW8NvEZHXkLmEvHJT0x/yqdYwHribRRXPEi
         zTy7qjYrqq3ptuBiWjzg4LfqAzgZGUcEiiuTLPaqkl9RmF4C5iQhHguDzTrEWfNUocVP
         tF6IuTlN+9XxzYMyXh8pm3YNdLLM1YA55mKIYpPyCPe5NIDH5bf2P/9WhqtAMrJaAH41
         CWRe54pcji6BquEAaCWyN2BU4PiM9mrUj/omC+QdoeBUIw1640EBEEHrIMcBHAX8mNmH
         yYzisiR45zaJg8Uk13mb1MDWXfYmcTjv20CJUzXN+Bv49S82oGIKZf3kKQp/w85c/uH8
         CfCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UukrQbD4Fgb2HOTXj2n65dHIumKclm6QTeeUOPVcbgM=;
        b=bprP6ZLADLQK7wujYuFZppy5IST4hTGcyFt9y4YY+LGT2oGl2AYJq5mRKVZjFwXbW3
         Ux7+EdSQA6PtcdTT9Wa8tpazH51fyYGlVLWrt5Cyt5TpoAYQLfHZhNBIpFpLLHZjga5+
         c7h1/pwKo7RuRF+D4Ic3m+lJnTUgzyFStbFPpyDTtX6OcxhG2g6sesHni/UJqkklO/dK
         NB4ut2MMknWvQByreca3u7eoQ7AhDzTsn5SYFHL/NJO6wgLlRBjMmNk29ms02lW7m7F2
         AmT8ksjD55hIk7cZRKeg5UWZnSTR5hnwNgZx5/22pqLrrg6r0XnERO5ihSKQwSn5Wgkj
         7i4w==
X-Gm-Message-State: APjAAAWg77ieCCbCeC50z1xaRv0BNyL5fAJevSXLUsHskTneYXglZfhV
        ALgVRftK4UTaaB74BWltWrkqEMnf9l9hr2CMIYFwNc6u8T4=
X-Google-Smtp-Source: APXvYqzO/5+dJ7ULE/bpLMrVGlVGeCPO6i/joV9KGyYfOjPG1Vx5we8BBp8FTmh4Hmbg7wJ94YStKhPEu2ARkB1cDEo=
X-Received: by 2002:a67:fb14:: with SMTP id d20mr3161497vsr.136.1581235510558;
 Sun, 09 Feb 2020 00:05:10 -0800 (PST)
MIME-Version: 1.0
References: <CAOtvUMcwLtwgigFE2mx7LVjhhEgcZsSS4WyR_SQ2gixTZxyBfg@mail.gmail.com>
 <28236835.Fk5ARk2Leh@tauon.chronox.de> <CAOtvUMchWrNsvmLJ2D-qiGOAAgbr_yxtt3h81yOHesa7C6ifZQ@mail.gmail.com>
 <6968686.FA8oO0t0Vk@tauon.chronox.de>
In-Reply-To: <6968686.FA8oO0t0Vk@tauon.chronox.de>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Sun, 9 Feb 2020 10:04:55 +0200
Message-ID: <CAOtvUMcqod8ubo_Y9_czM__+U9pWge4s6bLZoZ8YBa-WJTTWNg@mail.gmail.com>
Subject: Re: Possible issue with new inauthentic AEAD in extended crypto tests
To:     Stephan Mueller <smueller@chronox.de>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Miller <davem@davemloft.net>,
        Ofir Drang <Ofir.Drang@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 7, 2020 at 2:30 PM Stephan Mueller <smueller@chronox.de> wrote:
>
> Am Freitag, 7. Februar 2020, 12:50:51 CET schrieb Gilad Ben-Yossef:
>
> Hi Gilad,
>
> >
> > It is correct, but is it smart?
> >
> > Either we require the same IV to be passed twice as we do today, in whi=
ch
> > case passing different IV should fail in a predictable manner OR we sho=
uld
> > define the operation is taking two IV like structures - one as the IV a=
nd
> > one as bytes in the associated data and have the IPsec code use it in a
> > specific way of happen to pass the same IV in both places.
> >
> > I don't care either way - but right now the tests basically relies on
> > undefined behaviour
> > which is always a bad thing, I think.
>
> I am not sure about the motivation of this discussion: we have exactly on=
e
> user of the RFC4106 implementation: IPSec. Providing the IV/AAD is effici=
ent
> as the rfc4106 template intents to require the data in a format that requ=
ires
> minimal processing on the IPSec side to bring it in the right format.
>

The motivation for this discussion is that our current test suite for
RFC4106 generates test messages where req->iv is different than the
copy in the associated data.
This is not per my interpretation of RFC 4106, this is not the API as
is described in the header files and finally it is not per the use
case of the single user of RFC 4106 in the kernel and right now these
tests
causes the ccree driver to fail these tests.

Again, I am *not* suggesting or discussing changing the API.

I am asking the very practical question if it makes sense to me to
delve into understanding why this use case is failing versus fixing
the test suite to  test what we actually use.

Gilad

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
