From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto: Fix driver load failure
Date: Fri, 4 Dec 2015 22:41:24 +0800
Message-ID: <20151204144124.GC17703@gondor.apana.org.au>
References: <1448808334-8424-1-git-send-email-rui.y.wang@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ying.huang@intel.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Rui Wang <rui.y.wang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43968 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbbLDOl1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Dec 2015 09:41:27 -0500
Content-Disposition: inline
In-Reply-To: <1448808334-8424-1-git-send-email-rui.y.wang@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Nov 29, 2015 at 10:45:32PM +0800, Rui Wang wrote:
> ghash_clmulni_intel fails to load on Linux 4.3+ with the following message:
> "modprobe: ERROR: could not insert 'ghash_clmulni_intel': Invalid argument"
> 
> These two patches need to go together, for the driver to load correctly.
> 
> Rui Wang (2):
>   crypto: ghash-clmulni - Fix load failure
>   crypto: cryptd - Assign statesize properly

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
