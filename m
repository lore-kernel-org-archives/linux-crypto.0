From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [RESEND] crypto test: use print_hex_dump from <linux/kernel.h> instead
Date: Tue, 27 Nov 2007 09:05:50 +0800
Message-ID: <20071127010550.GB447@gondor.apana.org.au>
References: <20071126143939.GB28022@gondor.apana.org.au> <1196098095-8995-1-git-send-email-crquan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	dengxw@163.com, Randy Dunlap <randy.dunlap@oracle.com>
To: Denis Cheng <crquan@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4063 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754632AbXK0BFz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Nov 2007 20:05:55 -0500
Content-Disposition: inline
In-Reply-To: <1196098095-8995-1-git-send-email-crquan@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Nov 27, 2007 at 01:28:15AM +0800, Denis Cheng wrote:
> this patch is against cryptodev-2.6, and have passed scripts/checkpatch.pl
> 
> KERN_DEBUG is stripped out, this acts more like the original in tcrypto.c
> 
> and the last parameter "bool ascii" set to zero to disable ascii output,
> this could keep it happy on Unicode terminals.
> 
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Denis Cheng <crquan@gmail.com>

Sorry, it still doesn't compile because it doesn't change test_aead.
Perhaps you need to pull cryptodev again?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
