From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [RFC PATCH 0/8] crypto: AF_ALG support for KPP
Date: Wed, 19 Apr 2017 15:03:35 +0300
Message-ID: <13fbe75c-ddd3-5363-99f8-64b01a2cd479@microchip.com>
References: <2715753.J0rCo2lbig@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8bit
To: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>,
        <linux-crypto@vger.kernel.org>, <keyrings@vger.kernel.org>,
        <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:35582 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933510AbdDSMDn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Apr 2017 08:03:43 -0400
In-Reply-To: <2715753.J0rCo2lbig@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, Stephan, Herbert,

On 19.04.2017 02:03, Stephan Müller wrote:
> The patch 8 describes the different operations that are supported by AF_ALG
> KPP. This support includes generation and retaining of the private key
> inside the kernel. This private key would never be sent to user space.

There are crypto co-processors that are capable of generating and
retaining the private key inside the device without revealing it to
kernel. The private key will be further used to generate the public
key and the shared secret. Should we extend the KPP API to support this?

Thanks,
ta
