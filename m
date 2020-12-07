Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71364C4167B
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 00:16:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D07B22E03
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 00:16:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgLGAQc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 6 Dec 2020 19:16:32 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:32932 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgLGAQb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Dec 2020 19:16:31 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607300149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ws2ScGMjp86jp8aHAXXrqSbAWewd2teUNridlmZ/6nU=;
        b=hObnEdDAUiea928sQD8eEjcFoa7xTGkA5Wrk+UrTBzGfk+TftgXZSxaS4mbNZaIMnV9LWw
        h051BZDdNBMI5F6ltSchjzct4Cz0uwC4TSi/9tbxzpGOsQ6PtbFvKpeL0SPFFKA9I3kgiM
        xNVHO/oiee+l3R/Stfmrdb5gnuMgBTpU7//9PAuTJRZ5EPQUPutDwdpNDAp0AwBpXzuXZW
        eHAeEKkHAW2x4oQ0XhMtAAxvBi2A7BBySb5/4nFB05gVF86Yo6aEfwu4xrauBxu2eo2vbY
        Kg3m8wbG2dhN9OVq3UDeKVUu/AUZ5kbhbf39aoLEawU8ZMQZo3xA39WZa99w7Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607300149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ws2ScGMjp86jp8aHAXXrqSbAWewd2teUNridlmZ/6nU=;
        b=dSiJdSaW9yvM0UV8QDwe4Y4I1tZqsK8VBGlAz+ESmfKIGhPFx3824WD/vZfGjE35osK2Ob
        a6xKQVyNOhNAJFDQ==
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     herbert@gondor.apana.org.au, mripard@kernel.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-mm@kvack.org, Andrew Morton <akpm@linuxfoundation.org>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: crypto: sun4i-ss: error with kmap
In-Reply-To: <20201206214053.GA8458@Red>
References: <20201202195501.GA29296@Red> <877dpzexfr.fsf@nanos.tec.linutronix.de> <20201203173846.GA16207@Red> <87r1o6bh1u.fsf@nanos.tec.linutronix.de> <20201204132631.GA25321@Red> <874kl1bod0.fsf@nanos.tec.linutronix.de> <20201204192753.GA19782@Red> <87wnxx9tle.fsf@nanos.tec.linutronix.de> <20201205184334.GA8034@Red> <87mtys8268.fsf@nanos.tec.linutronix.de> <20201206214053.GA8458@Red>
Date:   Mon, 07 Dec 2020 01:15:49 +0100
Message-ID: <87ft4i79oq.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Dec 06 2020 at 22:40, Corentin Labbe wrote:
> On Sat, Dec 05, 2020 at 08:48:15PM +0100, Thomas Gleixner wrote:
>> So this maps two pages and unmaps the first one. That's all called from
>> sun4i_ss_opti_poll() and the bug is clearly visible there:
>> 
>> 	sg_miter_next(&mi);
>> 	sg_miter_next(&mo);
>> 
>> release_ss:
>> 	sg_miter_stop(&mi);
>> 	sg_miter_stop(&mo);
>> 
>> Written by yourself :) Same issue in sun4i_ss_cipher_poll()
>> 
>> Fix below.
>> 
>
> Unfortunatly, the crash still happen with the fix.
> See http://kernel.montjoie.ovh/131321.log

And why are you not looking for the reason of this problem in your own
code yourself? It's not a regression caused by my work.

Turn on CONFIG_DEBUG_HIGHMEM on 5.10-rcX or older kernels and you will
get the very same crashes. My work just made these checks unconditional.

This was broken forever and it's not my problem that you did not enable
mandatory debug options when developing this thing.

I gave you tons of hints by now how to debug this and what to look
for. Obviously I overlooked something and here is the final hint:

 	sg_miter_next(&mi);
 	sg_miter_next(&mo);

        do {
           ....
           if (cond1)
               sg_miter_next(&mi);      <--- HINT
           ....
           if (cond2)
               sg_miter_next(&mo);
 
release_ss:
 	sg_miter_stop(&mi);
 	sg_miter_stop(&mo);

So yes, I overlooked the obvious, but as I said above it's not something
which my is failing due to my changes. It was broken forever, it just
was not tested properly. Don't blame the messenger.

My knowledge about how to use nested sg_miter correctly is close to
zero. I can and did explain you the rules of kmap_atomic/local() but
that's it.

Thanks,

        tglx
