From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [PATCH v8 0/4] crypto: add algif_akcipher user space API
Date: Wed, 30 Aug 2017 11:17:51 +0300
Message-ID: <e0f2d10e-ed0f-6ab8-59d8-c4296a7c678f@microchip.com>
References: <26359147.tCiuJ5s8mz@positron.chronox.de>
 <alpine.OSX.2.21.1708101619530.33607@cjee-mobl1.amr.corp.intel.com>
 <3151047.7kO17u1kNV@tauon.chronox.de>
 <1E882887-3F56-4A4C-AADF-2F25F4D3A7C9@holtmann.org>
 <92b13089-acbf-6cf9-6e03-24a3b58a4f41@microchip.com>
 <0e6735b2-52cd-6369-38a3-f8b1f8b5d84f@microchip.com>
 <A9698C42-3476-4DF6-A1E1-D8AFC9B86ABE@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
To: Marcel Holtmann <marcel@holtmann.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:22844 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751039AbdH3ISn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Aug 2017 04:18:43 -0400
In-Reply-To: <A9698C42-3476-4DF6-A1E1-D8AFC9B86ABE@holtmann.org>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, Marcel,

On 08/30/2017 10:21 AM, Marcel Holtmann wrote:
> you still need to get the public key out of the kernel if you want to use it from user space. Or feed the remote public key if you plan to use some sort of key derivation function.
> 

The crypto hardware that I'm working on, generates the private key
internally within the device and never reveals it to software and
immediately returns the public key pair. The user can retrieve the
public key from hardware.

> I am saying this again, if you only have a hammer, everything looks like a nail. What about actually looking at how this would be used from user space in real crypto cases.
> 
> My point is that the usages here are key generation, some sort of key-exchange-agreement (aka DH) and key derivation into a symmetric key. Frankly the focus with asymmetric ciphers are the keys and the key derivation. They are not encryption and decryption of massive amounts of data.

The hardware uses it's own private key and the public key received from
the other end and computes the ecdh shared secret. The hardware computed
shared secret can then be used for key derivation.

Cheers,
ta
