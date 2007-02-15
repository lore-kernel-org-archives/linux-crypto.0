From: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing
Date: Thu, 15 Feb 2007 15:34:28 -0500
Message-ID: <200702152034.l1FKYS93012172@turing-police.cc.vt.edu>
References: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com> <200702142135.40832.agruen@suse.de> <20070215054559.GD15654@redhat.com>
            <200702142214.53625.agruen@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1171571668_27755P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Cc: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	torvalds@linux-foundation.org, herbert.xu@redhat.com,
	linux-kernel@vger.kernel.org, arjan@infradead.org,
	linux-crypto@vger.kernel.org
To: Andreas Gruenbacher <agruen@suse.de>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1161198AbXBOUfH@vger.kernel.org>
In-Reply-To: Your message of "Wed, 14 Feb 2007 22:14:53 PST."
             <200702142214.53625.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--==_Exmh_1171571668_27755P
Content-Type: text/plain; charset=us-ascii

On Wed, 14 Feb 2007 22:14:53 PST, Andreas Gruenbacher said:
> I agree, that's really what should happen. We solve this by marking modules as
> supported, partner supported, or unsupported, but in an "insecure" way, so
> partners and users could try to fake the support status of a module and/or
> remove status flags from Oopses, and cryptography wouldn't save us.

Where cryptography *can* save you is that a partner or user can't fake a
'Suse Supported' signature without access to the Suse private key.

--==_Exmh_1171571668_27755P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFF1MPUcC3lWbTT17ARAh66AJ9Gzvgd0zhuDVcrNqFTnRB2GRzatwCeLVDf
kNp5hrMChhmnQIr5y+0Zehg=
=5kzR
-----END PGP SIGNATURE-----

--==_Exmh_1171571668_27755P--
