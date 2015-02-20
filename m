From: Stephan Mueller <smueller@chronox.de>
Subject: Re: Intermediate Hash states
Date: Fri, 20 Feb 2015 20:37:29 +0100
Message-ID: <3307166.8E51TTmzB6@tachyon.chronox.de>
References: <CAHTT9VLHi6m8-NNS_MJ2cabNm2Eng18zs8iGqJudP1ANb-99Ww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: sri sowj <srisowj4linux@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60273 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195AbbBTThg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Feb 2015 14:37:36 -0500
Received: from tachyon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S166E4> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Fri, 20 Feb 2015 20:37:31 +0100
In-Reply-To: <CAHTT9VLHi6m8-NNS_MJ2cabNm2Eng18zs8iGqJudP1ANb-99Ww@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 19. Februar 2015, 21:48:30 schrieb sri sowj:

Hi sri,

> Hi ,
> 
> I am trying to understand Hashing Algorithms implementation in linux kernel
> .
> 
> I am really not sure on how to deal with following scenario.
> 
> assume when App1 is in middle of
> execution(crypto_ahash_init/update/update...) ,App2 sends a request
> may be from another cpu in multi-core system to underlying crypto
> driver .
> Then essentially input1 has to save its  state(intermediate Hash) and
> serves App2 request.
> 
> App1 ---------> Linux kernel crypto driver
> 
>        crypto_ahash_init(input1);
>         crypto_ahash_update(input1);
>        ..................
>        ..................
>         crypto_ahash_update(input1); // multple Hash requests
>        ..................
>        ..................
>     crypto_ahash_final()
> 
> 
> 
> App2 ---------> Linux kernel crypto driver
> 
>         crypto_ahash_init(input2);
>         crypto_ahash_update(input2);
> 
> 
> Here in this scenario how to track,save and restore the Hash state for App1
> ?

The ahash (ablkcipher too) uses kernel threads. Those are scheduled like 
normal processes, including the context switching.
> 
> BR,
> Srisowj
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ciao
Stephan
