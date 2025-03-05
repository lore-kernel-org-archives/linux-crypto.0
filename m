Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823F81DFD9A;
	Wed,  5 Mar 2025 07:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741158331; cv=fail; b=d6rBSCSL8hPKuZNBvGaDXfewZQ5eSX8RyGogI9PXlWpPMk+e+xvQ5Ilhuz2J1vWGdF19BDULDcailUEmr07FI953Gd+I66b2lLwdu4BrGPo0o2atoIh5p6isvxC/R4g2KSoTIQ1DDtzanjHejhFgA1esO1LfyYFcBwCh8paSIao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741158331; c=relaxed/simple;
	bh=KLHKDgfwys1oVi33kgCJ3OMzCaZUsN2YjL/tBUr7fdk=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aIniV2swHIo9PFAZi7/ZZGlIur9+pb5yh3cqjQoMKegg+p+22z0wSmICvrOcuLN5QorICzF640Kr4JFhx6Ij5d/N8YBUeBG4QY6nl18gG7F2sRjDlvOIq0w/u5kIepDzhcL9rmaSdTWXI6QaACQShJSc+Fx38HYxyFHuqFnyDJk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QiRfaEBE; arc=fail smtp.client-ip=40.107.93.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QiRfaEBE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H7s65bDlx85iv9KQ/zl2LqPmVE1S5qqg2xnzZpRVRyTA/2hM2zMPKDHPstJGR/yRXUdCfJiABd11v7zEWr4LjSE5VJ3vgZtP2S12g0PFVXApI2PBdCG03GK0qt+h5niB0goR5hr3jFFGPHc+dynS3cpbUSUj/J2hraqdbFjXbEcBLY58P+CtzJ+8f2Ws6gyljNKXy5V2WcfkNHg7RJJIs8QTbqkDfO5KVaXxzKpd3ORMgMiCHQAV3GifsAel5ihjJVYHTvy14K7z5YyZ/S92MknKEHkvmLCPgOO+XFxQM0nE8HGz+/wpDwufEE59lfiVXKPTFUlpXBYuA18OOC8E9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GPx79MFiCcZLikQcIbjQWaxveLWySM1vWuztnMg48KE=;
 b=MhwSo7Uyo7jh6V/pmwS7q8PsoMbK7TzQzxQcZEa8vpSuu3cLk+scN8nidsjJVif2u44ElEtkm9Igukp1secwrL0/hDEkygfDTbl72+aPoWAvebOnowYr6NHzyFYrVh8tYV5UcuY0ml/oSreYEyVbeuqiV/HeQl5XNgTvPz/6LdOzhj9it1Y4zAukgxO3CIxVy3fBY9wzCQtNq9tVlanEhttdwR8kTtSj30IBuc0nne5IYTRWsgIC26ZCrVJVGIXrzA9wmqrRiXxCWvfYb8HGu89JrIFwFCaD/GOjnBfa/V9fQCydrDmS+Jo4clR5M/vwXXCYvzdk0j6PytewRt5+jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GPx79MFiCcZLikQcIbjQWaxveLWySM1vWuztnMg48KE=;
 b=QiRfaEBEKo6G5b1EIyuLBN1hWJTkpq9j/KOZ7rlHdvNHmFiIdNpur7Xc7D9adGaXhG3DSDMprkPQ8OH0uKTG+ZeOIBU3Jx1Q9Dbveib0Y17tK9FzNEHlrtNfzitggFsVN9GnjWYP3GNTi6x0HLrebplbt1D6D9e/rEuUAZfz0mLQpxK/czvIrIwrFJs/5id2MsjDVvT2ZCHQxfe/ZsbOTjFM6vZxPCnhSNwZnMxgC/MakxKMc+AFZHlAYegLB293lk9gVqgH9eVX44o9vkJqk3XYynQ4ahe0OqaihpDdcTuxwjifWvnxLAqNLfbcdf1d2U03wO8GNLq9i9ZCnV3y1w==
