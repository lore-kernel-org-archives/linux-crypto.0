From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH cryptodev] crypto: memneq: fix for archs without
 efficient unaligned access
Date: Mon, 9 Dec 2013 20:10:13 +0800
Message-ID: <20131209121013.GB1628@gondor.apana.org.au>
References: <1386286413-8636-1-git-send-email-dborkman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Cesar Eduardo Barros <cesarb@cesarb.eti.br>
To: Daniel Borkmann <dborkman@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:46794 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932398Ab3LIMKS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Dec 2013 07:10:18 -0500
Content-Disposition: inline
In-Reply-To: <1386286413-8636-1-git-send-email-dborkman@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 06, 2013 at 12:33:33AM +0100, Daniel Borkmann wrote:
> Commit fe8c8a126806 introduced a possible build error for archs
> that do not have CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS set. :/
> Fix this up by bringing else braces outside of the ifdef.
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Fixes: fe8c8a126806 ("crypto: more robust crypto_memneq")
> Cc: Cesar Eduardo Barros <cesarb@cesarb.eti.br>
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
