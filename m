From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [PATCH v8 0/4] crypto: add algif_akcipher user space API
Date: Wed, 30 Aug 2017 09:15:06 +0300
Message-ID: <0e6735b2-52cd-6369-38a3-f8b1f8b5d84f@microchip.com>
References: <26359147.tCiuJ5s8mz@positron.chronox.de>
 <alpine.OSX.2.21.1708101619530.33607@cjee-mobl1.amr.corp.intel.com>
 <3151047.7kO17u1kNV@tauon.chronox.de>
 <1E882887-3F56-4A4C-AADF-2F25F4D3A7C9@holtmann.org>
 <92b13089-acbf-6cf9-6e03-24a3b58a4f41@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Stephan Mueller <smueller@chronox.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        <dhowells@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:2104 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751302AbdH3GPa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Aug 2017 02:15:30 -0400
In-Reply-To: <92b13089-acbf-6cf9-6e03-24a3b58a4f41@microchip.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, Herbert, all,

akcipher can work with its own internal keys, now that we have crypto
accelerators that can generate keys that never leave the hardware. Going
through the kernel's key subsystem seems superfluous in this case.

I also understand the need of going through the kernel's key subsystem
when the user wants to refer to a key which exists elsewhere, such as in
TPM or within an SGX software enclave, but this seems orthogonal with
crypto accelerators with key generation and retention support.

How should we interface akcipher/kpp with user-space?

Thanks,
ta

On 08/17/2017 04:17 PM, Tudor Ambarus wrote:
> Hi, all,
> 
> On 08/11/2017 07:05 PM, Marcel Holtmann wrote:
>> Hi Stephan,
>>
>>>> AF_ALG is best suited for crypto use cases where a socket is set up 
>>>> once
>>>> and there are lots of reads and writes to justify the setup cost. With
>>>> asymmetric crypto, the setup cost is high when you might only use the
>>>> socket for a brief time to do one verify or encrypt operation.
>>>
>>> To me, the entire AF_ALG purpose is solely to export hardware support 
>>> to user
>>> space. That said, if user space wants an accelerator, a socket would 
>>> be opened
>>> once followed by numerous read/write requests.
>>>
>>> Besides, I am aware of Tadeusz' patch to link algif_akcipher to the 
>>> keyring
>>> and I planned to port it to the current implementation. But I thought 
>>> I offer
>>> a small patch focusing on the externalization of the akcipher API first.
>>>
>>> I think the keyctl and AF_ALG are no opponents, but rather are 
>>> orthogonal to
>>> each other. The statement I made for the KPP AF_ALG RFC applies here 
>>> too:
>>>
>>> """
>>> I am aware and in fact supported development of the DH support in the 
>>> keys
>>> subsystem. The question will be raised whether the AF_ALG KPP 
>>> interface is
>>> superfluous in light of the keys DH support. My answer is that AF_ALG 
>>> KPP is
>>> orthogonal to the keys DH support. The keys DH support use case is that
>>> the keys are managed inside the kernel and thus has the focus on the
>>> key management. Contrary, AF_ALG KPP does not really focus on key 
>>> management
>>> but simply externalizes the DH/ECDH support found in the kernel 
>>> including
>>> hardware acceleration. User space is in full control of the key life 
>>> cycle.
>>> This way, AF_ALG could be used to complement user-space network protocol
>>> implementations like TLS or IKE to offload the resource intense DH
>>> calculations to accelerators.
>>> “""
>>
>> we do not need two interfaces for doing the same thing. Especially not 
>> one that can not handle hardware backed keys. And more important if 
>> you can not abstract an accelerator that doesn’t expose the private 
>> key at all.
> 
> I'm working with a crypto accelerator (find it at [1]) that is capable
> of generating random ecc private keys internally within the device that
> are never revealed outside of it. The keys can be further used for ECDH
> and ECDSA.
> 
> The simplest way to access my device from user-space is to go through
> af_alg. We can permit the users to provide NULL keys, and if so, we can
> generate the keys inside the kernel/hardware. If hardware supports
> key generation and retention, it will use it, else the keys
> will be generated inside the kernel. Either way it's a win, we don't
> reveal the private keys to user-space. Going through the keyring
> subsystem seems superfluous in this case.
> 
> My use case compared with the one of using keyring subsystem to access
> keys from TPMs or Intel's sgx enclave seem orthogonal. What do you
> think?
> 
> Cheers,
> ta
> 
> [1] http://www.microchip.com/wwwproducts/en/ATECC508A
> The driver can be found in drivers/crypto/atmel-ecc* in Herbert's tree.
