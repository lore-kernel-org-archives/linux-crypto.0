From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] lib/mpi: Fix kernel unaligned access in
 mpi_write_to_sgl
Date: Wed, 4 May 2016 10:32:47 +0800
Message-ID: <20160504023247.GA24809@gondor.apana.org.au>
References: <20160427174338.GA15460@oracle.com>
 <20160428010117.GA5262@gondor.apana.org.au>
 <20160428010827.GE15460@oracle.com>
 <20160503081230.GA17085@gondor.apana.org.au>
 <20160503101915.GI23757@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tadeusz.struk@intel.com, linux-kernel@vger.kernel.org,
	smueller@chronox.de, mmarek@suse.com, arnd@arndb.de,
	andrew.zaborowski@intel.com,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42581 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438AbcEDCdb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 May 2016 22:33:31 -0400
Content-Disposition: inline
In-Reply-To: <20160503101915.GI23757@oracle.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 03, 2016 at 06:19:15AM -0400, Sowmini Varadhan wrote:
> On (05/03/16 16:12), Herbert Xu wrote:
> > 
> > Sorry, but your patch doesn't apply against the current tree at all.
> > Please rebase it if it is still needed.
> 
> Hello,
> 
> I had based my patch off of net-next, which is where I do my work.

Please base it on cryptodev.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
