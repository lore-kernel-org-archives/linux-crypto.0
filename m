From: Gary R Hook <ghook@amd.com>
Subject: Re: [PATCH] crypto: ccp - Fix handling of RSA exponent on a v5 device
Date: Wed, 16 Nov 2016 11:25:19 -0600
Message-ID: <368b41ee-45e3-c330-10c5-16fcc22d3d16@amd.com>
References: <20161101190505.1191.20536.stgit@taos>
 <20161113094921.GB7399@gondor.apana.org.au>
 <60b38fe7-e08e-05c4-8316-e2408bef2f33@amd.com>
 <20161116090125.GC29644@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Gary R Hook <gary.hook@amd.com>, <linux-crypto@vger.kernel.org>,
        <thomas.lendacky@amd.com>, <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-co1nam03on0081.outbound.protection.outlook.com ([104.47.40.81]:19959
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751670AbcKPRZf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Nov 2016 12:25:35 -0500
In-Reply-To: <20161116090125.GC29644@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11/16/2016 03:01 AM, Herbert Xu wrote:
> On Tue, Nov 15, 2016 at 03:41:25PM -0600, Gary R Hook wrote:
>> On 11/13/2016 03:49 AM, Herbert Xu wrote:
>>> On Tue, Nov 01, 2016 at 02:05:05PM -0500, Gary R Hook wrote:
>>>> The exponent size in the ccp_op structure is in bits. A v5
>>>> CCP requires the exponent size to be in bytes, so convert
>>>> the size from bits to bytes when populating the descriptor.
>>>>
>>>> The current code references the exponent in memory, but
>>>> these fields have not been set since the exponent is
>>>> actually store in the LSB. Populate the descriptor with
>>>> the LSB location (address).
>>>>
>>>> Signed-off-by: Gary R Hook <gary.hook@amd.com>
>>>
>>> Patch applied.  Thanks.
>>>
>>
>> Thanks, Herbert.
>>
>> Is there a possibility of getting this pushed to 4.9, being
>> it's a bug fix?
>
> I thought ccp doesn't support RSA yet or is there another entry
> path into this code?

The kernel crypto layer does not yet support RSA, true. However, we
designed the ccp.ko layer to be available to anyone that wants to use
it. The underlying module currently has differing behavior/results
between the v3 and v5 implementations of the RSA command function.
This patch fixes the borked v5 code.


-- 
This is my day job. Follow me at:
IG/Twitter/Facebook: @grhookphoto
IG/Twitter/Facebook: @grhphotographer
