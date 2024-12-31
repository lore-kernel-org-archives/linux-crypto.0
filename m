Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2054.outbound.protection.outlook.com [40.107.220.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5931422D4;
	Tue, 31 Dec 2024 04:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735619115; cv=fail; b=nK5CUgq2aj7U+lUdaM7CEpPkWRg6OmuVHes5R3dqOpOdD9KLEy02qdjLYa+vZKoR7cLQB7n9nhPRCuYQcoztZg3mNfs4YRpqE88x97L2/2eokxYHkLp0BlrphuFDxWdA/LmSITWiAoaaDsCNK/UStQ95a9yxZnz5LRfYYhW7pCo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735619115; c=relaxed/simple;
	bh=0nGqrFfNUfeYVta08Y8t72dGCGQummDMHsbMWt+mets=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XPxdl6N1fOz5ar9jIbFNrM9UnOYNg8WX22guFnc/lhUBmEdEET+ioUaNO5M/0FNFBam0Uz0ee7N5AiERlgLbrwI8NzIMl1ji5BCG/XXVEB5SuN8I0Oxh1TooDm2C1yGfe71SNXqGfgD9Tmqm6ce6ZePvwLNoMVWIxXvfoFte/6A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NDVEBrXX; arc=fail smtp.client-ip=40.107.220.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NDVEBrXX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ygX1EuUe7H9otgs9NVdiLUp+WVDB/hT6zAzC8k6cTVoIQsNxqN8FQnUOOECTZ2sjtfVBj1m+ZPxswkJC39opA9/opj01AzHPzvlHa879XylhQOPSsW9xxySAg8tEM/2sVSi8Y4l/xW7iWw/yBaFlHFREy/jpxwl2Zod6aPLft5o909ERSq1nlF7M5UYVBkYtfSYrVnDMhZLt3EUJ02mYmSsq9cnZgF5j42OtuP62WLZkgvW6RC7+Mdb97+khLpurmWPQ0lrwo8fLTUuCiJkfvD4GHjBtZa7+Ks/nBpkQAiac+2jCfaGkFHN29JGBRjnkxmozTxrG7F879Svzyx95FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7gPM0XMM5+ZtnHJx2OoWiWcvoxAmC0794smF6Gu1Cp4=;
 b=hItMuWzr9LNaPc5jQ0+e1bIA7DYWTYSN5t878RwPmtEBug5tu6bdXb5ZEdXCbU86daoHA1vUWStl/W3iImj26/1vnmS69aLO5jpvb/AFfQ539SVCNQ667sgh89VIifejvWsbMbCoJ2VKs6aopoS212EMYemIyyMKOb/Bq9Iap8I7jZYhKvJSbJfcJLwL9qh0/wl3keMKBSSX3LiaZTeEOSdhBMs5x3rM6syioAe2ZUOZ1bcTzouMiHCCC0ah1xGU7wGJG5tZZmfaC98yTHxpCjDhLG/zJsVZmyX2xD8f93UOjLTTvohpP6ogHBHth3SAlOZGIh7zaEZxdLZlSBGBGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7gPM0XMM5+ZtnHJx2OoWiWcvoxAmC0794smF6Gu1Cp4=;
 b=NDVEBrXXiPMpeYN+zwrlei4UkYo7//HzXvxBfiXSjYs6U0ooVvs+JcnjVLxkFc/bQjCRBS3raVdbN5epHZiYx7tgzTID323TTt9YLA2LH3L2mOLKF+30M3M6f0K0nQ8tr+D4XQvdoadvw25neIWNb4NF0Wc17eBqgQwIFEadOmYzd4ZNsDjiSX8S5IAjIszmd97Vqy4E0ceBHsQLCopNepQAaKD2k5Ucf/o9bqFHTxVy9YVmo+G1fSgCAZFRzDQN3vkl6dWnHnBQwrBRvt8HwGMloLp87MnQtXRoJ80S0jvXeOnZt5wi+HrTHjWt+1h3COWr/qfp7sv3zxqAhkWjVQ==
Received: from PH7PR12MB8178.namprd12.prod.outlook.com (2603:10b6:510:2b3::19)
 by CH3PR12MB9025.namprd12.prod.outlook.com (2603:10b6:610:129::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.20; Tue, 31 Dec
 2024 04:25:06 +0000
Received: from PH7PR12MB8178.namprd12.prod.outlook.com
 ([fe80::77bb:a9fb:c75b:f530]) by PH7PR12MB8178.namprd12.prod.outlook.com
 ([fe80::77bb:a9fb:c75b:f530%6]) with mapi id 15.20.8293.000; Tue, 31 Dec 2024
 04:25:06 +0000
From: Akhil R <akhilrajeev@nvidia.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "davem@davemloft.net" <davem@davemloft.net>, "thierry.reding@gmail.com"
	<thierry.reding@gmail.com>, Jon Hunter <jonathanh@nvidia.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/7] crypto: tegra: Use separate buffer for setkey
Thread-Topic: [PATCH 1/7] crypto: tegra: Use separate buffer for setkey
Thread-Index: AQHbUJ6Qxi+DINGM+kmXYyCUmKJwL7L7mCkAgALfjvA=
Date: Tue, 31 Dec 2024 04:25:06 +0000
Message-ID:
 <PH7PR12MB8178F6A37DE6CD41850529BBC00A2@PH7PR12MB8178.namprd12.prod.outlook.com>
References: <20241217161207.72921-1-akhilrajeev@nvidia.com>
 <20241217161207.72921-2-akhilrajeev@nvidia.com>
 <Z2_iroxlT3C1d1HQ@gondor.apana.org.au>
In-Reply-To: <Z2_iroxlT3C1d1HQ@gondor.apana.org.au>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR12MB8178:EE_|CH3PR12MB9025:EE_
x-ms-office365-filtering-correlation-id: d197f8ec-670d-4f7b-cb1c-08dd29531ad0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?8xWDY9mYgiT/GBZ5pLy/FUZLArDBw+F3X9JxCyg029VvXH+4ZT9RnZVbzp+h?=
 =?us-ascii?Q?b2BrClbh1M/VUGE/QI7LfQ+wKWpxlq3j549vacOXOSXRM7Awu+Rhd5PjNLBI?=
 =?us-ascii?Q?hNwBjXKGExl0jtNnyXAqZgBOiZQsb21dOUULZ4R5y0JjpYW+MQDrAgDSLMw1?=
 =?us-ascii?Q?ez2X9OA0FIujo1L/uO3u4PDsCBfJOxcCYW0+uxEvcer/d/kPiNrG+0w2VmKu?=
 =?us-ascii?Q?VWcaRcf+dzMGjwhIERNA7NLsyP0S/RHC14bG7L2ZwOh32oJOjrgMy4OUGAdx?=
 =?us-ascii?Q?GRki3Vun0zze8mP8cTz+mqhIhaxusNeA8s+yT1DMfqQguFJPfWGBKqoCcjUF?=
 =?us-ascii?Q?TIdmZ406f3Q9jtSAUamztztr82k7M2dC1FANkQZpbaVfZdVhYTcG40R1mlWx?=
 =?us-ascii?Q?j5qoAgqRbpAfxwNkZD0W0t7cSnW7QB4pgYeDm8VG5AZyvooR6ZeTWwGuIwM/?=
 =?us-ascii?Q?9arCjpoudnRdnax0jleyaDaXEB1IEsB/E2cRDi9LA/y86IOWma0krov/065W?=
 =?us-ascii?Q?qPq1NECMYRe3ygifxAtbxKAygshEOhOEPcY6FQLFNM5Vry1g7XDuPEOdR8T6?=
 =?us-ascii?Q?UqS9ibGprPYWNGtTGT0Y9Jmvq0Fhe3CxlFZ4+HqEBJvG+W45ItJPGdZ+bz3q?=
 =?us-ascii?Q?URMXoi2Dg0ny9+O2OIY1kBJE3tm1flvHFxXTXUfqn5dSorEdeudhwUIeU9ax?=
 =?us-ascii?Q?1MeJ2Q1bihwycbWPf7soZNLZJNFs/+BWN1wrsq8cvwfIsE47RXU0WcUfFo3T?=
 =?us-ascii?Q?BETZE3/brer/uImGxlvV8zJ1NYNeCft0vTInvWDSgZAlYv7jpypwdePo0fNw?=
 =?us-ascii?Q?2yUBYyvQqoYodrr5NRsIZAeHstsF/yFG0xDLy+mM8CpN8PmGNuGCyIBvf+nI?=
 =?us-ascii?Q?czzyrOurEa+19OUhPmoBNM1qPG3WX9MUIye4i0fM1GYz3vlcPT5UNARZE71K?=
 =?us-ascii?Q?H7jCauTj9G4ogWBBDqkZes4nZF/VARUu1/rJxOePWyBzGhX0csElFVJSG47w?=
 =?us-ascii?Q?/1u1njfgz6MSzSAdH6phfR44uwS1i27iHYs/M71MKqZL+p6z9rTVfHgWxHRE?=
 =?us-ascii?Q?vltkjZt8vNsAG/ZLWhSN24wVBUiZqw4FCh9yv1D7nQcUfk0JCL37f6EYUGEI?=
 =?us-ascii?Q?3VTxc6EdAJhDOhlzkwjZaYHgtJeBP02miHTLQ38ARy6X/G5Re2Ap248JXdtz?=
 =?us-ascii?Q?m2ohjNOqd5+FCM5Mev/mIX2BFSBrYmQeaKHXJYCyZ4WoNMkQBBKrzDtiI3KJ?=
 =?us-ascii?Q?kEu6l2EwxPN0ENrf7M26IlCjcHCL5f17tF9J856NbvwIfvzbrU2j2La++LVe?=
 =?us-ascii?Q?CD8NTqj/eiuFjSW7Lacxy8OYNAJ8pNyfKCVQKZ9JegtSLhkSRQsiMw3P30aE?=
 =?us-ascii?Q?AamR+Qabamr3y3rjL1m4X+O3hbXp+4qRgZferysYjo9iBa+yYxPSOhzXxGWU?=
 =?us-ascii?Q?mjImt0ZA2kxjCOI3J0q71o4kLZf+7nRF?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB8178.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?URGqDBn1oCLWxlXgQ6ebEZGbcGVwqPthn62lGg0zzUmmpZIckU+uln3gRyyx?=
 =?us-ascii?Q?jBOh6cdK+W27ikN5eQBNmIXTod5s0WgB6YSHUU9nr2GNnb3UX7kv/y8QuRcp?=
 =?us-ascii?Q?0++HRYtlc7z+fsljNzS6CeFBairTNaXusIfy5NDkQtz194beccU61VL6LyE4?=
 =?us-ascii?Q?QSIGQSdSXe9MR+zb9J6tTGqlB2eS7h/rSF35LgGzT2K26fetHXQiTbckNPa5?=
 =?us-ascii?Q?0t1gH/FQJNFvGSYsHorzb0P98esT4j+rRldBeR34+CV6CklFu0qUOaWGbbUi?=
 =?us-ascii?Q?6OAuJA4hRmSZska35c9nE/64OHTcEsknL6vEiupct6L3WELR3qbWNLvjo0en?=
 =?us-ascii?Q?OghU0WOZU26k98JgJo/sgKA7XuJWtCZOXr7LNfi+NRKGaSTAd97jP7ol/jFP?=
 =?us-ascii?Q?zGWBbu9Zjw47fw8UFVMqdpikdc5vjpY9fMgApZrTXttXamtQ5AwmteODae9V?=
 =?us-ascii?Q?qthCR6XO2wcPiCVUJNoXSCD+Z4rk281MrwVKgkwAZJ6hcKAHhMsML02mLNsX?=
 =?us-ascii?Q?DtXyqr/amfxckvfwgQJjVkI8rKsLihdVhx7JCXrduRklDRLFURwjcN6AtIvG?=
 =?us-ascii?Q?9L+0zfoA74L9+iKoxpqab5VPEv4waYWmHU/y2HrC6eyitrM6JaSuo7c6ksEt?=
 =?us-ascii?Q?UchQy9sMPnw7nhhE6LLTUcYuwDB+HIDgFedZVS42Tux6iKXlSd8h2avzlDWY?=
 =?us-ascii?Q?EdvFgNhCPGwFdrdmD+bJHcr7XFGQpuev0GP73lPwrdapAo+hiotDtcP3oNDt?=
 =?us-ascii?Q?+1QS/G9Jdk5hc6CPbtxQw1BGfeLIniL/vQr25UpPJ7xeIKgKZufx94DGEqjT?=
 =?us-ascii?Q?V9ym4QLM21hRz4R7bwfjJqTBYXPjFwke++oJcNX598wnUK6v6ge4karmK3e1?=
 =?us-ascii?Q?0pDrcQ+nSYnH3JIeGGdjDQTtqOkVhoUJRCQHWMD/Aev3GnJxcLMti4cqqAnQ?=
 =?us-ascii?Q?D4FYLIRy53LMHWYhevlszWt+/OXRSCVyslBMHFSEybtJ6gMI+4GhvwjeM4r6?=
 =?us-ascii?Q?qzLN8fCC+ykXb0Z6+HnckY9R5adl494Oo4JN03hBoIwOW6xlPn/j2Qz1+tiD?=
 =?us-ascii?Q?+izjqZC9vY7zOJ5thel1rHM45vjzTENZi5/9HEHOnbGbB1bniWqe9T5igDXu?=
 =?us-ascii?Q?v/Bx16lodxkZQSNFx6V8koNIhK2QN+CKDgcwQIIO1VDM9E//5/hyrk+ZCyhx?=
 =?us-ascii?Q?ujRHATSqyEZHTQiwxH0r05PL/62bWdX6vWh493QOAbw72VkpK0s7G4mgOjgu?=
 =?us-ascii?Q?kwKdnbErMo4wTTvqkQ1yHDynM91WM5WlFIEz8LkBKhq6CvxMo8hAMhJEH8Q+?=
 =?us-ascii?Q?JaZd0OBSmr76Eeu1qhXiRKb1o/jcGCXMe9OI40u8j/yAY+HL8/P4+kdp0ktw?=
 =?us-ascii?Q?JotQ1fQgr6Rb9REVAJ7vJws3S+3i3/RhXrkkFvyUkeOxDTQpjHjgY/eBqEV5?=
 =?us-ascii?Q?FP1YhhWypL1/P50KZrcCuNyZ+Vvs/M3WtcjbH7hqRjGCTg10rIB2igLUiRjK?=
 =?us-ascii?Q?uObh1n1bsH+8Qtib+VWX8EKBqC2FsyhluHdWCRfyYMhIFdvRzXlnS10IjC9R?=
 =?us-ascii?Q?63j8Ug8mjc41JQG7uHm30Z+vIh7HHdbblnamRS2Z?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d197f8ec-670d-4f7b-cb1c-08dd29531ad0
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Dec 2024 04:25:06.5216
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: esb5xCWbtBhXpnbBY3dojasiaPkjQsPj4mMC/eZHE4kNHvwIoqdhUN/zXmM8RSdsfDYvL3vxnz97U8ehos3kMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9025

> On Tue, Dec 17, 2024 at 09:42:01PM +0530, Akhil R wrote:
> > The buffer which sends the commands to host1x was shared for all tasks
> > in the engine. This causes a problem with the setkey() function as it
> > gets called asynchronous to the crypto engine queue. Modifying the
> > same cmdbuf in setkey() will corrupt the ongoing host1x task and in
> > turn break the encryption/decryption operation. Hence use a separate
> > cmdbuf for setkey().
> >
> > Fixes:  0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine
> > driver")
> > Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
> > ---
> >  drivers/crypto/tegra/tegra-se-aes.c  | 16 ++++++++--------
> > drivers/crypto/tegra/tegra-se-hash.c | 13 +++++++------
> > drivers/crypto/tegra/tegra-se-key.c  | 10 ++++++++--
> > drivers/crypto/tegra/tegra-se-main.c | 16 ++++++++++++----
> >  drivers/crypto/tegra/tegra-se.h      |  3 ++-
> >  5 files changed, 37 insertions(+), 21 deletions(-)
>=20
> So there is a maximum of 15 key slots? In that case you should not be all=
ocating
> them in setkey because there can be a lot more than
> 15 tfm's in the system.
>=20
> Since the limit is so low they should only be allocated during an
> encryption/decryption operation.

Yes. That's right. The hardware has only 15 keyslots.

I am working on a patch which will reserve few keyslots and use them during
encryption/decription operation in case the remaining keyslots get full. Me=
ans,
the setkey will try to get a keyslot, if it fails it will store the key in =
a variable. Then
during the encryption/decryption, it will use one of the reserved keyslot f=
or the
operation.

This will allow users to have the capability of hardware protected keys and=
 faster
operations if there are limited number of tfms. It also does not halt the o=
peration
when there are more tfms.

Does it sound good, or do you think it will make the code overly complicate=
d?

Regards,
Akhil
