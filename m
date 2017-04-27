From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: ecdh: generation and retention of ecc privkey in kernel/hardware
Date: Thu, 27 Apr 2017 17:17:58 +0300
Message-ID: <db7c370c-65b6-2a78-2a5d-87f7a4e43cea@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>,
        =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>,
        Nicolas Ferre - M43238 <Nicolas.Ferre@microchip.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:41265 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937599AbdD0OSE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Apr 2017 10:18:04 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, Herbert,

I'm working with a crypto accelerator that is capable of generating and
retaining ecc private keys in hardware and further use them for ecdh.
The private keys can not be read from the device. This is good because
the less software has access to secrets, the better.

Generation and retention of ecc private keys are also helpful in a user
space to kernel ecdh offload. The privkey can be generated in kernel and 
never revealed to user space.

I propose to extend the ecc software support to allow the generation of
private keys. ECDH software implementation and drivers will permit the
users to provide NULL keys. In this case, the kernel (or the device, if
possible) will generate the ecc private key and further use it for ecdh.

What's your feeling on this?

Thanks,
ta
