From: Axel Lin <axel.lin@ingics.com>
Subject: Re: [PATCH] crypto: sahara - Fix misuse of IS_ENABLED
Date: Tue, 11 Aug 2015 08:33:28 +0800
Message-ID: <CAFRkauDJ1FP5T6quccE_=p8n8eg4ceYXeukGw6v+Q=WnQjpR_g@mail.gmail.com>
References: <1439191116.22743.1.camel@ingics.com>
	<20150810073234.GC16990@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "David S. Miller" <davem@davemloft.net>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:36632 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932670AbbHKAda (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Aug 2015 20:33:30 -0400
Received: by lbbpu9 with SMTP id pu9so76893453lbb.3
        for <linux-crypto@vger.kernel.org>; Mon, 10 Aug 2015 17:33:28 -0700 (PDT)
In-Reply-To: <20150810073234.GC16990@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

2015-08-10 15:32 GMT+08:00 Herbert Xu <herbert@gondor.apana.org.au>:
> On Mon, Aug 10, 2015 at 03:18:36PM +0800, Axel Lin wrote:
>> IS_ENABLED should only be used for CONFIG_* symbols.
>> So use #ifdef DEBUG instead.
>>
>> Signed-off-by: Axel Lin <axel.lin@ingics.com>
>
> Nack.  While the abuse is certainly wrong you're removing compiler
> coverage over code which is worse.
>
> PLease find a way to remove the IS_ENABLED abuse without causing
> the code in question to lose compiler coverage.

I don't get it.

sahara_decode_status/sahara_dump_descriptors/sahara_dump_links functions
are mainly debug code. In original code, if IS_ENABLED(DEBUG) is false,
these functions return immediately.
DEBUG is defined or not is compile time determinated, so I don't understand
that "removing compiler coverage over code which is worse".
