From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/6] crypto: talitos - making mapping helpers more generic
Date: Tue, 31 May 2016 17:46:51 +0800
Message-ID: <20160531094651.GA15187@gondor.apana.org.au>
References: <cover.1464330501.git.christophe.leroy@c-s.fr>
 <26474a2b44e69a0dbff43dbeed030ab5adef81db.1464330501.git.christophe.leroy@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kim Phillips <kim.phillips@arm.com>,
	David S Miller <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Christophe Leroy <christophe.leroy@c-s.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55199 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162AbcEaJra (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 05:47:30 -0400
Content-Disposition: inline
In-Reply-To: <26474a2b44e69a0dbff43dbeed030ab5adef81db.1464330501.git.christophe.leroy@c-s.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 27, 2016 at 11:32:36AM +0200, Christophe Leroy wrote:
>
> +	sg_count = sg_to_link_tbl_offset(src, sg_count, offset, len,
> +					 &edesc->link_tbl[tbl_off])
> +	if (sg_count == 1) {
> +		/* Only one segment now, so no link tbl needed*/
> +		copy_talitos_ptr(ptr, &edesc->link_tbl[tbl_off], is_sec1);
> +		return sg_count;
> +	}

This patch doesn't build.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
