From: "Li, Weigang" <weigang.li@intel.com>
Subject: Re: [PATCH v2 04/10] crypto/compress: add asynchronous compression
 support
Date: Thu, 4 Feb 2016 11:50:46 +0800
Message-ID: <56B2CA96.4010104@intel.com>
References: <1453796112-14273-5-git-send-email-iamjoonsoo.kim@lge.com>
 <20160127074140.GA30335@gondor.apana.org.au> <56A878C9.8050202@intel.com>
 <20160127080355.GA31330@gondor.apana.org.au>
 <20160127080926.GA31516@gondor.apana.org.au>
 <20160128031941.GA14467@js1304-P5Q-DELUXE>
 <20160129100901.GA17272@gondor.apana.org.au>
 <20160201021141.GA32125@js1304-P5Q-DELUXE> <56B2C4A7.6060106@intel.com>
 <20160204032850.GA2060@gondor.apana.org.au>
 <20160204032945.GA2100@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	"Dan Streetman" <ddstreet@ieee.org>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:24894 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742AbcBDDut (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Feb 2016 22:50:49 -0500
In-Reply-To: <20160204032945.GA2100@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2/4/2016 11:29 AM, Herbert Xu wrote:
> On Thu, Feb 04, 2016 at 11:28:50AM +0800, Herbert Xu wrote:
>> On Thu, Feb 04, 2016 at 11:25:27AM +0800, Li, Weigang wrote:
>>>
>>> Please can you advise how to get the acomp patch accepted?
>>
>> Can you do a posting of these patches without scomp so we can
>> evaluate the effects?
>
> Of course you can keep the driver-side scomp interface as otherwise
> the implementation would be unnecessarily complicated.
>
> Cheers,
>
Seems I need go back to my first acomp patch.. Assuming we shall still 
keep the comp i/f, and the linearisation of sg-list in acomp to fit the 
"comp" API? What do you mean by the driver-side scomp? Thanks!
