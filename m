From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: HIFN driver update.
Date: Thu, 13 Nov 2008 22:07:58 +0800
Message-ID: <20081113140758.GC32012@gondor.apana.org.au>
References: <20081111190553.GB18218@ioremap.net> <20081113135854.GA32012@gondor.apana.org.au> <20081113140440.GA9947@ioremap.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Andreas Gerlich <agl@online.de>
To: Evgeniy Polyakov <zbr@ioremap.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:39698 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751192AbYKMOIB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Nov 2008 09:08:01 -0500
Content-Disposition: inline
In-Reply-To: <20081113140440.GA9947@ioremap.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 13, 2008 at 05:04:40PM +0300, Evgeniy Polyakov wrote:
>
> Not sure if it is possible, since half of the Patrick's patches were
> not applied because of already made cleanups. I can split to Patrick's
> and 'the rest' though. New features (like variable ring size) will be in
> the new patches.

It doesn't have to be exactly what Patrick had, all I'm asking for
is one logical change/bug fix per patch.  Otherwise when someone
tries to debug this down the track they'll hit this changeset and
spit the dummy :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
