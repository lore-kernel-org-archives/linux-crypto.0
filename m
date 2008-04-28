From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [CRYPTO]: authenc: fix async crypto crash in crypto_authenc_genicv()
Date: Mon, 28 Apr 2008 10:18:45 +0800
Message-ID: <20080428021845.GA7713@gondor.apana.org.au>
References: <48152E8A.2020706@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:43456 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759448AbYD1CSt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 27 Apr 2008 22:18:49 -0400
Content-Disposition: inline
In-Reply-To: <48152E8A.2020706@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 28, 2008 at 03:55:22AM +0200, Patrick McHardy wrote:
> 

> commit 5546f35aa64c020074eca8546d638fc0305eb9ff
> Author: Patrick McHardy <kaber@trash.net>
> Date:   Sun Apr 27 22:22:11 2008 +0200
> 
>     [CRYPTO]: authenc: fix async crypto crash in crypto_authenc_genicv()

Good catch! I'll apply this to crypto-2.6 and push it up to stable.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
