From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] avoid excessive use of socket buffer in skcipher
Date: Thu, 4 Sep 2014 15:08:52 +0800
Message-ID: <20140904070852.GA2606@gondor.apana.org.au>
References: <1408960194-11726-1-git-send-email-okozina@redhat.com>
 <1408960194-11726-2-git-send-email-okozina@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, gmazyland@gmail.com
To: Ondrej Kozina <okozina@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:36135 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277AbaIDHJB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Sep 2014 03:09:01 -0400
Content-Disposition: inline
In-Reply-To: <1408960194-11726-2-git-send-email-okozina@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 25, 2014 at 11:49:54AM +0200, Ondrej Kozina wrote:
> On archs with PAGE_SIZE >= 64 KiB the function skcipher_alloc_sgl()
> fails with -ENOMEM no matter what user space actually requested.
> This is caused by the fact sock_kmalloc call inside the function tried
> to allocate more memory than allowed by the default kernel socket buffer
> size (kernel param net.core.optmem_max).
> 
> Signed-off-by: Ondrej Kozina <okozina@redhat.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
