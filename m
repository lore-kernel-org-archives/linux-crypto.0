From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: Runaway loop with the current git.
Date: Sun, 7 Dec 2008 19:31:51 +0300
Message-ID: <20081207163151.GA31838@ioremap.net>
References: <20081207112335.0afd5192@lxorguk.ukuu.org.uk> <E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au> <20081207155507.GA15355@gondor.apana.org.au> <ac3eb2510812070803i150d91e7led58128796e8045e@mail.gmail.com> <20081207160921.693f637a@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kay Sievers <kay.sievers@vrfy.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from corega.com.ru ([195.178.208.66]:58872 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754307AbYLGQbx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2008 11:31:53 -0500
Content-Disposition: inline
In-Reply-To: <20081207160921.693f637a@lxorguk.ukuu.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 07, 2008 at 04:09:21PM +0000, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > Even when this works around it, the problem that the kernel triggers
> > module loading on /dev/console access stays and needs to be fixed
> > instead.
> 
> It isn't a problem. It is trying to have hotplug load a suitable driver.
> This is what is supposed to happen.

Wrong. First at least because tty/console stuff is built in.
But we alredy got, that you decided that Debian's initramfs-tools (0.92e)
are allowed not to boot with some kernel configs.

-- 
	Evgeniy Polyakov
