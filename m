Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7A61BC08F
	for <linux-crypto@vger.kernel.org>; Tue,  6 Aug 2024 14:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722955632; cv=none; b=TMk+eGPJnDSiFo3RRZoda9Nrk5/Hk1YrCNHw7Znrg5i6CsbzGIDSEoLGbxcF4PGn+DfxMb7LvqWNEauGEVn1iTNJKUnvkvveW+pYbQ5gXTJiU7/wjNllsoH143aywzAwm8FQyvyWPRG9V498qXoDbTD5haOYVBPWMD8KYvKa6/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722955632; c=relaxed/simple;
	bh=hBTxP7X9fLwoaCHY51RwPvxvsYTKg4KPz4Shp6yAntw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:Content-Type:
	 MIME-Version:References; b=gIVBkzwIVxQODJFUorfk7U/Y3jFr044Y7Q9k/lvTrFA5g0kU4C8zEJPNm90ra2dNyO+X2Cu5nVizLhpTSZwRZQCeVyMxmUTjbofhHOmIQN8b5EASpd8Td0DklHUUpujUB+H0OzrSEYImMHRaIu8H4aBVPsJRsv8Fc6BFlmiTsCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=PQq9Ft3R; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="PQq9Ft3R"
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20240806144706euoutp018c9e079599fa46da9368d54805a2da3b~pKwOCZnSf2874228742euoutp01d
	for <linux-crypto@vger.kernel.org>; Tue,  6 Aug 2024 14:47:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20240806144706euoutp018c9e079599fa46da9368d54805a2da3b~pKwOCZnSf2874228742euoutp01d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1722955626;
	bh=hBTxP7X9fLwoaCHY51RwPvxvsYTKg4KPz4Shp6yAntw=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=PQq9Ft3R76DpTquvYWu7HOrxBo8itnfn4BFxGxhClyeh/VgR0PEqugYBX/8YqVbId
	 DVsc5UOfPbr5we/fG9hcFwCaGFnDeRw2nJe587JoztqlFwUwmj/3Gic9To/ur3b7ld
	 dgIyzOIkRlRkNUk5el+EXIEYJuSX1SyGBDYGCEhA=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20240806144706eucas1p1c798de6e79363b6f34d7d38e2168d762~pKwNv45JX2637626376eucas1p1o;
	Tue,  6 Aug 2024 14:47:06 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges2new.samsung.com (EUCPMTA) with SMTP id 84.67.09875.A6732B66; Tue,  6
	Aug 2024 15:47:06 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240806144705eucas1p24d12a8db41fe8a47a12185bf3f6c9f56~pKwNUD9Jh1329513295eucas1p28;
	Tue,  6 Aug 2024 14:47:05 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240806144705eusmtrp145b5f9fbd269212022e8b517314457c5~pKwNTc6ZC0030200302eusmtrp1f;
	Tue,  6 Aug 2024 14:47:05 +0000 (GMT)
X-AuditID: cbfec7f4-11bff70000002693-0d-66b2376a1eb5
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id C5.8E.08810.96732B66; Tue,  6
	Aug 2024 15:47:05 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240806144705eusmtip2d2be6a70313198ceda4368bf61fae7b4~pKwNFt5xn1333213332eusmtip2s;
	Tue,  6 Aug 2024 14:47:05 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) by
	CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Tue, 6 Aug 2024 15:47:05 +0100
Received: from CAMSVWEXC02.scsc.local ([::1]) by CAMSVWEXC02.scsc.local
	([fe80::3c08:6c51:fa0a:6384%13]) with mapi id 15.00.1497.012; Tue, 6 Aug
	2024 15:47:04 +0100
From: Daniel Gomez <da.gomez@samsung.com>
To: Andy Polyakov <appro@cryptogams.org>
CC: Jia He <justin.he@arm.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, Catalin Marinas
	<catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] crypto: arm64/poly1305 - move data to rodata section
Thread-Topic: [PATCH v2] crypto: arm64/poly1305 - move data to rodata
	section
