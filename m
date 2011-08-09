From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] lib/sha1: remove memsets and allocate workspace on the stack
Date: Tue, 9 Aug 2011 09:01:24 +0200
Message-ID: <CAMuHMdU1Pu7ya3W1HvoXLMPSn7vpbk=BejsCx=Kn5ieL-RuA8A@mail.gmail.com>
References: <1312844837-10086-1-git-send-email-msb@chromium.org>
	<1312847115.1643.22.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Mandeep Singh Baines <msb@chromium.org>,
	linux-kernel@vger.kernel.org,
	Ramsay Jones <ramsay@ramsay1.demon.co.uk>,
	Nicolas Pitre <nico@fluxnic.net>,
	Joachim Eastwood <manabian@gmail.com>,
	Andreas Schwab <schwab@linux-m68k.org>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:36982 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab1HIHBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2011 03:01:25 -0400
In-Reply-To: <1312847115.1643.22.camel@Joe-Laptop>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 9, 2011 at 01:45, Joe Perches <joe@perches.com> wrote:
> You should add #include <linux/crypthash.h> to
> lib/sha1.c and perhaps rationalize the use of __u8
> and char for the second argument to sha_transform in
> the definition and uses.
>
> For defense in depth, a bool could be added to sha_transform
> like:
>
> void sha_transform(__u32 *digest, const char *data, bool wipe);

Yeah, why is the second parameter not "const void *data"? That
would save some casts in the callers.

Gr{oetje,eeting}s,

=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-=
m68k.org

In personal conversations with technical people, I call myself a hacker=
=2E But
when I'm talking to journalists I just say "programmer" or something li=
ke that.
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 =C2=A0=C2=A0 -- Linus Torvalds
