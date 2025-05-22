Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F2A12E7E;
	Thu, 22 May 2025 14:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747922540; cv=none; b=LSo3HQJaCerxoFLoj3SINZmW8yxqVVbQs6Y3IG5LeJ/iU9KXvA67fuDmatuK3rLzKWMSiDwmDRn2FZRTCKKZnnjnHCgKLsmTpHyS1pLch2qPX0oLQQyLkP1wKImGRhJbc5LuICDoHhc3W/vZ7wIfbKLWMfdkckxHVMehbbzah0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747922540; c=relaxed/simple;
	bh=IJBDYm1zhobgeh9FbERBRVBW1Hyn1CyU2Bq6di3Qdho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VkOr1Nmmvvn9JpWF77njr2tyC39hXG5hRgwM5ruy8Iha0FiwC5E+W8yc5BCebGyIFqe0qnZ/UZ4r7rTS9V5f4tFJeF40z/oMsxjueEcCd5BC801Cmbwn0zawweDeFU8dEO9jqvyuVx+poqAfLWPpdVCsgLHfUljTYLZMKSzNXr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z+Jxa7Bg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z+Jxa7Bg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69425C4CEE4;
	Thu, 22 May 2025 14:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747922539;
	bh=IJBDYm1zhobgeh9FbERBRVBW1Hyn1CyU2Bq6di3Qdho=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z+Jxa7BgqX5yaqfQMZm+zQfmmGE45WibC0f+oVthi6nBydWGRwPIq+0SuRFbtVBJO
	 X+7eAfEccTg2LQi/im1fdNIgghMZH0GkD0jMapRQrNRmyjMTZe3glMIWnzwUk677KE
	 +iyRWJYrBiEa1ECXuLt6nNDAuah8IoTtsGrxrLgHhLVTst9morZyA5IuPxKdP6ukrC
	 bWbqkw7K/WNHnl/Ov64rx0lMNvDsyw65ZZaOLKfgYI/qO8Y5CUp2o9hbAMyprFo6JA
	 Qir2iT197qKN2IGJNw5vDF3/rMRJHR97y1rnunqyhTZSzFvtiLLOWxqIYhLM2JF70B
	 mowQhYwrQFbQA==
Date: Thu, 22 May 2025 15:02:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Dominik Grzegorzek <dominik.grzegorzek@oracle.com>
Cc: "aishwarya.tcv@arm.com" <aishwarya.tcv@arm.com>,
	"chenridong@huawei.com" <chenridong@huawei.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"steffen.klassert@secunet.com" <steffen.klassert@secunet.com>
Subject: Re: [PATCH] padata: do not leak refcount in reorder_work
Message-ID: <01bc9f1e-5a49-4387-b0cb-c2f8647e3b6e@sirena.org.uk>
References: <20250518174531.1287128-1-dominik.grzegorzek@oracle.com>
 <20250522131041.8917-1-aishwarya.tcv@arm.com>
 <afc8bfdaf9f14fa1f77c62f2969c4a5403ad771d.camel@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7v4MFKbpt5VMrkBn"
Content-Disposition: inline
In-Reply-To: <afc8bfdaf9f14fa1f77c62f2969c4a5403ad771d.camel@oracle.com>
X-Cookie: Beware of dog.


--7v4MFKbpt5VMrkBn
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 22, 2025 at 01:44:29PM +0000, Dominik Grzegorzek wrote:
> On Thu, 2025-05-22 at 14:10 +0100, Aishwarya wrote:

> > self->n1, self->n2) (-2) =3D=3D 0 (0)
> > 11213 03:29:55.022519=A0 # # # shared_anon_thp: Test terminated by asse=
rtion
> > 11214 03:29:55.022834=A0 # # #=A0=A0=A0=A0=A0=A0=A0=A0=A0 FAIL=A0 migra=
tion.shared_anon_thp
> > 11215 03:29:55.027864=A0 # # not ok 4 migration.shared_anon_thp
> > 11216 03:29:55.028156=A0 # # #=A0 RUN=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 mig=
ration.private_anon_htlb ...
> > 11217 03:30:14.595327=A0 # # #=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 OK=A0 m=
igration.private_anon_htlb
> > 11218 03:30:14.595777=A0 # # ok 5 migration.private_anon_htlb
> > 11219 03:30:14.596398=A0 # # #=A0 RUN=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 mig=
ration.shared_anon_htlb ...
> > 11220 03:30:34.595239=A0 # # #=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 OK=A0 m=
igration.shared_anon_htlb
> > 11221 03:30:34.595623=A0 # # ok 6 migration.shared_anon_htlb

> Looking at the test, I don't think this is related. The test allocates so=
me
> pages and attempts to migrate them between two NUMA nodes. It seems to be=
 a
> selftest for memory management code, and I don't see how this patch could=
 affect
> its outcome.

The hugepages code does make use of padata and it's a hugepages test so
there's some potential connection there, definitely not an obvious one
though.

--7v4MFKbpt5VMrkBn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmgvLmUACgkQJNaLcl1U
h9AhaAf+LyJn2mpp5ESkGdGH97HgCPHRgUcmTvPYt7GnnUpgViZsoD8SA8PpeVek
xfFMEgQvhTw/FPV/CqZHeCIi+O8n2wp0Sdk1oWr/1r6wzjkV0K6g6AGAswT1MTR7
z78PHvCtip060lAU4xxCNvbsdmD5HO8RyHv3vTId+YFKVN5/dFreudoX9Po7dvwx
djfKe3lGRFUeph565FoGSVfkicgbQhR7yPKcPrYl7aoLiVfpWADJgVKbfgyHUohD
xEns4TSVQfBWov/ZxRo/ejakkFWrZLW5p0YNfZ1/FDLfB2oXweUl3f2ovB0Ka93Z
L6aBFigykJUpRqxV54v5CP8pWV3nuw==
=wAeE
-----END PGP SIGNATURE-----

--7v4MFKbpt5VMrkBn--
