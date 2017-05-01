From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: ecdh: generation and retention of ecc privkey in kernel/hardware
Date: Mon, 01 May 2017 17:48:07 +0200
Message-ID: <1576175.e7clGeucrJ@positron.chronox.de>
References: <db7c370c-65b6-2a78-2a5d-87f7a4e43cea@microchip.com> <DE4B1DD4-6E10-48F1-83E9-C8254D5BE18F@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Tudor Ambarus <tudor.ambarus@microchip.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Nicolas Ferre - M43238 <Nicolas.Ferre@microchip.com>,
        David Woodhouse <dwmw2@infradead.org>
To: Marcel Holtmann <marcel@holtmann.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59410 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753778AbdEAPsJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 May 2017 11:48:09 -0400
In-Reply-To: <DE4B1DD4-6E10-48F1-83E9-C8254D5BE18F@holtmann.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 27. April 2017, 18:55:13 CEST schrieb Marcel Holtmann:

Hi Marcel,

> Hi Tudor,
> 
> > I'm working with a crypto accelerator that is capable of generating and
> > retaining ecc private keys in hardware and further use them for ecdh.
> > The private keys can not be read from the device. This is good because
> > the less software has access to secrets, the better.
> > 
> > Generation and retention of ecc private keys are also helpful in a user
> > space to kernel ecdh offload. The privkey can be generated in kernel and
> > never revealed to user space.
> > 
> > I propose to extend the ecc software support to allow the generation of
> > private keys. ECDH software implementation and drivers will permit the
> > users to provide NULL keys. In this case, the kernel (or the device, if
> > possible) will generate the ecc private key and further use it for ecdh.
> > 
> > What's your feeling on this?
> 
> can we represent these keys via keyctl as part of the kernel keyring? I
> think when it comes to asymmetric crypto and its keys, we need to have
> these as keys represented in kernel keyring. Recently we added keyctl
> features to sign, verify, encrypt and decrypt operations.

... as well as DH operations :-)

I would think that hardware support would fit into the keys DH framework just 
like it fits seamlessly into the kernel crypto API framework.

> 
> The crypto subsystem concept is broken when it comes to keys in hardware
> since it enforces the concept of always being able to fallback on a
> software implementation of the algorithm.

I do not think this argument is correct. The kernel crypto API requires that a 
key is set with a tfm -- i.e. a tfm is a representation of the "static" parts 
of a cipher instance (key, AAD-length, others). When you have a tfm that is 
ready for a cipher operation, all required data like a key must have been set 
with it. This tfm is now used with a "request" that defines the "volatile" 
data of the cipher operation.

For kpp the kernel crypto API may add one API call to generate a tfm without 
setting a real key, similar to my KPP AF_ALG proposal I aired a couple of days 
ago. Tudor's hardware could generate the key internally, whereas other 
implementations in the kernel could use a logical equivalent as the kpp_genkey 
function in [1].

I.e. if the key is provided by the caller, it should be taken by the tfm. If 
no key is provided or a null is provided, the DH implementation should 
generate the key and retain it with the tfm. That tfm then could be linked to 
by the keys framework.

[1] https://www.spinics.net/lists/linux-crypto/msg25296.html

Ciao
Stephan

PS: Marcel, could you comment on the kpp AF_ALG proposal I sent around some 
days ago? As DH operations are at the same time crypto operations and pure key 
management operations, I am not sure whether DH hardware should be 
externalized with an AF_ALG interface or keys interface. DH is a key 
management cipher type and thus fits with the keys framework, but AF_ALG 
provides an async interface. Further, when DH hardware is used to accelerate 
things like user space TLS / IKE / SSH or whatever, is the keys interface 
complete (think of scatter-gather-list / IOVEC handling offered by AF_ALG)?
