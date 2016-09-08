From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4/9] hwrng: omap - Use the managed device resource API
 for registration
Date: Fri, 9 Sep 2016 01:02:23 +0800
Message-ID: <20160908170223.GA29095@gondor.apana.org.au>
References: <20160906153857.5503-1-romain.perier@free-electrons.com>
 <20160906153857.5503-5-romain.perier@free-electrons.com>
 <CANc+2y6LeOqSy37x=vXaLPkGM3C5Wh6Yq11ybO+-0DU19wLBUQ@mail.gmail.com>
 <57D022F9.2020407@free-electrons.com>
 <CANc+2y5yzMNeHEgf6FfQHiN=-528YZgB3JwVcqa3C-s8s_RCfA@mail.gmail.com>
 <57D18801.5050901@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        dsaxena@plexity.net, mpm@selenic.com,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Omri Itach <omrii@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>,
        Yahuda Yitschak <yehuday@marvell.com>,
        Hanna Hawa <hannah@marvell.com>,
        Neta Zur Hershkovits <neta@marvell.com>,
        Igal Liberman <igall@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>, linux-crypto@vger.kernel.org
To: Romain Perier <romain.perier@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40749 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932443AbcIHRCm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Sep 2016 13:02:42 -0400
Content-Disposition: inline
In-Reply-To: <57D18801.5050901@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 08, 2016 at 05:47:13PM +0200, Romain Perier wrote:
>
> I was wondering something. hwrng_unregister does not check the kref
> reference counter of the object... so technically if the current
> rng_device is in use, with or without devm... calling
> platform->remove will break the driver anyway because
> hwrng_unregister will unbind the device from /dev/hwrng. What I mean
> is that I think that we had this issue even without
> devm_hwrng_register.
> 
> Herbert, could you confirm ?

Right.  remove can happen at any time and the driver needs to
cope with it by returning an error from data_read if the hardware
disappears in the middle of an operation.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
