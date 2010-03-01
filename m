From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH v1] compiler: prevent dead store elimination
Date: Mon, 1 Mar 2010 11:33:40 +0200
Message-ID: <b6fcc0a1003010133w45515b17g365d42afd6407eb8@mail.gmail.com>
References: <4B8984EE.8090605@gmail.com>
	 <20100228211511.60981829@infradead.org>
	 <19339.35216.412591.13392@pilspetsen.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Arjan van de Ven <arjan@infradead.org>,
	Roel Kluin <roel.kluin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>, penberg@cs.helsinki.fi,
	Brian Gerst <brgerst@gmail.com>, andi@firstfloor.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, Herbert@gondor.apana.org.au
To: Mikael Pettersson <mikpe@it.uu.se>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-iw0-f182.google.com ([209.85.223.182]:48636 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab0CAJdl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Mar 2010 04:33:41 -0500
In-Reply-To: <19339.35216.412591.13392@pilspetsen.it.uu.se>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 1, 2010 at 11:32 AM, Mikael Pettersson <mikpe@it.uu.se> wro=
te:
> Arjan van de Ven writes:
> =A0> On Sat, 27 Feb 2010 21:47:42 +0100
> =A0> Roel Kluin <roel.kluin@gmail.com> wrote:
> =A0> > +void secure_bzero(void *p, size_t n)
> =A0> > +{
> =A0> > + =A0memset(p, 0, n);
> =A0> > + =A0ARRAY_PREVENT_DSE(p, n);
> =A0> > +}
> =A0> > +EXPORT_SYMBOL(secure_bzero);
> =A0>
> =A0>
> =A0> please don't introduce bzero again to the kernel;
> =A0>
> =A0> make it secure_memset() please.

What's so secure in this function? :^)
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
