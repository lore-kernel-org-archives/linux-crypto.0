From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: nx-sha256/512: respect sg limit bounds when
 building sg lists
Date: Tue, 11 Aug 2015 22:06:13 +0800
Message-ID: <20150811140612.GA30943@gondor.apana.org.au>
References: <58cb150c5cef7194cb3fa8e6117ce3d79c603a58.1439016075.git.jstancek@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	leosilva@linux.vnet.ibm.com, mhcerri@linux.vnet.ibm.com,
	fin@linux.vnet.ibm.com, davem@davemloft.net
To: Jan Stancek <jstancek@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39834 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964890AbbHKOGT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Aug 2015 10:06:19 -0400
Content-Disposition: inline
In-Reply-To: <58cb150c5cef7194cb3fa8e6117ce3d79c603a58.1439016075.git.jstancek@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Aug 08, 2015 at 08:47:28AM +0200, Jan Stancek wrote:
> Commit 000851119e80 changed sha256/512 update functions to
> pass more data to nx_build_sg_list(), which ends with
> sg list overflows and usually with update functions failing
> for data larger than max_sg_len * NX_PAGE_SIZE.
> 
> This happens because:
> - both "total" and "to_process" are updated, which leads to
>   "to_process" getting overflowed for some data lengths
>   For example:
>     In first iteration "total" is 50, and let's assume "to_process"
>     is 30 due to sg limits. At the end of first iteration "total" is
>     set to 20. At start of 2nd iteration "to_process" overflows on:
>       to_process = total - to_process;
> - "in_sg" is not reset to nx_ctx->in_sg after each iteration
> - nx_build_sg_list() is hitting overflow because the amount of data
>   passed to it would require more than sgmax elements
> - as consequence of previous item, data stored in overflowed sg list
>   may no longer be aligned to SHA*_BLOCK_SIZE
> 
> This patch changes sha256/512 update functions so that "to_process"
> respects sg limits and never tries to pass more data to
> nx_build_sg_list() to avoid overflows. "to_process" is calculated
> as minimum of "total" and sg limits at start of every iteration.
> 
> Fixes: 000851119e80 ("crypto: nx - Fix SHA concurrence issue and sg
>                       limit bounds")
> 
> Signed-off-by: Jan Stancek <jstancek@redhat.com>
> Cc: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
> Cc: Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>
> Cc: Fionnuala Gunter <fin@linux.vnet.ibm.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>

Patch applied with stable cc.  Thanks a lot!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
