From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccp - Use different flag vars for nested locks
Date: Sat, 12 Mar 2016 10:22:02 +0800
Message-ID: <20160312022202.GA29618@gondor.apana.org.au>
References: <20160311163942.4791.47157.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
	davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34773 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbcCLCWJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Mar 2016 21:22:09 -0500
Content-Disposition: inline
In-Reply-To: <20160311163942.4791.47157.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 11, 2016 at 10:40:11AM -0600, Gary R Hook wrote:
>
> @@ -128,14 +128,14 @@ static struct ccp_device *ccp_get_device(void)
>  	 */
>  	read_lock_irqsave(&ccp_unit_lock, flags);
>  	if (!list_empty(&ccp_units)) {
> -		write_lock_irqsave(&ccp_rr_lock, flags);
> +		write_lock_irqsave(&ccp_rr_lock, rrflags);

The right thing to do is to drop the _irqsave on the inner lock.

Also why is this a write lock at all as nobody seems to take it
as a read lock?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
