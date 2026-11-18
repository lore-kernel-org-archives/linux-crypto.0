Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795012935;
	b=cXLL802IZE3nUdcHHsZGkUMZ8jQbJPEnccndZdzzWA1GGM24gX56Wh5FcvmnqL/kDqpL
	 j7UkY7uG2h4e3EbH0HEK2G+AzVO/FqRejGe5IVLaTI7pd6mkUwMd6+XVnI+yxq0vRZ1H9
	 xd+4iNyC6YZqj8FKSjXns82SaXEHAoP2V9Z2w4Pzyohjq6TNox4kuxtDCmPy2aSCGGijA
	 fVJtFmi4MXnTDKCoVrp567SoOPn7W2BHwdLUwxqUDThxJNeAVj9b3ecPxC2ZouzQf2iiv
	 EURS6QmDkCN6CiwRaEAtAREBxVuaj6a9sDtc+QsXgt7Gw2szxSZogkxfDk5WKsQaRCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795012935;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 MIME-Version:Content-Type:Content-Disposition;
	bh=y3fa1nWZYsT/yb1lDnlw7P4jbrPzywmk3FjvB3M0fZA=;
	b=yFv5Bzskc4c8KQhpw9lDHDc7YIFE6LctcfGXPu+MtT9BPnoHaaLs3M/XHCJSllTcsirH
	 /u4M+mhq/G/bYuZ8wQFMTe0k6hOSaoSFp026k6GlF91pWCBrFN5a0eclc9hefj2FE2NCt
	 oFgv0Sd1oH8xMsNSJ94zHhh12jEitvzmUYBfQgV/C07oo4ZwPprzZM+q5f+s1iZgLsWFn
	 IRLjlq/hDhBCGqKcBoP5AwRgZ49EPCpxOHtmdJqvzdHdryWUnGvlcco/QUA9e0kovIg78
	 QJJYNHZnOjbgB6HTeODexPwwn4aP7y2IbhJh4QNWStVJ8E8gY9Btxbm98JZ99uHOhJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gWNeP4zW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50CE606A320;
	Wed, 18 Nov 2026 14:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gWNeP4zW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18601F000C4;
	Wed, 18 Nov 2026 14:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795012935;
	bh=y3fa1nWZYsT/yb1lDnlw7P4jbrPzywmk3FjvB3M0fZA=;
	h=Date:From:To:Cc:Subject;
	b=gWNeP4zWhmZ6U02+ERnQyo0eoKv7fVcZpwk1o+n55uWuBxJSmS1GopyJEd876Tud4
	 QGjcm5BjmyxiANt+SozAJHEC9KNHtOjh3pxwT4lJow+QIBw3jBPUu5YxEn2/XutHTh
	 Lqo0Q2jSSuE8eUcdtUYtj4h45w70U57W7LJNG7Ww5xF8H06f9G0nYTdzA7+6jBf09a
	 cQjRoDetPEV//s87Krybq7HdZnxqJHeLzjG2q13dnzzokXeRBF8UxQDSpq98R0cF2V
	 kBfxqFa5AQxVAn94qvIZkOtYOh/948y78gmgzcjvWLLMfI1Tz7cgNrJ4raJFJfWT9l
	 LHhCc+zLv70hg==
Date: Wed, 18 Nov 2026 14:42:11 +0000
From: Mark Brown <broonie@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Imre Kaloz <kaloz@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: linux-next: manual merge of the crypto tree with the mips tree
Message-ID: <av25Q7bdayobYN_G@sirena.org.uk>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mphx2YdIYQ9Wh8H0"
Content-Disposition: inline


--mphx2YdIYQ9Wh8H0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the crypto tree got a conflict in:

  arch/mips/configs/ip32_defconfig

