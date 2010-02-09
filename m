From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] dm-crypt: disable block encryption with arc4
Date: Tue, 9 Feb 2010 18:37:18 +1100
Message-ID: <20100209073718.GA17612@gondor.apana.org.au>
References: <Pine.LNX.4.64.1001260722080.20780@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mbroz@redhat.com, linux-crypto@ml.breakpoint.cc,
	dm-devel@redhat.com, agk@redhat.com, linux-crypto@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:52628 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752473Ab0BIHhZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2010 02:37:25 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1001260722080.20780@hs20-bc2-1.build.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> You should rather add a flag CRYPTO_ALG_CHANGES_STATE to determine that a 
> cipher can't be used to encrypt disks.

No, please see my reply in the previous thread.  What we should
do is fix arc4.  I just haven't got around to doing it yet.

As to blacklisting algorithms not suitable for disk encryption,
that is up to the dm-crypt maintainers to decide.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
