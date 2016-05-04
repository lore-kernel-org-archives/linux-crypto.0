From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: Re: [PATCH v2] lib/mpi: Fix kernel unaligned access in
 mpi_write_to_sgl
Date: Wed, 4 May 2016 07:05:20 -0400
Message-ID: <20160504110520.GC29618@oracle.com>
References: <20160427174338.GA15460@oracle.com>
 <20160428010117.GA5262@gondor.apana.org.au>
 <20160428010827.GE15460@oracle.com>
 <20160503081230.GA17085@gondor.apana.org.au>
 <20160503101915.GI23757@oracle.com>
 <20160504023247.GA24809@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tadeusz.struk@intel.com, linux-kernel@vger.kernel.org,
	smueller@chronox.de, mmarek@suse.com, arnd@arndb.de,
	andrew.zaborowski@intel.com,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25924 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbcEDLFl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2016 07:05:41 -0400
Content-Disposition: inline
In-Reply-To: <20160504023247.GA24809@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On (05/04/16 10:32), Herbert Xu wrote:
> 
> Please base it on cryptodev.
> 

Looks like this got fixed in cryptodev by commit cece762f6f3c 
("lib/mpi: mpi_write_sgl(): fix out-of-bounds stack access")

Thanks,
--Sowmini