between commit:

  22df49ef5a332 ("MIPS: ip32_defconfig: drop dead options and add-in driver=
s, add audio")

=66rom the mips tree and commit:

  fd29be9b99251 ("crypto: arc4 - Remove obsolete crypto API support for ARC=
4")

=66rom the crypto tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --combined arch/mips/configs/ip32_defconfig
index e43a6a1913e08,0c3bae4a7bac4..0000000000000
--- a/arch/mips/configs/ip32_defconfig
+++ b/arch/mips/configs/ip32_defconfig
@@@ -9,9 -9,10 +9,9 @@@ CONFIG_RELAY=3D
  CONFIG_EXPERT=3Dy
  CONFIG_PROFILING=3Dy
  CONFIG_SGI_IP32=3Dy
 -# CONFIG_SECCOMP is not set
 -CONFIG_PCI=3Dy
  CONFIG_MIPS32_O32=3Dy
  CONFIG_MIPS32_N32=3Dy
 +# CONFIG_SECCOMP is not set
  CONFIG_MODULES=3Dy
  CONFIG_MODULE_UNLOAD=3Dy
  CONFIG_PARTITION_ADVANCED=3Dy
@@@ -39,10 -40,10 +39,10 @@@ CONFIG_INET6_ESP=3D
  CONFIG_INET6_IPCOMP=3Dm
  CONFIG_IPV6_TUNNEL=3Dm
  CONFIG_NETWORK_SECMARK=3Dy
 +CONFIG_PCI=3Dy
  CONFIG_CONNECTOR=3Dy
  CONFIG_BLK_DEV_LOOP=3Dm
  CONFIG_BLK_DEV_NBD=3Dm
 -CONFIG_RAID_ATTRS=3Dy
  CONFIG_SCSI=3Dy
  CONFIG_BLK_DEV_SD=3Dy
  CONFIG_BLK_DEV_SR=3Dy
@@@ -50,11 -51,16 +50,11 @@@ CONFIG_CHR_DEV_SG=3D
  CONFIG_SCSI_CONSTANTS=3Dy
  CONFIG_SCSI_LOGGING=3Dy
  CONFIG_SCSI_SCAN_ASYNC=3Dy
 -CONFIG_SCSI_SAS_LIBSAS=3Dy
  CONFIG_SCSI_AIC7XXX=3Dy
  CONFIG_AIC7XXX_RESET_DELAY_MS=3D15000
  CONFIG_NETDEVICES=3Dy
  CONFIG_BONDING=3Dm
  CONFIG_DUMMY=3Dm
 -CONFIG_NET_TULIP=3Dy
 -CONFIG_DE2104X=3Dm
 -CONFIG_TULIP=3Dm
 -CONFIG_TULIP_MMIO=3Dy
  CONFIG_SGI_O2MACE_ETH=3Dy
  CONFIG_INPUT_EVDEV=3Dm
  CONFIG_SERIO_MACEPS2=3Dy
@@@ -66,12 -72,12 +66,12 @@@ CONFIG_HW_RANDOM=3D
  CONFIG_WATCHDOG=3Dy
  CONFIG_FB=3Dy
  CONFIG_FB_GBE=3Dy
 -# CONFIG_VGA_CONSOLE is not set
  CONFIG_FRAMEBUFFER_CONSOLE=3Dy
  CONFIG_LOGO=3Dy
 -# CONFIG_LOGO_LINUX_MONO is not set
 -# CONFIG_LOGO_LINUX_VGA16 is not set
  # CONFIG_LOGO_LINUX_CLUT224 is not set
 +CONFIG_SOUND=3Dm
 +CONFIG_SND=3Dm
 +CONFIG_SND_SGI_O2=3Dm
  # CONFIG_USB_SUPPORT is not set
  CONFIG_RTC_CLASS=3Dy
  # CONFIG_RTC_HCTOSYS is not set
@@@ -143,17 -149,28 +143,17 @@@ CONFIG_NLS_ISO8859_15=3D
  CONFIG_NLS_KOI8_R=3Dm
  CONFIG_NLS_KOI8_U=3Dm
  CONFIG_NLS_UTF8=3Dm
 -CONFIG_KEYS=3Dy
  CONFIG_CRYPTO_NULL=3Dy
 -CONFIG_CRYPTO_CBC=3Dy
 -CONFIG_CRYPTO_ECB=3Dy
 -CONFIG_CRYPTO_LRW=3Dy
 -CONFIG_CRYPTO_HMAC=3Dy
 -CONFIG_CRYPTO_XCBC=3Dy
 -CONFIG_CRYPTO_MD4=3Dy
 -CONFIG_CRYPTO_SHA1=3Dy
 -CONFIG_CRYPTO_SHA256=3Dy
 -CONFIG_CRYPTO_SHA512=3Dy
 -CONFIG_CRYPTO_WP512=3Dy
 -CONFIG_CRYPTO_ANUBIS=3Dy
  CONFIG_CRYPTO_BLOWFISH=3Dy
 -CONFIG_CRYPTO_CAMELLIA=3Dy
  CONFIG_CRYPTO_CAST5=3Dy
  CONFIG_CRYPTO_CAST6=3Dy
  CONFIG_CRYPTO_DES=3Dy
 -CONFIG_CRYPTO_KHAZAD=3Dy
  CONFIG_CRYPTO_SERPENT=3Dy
 -CONFIG_CRYPTO_TEA=3Dy
  CONFIG_CRYPTO_TWOFISH=3Dy
 +CONFIG_CRYPTO_LRW=3Dy
 +CONFIG_CRYPTO_MD4=3Dy
 +CONFIG_CRYPTO_WP512=3Dy
 +CONFIG_CRYPTO_XCBC=3Dy
  CONFIG_CRYPTO_DEFLATE=3Dy
  CONFIG_FONTS=3Dy
  CONFIG_FONT_8x8=3Dy

--mphx2YdIYQ9Wh8H0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmr9uUIACgkQJNaLcl1U
h9DHUgf/aX//h+grKq5l0OahAWlEuzBK6MuB0iw1EPwCFxqpwnfL44UAfRGwxkzv
LXStnhAnrenEF906e/QqQEsee12nlQZYsRKgqUnkd8IILRzhw6b8sXDbPLKM/5Vb
pDuvYWD0JJphg/Fw5z2p0hIGUyKbBl4KscaaTniJIkF3GAZFyJEEFjX8yJmBCylz
v6B1jdqymS/j/P7prGTmX0RI6K4B9WpS+MJ59g4Q/T7oRm85bKdB/WeLBe6/h2iz
dGOp0bYbaP2SjK0hR6wjWch4kJTYcE46VoKlmRfIhSkMlFSoUN1WHdsLwjT5FqjS
ocjzmxKOzZrrKMpmq1WfT4Ariw7q7w==
=yc/y
-----END PGP SIGNATURE-----

--mphx2YdIYQ9Wh8H0--
