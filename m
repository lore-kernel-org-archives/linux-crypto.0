From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH] crypto: sun4i-ss: add missing statesize
Date: Tue, 17 Nov 2015 15:26:03 +0100
Message-ID: <20151117142603.GA1669@Red>
References: <1447420229-17911-1-git-send-email-clabbe.montjoie@gmail.com>
 <20151117140938.GH9546@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-arm-kernel@lists.infradead.org,
	maxime.ripard@free-electrons.com, wens@csie.org,
	stable@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:36032 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbbKQO0J (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Nov 2015 09:26:09 -0500
Content-Disposition: inline
In-Reply-To: <20151117140938.GH9546@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 17, 2015 at 10:09:38PM +0800, Herbert Xu wrote:
> On Fri, Nov 13, 2015 at 02:10:28PM +0100, LABBE Corentin wrote:
> > sun4i-ss implementaton of md5/sha1 is via ahash algorithms.
> > Commit 8996eafdcbad ("crypto: ahash - ensure statesize is non-zero")
> > made impossible to load them without giving statesize. This patch
> > specifiy statesize for sha1 and md5.
> > 
> > Fixes: 6298e948215f ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
> > Cc: <stable@vger.kernel.org> # v4.3+
> > Tested-by: Chen-Yu Tsai <wens@csie.org>
> > Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> 
> Patch applied to cryptodev as I don't think it needs to go into
> stable straight away.  Thanks.

Hello

I have lots of user reporting that they cannot use the device since it wont load.
For me it need to go stable since it respect all "stable rules", simple, tested, minimal, and fix a real bug that bother people.

Thanks in advance.
Regards
