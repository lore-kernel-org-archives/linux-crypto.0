From: Lee Nipper <lee.nipper@gmail.com>
Subject: Re: Crypto Fixes for 2.6.35
Date: Fri, 23 Jul 2010 08:17:59 -0500
Message-ID: <AANLkTik2eu0EUViJRHRwt2=2W=punHbswWK-AS6Qr_2S@mail.gmail.com>
References: <20090910141905.GA17948@gondor.apana.org.au>
	<20091020065442.GA5947@gondor.apana.org.au>
	<20091230021253.GA17067@gondor.apana.org.au>
	<20100201195204.GA6953@gondor.apana.org.au>
	<20100305071043.GA3548@gondor.apana.org.au>
	<20100427135547.GA4008@gondor.apana.org.au>
	<20100603100550.GA30681@gondor.apana.org.au>
	<20100716022648.GA28219@gondor.apana.org.au>
	<20100722055043.GA25689@gondor.apana.org.au>
	<AANLkTimqQXuiwgQep4uUrKDIAO2idw51Eu6XiZgs0HsR@mail.gmail.com>
	<20100723072746.GB4267@gondor.apana.org.au>
Reply-To: lee.nipper@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35383 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab0GWNSB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 23 Jul 2010 09:18:01 -0400
Received: by vws3 with SMTP id 3so205871vws.19
        for <linux-crypto@vger.kernel.org>; Fri, 23 Jul 2010 06:18:00 -0700 (PDT)
In-Reply-To: <20100723072746.GB4267@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 23, 2010 at 02:27, Herbert Xu <herbert@gondor.apana.org.au>=
 wrote:
> If it causes a crash or has other serious implications then I will
> push it. =A0However, if it simply results in a broken hash computatio=
n,
> a failure that should be fairly obvious, then it can wait til the
> next cycle.
>
> When I looked at it previously I thought it fell into the latter
> category, but I might be mistaken.

That's right.  It's just a hash thing.
Thanks,

Lee
