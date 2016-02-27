From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: allow rfc3686 aes-ctr variants in fips mode.
Date: Sat, 27 Feb 2016 20:33:55 +0100
Message-ID: <20160227193355.GC9123@gondor.apana.org.au>
References: <1455885268-15054-1-git-send-email-meissner@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, smueller@chronox.de
To: Marcus Meissner <meissner@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60268 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbcB0TeD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 27 Feb 2016 14:34:03 -0500
Content-Disposition: inline
In-Reply-To: <1455885268-15054-1-git-send-email-meissner@suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 19, 2016 at 01:34:28PM +0100, Marcus Meissner wrote:
> RFC 3686 CTR in various authenc methods.
> 
> rfc3686(ctr(aes)) is already marked fips compliant,
> so these should be fine.
> 
> Signed-off-by: Marcus Meissner <meissner@suse.de>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
