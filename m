From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] Automatically load the vmx_crypto module if supported
Date: Mon, 18 Jul 2016 18:22:53 +0800
Message-ID: <20160718102253.GA13780@gondor.apana.org.au>
References: <1468388840-12068-1-git-send-email-alastair@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
	davem@davemloft.net, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alastair D'Silva <alastair@d-silva.org>
To: alastair@au1.ibm.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58747 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbcGRKXh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jul 2016 06:23:37 -0400
Content-Disposition: inline
In-Reply-To: <1468388840-12068-1-git-send-email-alastair@au1.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 13, 2016 at 03:47:16PM +1000, alastair@au1.ibm.com wrote:
> From: Alastair D'Silva <alastair@d-silva.org>
> 
> This series allows the vmx_crypto module to be detected and automatically
> loaded via UDEV if the CPU supports the vector crypto feature.
> 
> Alastair D'Silva (2):
>   powerpc: Add module autoloading based on CPU features
>   crypto: vmx - Convert to CPU feature based module autoloading

Both patches applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
