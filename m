From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [PATCH 0/6] Add support for ECDSA algorithm
Date: Wed, 23 Aug 2017 16:40:55 +0300
Message-ID: <cefbcaf7-8eaf-af34-dee3-4fd438febdab@microchip.com>
References: <1484912161-5932-1-git-send-email-nkumbhar@nvidia.com>
 <20170123142417.GD19957@gondor.apana.org.au>
 <113d3ef8-ef34-0651-71e7-be09ef55727e@nvidia.com>
 <20170202135721.GA5289@gondor.apana.org.au>
 <87fcb3cf-b8ae-47de-550e-c76ae47af431@microchip.com>
 <CACXcFmk5mAfjW=SSQm7SM7oP0orwrFJ6m5UaXVB76VwMyXcyKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Nitin Kumbhar <nkumbhar@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:52324 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754001AbdHWNlm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Aug 2017 09:41:42 -0400
In-Reply-To: <CACXcFmk5mAfjW=SSQm7SM7oP0orwrFJ6m5UaXVB76VwMyXcyKQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, Sandy,

On 08/22/2017 08:22 PM, Sandy Harris wrote:
> On Tue, Aug 22, 2017 at 12:14 PM, Tudor Ambarus
> <tudor.ambarus@microchip.com> wrote:
>> Hi, Herbert,
>>
>> On 02/02/2017 03:57 PM, Herbert Xu wrote:
>>>
>>> Yes but RSA had an in-kernel user in the form of module signature
>>> verification.  We don't add algorithms to the kernel without
>>> actual users.  So this patch-set needs to come with an actual
>>> in-kernel user of ECDSA.
>>
>>
>> ECDSA can be used by the kernel module signing facility too. Is there
>> any interest in using ECDSA by the kernel module signing facility?
> 
> I'd say keep it simple wherever possible; adding an algorithm should
> need "is required by" not just "can be used by".
> 
> Even then, there is room for questions. In particular, whether such a
> fragile algorithm should be trusted at all, let alone for signatures
> on infrastructure modules that the whole OS will trust.
> https://en.wikipedia.org/wiki/Elliptic_Curve_Digital_Signature_Algorithm#Security
> 

ECDSA is a better alternative to RSA for digital signatures assuming
that you don't have implementation bugs.

ECDSA requires a much smaller key length in order to provide the same
security strength as RSA (see [1]):

security strength | RSA key length (bits) | ECDSA key lengths (bits)
        112                   2048                    224-255
        128                   3072                    256-383

When comparing to RSA, ECDSA promises better computational efficiency,
signature size and bandwith (see [2]).

Cheers,
ta

[1] NIST.SP.800-57pt1r4, section 5.6.1,  table 2
[2] rfc4754, rfc6979
