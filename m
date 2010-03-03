From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH 2/2] crypto: authenc - move saved IV in front of the
 ablkcipher request
Date: Wed, 3 Mar 2010 07:58:40 +0100
Message-ID: <20100303065840.GE20508@secunet.com>
References: <20100223062109.GD29013@secunet.com>
 <20100223062237.GE29013@secunet.com>
 <20100302141049.GB3808@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:35629 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722Ab0CCG6L (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Mar 2010 01:58:11 -0500
Content-Disposition: inline
In-Reply-To: <20100302141049.GB3808@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 02, 2010 at 10:10:49PM +0800, Herbert Xu wrote:
> 
> Hmm, I just noticed that both before and after the patch we're
> only including the hash request size for the encrypt case, and
> not the givencrypt case.  Is there a reason for this?
> 

Hm, for the moment I don't see what's missing. The ahash request
size should be the same for both cases. Do you have a hint?

