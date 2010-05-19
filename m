From: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [BUG] SLOB breaks Crypto
Date: Wed, 19 May 2010 08:53:41 +0300
Message-ID: <AANLkTil4bdUVF0eNiBZl6pIMZH-ERwJxh6sq6SSHI0kb@mail.gmail.com>
References: <AANLkTik3tKpPvilnWV6eVIm5_rUPeuCzXBDwmnZl9N6o@mail.gmail.com>
	 <20100518.142021.135951273.davem@davemloft.net>
	 <20100518223507.GB5933@linux-sh.org>
	 <20100518.154059.139137292.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: lethal@linux-sh.org, mpm@selenic.com, herbert@gondor.apana.org.au,
	ken@codelabs.ch, geert@linux-m68k.org, michael-dev@fami-braun.de,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	anemo@mba.ocn.ne.jp
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49698 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab0ESFxn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 May 2010 01:53:43 -0400
In-Reply-To: <20100518.154059.139137292.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi David,

On Wed, May 19, 2010 at 1:40 AM, David Miller <davem@davemloft.net> wro=
te:
> I don't even know of a 32-bit chip outside of x86 that doesn't
> potentially emit alignment requiring 64-bit memory operations for
> 64-bit objects. =A0So what SLOB is doing with a different default is
> even more strange. =A0And I bet you that even without the requirement=
,
> x86 runs faster with 64-bit alignment of 64-bit objects.

=46aster, sure, but SLOB is not about being fast, it's about being spac=
e
efficient.

                        Pekka
