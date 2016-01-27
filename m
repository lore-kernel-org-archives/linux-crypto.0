From: "Li, Weigang" <weigang.li@intel.com>
Subject: Re: [PATCH v2 04/10] crypto/compress: add asynchronous compression
 support
Date: Wed, 27 Jan 2016 16:26:16 +0800
Message-ID: <56A87F28.9050101@intel.com>
References: <1453796112-14273-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1453796112-14273-5-git-send-email-iamjoonsoo.kim@lge.com>
 <20160127074140.GA30335@gondor.apana.org.au> <56A878C9.8050202@intel.com>
 <20160127080355.GA31330@gondor.apana.org.au>
 <20160127080926.GA31516@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Joonsoo Kim <js1304@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Dan Streetman <ddstreet@ieee.org>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:27455 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbcA0I0V (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Jan 2016 03:26:21 -0500
In-Reply-To: <20160127080926.GA31516@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 1/27/2016 4:09 PM, Herbert Xu wrote:
> On Wed, Jan 27, 2016 at 04:03:55PM +0800, Herbert Xu wrote:
>> On Wed, Jan 27, 2016 at 03:59:05PM +0800, Li, Weigang wrote:
>>>
>>> The acomp is also SG-based, while scomp only accepts flat buffer.
>>
>> Right, but do we need a pointer-based scomp at all? IPComp would
>> certainly be better off with an SG-based interface.  Any other
>> users of compression are presumably dealing with large amounts
>> of data where an SG interface would make more sense.
>>
>> A pointer interface makes sense for shash because you may be hashing
>> 16 bytes at a time.  Nobody sane is going to be compressing 16 bytes,
>> or are they?
>
> Note that I'm fine with keeping an scomp interface underneath
> for those algorithms where the best way to handle SG input is
> to linearise things.  But I would prefer that this interface is
> not exposed to kernel users unless it is absolutely required.
>
> Cheers,
>
Thanks for your comments, Herbert. I Agree, SG-list based compression 
API makes more sense. Maybe Joonsoo can comment on this.
