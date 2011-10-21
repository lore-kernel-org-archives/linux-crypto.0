From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/3] Add snappy interface to crypto API
Date: Fri, 21 Oct 2011 15:24:44 +0200
Message-ID: <20111021132444.GA1141@gondor.apana.org.au>
References: <1319153941-26234-3-git-send-email-andi@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com, linux-crypto@vger.kernel.org,
	ak@linux.intel.com, dedekind1@gmail.com, adrian.hunter@intel.com
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:59357 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab1JUNY6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Oct 2011 09:24:58 -0400
Content-Disposition: inline
In-Reply-To: <1319153941-26234-3-git-send-email-andi@firstfloor.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Andi Kleen <andi@firstfloor.org> wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Mainly so that ubifs can use it.
> 
> Snappy is a better compressor in the same niche as LZO.
> 
> Only lightly tested so far. Experiences welcome.
> 
> Cc: herbert@gondor.apana.org.au
> Cc: dedekind1@gmail.com
> Cc: adrian.hunter@intel.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
