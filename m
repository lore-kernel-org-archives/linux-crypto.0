From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [PATCH 1/2] crypto: tcrypt - fix S/G table for test_aead_speed()
Date: Mon, 13 Nov 2017 20:27:47 +0200
Message-ID: <75766914-fdc1-5fb9-a571-82f86bcbe928@microchip.com>
References: <1507630920-9014-1-git-send-email-robert.baronescu@nxp.com>
 <20171103124157.GA8330@gondor.apana.org.au>
 <VI1PR0402MB33425E266579E4F3B375617498570@VI1PR0402MB3342.eurprd04.prod.outlook.com>
 <20171109222129.GB20824@gondor.apana.org.au>
 <VI1PR0402MB3342FFECA75AFC5556AD085498540@VI1PR0402MB3342.eurprd04.prod.outlook.com>
 <20171110074332.GB24384@gondor.apana.org.au>
 <VI1PR0402MB334241EA4B848E77AF8DFC2298540@VI1PR0402MB3342.eurprd04.prod.outlook.com>
 <20171110104145.GA25739@gondor.apana.org.au>
 <VI1PR0402MB33426CA117EDA1686C916D7B982A0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Robert Baronescu <robert.baronescu@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
To: =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:53342 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752833AbdKMS1z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Nov 2017 13:27:55 -0500
In-Reply-To: <VI1PR0402MB33426CA117EDA1686C916D7B982A0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

On 11/12/2017 06:26 PM, Horia Geantã wrote:

> -sg[0] - (1 entry) reserved for associated data, filled outside
> sg_init_aead()

Let's fill the sg[0] with aad inside sg_init_aead()!

Cheers,
ta
