From: Dan Streetman <ddstreet@ieee.org>
Subject: Re: [PATCH] crypto: add asynchronous compression support
Date: Wed, 28 Oct 2015 19:13:31 -0400
Message-ID: <CALZtONAF1oWXyERBc=yG4c6tR2vH--3QZxGADuz3NeDL80=Pyw@mail.gmail.com>
References: <1445008260-39367-1-git-send-email-weigang.li@intel.com>
 <20151016151354.GA16648@gondor.apana.org.au> <929511EA6367314D8E32364A24D45FA612FE85D3@shsmsx102.ccr.corp.intel.com>
 <000e01d10a12$9e381660$daa84320$@lge.com> <20151019084905.GE963@bbox>
 <20151021073322.GA31901@swordfish> <20151021073418.GA14479@gondor.apana.org.au>
 <929511EA6367314D8E32364A24D45FA612FED34B@shsmsx102.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Seth Jennings <sjennings@variantweb.net>,
	"Struk, Tadeusz" <tadeusz.struk@intel.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: "Li, Weigang" <weigang.li@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:33652 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbbJ1XOM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 Oct 2015 19:14:12 -0400
Received: by igvi2 with SMTP id i2so13423828igv.0
        for <linux-crypto@vger.kernel.org>; Wed, 28 Oct 2015 16:14:11 -0700 (PDT)
In-Reply-To: <929511EA6367314D8E32364A24D45FA612FED34B@shsmsx102.ccr.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 21, 2015 at 3:59 AM, Li, Weigang <weigang.li@intel.com> wrote:
>> -----Original Message-----
>> From: Herbert Xu [mailto:herbert@gondor.apana.org.au]
>> Sent: Wednesday, October 21, 2015 3:34 PM
>> To: Sergey Senozhatsky
>> Cc: Minchan Kim; Joonsoo Kim; Dan Streetman; Seth Jennings; Li, Weigang;
>> Struk, Tadeusz
>> Subject: Re: [PATCH] crypto: add asynchronous compression support
>>
>> On Wed, Oct 21, 2015 at 04:33:22PM +0900, Sergey Senozhatsky wrote:
>> >
>> > the thing is -- I still want to have/use SW compressors; and they [the
>> > existing S/W algorithms] want virtual addresses. so we need to
>> > kmap_atomic pages in every SW algorithm? isn't it simpler to keep
>> > kmap_atomic_to_page around?
>>
>> The Crypto API will do it for you.  Have a look at how we handle it for aead
>> and ahash for example.
>>
>> Cheers,
>> --
>> Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page:
>> http://gondor.apana.org.au/~herbert/
>> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>
> Adding the "linux-crypto" list back to the latest discussion.

re: zswap, I suspect it won't be able to use async compression,
because when its store function returns the page must be available for
reallocation.  Of course, async compression can be useful elsewhere.
