From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] Uncomment VSX enable routine for instructions access
Date: Tue, 14 Jul 2015 15:02:31 +0800
Message-ID: <20150714070231.GA20792@gondor.apana.org.au>
References: <20150713165011.GA3356@bluepex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, pfsmorigo@linux.vnet.ibm.com,
	mpe@ellerman.id.au
To: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42543 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbbGNHCg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jul 2015 03:02:36 -0400
Content-Disposition: inline
In-Reply-To: <20150713165011.GA3356@bluepex.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com> wrote:
> enable_kernel_vsx() was commented since anything was using
> it. It changes with vmx_crypto driver that call VSX instructions
> and need kernel_vsx enabled in order to do it properly. Without
> a way to enable VSX instruction vmx_crypto fails into an exception.
> 
> These patches uncomment enable_kernel_vsx() rountine and put it
> available for use. Also adds it in vmx_crypto in order to
> enable kernel_vsx before use VSX instructions.
> 
> Leonidas S. Barbosa (2):
>  Uncomment and make enable_kernel_vsx() routine available
>  Adding enable_kernel_vsx() to access VSX instructions

All applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
