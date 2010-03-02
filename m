From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v2] compiler: prevent dead store elimination
Date: Tue, 2 Mar 2010 13:24:22 +0100
Message-ID: <20100302122421.GB19208@basil.fritz.box>
References: <4B8984EE.8090605@gmail.com> <20100228095520.GA29531@one.firstfloor.org> <4B8A8D17.2040208@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	"David S. Miller" <davem@davemloft.net>,
	Mikael Pettersson <mikpe@it.uu.se>, penberg@cs.helsinki.fi,
	Brian Gerst <brgerst@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, Herbert@gondor.apana.org.au
To: Roel Kluin <roel.kluin@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:60292 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab0CBMYX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Mar 2010 07:24:23 -0500
Content-Disposition: inline
In-Reply-To: <4B8A8D17.2040208@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> 
> >> +#define ARRAY_PREVENT_DSE(p, n)
> > 
> > Who says the Intel compiler doesn't need this?
> 
> There was a comment in include/linux/compiler-intel.h that it's not supported.

That's true for the ia64 version, but not for the x86 version which supports
gcc compatible inline assembler. So on x86 you can use it. On Itanium
it probably would need some other compiler built in.

Also in any case some form of memory clobber is needed because it'll surely
do dead-store-optimization.

-Andi

