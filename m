From: Tapas Sarangi <TSarangi@trustwave.com>
Subject: Re: [PATCH v2] crypto: XTS - remove test that will fail in FIPS mode
Date: Wed, 17 Aug 2016 15:09:11 +0000
Message-ID: <D3D9E64F.30F1%tsarangi@trustwave.com>
References: <D3CF7065.28F3%tsarangi@trustwave.com>
 <16370043.OYgDIDmMpM@tauon.atsec.com> <D3D9E3A3.30E6%tsarangi@trustwave.com>
 <1521535.SOsKusk3RD@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from seg-node-elk-02.trustwave.com ([204.13.202.189]:4513 "EHLO
	seg-node-elk-02.trustwave.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752508AbcHQPJQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Aug 2016 11:09:16 -0400
In-Reply-To: <1521535.SOsKusk3RD@tauon.atsec.com>
Content-Language: en-US
Content-ID: <FEEF207B3909C04FB557E4051A93941E@namprd07.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,



On 8/17/16, 9:57 AM, "Stephan Mueller" <smueller@chronox.de> wrote:

>Am Mittwoch, 17. August 2016, 14:52:32 CEST schrieb Tapas Sarangi:
>
>Hi Tapas,
>
>(please, do not top-post)

DNT, Sorry.

>
>> Hi Stephan,
>>
>> Yes, can you give me some more detail about your findings on dracut-fips
>> !? This seems to be the major difference between our test environments
>> where a bunch of algorithms are failing self-test during boot with
>>fips=1.
>
>cmac must be statically compiled as otherwise dracut-fips does not find
>it (it
>misses it in the module list).
>
>The authenc() cipher must not be compiled as somehow the modprobe in
>dracut-
>fips does not find some components -- I am not sure what the issue is
>yet. I
>even have compiled all parts forming an authenc cipher (authenc, hmac,
>the
>hashes, the block chaining modes, the symmetric ciphers) to be bound into
>the
>kernel statically. But still, something is not found by the tcrypt module
>in
>dracut-fips.

Is that all the authenc() ciphers, or only some of them ? In my patch
where I had disabled .fips_allowed are mostly authenc() ciphers with
cbc(des3_ede) algo. Not all the authenc() ciphers were needed to be
disabled, but some.

For your XTS related findings and patches, are they going to 4.8 or 4.9 ?

Thanks
-Tapas


________________________________

This transmission may contain information that is privileged, confidential, and/or exempt from disclosure under applicable law. If you are not the intended recipient, you are hereby notified that any disclosure, copying, distribution, or use of the information contained herein (including any reliance thereon) is strictly prohibited. If you received this transmission in error, please immediately contact the sender and destroy the material in its entirety, whether in electronic or hard copy format.
