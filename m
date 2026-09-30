Received: from mx.itxnorge.no (itx-kvm-14.itxnorge.no [91.189.121.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B2B51CF74;
	Wed, 30 Sep 2026 17:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.189.121.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789162; cv=none; b=BJVIDgdqPhFlkrW3LvmzgJwhxRwc96AuYQNk0OZvMVWLtOPEKhjnJRWY61WhOa+atjIFaJY8LiDpf2sN719TUlc+ujDDUA4AgRjVwfmQ8G6R1UZc+apm2+odc+WcqHTcGdL/UW7Iz1uwZ2zT2IFvFvUkRpvU9o7HdcoqPanV/fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789162; c=relaxed/simple;
	bh=OcYdiQgz3hbXU9S9pktC02KaNG2OX2xxJKSURVyzdUs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=a57U+UlSvhr6yg4gaCLIaQSFEsS0binp+0mOSnx9l5+n+H9Yb3z949jFiz9Wp4cNU7/o0lEljAELTD8+J6BcFPjLU9aPf6ZiFlBq4VceMsluM0y1hiaP7/mQvGLjgDd1Im69zxiqtO4YHSCXbuWePtPZJ3t1PJlNCSlMbqR1smk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=itx.no; spf=pass smtp.mailfrom=itx.no; dkim=pass (1024-bit key) header.d=itx.no header.i=@itx.no header.b=awSKi71g; arc=none smtp.client-ip=91.189.121.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=itx.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=itx.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=itx.no header.i=@itx.no header.b="awSKi71g"
Message-ID: <61b4eb60d9a04bfc6bdf5b765741112419579f74.camel@itx.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itx.no; s=mx.itx.no;
	t=1790789158;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OcYdiQgz3hbXU9S9pktC02KaNG2OX2xxJKSURVyzdUs=;
	b=awSKi71gxB1SRz46SE10Z8W+khln59mQLp0xcPab2NPu6RQ4VJumoAM2RU25sjxUPEay+p
	mmdh8mqjw/u/q1MVH7AiSHH667I/KUVbFvnfU88U+jvJfA3lC0frQiv0HTLDxQaDcjHXVX
	VIWZGiTvSC/zi3poGQeomK/LEbiyTDg=
Subject: Re: [PATCH v3] crypto: aes - Fix undesired override of some
 optimized AES modes
From: Stian Halseth <stian@itx.no>
To: Magnus Lindholm <linmag7@gmail.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Eric Biggers
 <ebiggers@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A .
 Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 sparclinux@vger.kernel.org
Date: Wed, 30 Sep 2026 19:25:57 +0200
In-Reply-To: <CA+=Fv5R0F5YNgORUx1c8YWzyFcS6wqVtmzQUXaS3vuLHYwBndw@mail.gmail.com>
References: <20260929222752.36427-1-ebiggers@kernel.org>
	 <322e5255353e3a5f9e3840a496018edd980fb016.camel@itx.no>
	 <1f85bdb9614365fedda81fb649147da48bf7be13.camel@physik.fu-berlin.de>
	 <25c7a7c7bbe3c7f70fca559867e0883b9e4dc48d.camel@itx.no>
	 <3ea57d640ac7409fa37b15ec9e3f49126347e432.camel@physik.fu-berlin.de>
	 <8d3d3142d1ac323695a3ea2d5b3e2a10d2a129d6.camel@itx.no>
	 <CA+=Fv5R0F5YNgORUx1c8YWzyFcS6wqVtmzQUXaS3vuLHYwBndw@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-sTOkNDu79atxL9OFkPbH"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0


--=-sTOkNDu79atxL9OFkPbH
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Magnus,

On Wed, 2026-09-30 at 18:03 +0200, Magnus Lindholm wrote:
> I while back I got a hold of a Sun/Orcle M3000 box, there wasn't that
> much
> missing in the linux kernel, and some hardware manuals available
> online
> gave me the missing pieces. I have an experimental kernel running now
> with gentoo user-land installed. The box has been running stable for
> a while
> now during normal load (building stuff with emerge). I'm doing some
> final
> cleanup work with the patches now before I send them out.

Very nice, sounds promising!

/Stian


--=-sTOkNDu79atxL9OFkPbH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTK1ph9OaYoND1R57zoeAEuJe36VgUCar1GJQAKCRDoeAEuJe36
VmkBAP9GFeaRKsPLlVHMrRwKI2g5sQmqW9IwAfFT4NBaHnzLrgD9Fz9hKewXdH6l
Ob4psqoTYzvaqVE8SuE2iDLjkAIuOQE=
=D5C5
-----END PGP SIGNATURE-----

--=-sTOkNDu79atxL9OFkPbH--
