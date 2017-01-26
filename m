From: Nitin Kumbhar <nkumbhar@nvidia.com>
Subject: Re: [PATCH 0/6] Add support for ECDSA algorithm
Date: Thu, 26 Jan 2017 11:30:04 +0530
Message-ID: <113d3ef8-ef34-0651-71e7-be09ef55727e@nvidia.com>
References: <1484912161-5932-1-git-send-email-nkumbhar@nvidia.com>
 <20170123142417.GD19957@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from hqemgate14.nvidia.com ([216.228.121.143]:13030 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751598AbdAZGAN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Jan 2017 01:00:13 -0500
In-Reply-To: <20170123142417.GD19957@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Herbert,

On 1/23/2017 7:54 PM, Herbert Xu wrote:
> On Fri, Jan 20, 2017 at 05:05:55PM +0530, Nitin Kumbhar wrote:
>> Hello,
>>
>> This patch series adds support for Elliptic Curve Digital Signature
>> Algorithm (ECDSA). To reuse existing ECC functionality, which is
>> added as part of ECDH, it separates out ECC and ECDH so that
>> only ECC functionality is available for ECDSA even when ECDH is in
>> a disabled state.
>>
>> Patch #1 restructures ECC and ECDH code such that ECC is not
>> dependent on ECDH config.
>>
>> Patches #2 & #3 add vli and ecc functions which are required
>> for other Elliptic curve algorithms like ECDSA and ECIES.
>>
>> Patch #4 adds support for ECDSA. This has been validated for P192
>> and P256 elliptic curves.
>>
>> Patches #5 and #6 add ECDSA tests to validate ECDSA functionality
>> and measure ECDSA performance.
>
> Who is going to use this in the kernel?

This ECDSA implementation is analogous to the RSA kernel implementation 
for signature generation / verification. It extends ECC family of 
algorithms like ECDH to support signature verification using akcipher. 
This will be used in a way similar to RSA.

>
> Thanks,
>

Regards,
- Nitin

-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
