From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: caam warning fix, was: master build: 0 failures 1
 warnings (v4.9-rc5-177-g81bcfe5)
Date: Thu, 17 Nov 2016 23:34:04 +0800
Message-ID: <20161117153403.GA1687@gondor.apana.org.au>
References: <E1c6kSQ-0008UC-DM@optimist>
 <5255539.MpGQJX1bep@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linaro-kernel@lists.linaro.org,
        Build bot for Mark Brown <broonie@kernel.org>,
        kernel-build-reports@lists.linaro.org,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        linux-crypto@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58359 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S941666AbcKQRTi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Nov 2016 12:19:38 -0500
Content-Disposition: inline
In-Reply-To: <5255539.MpGQJX1bep@wuerfel>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 16, 2016 at 05:40:41PM +0100, Arnd Bergmann wrote:
> 
> This is currently the only build warning reported for v4.9, and you have merged
> the fix for v4.10 in
> 
> d69985a07692 ("crypto: caam - fix type mismatch warning")
> 
> Any chance you can send this for v4.9 so we have a clean build?

OK I'll push that along.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
