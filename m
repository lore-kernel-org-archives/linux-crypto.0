Received: from mx.itxnorge.no (itx-kvm-14.itxnorge.no [91.189.121.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249B3476059;
	Wed, 30 Sep 2026 09:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.189.121.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790759763; cv=none; b=kgREclW9IcLMPegIC5g0kvmHDJHPWHBuvWtcfpmqZZyf/cP1w+XOTxPyGqWq3fSj1jgA1VfMnIRghZOsS6jr6jotfX/dY1oP8UXRtU4oDJ2aooLw/HlW9Qb/inkp3gHgehvtRPOx/uIcdMf2NTw9inxiak6hbpmZpS4IRXPzJhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790759763; c=relaxed/simple;
	bh=bwM+9UV+CsBzjdSlGw3tSFUIrDT19nGCqGoiyzza/Ls=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RIwD7ds5t/8Tp/8fvF6Tek2IswRtGvaNJ9DCu7fJJ0ypPCS6+n6pP4ZWF3pa6uGmxoKKjDah48u4LU9AtuMuw+SHWkmypIlC9cxrDsoFF6B97XqpHqMETo3QIzyZJqc2DN3cykUH+ddJe8fcarRfBhuIspo10s3eQViaTWtb2Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=itx.no; spf=pass smtp.mailfrom=itx.no; dkim=pass (1024-bit key) header.d=itx.no header.i=@itx.no header.b=N/8RhCAS; arc=none smtp.client-ip=91.189.121.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=itx.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=itx.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=itx.no header.i=@itx.no header.b="N/8RhCAS"
Message-ID: <25c7a7c7bbe3c7f70fca559867e0883b9e4dc48d.camel@itx.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itx.no; s=mx.itx.no;
	t=1790759754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bwM+9UV+CsBzjdSlGw3tSFUIrDT19nGCqGoiyzza/Ls=;
	b=N/8RhCASCkpqAAAq9AZCLEm+vUfIi2xJUoaNK65coFE8of1aurKAydp5AXVuc6yM2qPG3Y
	IVEo1L+orB0hsHYBZsINVESa1nZQcH2mXfBiqELQ7hqpf4Shc+yxv6pI/6k5keTOi6vAhG
	Y0fGEOELtCtxxylouBA8nZHginByhLk=
Subject: Re: [PATCH v3] crypto: aes - Fix undesired override of some
 optimized AES modes
From: Stian Halseth <stian@itx.no>
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Eric Biggers
	 <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A
 . Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 sparclinux@vger.kernel.org
Date: Wed, 30 Sep 2026 11:15:53 +0200
In-Reply-To: <1f85bdb9614365fedda81fb649147da48bf7be13.camel@physik.fu-berlin.de>
References: <20260929222752.36427-1-ebiggers@kernel.org>
	 <322e5255353e3a5f9e3840a496018edd980fb016.camel@itx.no>
	 <1f85bdb9614365fedda81fb649147da48bf7be13.camel@physik.fu-berlin.de>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Z6bEZk1QJDhfraz15yO+"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0


--=-Z6bEZk1QJDhfraz15yO+
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Adrian,

On Wed, 2026-09-30 at 09:41 +0200, John Paul Adrian Glaubitz wrote:
>=20
>=20
>=20
> Very nice! Do you know which SPARC CPUs support these instructions?
>=20
> Adrian
>=20

SPARC T4 or later.

The T2 and T3 has a separate crypto unit, but not supported here.=20
Support was removed from the kernel in 6.14. Haven't tested it, as I
don't have the hardware.

Also worth noting, it's only used when the firmware lists the machine
description's hwcap-list and the CFR has its bit set.=20

I have no idea about Fujitsu's SPARC64 X family.

--=-Z6bEZk1QJDhfraz15yO+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTK1ph9OaYoND1R57zoeAEuJe36VgUCarzTSQAKCRDoeAEuJe36
VnZLAP4ueNBjD5U8fxj10uk6oB1o72itnfwX6IzaTigKjsGFTAEA6OVe+gd3KqtA
fx3a2s3USut+VsyJZC0NGduYIKHlbg0=
=ivE0
-----END PGP SIGNATURE-----

--=-Z6bEZk1QJDhfraz15yO+--
