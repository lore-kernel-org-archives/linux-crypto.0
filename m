From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: don't use interruptible wait in tests
Date: Tue, 13 Jan 2015 22:32:28 +1100
Message-ID: <20150113113227.GA6677@gondor.apana.org.au>
References: <1420817129-28903-1-git-send-email-rabin.vincent@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Rabin Vincent <rabinv@axis.com>
To: Rabin Vincent <rabin.vincent@axis.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:40224 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbbAMLce (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Jan 2015 06:32:34 -0500
Content-Disposition: inline
In-Reply-To: <1420817129-28903-1-git-send-email-rabin.vincent@axis.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 09, 2015 at 04:25:28PM +0100, Rabin Vincent wrote:
> tcrypt/testmgr uses wait_for_completion_interruptible() everywhere when
> it waits for a request to be completed.  If it's interrupted, then the
> test is aborted and the request is freed.
> 
> However, if any of these calls actually do get interrupted, the result
> will likely be a kernel crash, when the driver handles the now-freed
> request.  Use wait_for_completion() instead.
> 
> Signed-off-by: Rabin Vincent <rabin.vincent@axis.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
