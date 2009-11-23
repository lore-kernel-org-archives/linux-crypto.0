From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -next] crypto: ghash - put proper .data section in place
Date: Mon, 23 Nov 2009 20:20:06 +0800
Message-ID: <20091123122006.GD6424@gondor.apana.org.au>
References: <alpine.LSU.2.00.0911181713200.15039@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Huang Ying <ying.huang@intel.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Jiri Kosina <jkosina@suse.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:35224 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756997AbZKWMUH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Nov 2009 07:20:07 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0911181713200.15039@wotan.suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 18, 2009 at 05:15:44PM +0100, Jiri Kosina wrote:
> Lbswap_mask, Lpoly and Ltwo_one should clearly belong to
> .data section, not .text.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Patch applied.  Thanks Jiri.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
