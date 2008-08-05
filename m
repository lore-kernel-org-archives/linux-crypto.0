From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c algorithm by new crypto API -V2.
Date: Tue, 5 Aug 2008 20:39:44 +0800
Message-ID: <20080805123944.GA22680@gondor.apana.org.au>
References: <1217937403.3641.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dwmw2@infradead.org, davem@davemloft.net, randy.dunlap@oracle.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Austin Zhang <austin_zhang@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:43371 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751971AbYHEMkK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Aug 2008 08:40:10 -0400
Content-Disposition: inline
In-Reply-To: <1217937403.3641.8.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Austin:

On Tue, Aug 05, 2008 at 07:56:43AM -0400, Austin Zhang wrote:
> Revised by comments:
> Move hardware feature detect into module init;
> Revise dependency in Kconfig;
> Revise variable type;
> Add information output while module loading failed; 
>  
> 
> >From NHM processor onward, Intel processors can support hardware
> accelerated
> CRC32c algorithm with the new CRC32 instruction in SSE 4.2 instruction
> set.
> The patch detects the availability of the feature, and chooses the most
> proper
> way to calculate CRC32c checksum.
> Byte code instructions are used for compiler compatibility.
> No MMX / XMM registers is involved in the implementation.
> 
> Signed-off-by: Austin Zhang <austin.zhang@intel.com>
> Signed-off-by: Kent Liu <kent.liu@intel.com>

I tried to apply your patch but it doesn't work:

$ git apply --check --whitespace=error-all ~/p
fatal: patch fragment without header at line 34: @@ -0,0 +1,190 @@
$

Looks like your mail client has folded all the lines.

> +u32 crc32c_intel_le_hw_byte(u32 crc, unsigned char const *data, size_t
> length)

While you're fixing that up please add a static here.

> +u32 __pure crc32c_intel_le_hw(u32 crc, unsigned char const *p, size_t

And here.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
