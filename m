From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4/8] s390: add System z hardware support for CTR mode
Date: Tue, 26 Apr 2011 16:34:37 +1000
Message-ID: <20110426063437.GA19539@gondor.apana.org.au>
References: <20110419192913.888086020@linux.vnet.ibm.com> <20110419193248.399099652@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: jang@linux.vnet.ibm.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:41561 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489Ab1DZGfI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Apr 2011 02:35:08 -0400
Content-Disposition: inline
In-Reply-To: <20110419193248.399099652@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 19, 2011 at 09:29:17PM +0200, jang@linux.vnet.ibm.com wrote:
>
> @@ -664,11 +784,6 @@ static int __init aes_s390_init(void)
>  	if (ret)
>  		goto cbc_aes_err;
>  
> -	/* skip XTS if MSA-4 is not available */
> -	if ((stfle(facility_bits, 2) <= 0) ||
> -	    !(facility_bits[1] & (1ULL << (63 - (77 - 64)))))
> -		goto out;

Any reason why this hunk is here?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
