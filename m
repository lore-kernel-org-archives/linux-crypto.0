From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] to fix vmac test fails on s390
Date: Tue, 2 Mar 2010 21:57:06 +0800
Message-ID: <20100302135706.GA3522@gondor.apana.org.au>
References: <1263477930.5880.22.camel@bender> <20100117110546.GA32690@gondor.apana.org.au> <6CADD16F56BC954D8E28F3836FA7ED71282AC1E357@shzsmsx501.ccr.corp.intel.com> <20100221182722.GB11951@Chamillionaire.breakpoint.cc> <6CADD16F56BC954D8E28F3836FA7ED71282AC1E58F@shzsmsx501.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>,
	Jan Glauber <jang@linux.vnet.ibm.com>,
	"Cihula, Joseph" <joseph.cihula@intel.com>,
	linux-crypto <linux-crypto@vger.kernel.org>
To: "Wang, Shane" <shane.wang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:36703 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753075Ab0CBN5Y (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Mar 2010 08:57:24 -0500
Content-Disposition: inline
In-Reply-To: <6CADD16F56BC954D8E28F3836FA7ED71282AC1E58F@shzsmsx501.ccr.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 22, 2010 at 11:21:04AM +0800, Wang, Shane wrote:
>
> @@ -474,7 +475,10 @@ static u64 vmac(unsigned char m[], unsig
>  	}
>  	p = be64_to_cpup(out_p + i);
>  	h = vhash(m, mbytes, (u64 *)0, &ctx->__vmac_ctx);
> -	return p + h;
> +	r = p + h;
> +	r = le64_to_cpup(&r);
> +
> +	return r;

Is there any reason why we don't simply do

	return le64_to_cpu(p + h);

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
