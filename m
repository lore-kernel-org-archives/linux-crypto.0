From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: powerpc - CRYPT_CRC32C_VPMSUM should depend
 on ALTIVEC
Date: Tue, 9 Aug 2016 18:36:25 +0800
Message-ID: <20160809103625.GB6934@gondor.apana.org.au>
References: <1470696375-22023-1-git-send-email-mpe@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@ozlabs.org,
	Anton Blanchard <anton@samba.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54325 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbcHIKgc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 06:36:32 -0400
Content-Disposition: inline
In-Reply-To: <1470696375-22023-1-git-send-email-mpe@ellerman.id.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 09, 2016 at 08:46:15AM +1000, Michael Ellerman wrote:
> The optimised crc32c implementation depends on VMX (aka. Altivec)
> instructions, so the kernel must be built with Altivec support in order
> for the crc32c code to build.
> 
> Fixes: 6dd7a82cc54e ("crypto: powerpc - Add POWER8 optimised crc32c")
> Acked-by: Anton Blanchard <anton@samba.org>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