Received: from PH7PR12MB8178.namprd12.prod.outlook.com (2603:10b6:510:2b3::19)
 by CY8PR12MB7339.namprd12.prod.outlook.com (2603:10b6:930:51::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.25; Wed, 5 Mar
 2025 07:05:26 +0000
Received: from PH7PR12MB8178.namprd12.prod.outlook.com
 ([fe80::77bb:a9fb:c75b:f530]) by PH7PR12MB8178.namprd12.prod.outlook.com
 ([fe80::77bb:a9fb:c75b:f530%7]) with mapi id 15.20.8511.017; Wed, 5 Mar 2025
 07:05:25 +0000
From: Akhil R <akhilrajeev@nvidia.com>
To: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>, "thierry.reding@gmail.com"
	<thierry.reding@gmail.com>, Jon Hunter <jonathanh@nvidia.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 09/10] crypto: tegra: Reserve keyslots to allocate
 dynamically
Thread-Topic: [PATCH v3 09/10] crypto: tegra: Reserve keyslots to allocate
 dynamically
Thread-Index: AQHbhp0nML9qQG1F3UiTlayC2OyGxbNkKsyg
Date: Wed, 5 Mar 2025 07:05:25 +0000
Message-ID:
 <PH7PR12MB8178B92B6ED11B891AAFCE0BC0CB2@PH7PR12MB8178.namprd12.prod.outlook.com>
References: <20250224091610.49683-1-akhilrajeev@nvidia.com>
 <20250224091610.49683-10-akhilrajeev@nvidia.com>
