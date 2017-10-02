From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [PATCH v8 0/4] crypto: add algif_akcipher user space API
Date: Mon, 2 Oct 2017 17:15:35 +0300
Message-ID: <43d74317-5c5c-d1da-d4a1-185416053e8a@microchip.com>
References: <26359147.tCiuJ5s8mz@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        <gilad@benyossef.com>
To: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        Marcel Holtmann <marcel@holtmann.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "David S . Miller" <davem@davemloft.net>, <balrogg@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:5261 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751084AbdJBOPj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Oct 2017 10:15:39 -0400
In-Reply-To: <26359147.tCiuJ5s8mz@positron.chronox.de>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, all,

On 08/10/2017 09:39 AM, Stephan Müller wrote:
> Hi,
> 
> This patch set adds the AF_ALG user space API to externalize the
> asymmetric cipher API recently added to the kernel crypto API.

Do we have enough pros and cons so we can decide which interface to use
for exporting akcipher/kpp to user-space?

I'm willing to invest some time to make this happen.

Cheers,
ta
