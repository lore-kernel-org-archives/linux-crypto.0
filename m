From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] Remove dangling pieces of old digest/hash
	implementation
Date: Mon, 19 Oct 2009 12:59:39 +0900
Message-ID: <20091019035938.GA27342@gondor.apana.org.au>
References: <1255038065-3113-1-git-send-email-bgilbert@cs.cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Benjamin Gilbert <bgilbert@cs.cmu.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:60692 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755834AbZJSD7j (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Oct 2009 23:59:39 -0400
Content-Disposition: inline
In-Reply-To: <1255038065-3113-1-git-send-email-bgilbert@cs.cmu.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 08, 2009 at 05:41:02PM -0400, Benjamin Gilbert wrote:
> 
> This series removes several unused bits of code associated with the legacy
> digest/hash implementation.  It also fixes one bug: out-of-tree algorithm
> implementations which still use the legacy interface will build
> successfully against 2.6.32-rc but oops when they are loaded.  Patch 3/3
> causes such modules to FTBFS instead.
> 
> Compile-tested with allmodconfig.

All applied.  Thanks a lot!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
