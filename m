From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] padlock: don't whinge when loaded on a non-VIA cpu
Date: Wed, 09 Jul 2008 13:58:21 +0800
Message-ID: <E1KGSh3-0002uS-00@gondolin.me.apana.org.au>
References: <20080708193741.GB28899@phobos.i.cabal.ca>
Cc: alan@lxorguk.ukuu.org.uk, kyle@mcmartin.ca, kmcmartin@redhat.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: kyle@mcmartin.ca (Kyle McMartin)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53460 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751013AbYGIF6f (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Jul 2008 01:58:35 -0400
In-Reply-To: <20080708193741.GB28899@phobos.i.cabal.ca>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Kyle McMartin <kyle@mcmartin.ca> wrote:
> 
> I completely agree, but I don't know anything about Centaur cpuids...
> 
> Something like this might suffice:

Please base your patch on top of cryptodev-2.6 which already has
a fix on this from Jeremy Katz.  Also I suggest you either remove
the printk completely or invert it so that it prints something
when the hardware is detected.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
