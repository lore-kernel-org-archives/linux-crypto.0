From: Gary R Hook <gary.hook@amd.com>
Subject: Re: [PATCH v2] hwrng: Clean up RNG list when last hwrng is
 unregistered
Date: Mon, 8 Jan 2018 08:38:45 -0600
Message-ID: <c1b8293d-328c-6846-c0cd-cd75cf5d3df3@amd.com>
References: <151336772989.60446.16322941485803241258.stgit@sosxen2.amd.com>
 <d2f7189e-8a25-0352-0e33-a3df26f18c37@amd.com>
 <20180108050520.GA1775@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
        davem@davemloft.net, prasannatsmkumar@gmail.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam03on0041.outbound.protection.outlook.com ([104.47.42.41]:5024
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932575AbeAHOiw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Jan 2018 09:38:52 -0500
In-Reply-To: <20180108050520.GA1775@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/07/2018 11:05 PM, Herbert Xu wrote:
> On Fri, Jan 05, 2018 at 11:28:23AM -0600, Gary R Hook wrote:
>>
>> It may not have been obvious from the title but this fixes a bug
>> which will impact the use of any HW RNG that is the only RNG
>> registered. The breakage of rmmod/modprobe -r that this fix obviates
>> suggests that it needs to make the 4.15 kernel, please. Just want to
>> ensure this gets the proper attention. Thank you.
> 
> I don't think breaking rmmod is sufficiently serious to warrant
> immediate inclusion at this point.  We can always send it via
> stable after the release.
> 
> Thanks,
> 

Oh. I just figured that problems introduced in a particular kernel level 
should be resolved (if possible) in that same level.

Your call, of course; thank you for the clarification.
