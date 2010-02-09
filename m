From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] dm-crypt: disable block encryption with arc4
Date: Wed, 10 Feb 2010 08:45:22 +1100
Message-ID: <20100209214522.GA27002@gondor.apana.org.au>
References: <Pine.LNX.4.64.1001260722080.20780@hs20-bc2-1.build.redhat.com> <20100209073718.GA17612@gondor.apana.org.au> <20100209145705.GA20421@Chamillionaire.breakpoint.cc> <20100209204519.GC26258@gondor.apana.org.au> <20100209211238.GC21548@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mikulas Patocka <mpatocka@redhat.com>, mbroz@redhat.com,
	linux-crypto@ml.breakpoint.cc, dm-devel@redhat.com, agk@redhat.com,
	linux-crypto@vger.kernel.org
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:34341 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752491Ab0BIVp1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2010 16:45:27 -0500
Content-Disposition: inline
In-Reply-To: <20100209211238.GC21548@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 09, 2010 at 10:12:38PM +0100, Sebastian Andrzej Siewior wrote:
>
> >This is no different to any stream cipher.
> Sure. So we fix arc4 and don't play mother . Okay I will into this :)

That would be awesome.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
