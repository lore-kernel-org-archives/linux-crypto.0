From: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [PATCH v1] compiler: prevent dead store elimination
Date: Mon, 1 Mar 2010 10:32:00 +0100
Message-ID: <19339.35216.412591.13392@pilspetsen.it.uu.se>
References: <4B8984EE.8090605@gmail.com>
	<20100228211511.60981829@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Roel Kluin <roel.kluin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Mikael Pettersson <mikpe@it.uu.se>, penberg@cs.helsinki.fi,
	Brian Gerst <brgerst@gmail.com>, andi@firstfloor.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, Herbert@gondor.apana.org.au
To: Arjan van de Ven <arjan@infradead.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fanny.its.uu.se ([130.238.4.241]:2256 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab0CAJcF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Mar 2010 04:32:05 -0500
In-Reply-To: <20100228211511.60981829@infradead.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Arjan van de Ven writes:
 > On Sat, 27 Feb 2010 21:47:42 +0100
 > Roel Kluin <roel.kluin@gmail.com> wrote:
 > > +void secure_bzero(void *p, size_t n)
 > > +{
 > > +	memset(p, 0, n);
 > > +	ARRAY_PREVENT_DSE(p, n);
 > > +}
 > > +EXPORT_SYMBOL(secure_bzero);
 > 
 > 
 > please don't introduce bzero again to the kernel;
 > 
 > make it secure_memset() please.

In principle I would agree, but bzero() avoids the unfortunately
rather common mistake of swapping the int/size_t parameters to
memset(). I.e., people writing memset(p, n, 0) not memset(p, 0, n).
