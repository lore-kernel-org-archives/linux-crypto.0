From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: Runaway loop with the current git.
Date: Sun, 7 Dec 2008 17:21:01 +0100
Message-ID: <ac3eb2510812070821w53ffccfbn73ac40d6a1380553@mail.gmail.com>
References: <20081207112335.0afd5192@lxorguk.ukuu.org.uk>
	 <E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au>
	 <20081207155507.GA15355@gondor.apana.org.au>
	 <ac3eb2510812070803i150d91e7led58128796e8045e@mail.gmail.com>
	 <20081207160921.693f637a@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, zbr@ioremap.net,
	linux-kernel@vger.kernel.org,
	"Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.183]:31203 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228AbYLGQVD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2008 11:21:03 -0500
Received: by ik-out-1112.google.com with SMTP id c29so592241ika.5
        for <linux-crypto@vger.kernel.org>; Sun, 07 Dec 2008 08:21:01 -0800 (PST)
In-Reply-To: <20081207160921.693f637a@lxorguk.ukuu.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 7, 2008 at 17:09, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Even when this works around it, the problem that the kernel triggers
>> module loading on /dev/console access stays and needs to be fixed
>> instead.
>
> It isn't a problem. It is trying to have hotplug load a suitable driver.
> This is what is supposed to happen.

No, it's not. 5:1 is _in_ the kernel, and must not be tried to be
loaded by the kernel. We need to make /dev/console access return
-ENODEV if not available, not try to load a module for it.

It is a problem. It's broken behavior, and it breaks shipped products
with any innocent future driver change like Herbert's.

Please start to think about the problem, and don't repeat things that
do not make sense, and never made any sense.

Thanks,
Kay
