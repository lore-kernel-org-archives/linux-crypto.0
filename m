From: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing
Date: Thu, 15 Feb 2007 15:55:41 -0500
Message-ID: <200702152055.l1FKtfTY012824@turing-police.cc.vt.edu>
References: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com> <20070214194112.5bec3110.akpm@linux-foundation.org>
            <20070215041345.GA15654@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1171572941_27755P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	torvalds@linux-foundation.org, herbert.xu@redhat.com,
	linux-kernel@vger.kernel.org, arjan@infradead.org,
	linux-crypto@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from turing-police.cc.vt.edu ([128.173.14.107]:53319 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161237AbXBOU4N (ORCPT
	<RFC822;linux-crypto@vger.kernel.org>);
	Thu, 15 Feb 2007 15:56:13 -0500
In-Reply-To: Your message of "Wed, 14 Feb 2007 23:13:45 EST."
             <20070215041345.GA15654@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--==_Exmh_1171572941_27755P
Content-Type: text/plain; charset=us-ascii

On Wed, 14 Feb 2007 23:13:45 EST, Dave Jones said:
> One argument in its favour is aparently Red Hat isn't the only vendor
> with something like this.  I've not investigated it, but I hear rumours
> that suse has something similar.  Having everyone using the same code
> would be a win for obvious reasons.

Another argument in its favor is that it actually allows the kernel to
implement *real* checking of module licenses and trumps all the proposals
to deal with MODULE_LICENSE("GPL\0Haha!").  A vendor (or user) that wants
to be *sure* that only *really really* GPL modules are loaded can simply
refuse to load unsigned modules - and then refuse to sign a module until
after they had themselves visited the source's website, verified that the
source code was available under GPL, and so on.

Remember - the GPL is about the availability of the source.  And at modprobe
time, the source isn't available.  So you're left with two options:

1) Trust the binary to not lie to you about its license.
2) Ask a trusted 3rd party (usually, the person/distro that built the kernel)
whether they've verified the claim that it's really GPL.


--==_Exmh_1171572941_27755P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFF1MjNcC3lWbTT17ARAr2YAJ4wbVlqnW/LJ45a1duVb1reqCfxpwCfRuON
5sTJnmksg4ZJZQHW9qwqQDg=
=ybHd
-----END PGP SIGNATURE-----

--==_Exmh_1171572941_27755P--
