Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9606182C5;
	Mon,  6 Jan 2025 04:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736136671; cv=fail; b=EqQUyTBvjKwhzIVDyGTiABkqOQKeq+HLG2y1ckCKJfaEYyMsZDMVXXet9RprsiJXFPvBbILbcjIc8QQpWlwWb7fyPWqOnGNfiWrpZgTpca5VQPkX2xmRmeLZa5LgtlFv1EFyJmMUxfBH8VUf6iLedx+ttNnLiN+yU7GKIoROGMc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736136671; c=relaxed/simple;
	bh=X9ePxcifaAwFTwkuAwOSSVEzOeIbhI8j16n/glisMVQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OFwYev7jkOOZFfU4DTORFRROYKEgJ15jCa4KGrupEgHUvnMrNfWQB57S17V1J3YymSlibXEYQKbRP8sSl64x+TfgVE+U1tqBWRkKp730V6/f3M2dvbfDPTwdYPTtyIoLp/pNdCQ8hPY3gi9t+wrnYs7EfKsrDkxrWu2eOdvJKBQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=C4yBR0Rf; arc=fail smtp.client-ip=40.107.244.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="C4yBR0Rf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ScFNgfN/K/KRWWDzxtB+7mbsEexRGObgFeK2hwDr72R9Afw0O4bJjMC1Ouh8vugh6Ftu3SsFAMDOa2oDOSGio3P1pzEtbfw4bX4oAxWtk4xzfNXfR9roZ8TriG6EH7l+1vNIsgxr11s+j2ck5Mh5eVXZsUMFkIvAYZtaB/A+gEHUXHVwF8QKroymQ78eg14xnWqeTMDd+xdRPtEOfMcZcBVjUBget2oYJhf9VNd6icihsE1ml/VFmWLzTFhCkTEIX99hYvMsR2TSEClaCeO27TI8OON7o3vKc5JUQpTy+usqx1BbuAhamF+aBCYBmhjRqm9uRtfYb8x4AYKCZlvlZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fr48xAUGXecavt21aovFZAOxvRHaNluOKONm8sJTCWo=;
 b=c3E7MKETxf4cDtuagShsdYbZfDzwNClM6/6/aSTMpVtcczeOj7DTWmUA12QWE+KsgN6jgYiHZMC3/pOOuAmwXzYrMyQd/3DC+ZUPqGY/h8ZQnmWyxMx14A8tRnRxeindR2CXDu4JvqSc1YsEknxkartmhiyGSFcpgj4XD0RkHOmhJG6i1sVAnQE5g1ofn0mVzqzV9D67vM4/MDm1+wWTiNEpbOlXjECHvlo/wF4rfDlzRwiJSx2b2gZ2IY2dn58ddaVflxtR/SiFuBF/lLDG3n6M/5AjNpouSKSWQVNhoAzUAgKNvN4QLvsrwL/vuTsrT4TX0dkHUK1MEjWL11MQPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fr48xAUGXecavt21aovFZAOxvRHaNluOKONm8sJTCWo=;
 b=C4yBR0Rfhcs+Ve3A2BoXxtRFXfkRld8uYfbqZ2ZOhmeNgicGVqLWOfx9nuAfPRvBmhru6r+b6/0uyxggE2wYnSokrvzPaP/Hm4M4091+mfZwoQvV3ouHP7ZSiY0ajeuNG468cPZFX3Hl3uPOBoqOgAP5sxyCgqQJU6yQrv/QX8tIvKkMLuUaZ9L9B3P2SR9dcFIHrRtc7y+YIryQGqK2VSPN39NpTWtPQXz1SWoOP/ToGEfQy5YZWGDVv85HOTwmsFhBRlFgS1b467sW3eHs6TPzYGD+j4nFS4M7Ow6aMcMbTY6sFQBHGutVdjS0bxb3pJbSjwdH41nxn5FKRO77Mg==
