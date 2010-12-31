From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: 2.6.37-rc7: Regression: b43: crashes in hwrng_register()
Date: Fri, 31 Dec 2010 09:51:04 +0100
Message-ID: <20101231085103.GA31935@darkside.kls.lan>
References: <20101230012003.GA2665@darkside.kls.lan>
 <4D1BF056.3060909@lwfinger.net>
 <20101230143406.GA23219@darkside.kls.lan>
 <4D1CD161.4040107@lwfinger.net>
 <20101230204522.GC23219@darkside.kls.lan>
 <4D1D0C61.9050800@lwfinger.net>
 <20101231003735.GA24101@gondor.apana.org.au>
 <4D1D27E7.7030301@lwfinger.net>
 <20101231022550.GA2512@darkside.kls.lan>
 <20101231024653.GA24879@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9zSXsLTf0vkW971A"
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Matt Mackall <mpm@selenic.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Harald Welte <HaraldWelte@viatech.com>,
	Michal Ludvig <michal@logix.cz>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:59101 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab0LaIvX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 31 Dec 2010 03:51:23 -0500
Content-Disposition: inline
In-Reply-To: <20101231024653.GA24879@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--9zSXsLTf0vkW971A
Content-Type: multipart/mixed; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 31, 2010 at 01:46:53PM +1100, Herbert Xu wrote:
> Thanks for checking.  Can you provide the output of
> 	cat /proc/cpuinfo

attached.


Mario
--=20
The only thing to be scared of, son, is tomorrow.
I don't live for tomorrow. Never saw the fun in it.
                       -- Denny Crane, Boston Legal

--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=cpuinfo

processor	: 0
vendor_id	: CentaurHauls
cpu family	: 6
model		: 15
model name	: VIA Nano processor U2250 (1.6GHz Capable)
stepping	: 3
cpu MHz		: 1600.000
cache size	: 1024 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat clflush acpi mmx fxsr sse sse2 ss tm syscall nx lm constant_tsc up rep_good pni monitor vmx est tm2 ssse3 cx16 xtpr rng rng_en ace ace_en ace2 phe phe_en lahf_lm
bogomips	: 3192.08
clflush size	: 64
cache_alignment	: 128
address sizes	: 36 bits physical, 48 bits virtual
power management:


--oyUTqETQ0mS9luUI--

--9zSXsLTf0vkW971A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTR2ZdxS+e2HeSPbpAQJPFwf/b2zh5sU6xADhI8cdpJF3QNxfGsHhm1YT
BvrLVMSxDIMi3YG8+sGfTp7n8PlNqXloDwX4lwMGnJ66kW5GUry67as02jbhAZ/w
DjUFBOOUmMqbM2ZaHNJ6uubGZ0AAHNlRrcfnaSUNcqh2I5CYExV1jQACb4Xus8JA
LGsiVXp1tqYjOePxnwWrfBo4tGxzFCun/OZsRxkitdurJBJIiHpXUurfSMIzBPb/
V0s3yoPzS1yZfJCzAa7QlaMQX72EIhgnmd/5tTPD+rb5cvUBpucffmAKGB69wRl2
A5C0GFu/ICZrub9ZgloFcJJTnzCX1Ynt0vjvRaLj01sVMxWKMb1P6A==
=XqNP
-----END PGP SIGNATURE-----

--9zSXsLTf0vkW971A--
