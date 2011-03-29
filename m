From: Thomas Siedlich <thomas.siedlich@yahoo.com>
Subject: Re: loop-aes: It is not longer possible to create a filesystem on an   encrypted DVD-RAM
Date: Tue, 29 Mar 2011 13:42:00 -0700 (PDT)
Message-ID: <208104.65278.qm@web114105.mail.gq1.yahoo.com>
References: <4D915AE7.BA4444B9@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Jari Ruusu <jariruusu@users.sourceforge.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nm1.bullet.mail.sp2.yahoo.com ([98.139.91.71]:27933 "HELO
	nm1.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754003Ab1C2UmB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 29 Mar 2011 16:42:01 -0400
In-Reply-To: <4D915AE7.BA4444B9@users.sourceforge.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[solved]

Hi Jari!

Jari Ruusu wrote:
> Thomas Siedlich wrote:
> > For my kernel it should mean (if I interpret
> > /usr/src/linux/include/linux/bio.h right):
> > "Tell the IO scheduler not to wait for more requests
> > after this one has been submitted, even if it is a SYNC request."
> > "synchronous I/O hint."
> > "barrier"
> > "write"
>=20
> "barrier" bit is the one that triggered EOPNOTSUPP error
> from backing device.
>=20
> > Here:
> > "barrier"
> > and
> > "read"
>=20
> Same here.
>=20
> > So "barrier" is the same in both messages. But why does it work
> > without loop? The backing device should be the same, shouldn't it?
>=20
> Because loop-AES-v3.3a has a bug in barrier request handling that
> triggers when a barrier request is sent to backing device that can't
> handle barrier request. This is what happens:
>=20
> 1) Block layer kernel code above loop driver issues empty
>    barrier request to loop driver.
> 2) Loop driver does not pass that empty barrier request to
>    backing device.
> =A0=A0=A0Instead it sets a flag to indicate "mark next request as bar=
rier".
> 3) Next request arrives at loop driver, loop driver marks that one
>    as barrier request, and eventually sends it to backing device.
> 4) Backing device driver decides that it doesn't do
>    barriers at all, and aborts processing that request.
>=20
> In short: due to loop driver bug, backing device driver
> aborted wrong request with EOPNOTSUPP error code.

Thanks for the explanation.

> This bug is fixed in loop-AES-v3.6b (it got fixed as part
> of queue code removal/rewrite).=20

Yes it is fixed.

> If you can reproduce this error with loop-AES-v3.6b, then I
> definitely want to know about it.

No I can't :-). I'm running now 2.6.38.2 (kernel.org) with
loop-AES-v3.6b and it works. I can mke2fs on the loop device
without errors. The filesystem ist mountable and I can e2fsck
the filesystem without syslog errors.

Thanks a lot Jari and sorry for the noise.

Thomas



     =20
