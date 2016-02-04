From: "Li, Weigang" <weigang.li@intel.com>
Subject: Re: [PATCH v2 04/10] crypto/compress: add asynchronous compression
 support
Date: Thu, 4 Feb 2016 11:25:27 +0800
Message-ID: <56B2C4A7.6060106@intel.com>
References: <1453796112-14273-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1453796112-14273-5-git-send-email-iamjoonsoo.kim@lge.com>
 <20160127074140.GA30335@gondor.apana.org.au> <56A878C9.8050202@intel.com>
 <20160127080355.GA31330@gondor.apana.org.au>
 <20160127080926.GA31516@gondor.apana.org.au>
 <20160128031941.GA14467@js1304-P5Q-DELUXE>
 <20160129100901.GA17272@gondor.apana.org.au>
 <20160201021141.GA32125@js1304-P5Q-DELUXE>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	"Dan Streetman" <ddstreet@ieee.org>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:19279 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377AbcBDDZb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Feb 2016 22:25:31 -0500
In-Reply-To: <20160201021141.GA32125@js1304-P5Q-DELUXE>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2/1/2016 10:11 AM, Joonsoo Kim wrote:
> On Fri, Jan 29, 2016 at 06:09:01PM +0800, Herbert Xu wrote:
>> On Thu, Jan 28, 2016 at 12:19:42PM +0900, Joonsoo Kim wrote:
>>>
>>> I have tested asynchronous compression APIs in zram and I saw
>>> regression. Atomic allocation and setting up SG lists are culprit
>>> for this regression. Moreover, zram optimizes linearisation
>>
>> So which is it, atomic allocations or setting up SG lists? There
>> is nothing in acomp that requires you to do an atomic allocation.
>
> Atomic allocation are called for linearisation when needed. Zram's
> compressed content is usually stored in two physically separate pages
> so linearisation is needed. See scomp_map().
>
> Setting up SG lists means that to use acomp, sg_init_table(),
> sg_set_page() are need to be called by zram unlike the case just
> passing the pointer based buffer.
>
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
Hello Herbert & Joonsoo,
Please can you advise how to get the acomp patch accepted?
