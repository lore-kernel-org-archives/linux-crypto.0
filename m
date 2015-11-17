From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/8] crypto: niagara: Use precalculated hash from headers
Date: Tue, 17 Nov 2015 17:51:43 +0800
Message-ID: <20151117095143.GA7837@gondor.apana.org.au>
References: <1445326444-11019-1-git-send-email-clabbe.montjoie@gmail.com>
 <1445326444-11019-3-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60787 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbbKQJvs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Nov 2015 04:51:48 -0500
Content-Disposition: inline
In-Reply-To: <1445326444-11019-3-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 20, 2015 at 09:33:58AM +0200, LABBE Corentin wrote:
> Precalculated hash for empty message are now present in hash headers.
> This patch just use them.
> 
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>

You need to select CRYPTO_MD5 and CRYPTO_SHA*.  Please add the
corresponding Kconfig changes and resubmit.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
