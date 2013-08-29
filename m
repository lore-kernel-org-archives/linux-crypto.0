From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 03/10] crypto: nx - fix limits to sg lists for AES-CBC
Date: Thu, 29 Aug 2013 14:42:22 +1000
Message-ID: <20130829044221.GA25208@gondor.apana.org.au>
References: <1377288074-18998-1-git-send-email-mhcerri@linux.vnet.ibm.com>
 <1377288074-18998-4-git-send-email-mhcerri@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org
To: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:38296 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752059Ab3H2Emc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 29 Aug 2013 00:42:32 -0400
Content-Disposition: inline
In-Reply-To: <1377288074-18998-4-git-send-email-mhcerri@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 23, 2013 at 05:01:07PM -0300, Marcelo Cerri wrote:
> This patch updates the nx-aes-cbc implementation to perform several
> hyper calls if needed in order to always respect the length limits for
> scatter/gather lists.
> 
> Two different limits are considered:
> 
>  - "ibm,max-sg-len": maximum number of bytes of each scatter/gather
>    list.
> 
>  - "ibm,max-sync-cop":
>     - The total number of bytes that a scatter/gather list can hold.
>     - The maximum number of elements that a scatter/gather list can have.
> 
> Reviewed-by: Joy Latten <jmlatten@linux.vnet.ibm.com>
> Signed-off-by: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>

This patch does not apply against the current cryptodev tree.

Please regenerate your pathces.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
