From: Gary R Hook <ghook@amd.com>
Subject: Re: [PATCH] crypto: ccp - Fix handling of RSA exponent on a v5 device
Date: Tue, 15 Nov 2016 15:41:25 -0600
Message-ID: <60b38fe7-e08e-05c4-8316-e2408bef2f33@amd.com>
References: <20161101190505.1191.20536.stgit@taos>
 <20161113094921.GB7399@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <thomas.lendacky@amd.com>,
        <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-cys01nam02on0065.outbound.protection.outlook.com ([104.47.37.65]:56938
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752497AbcKOV4g (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Nov 2016 16:56:36 -0500
In-Reply-To: <20161113094921.GB7399@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11/13/2016 03:49 AM, Herbert Xu wrote:
> On Tue, Nov 01, 2016 at 02:05:05PM -0500, Gary R Hook wrote:
>> The exponent size in the ccp_op structure is in bits. A v5
>> CCP requires the exponent size to be in bytes, so convert
>> the size from bits to bytes when populating the descriptor.
>>
>> The current code references the exponent in memory, but
>> these fields have not been set since the exponent is
>> actually store in the LSB. Populate the descriptor with
>> the LSB location (address).
>>
>> Signed-off-by: Gary R Hook <gary.hook@amd.com>
>
> Patch applied.  Thanks.
>

Thanks, Herbert.

Is there a possibility of getting this pushed to 4.9, being
it's a bug fix?

-- 
This is my day job. Follow me at:
IG/Twitter/Facebook: @grhookphoto
IG/Twitter/Facebook: @grhphotographer
