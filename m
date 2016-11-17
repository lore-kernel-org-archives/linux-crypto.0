From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: crypto: caam warning fix, was: master build: 0 failures 1 warnings (v4.9-rc5-177-g81bcfe5)
Date: Thu, 17 Nov 2016 16:42:30 +0100
Message-ID: <2224726.Znm8OXAZaO@wuerfel>
References: <E1c6kSQ-0008UC-DM@optimist> <5255539.MpGQJX1bep@wuerfel> <20161117153403.GA1687@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linaro-kernel@lists.linaro.org,
        Build bot for Mark Brown <broonie@kernel.org>,
        kernel-build-reports@lists.linaro.org,
        Horia =?utf-8?B?R2VhbnTEgw==?= <horia.geanta@nxp.com>,
        linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:62138 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935006AbcKQR3z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Nov 2016 12:29:55 -0500
In-Reply-To: <20161117153403.GA1687@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday, November 17, 2016 11:34:04 PM CET Herbert Xu wrote:
> On Wed, Nov 16, 2016 at 05:40:41PM +0100, Arnd Bergmann wrote:
> > 
> > This is currently the only build warning reported for v4.9, and you have merged
> > the fix for v4.10 in
> > 
> > d69985a07692 ("crypto: caam - fix type mismatch warning")
> > 
> > Any chance you can send this for v4.9 so we have a clean build?
> 
> OK I'll push that along.
> 
> 

Thanks!

	Arnd
