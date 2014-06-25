From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: des3_ede/x86-64: fix parse warning
Date: Wed, 25 Jun 2014 21:50:41 +0800
Message-ID: <20140625135041.GE10379@gondor.apana.org.au>
References: <20140623163917.9000.14726.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:58614 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756907AbaFYNup (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Jun 2014 09:50:45 -0400
Content-Disposition: inline
In-Reply-To: <20140623163917.9000.14726.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 23, 2014 at 07:39:17PM +0300, Jussi Kivilinna wrote:
> Patch fixes following sparse warning:
> 
>   CHECK   arch/x86/crypto/des3_ede_glue.c
> arch/x86/crypto/des3_ede_glue.c:308:52: warning: restricted __be64 degrades to integer
> arch/x86/crypto/des3_ede_glue.c:309:52: warning: restricted __be64 degrades to integer
> arch/x86/crypto/des3_ede_glue.c:310:52: warning: restricted __be64 degrades to integer
> arch/x86/crypto/des3_ede_glue.c:326:44: warning: restricted __be64 degrades to integer
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
