From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] crypto: ixp4xx: avoid uninitialized variable use
Date: Tue, 19 Jan 2016 16:03:50 +0100
Message-ID: <5000322.oxUQo4qxNF@wuerfel>
References: <4569235.PkyVAB6DSj@wuerfel> <20160119010021.GB5571@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net,
	Krzysztof =?utf-8?B?SGHFgmFzYQ==?= <khalasa@piap.pl>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:51428 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920AbcASPEO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Jan 2016 10:04:14 -0500
In-Reply-To: <20160119010021.GB5571@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tuesday 19 January 2016 09:00:21 Herbert Xu wrote:
> Subject: crypto: ixp4xx - Fix false lastlen uninitialised warning
> 
> This patch fixes a false positive uninitialised variable warning
> in aead_perform by moving the source processing in front of the
> destination processing, thus ensuring that the initialisation of
> lastlen is always visible to gcc.
> 
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 

I've checked that the warnings are now gone, and after reviewing the
code again, I see now that it was indeed a false positive,
contrary to what I thought before.

Patch looks good.

Acked-by: Arnd Bergmann <arnd@arndb.de>
