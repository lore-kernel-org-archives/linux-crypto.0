From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: scatterwalk - Use sg_chain_ptr on chain entries
Date: Mon, 9 Dec 2013 19:57:19 +0800
Message-ID: <20131209115719.GA1433@gondor.apana.org.au>
References: <20131205190953.16167.59879.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:54765 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932604Ab3LIL5Y (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Dec 2013 06:57:24 -0500
Content-Disposition: inline
In-Reply-To: <20131205190953.16167.59879.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 05, 2013 at 01:09:53PM -0600, Tom Lendacky wrote:
> Now that scatterwalk_sg_chain sets the chain pointer bit the sg_page
> call in scatterwalk_sg_next hits a BUG_ON when CONFIG_DEBUG_SG is
> enabled. Use sg_chain_ptr instead of sg_page on a chain entry.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
