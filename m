From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: Re: [PATCH v2] lib/mpi: Fix kernel unaligned access in
 mpi_write_to_sgl
Date: Tue, 3 May 2016 06:19:15 -0400
Message-ID: <20160503101915.GI23757@oracle.com>
References: <20160427174338.GA15460@oracle.com>
 <20160428010117.GA5262@gondor.apana.org.au>
 <20160428010827.GE15460@oracle.com>
 <20160503081230.GA17085@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tadeusz.struk@intel.com, linux-kernel@vger.kernel.org,
	smueller@chronox.de, mmarek@suse.com, arnd@arndb.de,
	andrew.zaborowski@intel.com,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47969 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbcECKUg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 May 2016 06:20:36 -0400
Content-Disposition: inline
In-Reply-To: <20160503081230.GA17085@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On (05/03/16 16:12), Herbert Xu wrote:
> 
> Sorry, but your patch doesn't apply against the current tree at all.
> Please rebase it if it is still needed.

Hello,

I had based my patch off of net-next, which is where I do my work.

I'd be happy to rebase it on the "current tree", 
but given that mpicoder.c does not have an entry in MAINTAINERS, 
please clarify what you mean by "current tree" in this case.

do you mean

 git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
or
 git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
or 
 git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

(which are the three possible candidates I can see in MAINTAINERS).

It would be nice to get this bug fixed, since the fix is fairly
obvious, and the nuisance factor from the generated "unaligned
access" messages on the impacted non-intel platforms is quite high, 

thanks,
--Sowmini
