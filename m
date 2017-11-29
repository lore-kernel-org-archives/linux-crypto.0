From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [1/2] crypto: tcrypt - fix S/G table for test_aead_speed()
Date: Wed, 29 Nov 2017 21:23:33 +1100
Message-ID: <20171129102333.GB24171@gondor.apana.org.au>
References: <1507630920-9014-1-git-send-email-robert.baronescu@nxp.com>
 <20171129062821.GA21594@gondor.apana.org.au>
 <VI1PR0402MB3342C5A4ECEB14C785823073983B0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Robert Baronescu <robert.baronescu@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:40910 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932279AbdK2KXo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Nov 2017 05:23:44 -0500
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB3342C5A4ECEB14C785823073983B0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 29, 2017 at 08:57:33AM +0000, Horia Geantă wrote:
>
> Considering this fixes the crash reported by Tudor:
> https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg29172.html
> I think it should be merged in this release cycle (v4.15).

This only affects tcrypt right? Since tcrypt is merely a debugging
interface I don't think it's that critical.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
