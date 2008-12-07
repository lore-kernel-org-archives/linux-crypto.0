From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Runaway loop with the current git.
Date: Sun, 7 Dec 2008 16:09:21 +0000
Message-ID: <20081207160921.693f637a@lxorguk.ukuu.org.uk>
References: <20081207112335.0afd5192@lxorguk.ukuu.org.uk>
	<E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au>
	<20081207155507.GA15355@gondor.apana.org.au>
	<ac3eb2510812070803i150d91e7led58128796e8045e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, zbr@ioremap.net,
	linux-kernel@vger.kernel.org,
	"Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:32800 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754179AbYLGQLT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2008 11:11:19 -0500
In-Reply-To: <ac3eb2510812070803i150d91e7led58128796e8045e@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> Even when this works around it, the problem that the kernel triggers
> module loading on /dev/console access stays and needs to be fixed
> instead.

It isn't a problem. It is trying to have hotplug load a suitable driver.
This is what is supposed to happen.

Alan
