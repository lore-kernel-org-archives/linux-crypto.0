From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/2] mach-ux500: Crypto: core support for CRYP/HASH module.
Date: Wed, 9 May 2012 12:17:30 +0000
Message-ID: <201205091217.30631.arnd@arndb.de>
References: <1336476513-17145-1-git-send-email-andreas.westin@stericsson.com> <CACRpkdaEV-vMjh-ObWuJ3AyqVZyG1QNbzOkz8OZ7E+rNaPSZUQ@mail.gmail.com> <4FAA300A.9090000@stericsson.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Linus Walleij <linus.walleij@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
	"lee.jones@linaro.org" <lee.jones@linaro.org>
To: Andreas WESTIN <andreas.westin@stericsson.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:60801 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758646Ab2EIMRp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 May 2012 08:17:45 -0400
In-Reply-To: <4FAA300A.9090000@stericsson.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday 09 May 2012, Andreas WESTIN wrote:
> On 2012-05-09 10:36, Linus Walleij wrote:
> >> This needs an explanation! Why do you export an internal data structure
> >> to non-GPL modules?
> >
> > This does not look like it's needed at all, none of the other two patches use
> > it. Andreas can you just drop this hunk of the patch?
> 
> It is needed if you compile the drivers as modules, but it should be a 
> GPL export. I will change it.

How about using distinct identification strings for each version of the
crypto hardware? The driver should really only care about what kind
of device it is talking to, not which SoC it is built into.

	Arnd
