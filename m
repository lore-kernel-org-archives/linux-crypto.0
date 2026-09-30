Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DED46EF77;
	Wed, 30 Sep 2026 20:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=130.133.4.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790799169; cv=none; b=IDGfGFfARwVjo/eaDOsLlQqWHQ2axcWg8CuJUKdYEIj7FQe+Ey0cYX//d7T/0SSXmXjR/BpxTDcfe5OGPwA5KcG93fmzBEsclvT+pwzSrsLYQ+x2lgO+Lbh6byKGCXYDT9uC2tJneYqm7cQlOqLHf+7xdthILhMqdNa5qwXDH5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790799169; c=relaxed/simple;
	bh=sBgF9Y46NI/gU3jT2wUJYG50u/1/RqY7WhqZc5NYaA0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=B/bal00Hh3+B+3UFMo/jkb7isxYRVk2LWZTknLBNqamTBSovscwxaapXDpkvhCAtUP+WP8zckFbiPtEE4lXepBuv1b3eldC/du/lAFo24/EXQOxc1OJ2C3kmMc1XPEgUedKkB0NUirW2ll1nV7yYDol36a+Rt+GDrUQBDMDLFC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=physik.fu-berlin.de; spf=pass smtp.mailfrom=zedat.fu-berlin.de; dkim=pass (2048-bit key) header.d=fu-berlin.de header.i=@fu-berlin.de header.b=drVVsVb3; arc=none smtp.client-ip=130.133.4.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=physik.fu-berlin.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zedat.fu-berlin.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fu-berlin.de header.i=@fu-berlin.de header.b="drVVsVb3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=fu-berlin.de; s=fub01; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:From:
	Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=fn94tcPxJTTGol27yw+1XT2Fjcn8JLYae+CiyHYbMOY=; t=1790799165;
	x=1791403965; b=drVVsVb3hmzJdHTwaZjDsbOC5agt/SKDoVZJSYB8D/dh7Gw956B4p+9GAL2kN
	FsXw/M3dzj++vxH9hCfMgAe4KS9Q4Qe7CzZaP9fMHWYFJI5FxOiFwiIQU1TfF7YRCf6411g9nVMoR
	PqjCY7Bv5p1f2j9JEaF6FQ6rxWUCpU+H6r6YcfnXq7Kd1zxt0jo2DBH/Y3BeFkW2JTizavZPIiQQs
	YbhTO//4xsWspKjYM5GmIrRfLI/4yWrQNfqgA15sUofNIhw6dlAR8eOAt04X8hTPxLJelZ0mQ6AAy
	cxTbpdic8JTnsfkELPnnALLh7BGvfM/h6A9jCyID9G2+m5YGCw==;
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.100)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1xC0fT-00000001rhF-0oj0; Wed, 30 Sep 2026 22:12:43 +0200
Received: from p5dc55206.dip0.t-ipconnect.de ([93.197.82.6] helo=[192.168.178.61])
          by inpost2.zedat.fu-berlin.de (Exim 4.100)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1xC0fS-00000001Cht-408o; Wed, 30 Sep 2026 22:12:43 +0200
Message-ID: <20b7ef8ffa6ebd8903967b66867808a7f4355a70.camel@physik.fu-berlin.de>
Subject: Re: [PATCH v3] crypto: aes - Fix undesired override of some
 optimized AES modes
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To: Stian Halseth <stian@itx.no>, Eric Biggers <ebiggers@kernel.org>, 
	linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A
 . Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 sparclinux@vger.kernel.org
Date: Wed, 30 Sep 2026 22:12:41 +0200
In-Reply-To: <8d3d3142d1ac323695a3ea2d5b3e2a10d2a129d6.camel@itx.no>
References: <20260929222752.36427-1-ebiggers@kernel.org>
		 <322e5255353e3a5f9e3840a496018edd980fb016.camel@itx.no>
		 <1f85bdb9614365fedda81fb649147da48bf7be13.camel@physik.fu-berlin.de>
		 <25c7a7c7bbe3c7f70fca559867e0883b9e4dc48d.camel@itx.no>
		 <3ea57d640ac7409fa37b15ec9e3f49126347e432.camel@physik.fu-berlin.de>
	 <8d3d3142d1ac323695a3ea2d5b3e2a10d2a129d6.camel@itx.no>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-ZEDAT-Hint: PO

Hi Stian,

On Wed, 2026-09-30 at 16:07 +0200, Stian Halseth wrote:
> > I think SPARC64 X is not supported by the Linux kernel at all, is it?
> >=20
> There some chip detection for it, but I've never tested, or heard about
> anyone actually using it.=20
>=20
> sparc64: correctly recognize SPARC64-X chips
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D76950e6e54ccfc98a25b501dbb1bc879cce1aa29
>=20
> cpu hw caps support for sparc64x:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D4e96377983d2e060dd89703f1846ad920af9e17f

There is one guy on the debian-sparc mailing list who got one.

Not sure if he's still active these days. I'll try to reach out.

Adrian

--=20
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913
