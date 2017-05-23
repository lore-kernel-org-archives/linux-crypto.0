From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: ecdh: generation and retention of ecc privkey in kernel/hardware
Date: Tue, 23 May 2017 11:06:53 +0300
Message-ID: <99d85bf6-5bd1-6c4e-9ffa-91ce81c846d8@microchip.com>
References: <db7c370c-65b6-2a78-2a5d-87f7a4e43cea@microchip.com>
 <20170523035836.GA12788@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>,
        =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>,
        Nicolas Ferre - M43238 <Nicolas.Ferre@microchip.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:41673 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753236AbdEWIG5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 May 2017 04:06:57 -0400
In-Reply-To: <20170523035836.GA12788@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 23.05.2017 06:58, Herbert Xu wrote:
> On Thu, Apr 27, 2017 at 05:17:58PM +0300, Tudor Ambarus wrote:
>> Hi, Herbert,
>>
>> I'm working with a crypto accelerator that is capable of generating and
>> retaining ecc private keys in hardware and further use them for ecdh.
>> The private keys can not be read from the device. This is good because
>> the less software has access to secrets, the better.
>>
>> Generation and retention of ecc private keys are also helpful in a user
>> space to kernel ecdh offload. The privkey can be generated in kernel and
>> never revealed to user space.
>>
>> I propose to extend the ecc software support to allow the generation of
>> private keys. ECDH software implementation and drivers will permit the
>> users to provide NULL keys. In this case, the kernel (or the device, if
>> possible) will generate the ecc private key and further use it for ecdh.
>>
>> What's your feeling on this?
> 
> It sounds sane to me.
> 
> It does raise the question though whether we need the ability to set the
> secret at all.

Ephemeral-Static Mode is a must in rfc2631[1], so the ability of using
a static key pair.

Thanks,
ta

[1]https://www.ietf.org/rfc/rfc2631.txt
