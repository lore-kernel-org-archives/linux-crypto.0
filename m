From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: ecdh: generation and retention of ecc privkey in kernel/hardware
Date: Thu, 27 Apr 2017 18:55:13 +0200
Message-ID: <DE4B1DD4-6E10-48F1-83E9-C8254D5BE18F@holtmann.org>
References: <db7c370c-65b6-2a78-2a5d-87f7a4e43cea@microchip.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        =?utf-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>,
        Nicolas Ferre - M43238 <Nicolas.Ferre@microchip.com>,
        David Woodhouse <dwmw2@infradead.org>
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from coyote.holtmann.net ([212.227.132.17]:33969 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754077AbdD0QzQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Apr 2017 12:55:16 -0400
In-Reply-To: <db7c370c-65b6-2a78-2a5d-87f7a4e43cea@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Tudor,

> I'm working with a crypto accelerator that is capable of generating and
> retaining ecc private keys in hardware and further use them for ecdh.
> The private keys can not be read from the device. This is good because
> the less software has access to secrets, the better.
> 
> Generation and retention of ecc private keys are also helpful in a user
> space to kernel ecdh offload. The privkey can be generated in kernel and never revealed to user space.
> 
> I propose to extend the ecc software support to allow the generation of
> private keys. ECDH software implementation and drivers will permit the
> users to provide NULL keys. In this case, the kernel (or the device, if
> possible) will generate the ecc private key and further use it for ecdh.
> 
> What's your feeling on this?

can we represent these keys via keyctl as part of the kernel keyring? I think when it comes to asymmetric crypto and its keys, we need to have these as keys represented in kernel keyring. Recently we added keyctl features to sign, verify, encrypt and decrypt operations.

The crypto subsystem concept is broken when it comes to keys in hardware since it enforces the concept of always being able to fallback on a software implementation of the algorithm.

Regards

Marcel