Thread-Index: AQHa5//zJkuz2mMGX0eEFIkrDDjbXrIaKESAgAAV+IA=
Date: Tue, 6 Aug 2024 14:47:04 +0000
Message-ID: <jpn3ryddqowd6t2yj22z7rfrjkr6may53ned672coghzaa5ims@gnx7q6yx2625>
In-Reply-To: <ab440f8d-c947-4621-89e2-f348510896a9@cryptogams.org>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C5B584B6C88F6C48B7BEDADF71BB203F@scsc.local>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsWy7djPc7pZ5pvSDOY8Y7eY+6SVyeL9sh5G
	iznnW1gsul/JWDw98YfdYtPja6wW9+/9ZLK4vGsOm0XLHVMHTo8189YwejyYuIHFY8vKm0we
	2w6oemxa1cnmsXlJvcfnTXIB7FFcNimpOZllqUX6dglcGWuP3GQp6GavmLf1InsD4yfWLkYO
	DgkBE4neRTxdjFwcQgIrGCVW/VjGCOF8YZSYuuQ+UBEnkPOZUeLcHFEQG6ThzdZDrBBFyxkl
	/hyYyAThABVdWt7KDNFxmlFi714uuLmH1t9hAkmwCWhK7Du5iR3EFhHQkDj/6CAzSBGzwBRm
	iZV/V4MVCQv4SMzY/5EFoshf4u3DLawQtpXEy4ftbCA2i4CKxLOfC8FqeAV8JW4+n8UIYnMK
	OEk0NTSAxRkFZCUerfwFtoxZQFzi1pP5TBA/CEosmr2HGcIWk/i36yEbhK0jcfb6E0YI20Bi
	69J9LBC2okTHsZtsEHN0JBbs/gRlW0p0P3oLNV9bYtnC18wQ9whKnJz5hAXkMQmBZ5wS+xd0
	Qi12kbh0ookVwhaWeHV8C/sERp1ZSO6bhWTHLCQ7ZiHZMQvJjgWMrKsYxVNLi3PTU4uN8lLL
	9YoTc4tL89L1kvNzNzECU9jpf8e/7GBc/uqj3iFGJg7GQ4wSHMxKIrxdpRvShHhTEiurUovy
	44tKc1KLDzFKc7AoifOqpsinCgmkJ5akZqemFqQWwWSZODilGpic7/ZPP2F/4F+qf9TMTQw3
	ZoTu85I5t/G6RHFvnoncAeFoRyHOqYI5Kuzs835Pds+e2J1i/MJD2MWz1Lsq/MtCG17t4ns6
	rkyBB2VYGs+wNU7l7j1VuS1MKblZodnwXjhzpOIXnRPCqeHtvtOUbBVPT1zZXtK9+cKv5VN8
	pYss/uzh9DD/Kj/l2oFAw7TD++WeFnEfDF+UeHSnTdftkFUajSqlGRdnmNwr41FOr3m1/UUe
	w3yXve9jb+9NOtp9oPv/Gnbpx2aM6c6MFRqnZrm6KF7T/79umWhkuOpJ5SNLhRiE9hS2yz0u
	0j6XLpwewX3njI6ZieeZgI0d1ou6XuwqOvxzw7mFMTFfm45PV2Ipzkg01GIuKk4EABDVM3DQ
	AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsVy+t/xe7qZ5pvSDO78V7WY+6SVyeL9sh5G
	iznnW1gsul/JWDw98YfdYtPja6wW9+/9ZLK4vGsOm0XLHVMHTo8189YwejyYuIHFY8vKm0we
	2w6oemxa1cnmsXlJvcfnTXIB7FF6NkX5pSWpChn5xSW2StGGFkZ6hpYWekYmlnqGxuaxVkam
	Svp2NimpOZllqUX6dgl6GWuP3GQp6GavmLf1InsD4yfWLkZODgkBE4k3Ww8B2VwcQgJLGSVO
	/P/AApGQkdj45SpUkbDEn2tdbBBFHxklDl59wQ7hnGaUOH51JxOEs4JR4tfCTrAWNgFNiX0n
	N7GD2CICGhLnHx1kBiliFpjCLLHy72omkISwgI/EjP0fWSCKfCVOr/wF1WAl8fJhOxuIzSKg
	IvHs50KwGl6gmpvPZzGC2EIC7UwSn+ZZgNicAk4STQ0NYDWMArISj6DmMAuIS9x6Mp8J4gcB
	iSV7zjND2KISLx//g/pNR+Ls9SeMELaBxNal+6D+V5ToOHaTDWKOjsSC3Z+gbEuJ7kdvoeZr
	Syxb+JoZ4jZBiZMzn7BMYJSZhWT1LCTts5C0z0LSPgtJ+wJG1lWMIqmlxbnpucWGesWJucWl
	eel6yfm5mxiBKWrbsZ+bdzDOe/VR7xAjEwfjIUYJDmYlEd6u0g1pQrwpiZVVqUX58UWlOanF
	hxhNgWE3kVlKNDkfmCTzSuINzQxMDU3MLA1MLc2MlcR5PQs6EoUE0hNLUrNTUwtSi2D6mDg4
	pRqYshWeHlz9Yt11/QzbQoGnexWON3yq/jYvqOZRj9pDW5blEb1lHzYsdXluYhf1voznOasQ
	/+cfn8uibN+lvbVrfda28dNnPZb5tmsXSO7/3hIv/Wnai9by9ncq7wTsnUXMV8h08k2aGfti
	+o3YLYfig4o3P5ug1HV/jdjLZlsfF8Vgw8jodbrxnOumREs6v51Qum/xR8FvUyvumy9qYbZp
	tmMQ239gq++tgNNltzYyXFvp05jzMHG55teaQpsP8yWE7X5Jfmx127vvT5LNx9J7Vkr78oOl
	39wy+qz+69UB3V/pzD7R/FMC5LOPnrYM4O9b9cyY2eN3sRbn7QtnHpx97jHL+OBUVZtpcZs3
	T3x8SImlOCPRUIu5qDgRAGSks1LaAwAA
