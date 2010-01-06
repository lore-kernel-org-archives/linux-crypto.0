From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH] geode: PTR_ERR return of wrong pointer in
 fallback_init_cip()
Date: Wed, 6 Jan 2010 19:07:36 +0100
Message-ID: <20100106180736.GA9625@Chamillionaire.breakpoint.cc>
References: <4B1D02F7.2020505@gmail.com>
 <20091207134012.GA21388@Chamillionaire.breakpoint.cc>
 <4B1D0DC9.5000908@gmail.com>
 <20091211150349.GA736@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Roel Kluin <roel.kluin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Sergey Mironov <ierton@gmail.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60104 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932488Ab0AFSHn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 Jan 2010 13:07:43 -0500
Content-Disposition: inline
In-Reply-To: <20091211150349.GA736@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Herbert Xu | 2009-12-11 23:03:49 [+0800]:

>On Mon, Dec 07, 2009 at 03:14:33PM +0100, Roel Kluin wrote:
>> Return the PTR_ERR of the correct pointer.
>> 
>> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>
>Patch applied.  Thank you.

Martin picked an earlier version of this patch [0] which is allready in
Linus' tree as b59cdcb33 ("[S390] crypto: use more descriptive function
names for init/exit routines.") and I don't see this in the cryptodev or
crypto tree.
Herbert, do you want me to rebase this patch on top of Linus' tree or
do you have allready plans for this?

[0] http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg03919.html

Sebastian
