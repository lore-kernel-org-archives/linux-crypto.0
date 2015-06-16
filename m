From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC 01/11] crypto: caam - Add cache coherency support
Date: Tue, 16 Jun 2015 10:33:52 +0800
Message-ID: <20150616023352.GA19203@gondor.apana.org.au>
References: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
 <1434412379-11623-2-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, horia.geanta@freescale.com,
	ruchika.gupta@freescale.com
To: Victoria Milhoan <vicki.milhoan@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46546 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbbFPCd4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 22:33:56 -0400
Content-Disposition: inline
In-Reply-To: <1434412379-11623-2-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 15, 2015 at 04:52:49PM -0700, Victoria Milhoan wrote:
>
> @@ -202,6 +214,13 @@ static void caam_jr_dequeue(unsigned long devarg)
>  		userdesc = jrp->entinfo[sw_idx].desc_addr_virt;
>  		userstatus = jrp->outring[hw_idx].jrstatus;
>  
> +		/*
> +		 * Make sure all information from the job has been obtained
> +		 * before telling CAAM that the job has been removed from the
> +		 * output ring.
> +		 */
> +		smp_mb();

So you're not actually guarding against another CPU here, right?
In that case shouldn't this be mb()?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
