From: Gary R Hook <ghook@amd.com>
Subject: Re: [PATCH] crypto: ccp - Fix handling of RSA exponent on a v5 device
Date: Thu, 17 Nov 2016 08:22:16 -0600
Message-ID: <ffaa6f51-2496-63fa-4f5d-05d1d5c6ae32@amd.com>
References: <20161101190505.1191.20536.stgit@taos>
 <20161113094921.GB7399@gondor.apana.org.au>
 <60b38fe7-e08e-05c4-8316-e2408bef2f33@amd.com>
 <20161116090125.GC29644@gondor.apana.org.au>
 <368b41ee-45e3-c330-10c5-16fcc22d3d16@amd.com>
 <20161117131447.GA2029@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <thomas.lendacky@amd.com>,
        <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0077.outbound.protection.outlook.com ([104.47.34.77]:37952
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753268AbcKQQ5Y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Nov 2016 11:57:24 -0500
In-Reply-To: <20161117131447.GA2029@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11/17/2016 07:14 AM, Herbert Xu wrote:
> On Wed, Nov 16, 2016 at 11:25:19AM -0600, Gary R Hook wrote:
>>
>> The kernel crypto layer does not yet support RSA, true. However, we
>> designed the ccp.ko layer to be available to anyone that wants to use
>> it. The underlying module currently has differing behavior/results
>> between the v3 and v5 implementations of the RSA command function.
>> This patch fixes the borked v5 code.
>
> Do you mean that an out-of-tree module could enter the buggy
> code path?

I mean that anything that can call ccp_run_cmd() (in ccp.ko) can run
into a problem, yes. Is this likely? We don't know, as we don't know
if anyone actually uses this layer. But it _is_ possible to find the
problem.

-- 
This is my day job. Follow me at:
IG/Twitter/Facebook: @grhookphoto
IG/Twitter/Facebook: @grhphotographer
