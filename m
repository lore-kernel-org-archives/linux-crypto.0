From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 8/8] Replacing spinlocks by nx_copy_ctx on NX-SHA256 and
 NX-SHA512
Date: Fri, 1 Aug 2014 22:26:06 +0800
Message-ID: <20140801142606.GB14651@gondor.apana.org.au>
References: <20140724140243.GA26496@bluepex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	mhcerri@linux.vnet.ibm.com, fin@linux.vnet.ibm.com
To: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:58224 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbaHAO0O (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 1 Aug 2014 10:26:14 -0400
Content-Disposition: inline
In-Reply-To: <20140724140243.GA26496@bluepex.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 24, 2014 at 11:02:45AM -0300, Leonidas Da Silva Barbosa wrote:
> Replaces spinlock usage by a simple copy of the crypto context, avoiding
> possible bottlenecks.
> 
> Signed-off-by: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>

While your patches look OK, it appears that the underlying hash
code is completely broken when it's used by multiple users because
it stores the hash state in the tfm context.

If this is the case we should disable the hash part of the driver
until it's fixed properly.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
