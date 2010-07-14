From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3]crypto:hifn_795x.c Fix warning: variable 'ctx' set
	but not used
Date: Wed, 14 Jul 2010 20:12:04 +0800
Message-ID: <20100714121204.GA11194@gondor.apana.org.au>
References: <1278441397-10960-1-git-send-email-justinmattock@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net, jkosina@suse.cz,
	kim.phillips@freescale.com
To: "Justin P. Mattock" <justinmattock@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:34437 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab0GNMMK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Jul 2010 08:12:10 -0400
Content-Disposition: inline
In-Reply-To: <1278441397-10960-1-git-send-email-justinmattock@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 06, 2010 at 11:36:37AM -0700, Justin P. Mattock wrote:
> The below patch gets rid of an unused variable ctx reported by
> GCC when building the kernel.
>   CC [M]  drivers/crypto/hifn_795x.o
> drivers/crypto/hifn_795x.c: In function 'hifn_flush':
> drivers/crypto/hifn_795x.c:2021:23: warning: variable 'ctx' set but not used
> drivers/crypto/hifn_795x.c: In function 'hifn_process_queue':
> drivers/crypto/hifn_795x.c:2142:23: warning: variable 'ctx' set but not used
> 
>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

Patch applied.  Thanks Justin!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
