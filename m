From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v2] compiler: prevent dead store elimination
Date: Tue, 2 Mar 2010 13:17:02 +0100
Message-ID: <20100302121701.GA19208@basil.fritz.box>
References: <4B8984EE.8090605@gmail.com> <20100228095520.GA29531@one.firstfloor.org> <4B8A8D17.2040208@gmail.com> <19339.35080.637800.292674@pilspetsen.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Roel Kluin <roel.kluin@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	"David S. Miller" <davem@davemloft.net>, penberg@cs.helsinki.fi,
	Brian Gerst <brgerst@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, Herbert@gondor.apana.org.au
To: Mikael Pettersson <mikpe@it.uu.se>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:44339 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab0CBMRJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Mar 2010 07:17:09 -0500
Content-Disposition: inline
In-Reply-To: <19339.35080.637800.292674@pilspetsen.it.uu.se>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>  > +	do {						\
>  > +		struct __scrub { typeof(*p) c[n]; };	\
> 
> The typeof(*p) suggestion doesn't work. It would require p to always be
> a pointer type with an accurate (for memset) sizeof(*p). In general however
> we'll memset some array described by a void*/size_t pair, and typeof in
> that case is useless. The original'struct __scrub { char c[n]; };' was Ok.

I just suggested it because of the original array name of the macro
and without it it would have only worked for char arrays. With the new
naming it's ok I guess.

It could be made to work with macros and builtin_type_match I guess,
but it would be fairly ugly and not worth it.

-Andi

