From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] s390: crypto: replace raw value by their coresponding
 define
Date: Thu, 15 Oct 2015 21:19:32 +0800
Message-ID: <20151015131932.GC3981@gondor.apana.org.au>
References: <1444849860-16334-1-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, heiko.carstens@de.ibm.com,
	schwidefsky@de.ibm.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40221 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbbJONTk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Oct 2015 09:19:40 -0400
Content-Disposition: inline
In-Reply-To: <1444849860-16334-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 14, 2015 at 09:11:00PM +0200, LABBE Corentin wrote:
> SHA_MAX_STATE_SIZE is just the number of u32 word for SHA512.
> So replace the raw value "16" by their meaning (SHA512_DIGEST_SIZE / 4)
> 
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
