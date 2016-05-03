From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] lib/mpi: Fix kernel unaligned access in
 mpi_write_to_sgl
Date: Tue, 3 May 2016 16:12:30 +0800
Message-ID: <20160503081230.GA17085@gondor.apana.org.au>
References: <20160427174338.GA15460@oracle.com>
 <20160428010117.GA5262@gondor.apana.org.au>
 <20160428010827.GE15460@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tadeusz.struk@intel.com, linux-kernel@vger.kernel.org,
	smueller@chronox.de, mmarek@suse.com, arnd@arndb.de,
	andrew.zaborowski@intel.com,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33965 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbcECINB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 May 2016 04:13:01 -0400
Content-Disposition: inline
In-Reply-To: <20160428010827.GE15460@oracle.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 27, 2016 at 09:08:27PM -0400, Sowmini Varadhan wrote:
> On (04/28/16 09:01), Herbert Xu wrote:
> > Subject: Re: [PATCH v2] lib/mpi: Fix kernel unaligned access in
> >  mpi_write_to_sgl
> > 
> > Please cc linux-crypto.
> 
> Just bounced the message to linux-crypto as well. 
> I think get_maintainers.pl might also need to be updated to 
> generate this automatically.

Sorry, but your patch doesn't apply against the current tree at all.
Please rebase it if it is still needed.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
