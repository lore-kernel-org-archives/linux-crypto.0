From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: omap-sham: Add the offset of sg page to vaddr
Date: Fri, 3 Apr 2015 18:00:25 +0800
Message-ID: <20150403100025.GA19317@gondor.apana.org.au>
References: <1427968965-4944-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-kernel@vger.kernel.org, nsekhar@ti.com, t-kristo@ti.com
To: Lokesh Vutla <lokeshvutla@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:50425 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbbDCKAa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 Apr 2015 06:00:30 -0400
Content-Disposition: inline
In-Reply-To: <1427968965-4944-1-git-send-email-lokeshvutla@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 02, 2015 at 03:32:45PM +0530, Lokesh Vutla wrote:
> kmap_atomic() gives only the page address of the input page.
> Driver should take care of adding the offset of the scatterlist
> within the page to the returned page address.
> omap-sham driver is not adding the offset to page and directly operates
> on the return vale of kmap_atomic(), because of which the following
> error comes when running crypto tests:
> 
> 00000000: d9 a1 1b 7c aa 90 3b aa 11 ab cb 25 00 b8 ac bf
> [    2.338169] 00000010: c1 39 cd ff 48 d0 a8 e2 2b fa 33 a1
> [    2.344008] alg: hash: Chunking test 1 failed for omap-sha256
> 
> So adding the scatterlist offset to vaddr.
> 
> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