Received: from PH7PR12MB8178.namprd12.prod.outlook.com (2603:10b6:510:2b3::19)
 by MN6PR12MB8490.namprd12.prod.outlook.com (2603:10b6:208:470::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Mon, 6 Jan
 2025 04:11:03 +0000
Received: from PH7PR12MB8178.namprd12.prod.outlook.com
 ([fe80::77bb:a9fb:c75b:f530]) by PH7PR12MB8178.namprd12.prod.outlook.com
 ([fe80::77bb:a9fb:c75b:f530%6]) with mapi id 15.20.8314.015; Mon, 6 Jan 2025
 04:11:02 +0000
From: Akhil R <akhilrajeev@nvidia.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "davem@davemloft.net" <davem@davemloft.net>, "thierry.reding@gmail.com"
	<thierry.reding@gmail.com>, Jon Hunter <jonathanh@nvidia.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/7] crypto: tegra: Use separate buffer for setkey
Thread-Topic: [PATCH 1/7] crypto: tegra: Use separate buffer for setkey
Thread-Index: AQHbUJ6Qxi+DINGM+kmXYyCUmKJwL7L7mCkAgALfjvCABEn+gIAGfV1w
Date: Mon, 6 Jan 2025 04:11:02 +0000
Message-ID:
 <PH7PR12MB817817C71B80A04A82CEEF1EC0102@PH7PR12MB8178.namprd12.prod.outlook.com>
References: <20241217161207.72921-1-akhilrajeev@nvidia.com>
 <20241217161207.72921-2-akhilrajeev@nvidia.com>
 <Z2_iroxlT3C1d1HQ@gondor.apana.org.au>
 <PH7PR12MB8178F6A37DE6CD41850529BBC00A2@PH7PR12MB8178.namprd12.prod.outlook.com>
 <Z3XkxdheTGBnCmQR@gondor.apana.org.au>
