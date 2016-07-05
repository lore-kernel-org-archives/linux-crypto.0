From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: bfin_crc: Simplify use of devm_ioremap_resource
Date: Tue, 5 Jul 2016 23:15:45 +0800
Message-ID: <20160705151545.GE8117@gondor.apana.org.au>
References: <20160704130021.GA16839@amitoj-Inspiron-3542>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
To: Amitoj Kaur Chawla <amitoj1606@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60235 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbcGEPP4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Jul 2016 11:15:56 -0400
Content-Disposition: inline
In-Reply-To: <20160704130021.GA16839@amitoj-Inspiron-3542>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 04, 2016 at 06:30:21PM +0530, Amitoj Kaur Chawla wrote:
> Remove unneeded error handling on the result of a call to
> platform_get_resource when the value is passed to
> devm_ioremap_resource.
> 
> The Coccinelle semantic patch that makes this change is as follows:
> 
> // <smpl>
> @@
> expression pdev,res,n,e,e1;
> expression ret != 0;
> identifier l;
> @@
> 
> - res = platform_get_resource(pdev, IORESOURCE_MEM, n);
>   ... when != res
> - if (res == NULL) { ... \(goto l;\|return ret;\) }
>   ... when != res
> + res = platform_get_resource(pdev, IORESOURCE_MEM, n);
>   e = devm_ioremap_resource(e1, res);
> // </smpl>
> 
> Signed-off-by: Amitoj Kaur Chawla <amitoj1606@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
