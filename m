From: Joachim Eastwood <manabian@gmail.com>
Subject: Re: [PATCH] lib/sha1: use the git implementation of SHA-1
Date: Sun, 7 Aug 2011 19:36:03 +0200
Message-ID: <CAGhQ9VzBAXv1cW5hAmUmfHQBDcAprLg_8T2XxRyrWT2G85AV6A@mail.gmail.com>
References: <1312595187-3265-1-git-send-email-msb@chromium.org>
	<CAGhQ9Vxb9F0jJ2o0ft-OOfOUMOArj_ci2gO__mxPkZJaNiA+4A@mail.gmail.com>
	<CA+55aFxKES2bbcYWD29TFsGg19KXauPDwdkgYXXZbZ72kEXduw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Mandeep Singh Baines <msb@chromium.org>,
	linux-kernel@vger.kernel.org,
	Ramsay Jones <ramsay@ramsay1.demon.co.uk>,
	Nicolas Pitre <nico@cam.org>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux@arm.linux.org.uk
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34366 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab1HGRgE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Aug 2011 13:36:04 -0400
In-Reply-To: <CA+55aFxKES2bbcYWD29TFsGg19KXauPDwdkgYXXZbZ72kEXduw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Aug 7, 2011 at 6:52 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, Aug 7, 2011 at 4:54 AM, Joachim =A0Eastwood <manabian@gmail.c=
om> wrote:
>>
>> I see some ARM asm in your patch, maybe this is the cause?
>
> No, it's just a barrier to make sure the compiler doesn't do crazy
> things, no actual asm instructions involved.
>
> That code is quite well tested in git, so I'm surprised it has any
> problems on arm. It also has zero loops, a hang sounds odd. Can you
> get some more debug information out of it (for example, where it hang=
s
> - maybe "initcall_debug=3D1" on the kernel command line?

initcall_debug=3D1 didn't do anything to the boot log.

But I add some printk's around the calls to sha_init and sha_transform.
=2E..
NET: Registered protocol family 2
extract_buf: call sha_init
extract_buf: call sha_init done
extract_buf: call sha_transform
extract_buf: call sha_transform done
extract_buf: call sha_transform
extract_buf: call sha_transform done
extract_buf: function exit

These printk's come from drivers/char/random.c
So it doesn't seem like it hangs in any of the sha_* funtions.

But I never see any of the printk's I added to net/ipv4/syncookies.c
or net/ipv4/tcp_output.c.

btw, my compiler is: arm-angstrom-linux-gnueabi-gcc (GCC) 4.3.3

regards
Joachim Eastwood

> The biggest difference with the git sources is the slightly different
> calling conventions (passing the workspace array as an argument is ba=
d
> for code generation, btw - since now gcc doesn't see that the
> workspace accesses are dead) and the fact that the kernel version use=
s
> kernel macros like "get_unaligned_be32()" rather than it's own
> implementation.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0Linus
>
