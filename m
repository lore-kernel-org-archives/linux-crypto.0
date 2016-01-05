From: Valdis.Kletnieks@vt.edu
Subject: Re: next-20151231 - aes crypto algorithm went missing?
Date: Tue, 05 Jan 2016 01:02:18 -0500
Message-ID: <135614.1451973738@turing-police.cc.vt.edu>
References: <4632.1451799253@turing-police.cc.vt.edu>
 <5688F5D3.7080605@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1451973738_81471P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from outbound.smtp.vt.edu ([198.82.183.121]:43581 "EHLO
	omr2.cc.vt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751592AbcAEGCe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Jan 2016 01:02:34 -0500
In-Reply-To: <5688F5D3.7080605@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--==_Exmh_1451973738_81471P
Content-Type: text/plain; charset=us-ascii

On Sun, 03 Jan 2016 11:20:03 +0100, Milan Broz said:
> On 01/03/2016 06:34 AM, Valdis Kletnieks wrote:
> > So booting into a next-20151222 kernel, I can mount an external drive
> > that uses cryptLuks.  I try -1231, and I get this failure:
> >
> > Failed to setup dm-crypt key mapping for device /dev/sdb2.
> > Check that kernel supports aes-cbc-essiv:sha256 cipher (check syslog for more info).
> >
> > Tracked it down to this difference in /proc/crypto between the 12/22 and 12/31:
>
> ...
> > This ringing any bells, before I start the New Year with a bisect? :)
>
> Perhaps see the discussion in thread
> [PATCH v2] crypto: algif_skcipher - Require setkey before accept(2)
>
> Could you try to revert this patch?
> http://git.kernel.org/cgit/linux/kernel/git/next/linux-next-history.git/commit/crypto?id=9f47e11b9e3169ff4cb35b3cdac0e0f7c2fcfe27

Confirming that this patch reverts cleanly for me, and makes cryptsetup
happy again on next-20151231.

--==_Exmh_1451973738_81471P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVotcagdmEQWDXROgAQLmSw//fOk7BMzb7WEuZhE4Ulvm02cAgppafbD/
VOuSOeCZse7+Jir/n4o76XlcsE32u4wmsL/Rf2CzJxlT8PwCY7JvfMyrzTmP75YA
JlHYLnIqWN1lXsY5vPNTgM0scv1g7BgQ4I9bh8CUhdgl4JFDq2b3yGg7+/6q7GN6
q53IEW/NdXJt//AE4BlU3rKLpl7aQfFtpaNcJTKeSJv592L6gmz/sogswoQxIv3l
eK9hMovn1l5X49qeCILpGM24mvgvQIQP03SbB+OVrDDXC1ngbTd9uS7rcg4FrWUl
u/1L/V7rx/B4Gm13449SeWcm7/B9Kuy6Rpzqzk9PG41hcp4zFgpQwYp4E0l7Z6mG
10QcaGQretly3TdAVTKy7pQT3gPdPhVuW/AR0dTcys33NiWQOXgny9djKIKiS2VF
Qu3bzqig6B1inRpmuvuzPY8KmBJK7sdQlMpv8fkH2EROT+ZjR2yyrURhgRQ6SxoC
sS9jTnM/adDCtIsyteB3XGTIoW4BbgBe6ZtlpNdjjeC++0IFjgqVYGiMRXgiOqOU
UXY4x10Lg95zHk62zxLLFrkaD3/P/Hbw0GnVguQUqMJ1NNmRsvWa/r3Z7ds5Qds4
CT+1PGGLpkzKPI7fDCJWHGnVFwi5HcSBP/SkNVLwu666jKeioqEzl3rjMmkJhp3M
3qB1GS83dx4=
=M/0o
-----END PGP SIGNATURE-----

--==_Exmh_1451973738_81471P--