In-Reply-To: <20250224091610.49683-10-akhilrajeev@nvidia.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR12MB8178:EE_|CY8PR12MB7339:EE_
x-ms-office365-filtering-correlation-id: 063110c6-5fae-4c60-1117-08dd5bb41acf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?F/RGj+HDhFnseEVOeWjjb2pCI+tBu63kCGaHl6iNRu3HCFsxbQ/irXQTENrG?=
 =?us-ascii?Q?1SXshFpFAhKbGHX984nO4iZ5iQfWjp8HGEJiuAIjrifbl/qPCrKRbiQe6cSq?=
 =?us-ascii?Q?lo0lTzPFtCsVHPHKUTVjOLQzofBbZSwQrI4xULskpBe/NWLgdAeWp5MpbfDi?=
 =?us-ascii?Q?9RFsa/lERRSAqRO+DYl61seTD+utwg663oqbJQAhCtrlgTTAvvK7XhPO7nkc?=
 =?us-ascii?Q?Zw0ZfwGJK19tvhXkv6UhlH2H5z7MUx5Tjizoa4WJvOpXR/fiQNp24eZJHanU?=
 =?us-ascii?Q?bexPl9g4ZveN0ya4/FxEM7tlsPo9+TxJaHQAVQXpl2+KJmobN7aDWVi5rfxH?=
 =?us-ascii?Q?OBSCiASbir4dhJvuqHPzcGMa/OzPgeXg1yXtMuFaAIizn7p/mFhjWLb9QpdT?=
 =?us-ascii?Q?Xk5XJsZGimjb3MZ2e79Q9XuHgYjJzcyV2P6c0KBYE4M+z6uIEx1Na/U/k7em?=
 =?us-ascii?Q?3rB+13JBhOqV5VkzCyUKSD0wuB+Q+K3RFcnY99KLJNGykKeQKWwfG79o/2eZ?=
 =?us-ascii?Q?DmG0DSbhF42b+pHP7Ji7VOC3G45SVkaTsoygKznn0ymI2jarT/njW5/wMChX?=
 =?us-ascii?Q?onwjJUdl4qg53J2ozxOLRg9ZbHvc4qderd2/ms2UrHfHi5G2m2zC2TxmrxgV?=
 =?us-ascii?Q?VWbsD/HhYMq5DjFQ9hCTMnDScUmZRo+SO77tYAdDTIBLJ1Up0rHv+jUEQIKc?=
 =?us-ascii?Q?MPf0uPim4yBnJTKfpZK+806OLftzM4+fX7wxuvVKuUTSruyfQdBDjzCl1Q9O?=
 =?us-ascii?Q?jENo4U4rlZMsgQ+zVAwJqKfx9FLOFMNIG4thWJsRecWXqRvV75UF6uJK1H3L?=
 =?us-ascii?Q?/AGPzlp+UPMzBmIjST00LkYpBba2HMSXjtuoVFval6x2ieeSSWijUXu7Wgal?=
 =?us-ascii?Q?XpVMf2nDsYRzxxsuJVWPpvKluMU4TskXydPVUhS+KbjIPu2f8LbE9kulLsr/?=
 =?us-ascii?Q?hHDCKbG78oK1DZlrfIHN/Q97Kr2j0mcv24TKNxjsn6XJ6NnLVFmR4NOYowoo?=
 =?us-ascii?Q?hGJJX4UcB0wrsk3uEnJjQvwLP2AFwDbFJUSgtCgQbIWqkB5FNHTH4dn9PC9J?=
 =?us-ascii?Q?wfFWCp2we3qDIFSDT2b8a/33OKNnov6oNuOJsZRVfiJUfcDZD1fCRzMXa10x?=
 =?us-ascii?Q?DO083NgCVvRxkMY14DRVGuOrziiJueaN4gaF/SH66LU+Od79AGE64fgRdQ3K?=
 =?us-ascii?Q?EONzGQETmpAXjh+y4ce60qg8cPeBRR2/0mAtK4xhEQooDyh4HIKNKWqOH9Ev?=
 =?us-ascii?Q?740Xyp40x6LZo5C8Adv1A8wLXNcCJZtQcvF29BKJOFgiEmtayaKyfALwW49d?=
 =?us-ascii?Q?GUEXlIjeClgW4NXsOYeo1U02ZCLID/5eSqbA9/jhmu9o9Yk3OBkIZVPdMxMY?=
 =?us-ascii?Q?p4D78/eqrnhS95yer5MvhcJaW040SMrLtInUjJtOtuyr0NxUnA3A52CjZOuh?=
 =?us-ascii?Q?NheMhEyzz8rLz9A4069CtB/VvMu8WzNb?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB8178.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?nIuKOvQ5Jq2tYCAuzgWIlH9u7KACuV27gMY1aZY/qFFrRhUqpXoqEwIph4Eh?=
 =?us-ascii?Q?zg7nruZYRLQDHBgyY0qKi4dGv7eisR7MjTNw8vhHHLz3OtWdUjoOrRo+Cuwa?=
 =?us-ascii?Q?sLGS/kD/IzuP58tzcgzawvsoOyzDpcYVJ6q8gCRsFq9ooqaG+XGcDzz9XF3W?=
 =?us-ascii?Q?+Iw0BO8jDomLLui5sQ0IVMwjRwnGdJa79yCp2zSAa47JX/u7DNJyY9EtJQ2v?=
 =?us-ascii?Q?8IZ0uZWnmrWhZ1Aq4t0xkFHKY3a/OpOnO9TzAYIDZXA1ZIwUvhgAagK6xEER?=
 =?us-ascii?Q?dr6ZCCUqvDPW5qcasI/PhFlbTrUiCHE1zv78fEnyZDciv8+g/vK6FSI40JR9?=
 =?us-ascii?Q?ZfstfsPRphdyADvmb3ezdM89x+c+ujLMqqakP3kKe1Kl3EKohiQWi77FJ6vm?=
 =?us-ascii?Q?0Y+YfCz0qqrdlxJYXOcjzTynylwt0it40Qq77EV7iUUAEKiRVF+AxZXu2TYW?=
 =?us-ascii?Q?V7MMbYsQCjWlnr8r/bcWwdiwxGAe0WCZ5tFMtHoObZYaEXuGGe7tWKsdD3R1?=
 =?us-ascii?Q?KhIbAxsp7Lw5SNzdhpqxINM8/YZ+/fzscYgngLli8C5uarwed88WTvs0ERN0?=
 =?us-ascii?Q?MPUR64MjDzuTd//E/rKSEzMqFPKhgfRxqY7Pxc7kuD0jX3UeQqOvcZBLaCxI?=
 =?us-ascii?Q?+YyrxlSeQkKVaRS1+847Guyt0jlHMYP9lMDLI8fXMSg/kRfR5C0vqNjtNWLo?=
 =?us-ascii?Q?0pYnEGNgYXur+8rPETECCtL9hUCuO8ChlMcFYs4NSwC+O+my4ClpXHepq445?=
 =?us-ascii?Q?4RDEae2dm5OLjboaAKqL+UaClQyb63pajgQwuK25Bdde2Sbr9fbcQBUvWtt6?=
 =?us-ascii?Q?WEbpw2uHr7odHnF7EzZmFsl/748lJaPXVhDTMXDBG68hBZX0HrVLY+7YfkVN?=
 =?us-ascii?Q?9DFa3H8RUjUO3AzdKadp6QFqNp9q2mRtrUS15p+iyypAr5lew2ZNmCiqN6Ll?=
 =?us-ascii?Q?+cI/woEr+IqGgciMahGdblU4Qk/oam+IBY0i5imm1tiHWecjIhX2f7EmOsOi?=
 =?us-ascii?Q?GZLqvy/UmQleIoBUEUHF+ADfqoHs1cvCztCcBXuLf1Ds+jOUZM4hotR+sOEy?=
 =?us-ascii?Q?6hsMR5iwigkQQI4nk+FRFUMZSRqlcJnjzbnzI78UbVY9gb/md6PK3caWOUHk?=
 =?us-ascii?Q?6xkClYRjzmA20F2Xnk/FkfG8nUbzemibHjkz5mZUugr7RITH1+o9lv+q2min?=
 =?us-ascii?Q?LUn2nJfz5DGa3/hMXVizYHIPk5+dCpxbVh5JQ088XWoJbZTfTyoAHAEWcL2g?=
 =?us-ascii?Q?xnAv3TC8npQE+Eppm4GobQEkPK7JLQ/UD2EiTBbyQDml8eTplNHtaC5fT461?=
 =?us-ascii?Q?IQcD3KBknjJMSEyVSqpm6BKgFx/2gR53f3oxUjs+meO3szX5elPRs+ycy+o/?=
 =?us-ascii?Q?oaxyfEhQhs2SLthY4FFPfPcyGfWUjjZkNZ59vt/wvYb9LKjdzA9KlsBAaa+o?=
 =?us-ascii?Q?bPxAfHc/Z7EqCa1Q+SKk1qTzpODEc3JyFIVj6BYKYfeCWlUtE4dspwdTuPmL?=
 =?us-ascii?Q?3f1mUQDJSu5mCNhhZX3YfGjlf0Xxh3rstZ2uEfPywsMqCcWSNvz3oMBqf57s?=
 =?us-ascii?Q?p9pXNWGQrcaEbhhwsCg5dO3q2fkU5qSdqmNsmxus?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 063110c6-5fae-4c60-1117-08dd5bb41acf
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2025 07:05:25.8442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A3nZmj4aay2tVabtd5ho7Cwpu+kCz9stBVYYGI5OyETRq9i4PL8xAadIhL+eIkMuK85RZOqAK23AZL3DvkKF4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7339

