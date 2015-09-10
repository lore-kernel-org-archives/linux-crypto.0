From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: vmx - VMX crypto should depend on CONFIG_VSX
Date: Thu, 10 Sep 2015 17:26:42 +0800
Message-ID: <20150910092642.GA28753@gondor.apana.org.au>
References: <1441786955-6249-1-git-send-email-mpe@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linuxppc-dev@ozlabs.org, leosilva@linux.vnet.ibm.com,
	Paul Mackerras <paulus@samba.org>, tim.gardner@canonical.com,
	linux-crypto@vger.kernel.org
To: Michael Ellerman <mpe@ellerman.id.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40421 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbbIJJ04 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Sep 2015 05:26:56 -0400
Content-Disposition: inline
In-Reply-To: <1441786955-6249-1-git-send-email-mpe@ellerman.id.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 09, 2015 at 06:22:35PM +1000, Michael Ellerman wrote:
> This code uses FP (floating point), Altivec and VSX (Vector-Scalar
> Extension). It can just depend on CONFIG_VSX though, because that
> already depends on FP and Altivec.
> 
> Otherwise we get lots of link errors such as:
> 
>   drivers/built-in.o: In function `.p8_aes_setkey':
>   aes.c:(.text+0x2d325c): undefined reference to `.enable_kernel_altivec'
>   aes.c:(.text+0x2d326c): undefined reference to `.enable_kernel_vsx'
> 
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
