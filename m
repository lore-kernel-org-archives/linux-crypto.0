From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [PATCH 0/3] Introduce the cypto engine framework
Date: Tue, 2 Feb 2016 09:37:54 +0800
Message-ID: <CAMz4kuJwwbR=4ukZYBeB4brwvRxMkXzs2v-jRvP395rgHk7Xgg@mail.gmail.com>
References: <cover.1453810716.git.baolin.wang@linaro.org>
	<20160201143358.GA11410@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: David Miller <davem@davemloft.net>,
	Mark Brown <broonie@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yk0-f180.google.com ([209.85.160.180]:36293 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbcBBBhz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Feb 2016 20:37:55 -0500
Received: by mail-yk0-f180.google.com with SMTP id z7so93933721yka.3
        for <linux-crypto@vger.kernel.org>; Mon, 01 Feb 2016 17:37:54 -0800 (PST)
In-Reply-To: <20160201143358.GA11410@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 1 February 2016 at 22:33, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Jan 26, 2016 at 08:25:37PM +0800, Baolin Wang wrote:
>> Now block cipher engines need to implement and maintain their own queue/thread
>> for processing requests, moreover currently helpers provided for only the queue
>> itself (in crypto_enqueue_request() and crypto_dequeue_request()) but they
>> don't help with the mechanics of driving the hardware (things like running the
>> request immediately, DMA map it or providing a thread to process the queue in)
>> even though a lot of that code really shouldn't vary that much from device to
>> device.
>>
>> This patch introduces the crypto engine framework to help the crypto hardware
>> drivers to queue requests.
>
> Very nice, all applied.  Thanks!

Thanks a lot!

> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt



-- 
Baolin.wang
Best Regards
