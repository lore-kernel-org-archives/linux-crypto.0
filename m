From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4 v3] crypto: sha512 - Move message schedule W[80] to
	static percpu area
Date: Sun, 7 Dec 2008 19:33:02 +0800
Message-ID: <20081207113302.GB13736@gondor.apana.org.au>
References: <20081204100543.GA19425@gondor.apana.org.au> <12284306281986-git-send-email-ken@codelabs.ch> <1228430628526-git-send-email-ken@codelabs.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com
To: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:47251 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753468AbYLGLdG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2008 06:33:06 -0500
Content-Disposition: inline
In-Reply-To: <1228430628526-git-send-email-ken@codelabs.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 04, 2008 at 11:43:45PM +0100, Adrian-Ken Rueegsegger wrote:
>
>  	int i;
> +	u64 *W = __get_cpu_var(msg_schedule);

That should be get_cpu_var unless you've already disabled preemption
somewhere.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
