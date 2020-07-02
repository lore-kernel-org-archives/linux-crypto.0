Return-Path: <SRS0=MdlN=AN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 520E0C433E1
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Jul 2020 07:56:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A00020B1F
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Jul 2020 07:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgGBH4U (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jul 2020 03:56:20 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:38030 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725287AbgGBH4U (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jul 2020 03:56:20 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jqu4u-0002zd-9q; Thu, 02 Jul 2020 17:56:17 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 02 Jul 2020 17:56:16 +1000
Date:   Thu, 2 Jul 2020 17:56:16 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: Re: [PATCH] crypto: caam - Remove broken arc4 support
Message-ID: <20200702075616.GA4394@gondor.apana.org.au>
References: <20200702043648.GA21823@gondor.apana.org.au>
 <CAMj1kXFKkCSf06d4eKRZvdPzxCsVsYhOjRk221XpmLxvrrdKMw@mail.gmail.com>
 <CAMj1kXGEvumaCaQivdZjTFBMMctePWuvoEupENaUbjbdiqmr8Q@mail.gmail.com>
 <CAMj1kXGvMe_A_iQ43Pmygg9xaAM-RLy=_M=v+eg--8xNmv9P+w@mail.gmail.com>
 <20200702074533.GC4253@gondor.apana.org.au>
 <CAMj1kXHT9Puv2tC4_J2kVMjSF5es_9k+URVwsvao6TReS_5aJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHT9Puv2tC4_J2kVMjSF5es_9k+URVwsvao6TReS_5aJA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 02, 2020 at 09:51:29AM +0200, Ard Biesheuvel wrote:
>
> I'll wait for the code to be posted (please put me on cc), but my

Sure I will.

> suspicion is that carrying opaque state like that is going to bite us
> down the road.

Well it's only going to be arc4 at first, where it's definitely
an improvement over modifying the tfm context in encrypt/decrypt.

For XTS I haven't decided whether to go this way or not.  If it
does work out though we could even extend it to AEAD.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
