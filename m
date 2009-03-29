From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: testmgr - Kill test_comp() sparse warnings
Date: Sun, 29 Mar 2009 15:45:54 +0800
Message-ID: <20090329074554.GC11735@gondor.apana.org.au>
References: <1237994238-3545-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:46352 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751364AbZC2Hp6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 29 Mar 2009 03:45:58 -0400
Content-Disposition: inline
In-Reply-To: <1237994238-3545-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 25, 2009 at 04:17:17PM +0100, Geert Uytterhoeven wrote:
> make C=1:
> | crypto/testmgr.c:846:45: warning: incorrect type in argument 5 (different signedness)
> | crypto/testmgr.c:846:45:    expected unsigned int *dlen
> | crypto/testmgr.c:846:45:    got int *<noident>
> | crypto/testmgr.c:878:47: warning: incorrect type in argument 5 (different signedness)
> | crypto/testmgr.c:878:47:    expected unsigned int *dlen
> | crypto/testmgr.c:878:47:    got int *<noident>
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Both patches applied.  Thanks Geert!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