> Subject: [PATCH v3 09/10] crypto: tegra: Reserve keyslots to allocate dyn=
amically
>=20
> The HW supports only storing 15 keys at a time. This limits the number
> of tfms that can work without failutes. Reserve keyslots to solve this
> and use the reserved ones during the encryption/decryption operation.
> This allow users to have the capability of hardware protected keys
> and faster operations if there are limited number of tfms while not
> halting the operation if there are more tfms.
>=20
> Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
> Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
> ---
>  drivers/crypto/tegra/tegra-se-aes.c | 139 +++++++++++++++++++++++-----
>  drivers/crypto/tegra/tegra-se-key.c |  17 ++++
>  drivers/crypto/tegra/tegra-se.h     |  28 ++++++
>  3 files changed, 163 insertions(+), 21 deletions(-)
>=20

I noticed that we need the below additional change to this patch. Not getti=
ng a
keyslot will not cause a failure. We can skip this print unless for debug.

diff --git a/drivers/crypto/tegra/tegra-se-key.c b/drivers/crypto/tegra/teg=
ra-se-key.c
index bf265514b04c..956fa9b4e9b1 100644
--- a/drivers/crypto/tegra/tegra-se-key.c
+++ b/drivers/crypto/tegra/tegra-se-key.c
@@ -166,7 +166,7 @@ int tegra_key_submit(struct tegra_se *se, const u8 *key=
, u32 keylen, u32 alg, u3
        if (!tegra_key_in_kslt(*keyid)) {
                *keyid =3D tegra_keyslot_alloc();
                if (!(*keyid)) {
-                       dev_err(se->dev, "failed to allocate key slot\n");
+                       dev_dbg(se->dev, "failed to allocate key slot\n");
                        return -ENOMEM;
                }
        }



Hi Herbert,

Do we have any other concerns with the patches in this series.
If all those look good, I can push a new version with this change included.

Thanks & regards,
Akhil

