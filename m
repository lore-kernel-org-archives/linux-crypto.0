From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 21/21] MODSIGN: Apply signature checking to modules on module load [ver #3]
Date: Sat, 10 Dec 2011 14:08:34 +0000
Message-ID: <30007.1323526114@redhat.com>
References: <8739csq5ac.fsf@rustcorp.com.au> <87boriouwa.fsf@rustcorp.com.au> <20111202184229.21874.25782.stgit@warthog.procyon.org.uk> <20111202184651.21874.57769.stgit@warthog.procyon.org.uk> <2657.1323456206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: dhowells@redhat.com, keyrings@linux-nfs.org,
	linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com,
	zohar@linux.vnet.ibm.com, arjan.van.de.ven@intel.com,
	alan.cox@intel.com, Jon Masters <jcm@jonmasters.org>
To: Rusty Russell <rusty@ozlabs.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab1LJOIx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 10 Dec 2011 09:08:53 -0500
In-Reply-To: <8739csq5ac.fsf@rustcorp.com.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Rusty Russell <rusty@ozlabs.org> wrote:

> > > Sure, you now need to re-append that after stripping, but that's =
not the
> > > kernel's problem.
> >=20
> > You may also have to remove the signature before passing it to any
> > binutils tool lest it malfunction on the trailer
>=20
> Well, you're already on your own if you're using non-module-init-tool=
s
> tools on modules.

The distributions packaging tools and initramfs tools are things I have=
 to
contend with, and others will have to contend with.

> (We'll want to enhance modinfo, at least, to show the signatures).

Ummm...  To show what exactly?  And why?  The modinfo has to go into th=
e
signature hash.  Further to find the modinfo, you have to parse the ELF=
 - which
brings us right back to how do you know you can trust it?

> > I've found that rpmbuild and mkinitrd alter the module files at
> > various times, so you'd need a bunch of signatures, one for each (m=
ay
> > just be two, but I can't guarantee that).  This means the kernel bu=
ild
> > process needs to know what transformations are going to be applied =
to
> > a module - something that has changed occasionally within the
> > distribution I use and may vary between distributions (or even just
> > someone building for themselves).
>=20
> Yes, there may be more than stripped and unstripped.  You may need to
> do fancy things.  But now, adding a signature is so easy that it's no=
t a
> real problem.  And we can always have a hook, like:
>=20
>         if VARIANTS=3D`make-module-variants $MOD`; then
>                 for m in $VARIANTS; do sign $m >> $MOD; rm $m; done
>         fi

That's not very practical.  That spreads the what-do-we-need-to-calcula=
te
question over a whole bunch of packages: the kernel, rpmbuild (if RPM-b=
ased),
mkinitramfs and maybe others.  I presume you're thinking of trying all =
the
possible strip combinations and generating a signature for each?  Howev=
er, if
someone upgrades their binutils, but not their kernel, say, and then th=
eir
initramfs gets rebuilt for some reason, this may invalidate all their m=
odule
signatures.

So the number of signatures is:

	strip_combos =C3=97 binutils_variations =C3=97 other_factors

and you have to generate all these at kernel build time because the sec=
ret key
cannot be disseminated to the installed machines that might be affected=
 by
this.

(Note that binutils may rearrange the symbol, relocation and section ta=
bles in
different ways for different versions.)

David
