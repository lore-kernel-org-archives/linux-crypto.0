From: "Li, Weigang" <weigang.li@intel.com>
Subject: Re: [PATCH v2 04/10] crypto/compress: add asynchronous compression
 support
Date: Wed, 27 Jan 2016 15:59:05 +0800
Message-ID: <56A878C9.8050202@intel.com>
References: <1453796112-14273-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1453796112-14273-5-git-send-email-iamjoonsoo.kim@lge.com>
 <20160127074140.GA30335@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	"Dan Streetman" <ddstreet@ieee.org>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Joonsoo Kim <js1304@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:59036 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698AbcA0H7I (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Jan 2016 02:59:08 -0500
In-Reply-To: <20160127074140.GA30335@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 1/27/2016 3:41 PM, Herbert Xu wrote:
> On Tue, Jan 26, 2016 at 05:15:06PM +0900, Joonsoo Kim wrote:
>> From: Weigang Li <weigang.li@intel.com>
>>
>> Now, asynchronous compression APIs are supported. There is no asynchronous
>> compression driver now but this APIs can be used as front-end to
>> synchronous compression algorithm. In this case, scatterlist would be
>> linearlized when needed so it would cause some overhead.
>>
>> Signed-off-by: Weigang Li <weigang.li@intel.com>
>> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
> I think we should be able to use this for the synchronous case
> too, like we do with skcipher and ahash.
>
> The main difference that I can see right now is that acomp always
> allocates a context through the request object while scomp does not.
>
> This difference is entirely artificial as we could also make the
> context conditional for acomp.
>
> The reason we had the shash/ahash division is because the shash
> interface offers a direct pointer interface while ahash is SG-based.
> Otherwise ahash is just as able as shash to handle synchronous
> requests.
>
> At this point in time I don't see such a fundamental distinction
> between acomp and scomp.
>
> Cheers,
>
The acomp is also SG-based, while scomp only accepts flat buffer.
