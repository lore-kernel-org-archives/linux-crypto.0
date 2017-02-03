From: Nitin Kumbhar <nkumbhar@nvidia.com>
Subject: Re: [PATCH 0/6] Add support for ECDSA algorithm
Date: Fri, 3 Feb 2017 16:46:50 +0530
Message-ID: <fd0c8ea7-dd8e-854b-e09a-9859e54735a6@nvidia.com>
References: <1484912161-5932-1-git-send-email-nkumbhar@nvidia.com>
 <20170123142417.GD19957@gondor.apana.org.au>
 <113d3ef8-ef34-0651-71e7-be09ef55727e@nvidia.com>
 <20170202135721.GA5289@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <nkumbhar@nvidia.com>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from hqemgate15.nvidia.com ([216.228.121.64]:14586 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752514AbdBCLRC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Feb 2017 06:17:02 -0500
In-Reply-To: <20170202135721.GA5289@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Herbert,

On 2/2/2017 7:27 PM, Herbert Xu wrote:
> On Thu, Jan 26, 2017 at 11:30:04AM +0530, Nitin Kumbhar wrote:
>>
>> This ECDSA implementation is analogous to the RSA kernel implementation for
>> signature generation / verification. It extends ECC family of algorithms
>> like ECDH to support signature verification using akcipher. This will be
>> used in a way similar to RSA.
>
> Yes but RSA had an in-kernel user in the form of module signature
> verification.  We don't add algorithms to the kernel without
> actual users.  So this patch-set needs to come with an actual
> in-kernel user of ECDSA.

If this is about ECC in kernel then ECDSA extends ECDH which is from ECC 
and already part of kernel.

If none of the above are sufficient for now then let these patches come 
along with a consumer or let kernel add ECDSA based on akcipher as part 
of a crypto engine.

Nonetheless, how about rest of the vli and ECC patches?

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
