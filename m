From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 5/8] lib: introduce sg_nents_len_chained
Date: Mon, 21 Sep 2015 22:19:17 +0800
Message-ID: <20150921141917.GA2278@gondor.apana.org.au>
References: <1442581036-23789-1-git-send-email-clabbe.montjoie@gmail.com>
 <1442581036-23789-6-git-send-email-clabbe.montjoie@gmail.com>
 <55FC3995.8050600@cybernetics.com>
 <55FC815B.8020206@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>, davem@davemloft.net,
	akpm@linux-foundation.org, arnd@arndb.de, axboe@fb.com,
	david.s.gordon@intel.com, martin.petersen@oracle.com,
	robert.jarzmik@free.fr, thomas.lendacky@amd.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	lee.nipper@gmail.com, yuan.j.kang@gmail.com
To: Tony Battersby <tonyb@cybernetics.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36476 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756304AbbIUOTy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Sep 2015 10:19:54 -0400
Content-Disposition: inline
In-Reply-To: <55FC815B.8020206@cybernetics.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 18, 2015 at 05:25:47PM -0400, Tony Battersby wrote:
>
> So instead of adding a new function sg_nents_len_chained(), a better
> cleanup would be:
> 1) replace the driver-specific functions with calls to sg_nents_for_len()
> 2) get rid of the "chained" variables
> 3) always call dma_map_sg()/dma_unmap_sg() for the entire scatterlist
> regardless of whether or not the scatterlist is chained
> 
> Would someone more familiar with the crypto API please confirm that my
> suggestions are correct?

Yes I think you're absolutely right Tony.  Corentin, could you
please take this opportunity to clean up those drivers so that
they simply use dma_map_sg a single time rather than over and
over again for chained SG lists?

You only have to redo patches 5-8.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
