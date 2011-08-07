From: Joachim Eastwood <manabian@gmail.com>
Subject: Re: [PATCH] lib/sha1: use the git implementation of SHA-1
Date: Sun, 7 Aug 2011 22:48:02 +0200
Message-ID: <CAGhQ9Vy9boyXuMMn=0E5Z-oN629wUTCC=ZMWWwUpB8U9RXJmdw@mail.gmail.com>
References: <1312595187-3265-1-git-send-email-msb@chromium.org>
	<CAGhQ9Vxb9F0jJ2o0ft-OOfOUMOArj_ci2gO__mxPkZJaNiA+4A@mail.gmail.com>
	<CA+55aFxKES2bbcYWD29TFsGg19KXauPDwdkgYXXZbZ72kEXduw@mail.gmail.com>
	<CAGhQ9VzBAXv1cW5hAmUmfHQBDcAprLg_8T2XxRyrWT2G85AV6A@mail.gmail.com>
	<CA+55aFyECSVQT9Gi6KuiBrrMoC44CVJRZAb+s0Lt9j0UuKyfwQ@mail.gmail.com>
	<CAGhQ9Vx-MoFb7rEBQCwqi8zLjoWiED7FXvzcq2eDfTEg_P=2ug@mail.gmail.com>
	<d86cf41b-bc2f-400f-823e-8042913974ae@email.android.com>
	<CAGhQ9VwgpPv=z3TmODKwaXSneTaCrsj4cTpLEVXJ1aATiGZLrg@mail.gmail.com>
	<m2liv5ovf5.fsf@igel.home>
	<CA+55aFz9K1A=v6RsMMfjJdMURWPNGTi6J53iA5jqSwqP+x-gRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Schwab <schwab@linux-m68k.org>,
	Nicolas Pitre <nico@fluxnic.net>,
	Mandeep Singh Baines <msb@chromium.org>,
	linux-kernel@vger.kernel.org,
	Ramsay Jones <ramsay@ramsay1.demon.co.uk>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux@arm.linux.org.uk
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:56639 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105Ab1HGUsE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Aug 2011 16:48:04 -0400
In-Reply-To: <CA+55aFz9K1A=v6RsMMfjJdMURWPNGTi6J53iA5jqSwqP+x-gRQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Aug 7, 2011 at 10:17 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, Aug 7, 2011 at 12:47 PM, Andreas Schwab <schwab@linux-m68k.or=
g> wrote:
>>
>> ARM has its own implementation of sha_transform in arch/arm/lib/sha1=
=2ES,
>> which assumes SHA_WORKSPACE_WORDS is 80.
>
> Well, that certainly explains it.
>
> I wonder if that thing is worth it. It seems to be based on the bad
> slow version of sha1, so I suspect that the biggest advantage of it
> may the byte-swapping being done more efficiently. The ARM version of
> "get_unaligned_be32()" is potentially pretty bad.
>
> Joachim, does it all work for you if you just remove 'sha1.o' from
> lib-y in arch/arm/lib/Makefile?

yes, this works. At least my board boots as normal.

regards
Joachim Eastwood

> Nico (now with corrected email address): is that ARM-optimized asm
> really worth it? Compared to the git C implementation?
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Linus
>
