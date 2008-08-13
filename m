From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c algorithm by new crypto API -V3.
Date: Wed, 13 Aug 2008 11:14:16 +1000
Message-ID: <E1KT4wK-0007mN-00@gondolin.me.apana.org.au>
References: <20080811161015.GA5240@ucw.cz>
Cc: herbert@gondor.apana.org.au, drepper@gmail.com,
	austin_zhang@linux.intel.com, bunk@kernel.org, dwmw2@infradead.org,
	davem@davemloft.net, randy.dunlap@oracle.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: pavel@suse.cz (Pavel Machek)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:40485 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752243AbYHMBOm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Aug 2008 21:14:42 -0400
In-Reply-To: <20080811161015.GA5240@ucw.cz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Pavel Machek <pavel@suse.cz> wrote:
>
> I thought we support intel x86 cpus in both 32 and 64bit modes...?

Yes we do, but the original patch had ugly ifdefs that did the
same thing.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
