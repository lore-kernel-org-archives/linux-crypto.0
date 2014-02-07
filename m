From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [RFC PATCH 0/3] support for interleaving in generic chaining modes
Date: Fri, 7 Feb 2014 10:51:08 +0100
Message-ID: <CAKv+Gu_uZRYqhi_8ReKabBGJxtKQSR4X4DJBse4muDOMMMf8Ww@mail.gmail.com>
References: <1391689504-28160-1-git-send-email-ard.biesheuvel@linaro.org>
	<20140207022335.GA27694@gondor.apana.org.au>
	<CAKv+Gu-4J6jO135QgNrLrEX96U7aS7k4BE82j9ZLzwe60HfTTQ@mail.gmail.com>
	<20140207092304.GA2573@gondor.apana.org.au>
	<CAKv+Gu_kQFA26Ntc1p1yNRpxfJd8xgk27OnS7LG4V5qzH5NBjg@mail.gmail.com>
	<20140207094406.GA3012@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:42884 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbaBGJvL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Feb 2014 04:51:11 -0500
Received: by mail-lb0-f180.google.com with SMTP id n15so2390570lbi.25
        for <linux-crypto@vger.kernel.org>; Fri, 07 Feb 2014 01:51:09 -0800 (PST)
In-Reply-To: <20140207094406.GA3012@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 7 February 2014 10:44, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Fri, Feb 07, 2014 at 10:42:14AM +0100, Ard Biesheuvel wrote:
>>
>> Another example is bit sliced AES like the implementation in
>> arch/arm/crypto. It is 45% faster than the ordinary ARM asm
>> implementation, but its natural chunk size is 8 blocks. Passing fewer
>> blocks hurts performance, while passing more blocks does not give any
>> additional benefit at all.
>>
>> So in many cases, it would be good to know the preferred chunk size of
>> an algorithm.
>
> So are there cases where passing more blocks hurt the performance
> or not?
>

>From the point of the core algo implementation, probably not, it just
levels off asymptotically.

So i get your point: I will have a go at passing the entire buffer to
ecb(%s), and then wrapping the chaining mode around that.
I guess you don't think the (avoidable) additional memory usage is a concern?

-- 
Ard.
