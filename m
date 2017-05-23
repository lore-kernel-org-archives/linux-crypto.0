From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: ecdh: generation and retention of ecc privkey in kernel/hardware
Date: Tue, 23 May 2017 11:58:36 +0800
Message-ID: <20170523035836.GA12788@gondor.apana.org.au>
References: <db7c370c-65b6-2a78-2a5d-87f7a4e43cea@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        Nicolas Ferre - M43238 <Nicolas.Ferre@microchip.com>
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:47838 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1757335AbdEWD6x (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 May 2017 23:58:53 -0400
Content-Disposition: inline
In-Reply-To: <db7c370c-65b6-2a78-2a5d-87f7a4e43cea@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 27, 2017 at 05:17:58PM +0300, Tudor Ambarus wrote:
> Hi, Herbert,
> 
> I'm working with a crypto accelerator that is capable of generating and
> retaining ecc private keys in hardware and further use them for ecdh.
> The private keys can not be read from the device. This is good because
> the less software has access to secrets, the better.
> 
> Generation and retention of ecc private keys are also helpful in a user
> space to kernel ecdh offload. The privkey can be generated in kernel and
> never revealed to user space.
> 
> I propose to extend the ecc software support to allow the generation of
> private keys. ECDH software implementation and drivers will permit the
> users to provide NULL keys. In this case, the kernel (or the device, if
> possible) will generate the ecc private key and further use it for ecdh.
> 
> What's your feeling on this?

It sounds sane to me.

It does raise the question though whether we need the ability to set the
secret at all.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
