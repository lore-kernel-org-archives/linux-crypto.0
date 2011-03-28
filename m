From: Thomas Siedlich <thomas.siedlich@yahoo.com>
Subject: Re: loop-aes: It is not longer possible to create a filesystem on an  encrypted DVD-RAM
Date: Mon, 28 Mar 2011 15:24:21 -0700 (PDT)
Message-ID: <610509.93400.qm@web114106.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Jari Ruusu <jariruusu@users.sourceforge.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nm26-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.230]:39622 "HELO
	nm26-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754995Ab1C1WYW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Mar 2011 18:24:22 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Jari!

Jari Ruusu wrote:
> Thomas Siedlich wrote:
> > I try to format a loop-aes encrypted DVD-RAM in
> > /dev/sr0 with mke2fs.
>=20
> What loop-AES version are you using?

3.3a, which is the latest in Debian.
I see sourceforge has 3.6b :-( and I see also that the Debian package
has orphaned.
<http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D614808>
It's a pity.

> What kernel version are you using?

2.6.35.3 (selfcompiled from kernel.org).

> > ,----[/var/log/syslog]
> > | Mar 27 15:29:27 eagle kernel: loop2:
> > loop_end_io_transfer err=3D-95 bi_rw=3D0x461
>=20
> Backing device returned EOPNOTSUPP (Operation not supported
> on transport
> endpoint) error for a write. Interpreting rest of bi_rw
> bits depends on
> kernel version. For 2.6.38 kernel bi_rw means: "metadata io
> request",
> "request to discard sectors", and "This bio has already
> been subjected to
> throttling rules. Don't do it again"

=46or my kernel it should mean (if I interpret=20
/usr/src/linux/include/linux/bio.h right):
"Tell the IO scheduler not to wait for more requests after this
=A0 =A0 =A0 =A0 one has been submitted, even if it is a SYNC request."
"synchronous I/O hint."
"barrier"
"write"

> > | Mar 27 15:29:27 eagle kernel: Buffer I/O error on
> >   device loop2, logical block 0
> > | Mar 27 15:29:27 eagle kernel: lost page write due to
> >   I/O error on loop2
>=20
> Somehow EOPNOTSUPP error got interpreted as I/O error
> and/or write was not
> retried with bi_rw bits cleared that backing device do not
> support.
>=20
> > | Mar 27 15:29:27 eagle kernel: loop2:
> >   loop_end_io_transfer err=3D-95 bi_rw=3D0x20
> > | Mar 27 15:29:27 eagle kernel: Buffer I/O error on
> >   device loop2, logical block 0
>=20
> Backing device returned EOPNOTSUPP error for a read.
> Interpreting rest of
> bi_rw bits depends on kernel version. For 2.6.38 kernel
> bi_rw means:
> "metadata io request".

Here:
"barrier"
and
"read"

So "barrier" is the same in both messages. But why does it work
without loop? The backing device should be the same, shouldn't it?

> > It just works fine but unencrypted :-(.
>=20
> As a temporary workaround, you can create unencrypted file
> system and then
> encrypt it in-place using aespipe tool.

Great idea! I give it a try.

dd if=3D/dev/sr0 bs=3D64k | aespipe -e AES256 -K ./key.gpg \
  | dd of=3D/dev/sr0 bs=3D64k conv=3Dnotrunc

This works. Thanks Jari for this workaround!

Thomas



     =20
