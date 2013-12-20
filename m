From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH cryptodev] crypto: arch - use crypto_memneq instead of
 memcmp
Date: Fri, 20 Dec 2013 22:07:46 +0800
Message-ID: <20131220140746.GB356@gondor.apana.org.au>
References: <1386757739-32564-1-git-send-email-dborkman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, James Yonan <james@openvpn.net>
To: Daniel Borkmann <dborkman@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:57364 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932397Ab3LTOHu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Dec 2013 09:07:50 -0500
Content-Disposition: inline
In-Reply-To: <1386757739-32564-1-git-send-email-dborkman@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 11, 2013 at 11:28:59AM +0100, Daniel Borkmann wrote:
> Replace remaining occurences (just as we did in crypto/) under arch/*/crypto/
> that make use of memcmp() for comparing keys or authentication tags for
> usage with crypto_memneq(). It can simply be used as a drop-in replacement
> for the normal memcmp().
> 
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> Cc: James Yonan <james@openvpn.net>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
