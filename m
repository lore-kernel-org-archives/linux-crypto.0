From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [HIFN 05/n]: Fix data alignment checks
Date: Wed, 7 May 2008 20:48:28 +0800
Message-ID: <20080507124828.GA26672@gondor.apana.org.au>
References: <48219D24.1040702@trash.net> <48219FF6.2090009@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:40258 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754866AbYEGMsa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 08:48:30 -0400
Content-Disposition: inline
In-Reply-To: <48219FF6.2090009@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 07, 2008 at 02:26:30PM +0200, Patrick McHardy wrote:
> I'm not entirely sure about the alignmask change at the end of
> this patch, is an alignmask of 1 correct if no source buffer

If no alignment is required you want 0, 1 means 2-byte aligned.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
