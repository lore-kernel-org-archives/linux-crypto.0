From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [RFC PATCH 0/8] crypto: AF_ALG support for KPP
Date: Wed, 19 Apr 2017 14:16:22 +0200
Message-ID: <2901317.mRtm3aTmG0@tauon.chronox.de>
References: <2715753.J0rCo2lbig@positron.chronox.de> <13fbe75c-ddd3-5363-99f8-64b01a2cd479@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org, keyrings@vger.kernel.org,
        herbert@gondor.apana.org.au
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59012 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762888AbdDSMQZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Apr 2017 08:16:25 -0400
In-Reply-To: <13fbe75c-ddd3-5363-99f8-64b01a2cd479@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 19. April 2017, 14:03:35 CEST schrieb Tudor Ambarus:

Hi Tudor,

> Hi, Stephan, Herbert,
> 
> On 19.04.2017 02:03, Stephan Müller wrote:
> > The patch 8 describes the different operations that are supported by
> > AF_ALG
> > KPP. This support includes generation and retaining of the private key
> > inside the kernel. This private key would never be sent to user space.
> 
> There are crypto co-processors that are capable of generating and
> retaining the private key inside the device without revealing it to
> kernel. The private key will be further used to generate the public
> key and the shared secret. Should we extend the KPP API to support this?

The less software has access to secrets, the better. Thus, having such API 
would be good.

This of course assumes that the private key is generated with an appropriate 
RNG. As normal users cannot verify the RNG or the noise sources implemented in 
hardware, the choice of using such API to keep the private key inside the 
hardware should be left to the caller.

>From the AF_ALG KPP support side, I could imagine that that the algif_kpp code 
makes use of the hardware support unless the caller objects.

Ciao
Stephan
