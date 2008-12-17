From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2 v4] Switch remaining algorithms to shash
Date: Wed, 17 Dec 2008 16:49:16 +1100
Message-ID: <20081217054916.GA14432@gondor.apana.org.au>
References: <20081207113302.GB13736@gondor.apana.org.au> <1228688249887-git-send-email-ken@codelabs.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com
To: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:32976 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750906AbYLQFtU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Dec 2008 00:49:20 -0500
Content-Disposition: inline
In-Reply-To: <1228688249887-git-send-email-ken@codelabs.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 07, 2008 at 11:17:27PM +0100, Adrian-Ken Rueegsegger wrote:
> This resend contains the fixed up sha512 patches to switch the last
> remaining algorithm to shash.
> 
> The first patch is now correct also in the case of preemption. The
> second patch remains unchanged.

Both applied.  Thanks a lot Adrian!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
