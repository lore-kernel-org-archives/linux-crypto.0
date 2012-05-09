From: Andreas WESTIN <andreas.westin@stericsson.com>
Subject: Re: [PATCH 1/2] mach-ux500: Crypto: core support for CRYP/HASH module.
Date: Wed, 9 May 2012 10:51:22 +0200
Message-ID: <4FAA300A.9090000@stericsson.com>
References: <1336476513-17145-1-git-send-email-andreas.westin@stericsson.com> <1336476513-17145-2-git-send-email-andreas.westin@stericsson.com> <201205081937.24450.arnd@arndb.de> <CACRpkdaEV-vMjh-ObWuJ3AyqVZyG1QNbzOkz8OZ7E+rNaPSZUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Arnd Bergmann <arnd@arndb.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
	"lee.jones@linaro.org" <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:53914 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757903Ab2EIIvx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 May 2012 04:51:53 -0400
In-Reply-To: <CACRpkdaEV-vMjh-ObWuJ3AyqVZyG1QNbzOkz8OZ7E+rNaPSZUQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 2012-05-09 10:36, Linus Walleij wrote:
>> This needs an explanation! Why do you export an internal data structure
>> to non-GPL modules?
>
> This does not look like it's needed at all, none of the other two patches use
> it. Andreas can you just drop this hunk of the patch?

It is needed if you compile the drivers as modules, but it should be a 
GPL export. I will change it.

Cheers
Andreas
