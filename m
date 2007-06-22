From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch 1/1] add cast to regain ablkcipher_request from private ctx
Date: Fri, 22 Jun 2007 20:39:16 +0800
Message-ID: <20070622123916.GA30017@gondor.apana.org.au>
References: <20070612162023.GA25764@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3675 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752773AbXFVMjT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jun 2007 08:39:19 -0400
Content-Disposition: inline
In-Reply-To: <20070612162023.GA25764@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jun 12, 2007 at 04:20:23PM +0000, Sebastian Siewior wrote:
> This cast allows to regain the struct ablkcipher_request for a request 
> from private data.

How about just passing the ablkcipher_request instead of the ctx?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
