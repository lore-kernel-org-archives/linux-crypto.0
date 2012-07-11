From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: aesni-intel - fix wrong kfree pointer
Date: Wed, 11 Jul 2012 11:24:44 +0800
Message-ID: <20120711032444.GC5263@gondor.apana.org.au>
References: <1340897162-5046-1-git-send-email-mbroz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:46375 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753745Ab2GKDYr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Jul 2012 23:24:47 -0400
Content-Disposition: inline
In-Reply-To: <1340897162-5046-1-git-send-email-mbroz@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 28, 2012 at 05:26:02PM +0200, Milan Broz wrote:
> kfree(new_key_mem) in rfc4106_set_key() should be called on malloced pointer,
> not on aligned one, otherwise it can cause invalid pointer on free.
> 
> (Seen at least once when running tcrypt tests with debug kernel.)
> 
> Signed-off-by: Milan Broz <mbroz@redhat.com>

Good catch.  Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
