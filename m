From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: aesni-intel: fix crypto_fpu_exit() section
 mismatch
Date: Mon, 15 Jun 2015 18:19:22 +0800
Message-ID: <20150615101922.GB32751@gondor.apana.org.au>
References: <1434171400-10566-1-git-send-email-jmmahler@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jeremiah Mahler <jmmahler@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58898 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbbFOKTo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 06:19:44 -0400
Content-Disposition: inline
In-Reply-To: <1434171400-10566-1-git-send-email-jmmahler@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 12, 2015 at 09:56:40PM -0700, Jeremiah Mahler wrote:
> The '__init aesni_init()' function calls the '__exit crypto_fpu_exit()'
> function directly.  Since they are in different sections, this generates
> a warning.
> 
>   make CONFIG_DEBUG_SECTION_MISMATCH=y
>   ...
>   WARNING: arch/x86/crypto/aesni-intel.o(.init.text+0x12b): Section
>   mismatch in reference from the function init_module() to the function
>   .exit.text:crypto_fpu_exit()
>   The function __init init_module() references
>   a function __exit crypto_fpu_exit().
>   This is often seen when error handling in the init function
>   uses functionality in the exit path.
>   The fix is often to remove the __exit annotation of
>   crypto_fpu_exit() so it may be used outside an exit section.
> 
> Fix the warning by removing the __exit annotation.
> 
> Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
