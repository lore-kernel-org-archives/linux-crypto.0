From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: vmx: Fix ABI detection
Date: Mon, 13 Jun 2016 20:30:21 +0800
Message-ID: <20160613123021.GC8583@gondor.apana.org.au>
References: <1465541223-17537-1-git-send-email-anton@ozlabs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pfsmorigo@linux.vnet.ibm.com, benh@kernel.crashing.org,
	paulus@samba.org, mpe@ellerman.id.au, davem@davemloft.net,
	strosake@austin.ibm.com, linux-crypto@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org
To: Anton Blanchard <anton@ozlabs.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58420 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964822AbcFMMa7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jun 2016 08:30:59 -0400
Content-Disposition: inline
In-Reply-To: <1465541223-17537-1-git-send-email-anton@ozlabs.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 10, 2016 at 04:47:02PM +1000, Anton Blanchard wrote:
> From: Anton Blanchard <anton@samba.org>
> 
> When calling ppc-xlate.pl, we pass it either linux-ppc64 or
> linux-ppc64le. The script however was expecting linux64le, a result
> of its OpenSSL origins. This means we aren't obeying the ppc64le
> ABIv2 rules.
> 
> Fix this by checking for linux-ppc64le.
> 
> Fixes: 5ca55738201c ("crypto: vmx - comply with ABIs that specify vrsave as reserved.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Anton Blanchard <anton@samba.org>

Both applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