In-Reply-To: <Z3XkxdheTGBnCmQR@gondor.apana.org.au>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR12MB8178:EE_|MN6PR12MB8490:EE_
x-ms-office365-filtering-correlation-id: 7e117c49-5e82-4a9f-539a-08dd2e082276
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?BkH8b6VKvdMT3L/KzSXaHa3VHYqxfj5Ftrth0JhjpmyJcBOUgMruXl6oLFS8?=
 =?us-ascii?Q?PDEg7FczNtwf/AHW4Io2tpgbZlGGVxC5702h1lWYsazuOJohgm8cwTgReP5A?=
 =?us-ascii?Q?pwJ2+ifPCTzv9UDk9xjXFczTo5keKMYuFSEocjPKm3O572IQeJDuKed4+qbW?=
 =?us-ascii?Q?UtetRnt6eIFOhWBqFybIiygWZ3mNNWXhg2J4TX16uwbHgZys0gF7VxyBE110?=
 =?us-ascii?Q?MGgHp6SfCPjyY4JUFZo3YoP15S0OAtHRfYy4HzGjIx9UeyFQHAzC9K1MEpxk?=
 =?us-ascii?Q?QDPgyCAFIFUiFvzR1pUjjkk9kwADQv6zfi4HQchyAaBLWGB4ZJ+WoPXeizzK?=
 =?us-ascii?Q?rK1to9TLM7PXZaNLYvBYodX/bdUbynk2MkIgkxmq/rCXQSnIG4EOsYdJwsLb?=
 =?us-ascii?Q?w3UZSB4UqXDA46BptXzaBADj2Og1W8vgupcEaHvbrKejblpKoB4SK0we9iys?=
 =?us-ascii?Q?6VhA/+6Ou67Iw3gpHhooUe0wOx9rNoCu1oisnj/tzMjRkMCUd4Vj0og2QR47?=
 =?us-ascii?Q?9II4wU7NOtuDieZneKb5roOXhT1gktNF95zgh15iCVyljzQwd9ZCLJC3RwHi?=
 =?us-ascii?Q?QJZztHUnNSVjUPR2vegVShtMf8rzRQgx8hAbSMtZKVWQa1W8cVWoTEQWnzk2?=
 =?us-ascii?Q?sNOm1xAUmX7WTQ9RXmL2ZFm4YWvwqQPo470mJjAKsd8zQGiVfaJO4/DKyMOW?=
 =?us-ascii?Q?UR4Il47Kn6gi3m6t4FrgJmeFpNJqFOIPN4CPklaiOplLVyGHFrBfXyW7Zx8R?=
 =?us-ascii?Q?80ONGhufjykeLRyUZwe07hinT2dr+imUJyW919tM3p4RJL4NQFDUDh7aDjP4?=
 =?us-ascii?Q?nEQyXWPgNqf8lOMKrDPK/tdH0scVH2SxcrGOZuxzGRG3FCXTi727b/QTsAFI?=
 =?us-ascii?Q?KHjWT+ADzn+Sxtyh1B/g3DSHsdSoRZd5xiwypQMYE16IVCCW3DLGP+A5Qre2?=
 =?us-ascii?Q?ZUNC82ekv7L8AozMl6qO4MFwcI0Zr0GHqpyui2L49QXmGkSh9ht+CdP37GuA?=
 =?us-ascii?Q?f22l9N4uTcwHYA4+6PiCBfMN/TFe9sMEshpG7x+CvmV9ayXMDi+zx/Vn+12C?=
 =?us-ascii?Q?Opyx3Cev9G81rML//ed40MdXs3AzLie0oo9jiywIjFZoUswh+SyZ1AtMgI7K?=
 =?us-ascii?Q?VpGWTD3hTfUcrboLezokWXaY9k1pxduj7tImDtE1Pux0UBSISLTfGPuNv65g?=
 =?us-ascii?Q?OYWDyBlxEar1KpQ04cQ7sjyOjHuYOHg46xHctviP0BwXH8pEp2QmV6CnIYlf?=
 =?us-ascii?Q?79Mzd1yJpwWVxx2d3wflunFs/Z8N/y/8G36GFucUo5TKAKZltDN1nf326d7R?=
 =?us-ascii?Q?RTwZhWB/0Gvu3SYoXl3YrSshsgEgXAxbsFrX06SH6M20ReCLfHT0svix3i+n?=
 =?us-ascii?Q?yLAdNIbtct1XoJ/1ZVthBqETXc7hLqqpBciSERZt7mRf8/N96fBV3VbzzKVo?=
 =?us-ascii?Q?qDpZYVMg2nAyc7e+6ycuMpN5/tcgOT1T?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB8178.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?yraD/8cQvIIZtGhluHJbgHqhNRp0Obi2T9hSJQbMh3qoOWGpOd2mVUb1KXK1?=
 =?us-ascii?Q?Ztg7wC3fsr8e0fkC8HkPjXFCbcX5cGwqkOXICOcgF6KsXuUe4UFgZxLTUaQa?=
 =?us-ascii?Q?yl/CEdXTrZY71y3N+EOmr0qATvXOjXo6IbBuhVDCvtHdi1SQ+HR5KL4mbSO8?=
 =?us-ascii?Q?WlAU6X576aPXNZOPXFXVGvP39U8JEnKNDfbXVDLlerZnsIJM5muCVKDv99fj?=
 =?us-ascii?Q?bxzHv0cDvp1MoRe4sz6tpcnzRr2BxcltX3d3jES8FTemSkU0qkt33ELlzWxy?=
 =?us-ascii?Q?SPSBFPQ448eKRK5s3NZU6MeIKQAb+hlxROeUZuxbKL55cU35qVbyQab59Oci?=
 =?us-ascii?Q?zXy+fLq9fPPfBCkBulMRsoWizjNvu0M8HQAh45dpUHGc6LB1W/ETOFCKE9Qb?=
 =?us-ascii?Q?0eazaXREvM7rPBGRW5yfynzP3gX+PJt39P0fi5izopHfkrE287swek6z6kZK?=
 =?us-ascii?Q?ve9L/CeQ+onSucv+bXQrUXikgqtN+RL6KEJS7h7z5lqhQN/aE9e7h1KAug+s?=
 =?us-ascii?Q?I/iOEQcSRQpOoz7oSEniwUywFnb0xenrFH8nTuZ26UpbTPcrQ+/8w1Mig+yH?=
 =?us-ascii?Q?A1n7rk6qbZTsWEsdWPVOCkOsfH/2XRx/GKG12VV3QCz/sVqq3DUkBZdXjbds?=
 =?us-ascii?Q?krb+qj5aWXgqj4FFZsWhvjxswo8IQUwc1Hg7J00BLsKbz7Kiw28QtVvSmjy3?=
 =?us-ascii?Q?QUT+8YZs6h4MAIj0iKqjT1oeqA6j8qiprurBx+GLpbNtbiSYq0EwodZQ1Jvo?=
 =?us-ascii?Q?NM5RuVluLctQ9fyrh03mOOWXERb/0zfpSk5Pd6uRkVqQskr/JCKGU7PaFHS5?=
 =?us-ascii?Q?J049ogckg97T5JHKkZTfyqlcsYumZLBmp149NmHUzmzmEpNKpJKQO0aKhcdZ?=
 =?us-ascii?Q?JSHu2sRuhGjzcBFh/dQ+p7inNB7jNZWv9ES/+ZLh6K+JVqeq4y41tQtjEUbb?=
 =?us-ascii?Q?PUJEVj4pTrm7e75mzfqRbpcjlTnIhRrYKaETBFrvnZDo49+jwPYjAOp+zO0f?=
 =?us-ascii?Q?fhX4KxjOe4Zsu1UziFGl+N7iBsVX5c5RqdWSiRxZ6oz/TtExp+K0z2snP+58?=
 =?us-ascii?Q?+Iy87KkSHpq10RkOBbDZYJ0sYEeq33+24gHTmiQA9vXQC/084xO+/jsQ08B+?=
 =?us-ascii?Q?Ci9eXLZZceY6LXAAlg9OVDGW2BUNZEv2tQOTuVB9jKgbc5deMwLObCLSPqHe?=
 =?us-ascii?Q?Sc9P6IVAZrvO5u4Hrl6oE49aLdz6kIt+jFG0kM8beekLypzjZBqIN073xQPj?=
 =?us-ascii?Q?tg7lLgPPkZd1V09dJl3CFuGXzWub1aQm+2BqlpeySPChjcT1EkNLCBMoEzTn?=
 =?us-ascii?Q?4+t/7goTN+pntXNING7yJI4GPwBDslYbd0+cXvmdcPr4r3WKVCGwUIbiS6Uu?=
 =?us-ascii?Q?2KnK+jJo8juAgFERxMRVErGgYZfFvnG7eTq0IdpK0Qtzg1W6BoH4WkZjUmXN?=
 =?us-ascii?Q?kxahVRauTSh7coLy/xb+OTIe/fePVevKUQbzXhoxfkKRIiqgzN+5wqpv54Er?=
 =?us-ascii?Q?YTTbBQ232SS0T5XHWR9i204OJnbRUFzN1QezL5umzqzxYjjmbu2t2HVQTzSg?=
 =?us-ascii?Q?yEcnH5PqQC46Ke9SFZd9XLwi7K55yshOKcygepes?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB8178.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e117c49-5e82-4a9f-539a-08dd2e082276
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2025 04:11:02.8763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mGBzifXxnP2F2U52kj8tGBvubjOivqRMZfdjm6v+KXqg/x+RAVJuP306Znceys7WpPkmB3VjeD+50MOQxUuWRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8490

, Dec 31, 2024 at 04:25:06AM +0000, Akhil R wrote:
> >
> > Does it sound good, or do you think it will make the code overly compli=
cated?
>=20
> My main concern was arbitrary failure when you exceeded the 16-slot
> limit.  As long as that problem goes away I'm happy with any solution.

Thanks. I will send out a patch for this along with the other changes as th=
e next version.=20

Any concerns on the other patches in the series? I can push the updates tog=
ether in
the next version, if anything.

Thanks,
Akhil
