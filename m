From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing
Date: Fri, 16 Feb 2007 16:38:18 +0100
Message-ID: <E1HI5AB-0000rZ-32@be1.lrz>
References: <7OPWh-470-9@gated-at.bofh.it> <7OxPF-16i-7@gated-at.bofh.it> <7OSKA-8A-17@gated-at.bofh.it> <7OTGJ-1G5-23@gated-at.bofh.it>
Reply-To: 7eggert@gmx.de
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Roman Zippel <zippel@linux-m68k.org>,
	David Howells <dhowells@redhat.com>, torvalds@osdl.org,
	akpm@osdl.org, herbert.xu@redhat.com, linux-kernel@vger.kernel.org,
	davej@redhat.com, arjan@infradead.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:62300 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932393AbXBPPiv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 16 Feb 2007 10:38:51 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Roman Zippel <zippel@linux-m68k.org> wrote:
> On Thu, 15 Feb 2007, David Howells wrote:

>> > This is really the weak point - it offers no advantage over an equ=
ivalent
>> > implementation in user space (e.g. in the module tools). So why ha=
s to be
>> > done in the kernel?
>>=20
>> Because the init_module() system call is the common point of module
>> submission
>> to the kernel, not any particular userspace program.  There is no re=
quirement
>> for userspace to load a module by invoking a module tools program or=
 library,
>> and so userspace can bypass the checks entirely by just calling
>> init_module().
>> Assume for a moment that you can't trust userspace...  (Obviously, i=
f you
>> can't trust the kernel then you're already stuffed.)
>=20
> All the security stuff in the kernel should provide the necessary mea=
ns to
> restrict this system call.

Hardening a system should include deeper layers, too.

>> It is possible to protect /dev/mem and /dev/kmem or make them unavai=
lable and
>> it is possible to protect the kernel's memory whilst it is running (=
provided
>> you don't have nommu or broken hardware and you don't let userspace =
concoct
>> any DMA request it likes) which mostly closes those other vectors I
>> mentioned.
>> This isn't something I intended to look at with this patch.  Those a=
re
>> separate holes.
>=20
> Exactly and as long as there are these holes, these patches are only
> kernel bloat.

Off cause there are other ways to expose the kernel, but they can be pl=
ugged,
too, one by one. You wouldn't leave your door open just because your wi=
ndow
is open, while leaving the window open because the door is open.

> The simple verification can also be done in userspace and

You may verify in userspace, but you can't use the result.

OTOH, having 1000 lines of code to verify a module _is_ bloat for this =
task.
Remove a 0 and it should be plenty (not counting the help text).

> module signing offers no real security.

It offers security against a class of attacks.

> What real value do these patches provide, that can't be reached via o=
ther
> means?

It provides an extra layer of security: If an exploit allows execution =
of
insmod(userstring), it can't compromise kernel internals.

> Who else than distributions would be interested in this?

How large is the userbase _not_ using a distribution? And are they unab=
le to
unselect [X] Signes modules support?

> Pretty
> much any use you initially mentioned can be done in simpler ways, e.g=
=2E
> anyone afraid of modules simply disables module loading completely.

That would work if there was no need for modules. Unfortunately some pe=
ople
are doomed with external modules, or not experienced enough to customiz=
e
their system. Those could benefit from a sysctl(?) saying "unsigned_mod=
ules
=3D taint|disallow".
--=20
Whenever you have plenty of ammo, you never miss. Whenever you are low =
on
ammo, you can't hit the broad side of a barn.

=46ri=DF, Spammer: 5usmqnrkze@xFzMz.7eggert.dyndns.org
