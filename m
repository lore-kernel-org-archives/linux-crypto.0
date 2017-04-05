From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [7/7] crypto: caam/qi - add ablkcipher and authenc algorithms
Date: Wed, 05 Apr 2017 20:06:50 +1000
Message-ID: <87lgrftbgl.fsf@concordia.ellerman.id.au>
References: <20170317100602.2837-8-horia.geanta@nxp.com> <87vaqkvk6c.fsf@concordia.ellerman.id.au> <58E39F90.6050408@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Claudiu Manoil <claudiu.manoil@nxp.com>,
        Cristian Stoica <cristian.stoica@nxp.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        "linux-arm-kernel\@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Vakul Garg <vakul.garg@nxp.com>,
        "linuxppc-dev\@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandru Porosanu <alexandru.porosanu@nxp.com>,
        "linux-crypto\@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Scott Wood <oss@buserror.net>, Roy Pledge <roy.pledge@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:47019 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755214AbdDEKHC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Apr 2017 06:07:02 -0400
In-Reply-To: <58E39F90.6050408@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Laurentiu Tudor <laurentiu.tudor@nxp.com> writes:

> Hi Michael,
>
> Just a couple of basic things to check:
>   - was the dtb updated to the newest?

Possibly not, it's an automated build/boot, I'll have to check what it
does with the dtb.

>   - is the qman node present? This should be easily visible in 
> /proc/device-tree/soc@ffe000000/qman@318000.

No it's not there.

That's running linux-next with:

CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI=n


Does that mean I didn't update the device tree?

cheers
