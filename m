From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/4] crypto: add precalculated hash for zero message
 length
Date: Sat, 12 Dec 2015 13:42:18 +0800
Message-ID: <20151212054218.GA17504@gondor.apana.org.au>
References: <1449562253-13846-1-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, geert+renesas@glider.be,
	luis@debethencourt.com, maxime.ripard@free-electrons.com,
	thomas.lendacky@amd.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:50379 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbbLLFmm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 12 Dec 2015 00:42:42 -0500
Content-Disposition: inline
In-Reply-To: <1449562253-13846-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 08, 2015 at 09:10:49AM +0100, LABBE Corentin wrote:
> Hello
> 
> Some crypto drivers cannot process empty data message and so rely on
> precalculated hash.
> This patch series add precalculated hash in headers and
> make the drivers use them.
> 
> Using those precalculated hash make some additionnal constify patch necessary.
> 
> Changes since v1
> - Moved arrays from headers to c file and made them EXPORT.

You still haven't included the Kconfig changes to add dependencies
on the general implementations.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