X-CMS-MailID: 20240806144705eucas1p24d12a8db41fe8a47a12185bf3f6c9f56
X-Msg-Generator: CA
X-RootMTR: 20240806125547eucas1p2016c788b38c2bc55e6b7614c3b0cf381
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240806125547eucas1p2016c788b38c2bc55e6b7614c3b0cf381
References: <20240806055444.528932-1-justin.he@arm.com>
	<CGME20240806125547eucas1p2016c788b38c2bc55e6b7614c3b0cf381@eucas1p2.samsung.com>
	<qd2jxjle5zf6u4vyu5x32wjhzj4t5cxrc7dbi46inhlhjxhw4s@llhfvho4l2e6>
	<ab440f8d-c947-4621-89e2-f348510896a9@cryptogams.org>

On Tue, Aug 06, 2024 at 03:28:25PM GMT, Andy Polyakov wrote:
> > I'm getting the following error with next-20240806
> >=20
> > make LLVM=3D1 ARCH=3Darm64 allyesconfig
> > make LLVM=3D1 ARCH=3Darm64 -j$(nproc)
> >=20
> > ld.lld: error: vmlinux.a(arch/arm64/crypto/poly1305-core.o):(function p=
oly1305_blocks_neon: .text+0x3d4): relocation R_AARCH64_ADR_PREL_LO21 out o=
f range: 269166444 is not in [-1048576, 1048575]
>=20
> This looks like the original version of the path. At the very least the
> R_AARCH64_ADR_PREL_LO21 relocation is generated for the adr instruction. =
The
> v2 has adrp and add pair for which the relocations are
> R_AARCH64_ADR_PREL_PG_HI21 and R_AARCH64_ADD_ABS_LO12_NC.
>=20

I see, I thought v2 was already part of next-20240806 tag. Reverting v1 and
applying v2 works for me. Thanks for clarifying.

Tested-by: Daniel Gomez <da.gomez@samsung.com>

Daniel=
