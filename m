From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: ahash alg that does not implement import/export failed to
 register
Date: Sat, 19 Dec 2015 10:33:08 +0800
Message-ID: <20151219023308.GA27731@gondor.apana.org.au>
References: <1450488694.30844.11.camel@schen9-desk2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"; linux-crypto" <linux-crypto@vger.kernel.org>,
	"megha.dey" <megha.dey@intel.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56490 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbbLSCdU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Dec 2015 21:33:20 -0500
Content-Disposition: inline
In-Reply-To: <1450488694.30844.11.camel@schen9-desk2.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 18, 2015 at 05:31:34PM -0800, Tim Chen wrote:
> Herbert,
> 
> There are some ahash algorithms like x86's sha1-mb and
> ghash that failed to register because of the newly added
> check of non-zero statesize from commit 8996eafd.  But
> since there are algorithms that do not implement an import or
> export, there is no state required for them.  Wonder if the check
> should be modified to something like:

No import and export are required by algif_hash so they must be
implemented.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
