From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] crypto: hide unused label
Date: Wed, 31 Aug 2016 16:43:42 +0200
Message-ID: <43162306.qpl1kaeM3f@wuerfel>
References: <20160829124050.3405624-1-arnd@arndb.de> <20160831143752.GA26616@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:49177 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935154AbcHaOnt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Aug 2016 10:43:49 -0400
In-Reply-To: <20160831143752.GA26616@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday, August 31, 2016 10:37:52 PM CEST Herbert Xu wrote:
> On Mon, Aug 29, 2016 at 02:40:43PM +0200, Arnd Bergmann wrote:
> > A recent change left an existing label unused in some configurations,
> > as seen from a gcc warning:
> > 
> > crypto/xor.c: In function 'calibrate_xor_blocks':
> > crypto/xor.c:156:1: error: label 'out' defined but not used [-Werror=unused-label]
> > 
> > This adds an #ifdef around it to match the one around the respective "goto".
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Fixes: 39457acda913 ("crypto: xor - skip speed test if the xor function is selected automatically")
> 
> Thanks for the patch.  But I've already queued up a fix at
> 
> https://patchwork.kernel.org/patch/9301603/
> 

Ok, that one looks like a nicer solution anyway.

	Arnd
