From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [PATCH v4 04/14] crypto: ecc - don't be selfish on pubkeys
Date: Mon, 29 May 2017 17:11:41 +0300
Message-ID: <260d4e89-76a5-6566-829a-4e95529dd556@microchip.com>
References: <1495696696-22580-1-git-send-email-tudor.ambarus@microchip.com>
 <1495696696-22580-5-git-send-email-tudor.ambarus@microchip.com>
 <VI1PR0401MB25914061D5FFCB13C047A1E798F20@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"; format=flowed
Content-Transfer-Encoding: 8bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Dan Douglass <dan.douglass@nxp.com>,
        "giovanni.cabiddu@intel.com" <giovanni.cabiddu@intel.com>,
        "salvatore.benedetto@intel.com" <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:48552 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750987AbdE2OLp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 May 2017 10:11:45 -0400
In-Reply-To: <VI1PR0401MB25914061D5FFCB13C047A1E798F20@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, Horia,

On 28.05.2017 20:22, Horia Geantã wrote:
> On 5/25/2017 10:18 AM, Tudor Ambarus wrote:
>> Rename ecdh_make_pub_key() to ecc_make_pub_key().
>> This function might as well be used by ecdsa.
> 
> Where exactly is ecdsa used in the kernel?
> https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg23235.html

Nowhere. Maybe I should have dropped the reference to ecdsa.
ecdh_make_pub_key() is not dh specific and the reference to dh is wrong.

Thanks for the review,
ta
