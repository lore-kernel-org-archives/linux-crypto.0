From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH]: kernel crashes when ipsec uses xcbc-mac with big data chunk
Date: Wed, 2 Apr 2008 14:39:16 +0800
Message-ID: <20080402063916.GA7295@gondor.apana.org.au>
References: <200804011723.m31HNAxB008013@faith.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Joy Latten <latten@austin.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:42432 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752030AbYDBGjW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Apr 2008 02:39:22 -0400
Content-Disposition: inline
In-Reply-To: <200804011723.m31HNAxB008013@faith.austin.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 01, 2008 at 12:23:10PM -0500, Joy Latten wrote:
> The kernel crashes when ipsec passes a udp packet of about 14XX bytes
> of data to aes-xcbc-mac.
> 
> It seems the first xxxx bytes of the data are in first sg entry,
> and remaining xx bytes are in next sg entry. But we don't 
> check next sg entry to see if we need to go look the page up.
> 
> I noticed in hmac.c, we do a scatterwalk_sg_next(), to do this check
> and possible lookup, thus xcbc.c needs to use this routine too.
> 
> A 15-hour run of an ipsec stress test sending streams of tcp and
> udp packets of various sizes,  using this patch and 
> aes-xcbc-mac completed successfully, so hopefully this fixes the
> problem.
> 
> regards,
> Joy
>  
> Signed-off-by: Joy Latten <latten@austin.ibm.com>

Applied to crypto-2.6.

Thanks Joy!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
