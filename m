Return-Path: <SRS0=XS/1=OS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39832 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbeLIUGF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Dec 2018 15:06:05 -0500
Date: Sun, 9 Dec 2018 21:06:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        platform-driver-x86@vger.kernel.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, Alexei Starovoitov <ast@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        "open list:INTEL SGX" <intel-sgx-kernel-dev@lists.01.org>,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)"
        <kvm@vger.kernel.org>, Len Brown <len.brown@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:SPARSE CHECKER" <linux-sparse@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>
Subject: Re: [PATCH v11 00/13] Intel SGX1 support
Message-ID: <20181209200600.GA11608@amd>
References: <20180608171216.26521-1-jarkko.sakkinen@linux.intel.com>
 <20180612105011.GA26931@amd>
 <20180619145943.GC8034@linux.intel.com>
 <20180619200414.GA3143@amd>
 <20180619214833.GA5873@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <20180619214833.GA5873@localhost>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

(sorry to bring up old thread).

> > > > > Intel(R) SGX is a set of CPU instructions that can be used by app=
lications
> > > > > to set aside private regions of code and data. The code outside t=
he enclave
> > > > > is disallowed to access the memory inside the enclave by the CPU =
access
> > > > > control.  In a way you can think that SGX provides inverted sandb=
ox. It
> > > > > protects the application from a malicious host.
> > > >=20
> > > > Do you intend to allow non-root applications to use SGX?
> > > >=20
> > > > What are non-evil uses for SGX?
> > > >=20
> > > > ...because it is quite useful for some kinds of evil:
> > >=20
> > > The default permissions for the device are 600.
> >=20
> > Good. This does not belong to non-root.
>=20
> There are entirely legitimate use cases for using this as an
> unprivileged user. However, that'll be up to system and distribution
> policy, which can evolve over time, and it makes sense for the *initial*
> kernel permission to start out root-only and then adjust permissions via
> udev.

Agreed.

> > What are some non-evil uses for SGX?
>=20
> Building a software certificate store. Hardening key-agent software like
> ssh-agent or gpg-agent. Building a challenge-response authentication
> system. Providing more assurance that your server infrastructure is
> uncompromised. Offloading computation to a system without having to
> fully trust that system.

I think you can do the crypto stuff... as crypto already verifies the
results. But I don't think you can do the computation offload.

> As one of many possibilities, imagine a distcc that didn't have to trust
> the compile nodes. The compile nodes could fail to return results at
> all, but they couldn't alter the results.

distcc on untrusted nodes ... oh yes, that would be great.

Except that you can't do it, right? :-).

First, AFAICT it would be quite hard to get gcc to run under SGX. But
maybe you have spare month or three and can do it.

But ... you really can't guarantee getting right results. Evil owner
of the machine might intentionaly overheat the CPU, glitch the power,
induce single-bit errors using gamma source, ... You can't do it.

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlwNdagACgkQMOfwapXb+vLmBACglfRsX3Mr2i4qikFMap6DH0ZS
3OwAnj5BaVdvd6w1ipEHlMOQVSTpim9l
=7YhW
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
