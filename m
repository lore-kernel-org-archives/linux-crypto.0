Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5CC37160;
	Mon, 14 Jul 2025 06:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752473134; cv=fail; b=R/+m6JFszopxMTrFEZIDKEg83q2IUBhH86jFM7W8MYAgL8c91L6WcYXyv7pFf99fhYyfY6/EASWK1Xian9AHaIlczEw0Jzr+DibJ6sSFTu1zuJRzzVPm/VGdybQPrVUVDVdlgeLZvJD/0pAWPOlyfheOlP+sdu8P6XBVIL7Zgx0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752473134; c=relaxed/simple;
	bh=J40MAPUFHbXnBQ52yyEJJMAPozSpSdTejbebBvVKq3s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nX1WyOGXkkriTZuMVRxJcYu6m4Mc2zY9Tkx4YmJ5Ia0cbSK4ysV+P9OzZCpoVC9vcYmCADsHcSCGRHDOkb7lInjA4c9s1Hz9PBUMqRX2eIelA4TkVnGgIcATmMQLbz1PQOlYkoKy7PHTtQ+rtQU/9dvFo7gplC8cbhMez71dlHE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iraiC7qv; arc=fail smtp.client-ip=40.107.220.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iraiC7qv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZnvAeGi+PScaTqlZgPIVrMb6mYYApjKot44HQ1yy8xTuvyip27PiZ7qje11c9txhMMLTjMq2F8R4Ls0wgfOphbmIJYONdqooD8NMAi0Tgf+WfD5vjA14NvF+ixh3gn16DyDYtM58k0mrhWcY4bONd1HJkLFYUszOVfGD37tw4a3pXYsgDrOyCvvwc6GufrQteGEjFfDWsCQ7XC2C2M5vjwrkB3eNmrgfg64eGZA2uWP+s5Wr2whxsscUwoGl3VL1DbDhEzwHh53Jetx+VKeKXYIsRIb6YCrKr6FO2WJLrYsBjtcN3CRBgKBLtTKsxLL5ODNpdBtprdRCbfSImmd+zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h4G9pHavOA4ffG4wDcXLxqHX3f2MHQNYTwsAqS+jMjw=;
 b=djA3hO7QVABwXs9sAA4hJlm17SzIhEMg3tSHk0naFFlPyQs9WX8R2sTJJ+UMvY2Yde6a9QS2XioH+SP9HUR/PwwxNAY37NguLX8eOjb5XbDd4Z0EqK8VPN+Oh4RFgv0dptzagQDdA9ZbMxtgvVd6Lp9JuSPNIS3ZI6AHHRvXEC0SfFdLvljI0B8r9u+OBYJMSG1HMSNjkCKD80fnHFDB40FJgC/OQJaZBZsYTdn+3nIjazgXKOZYk5iDrFlc9oqdL02CrAzWVmElIrU0n/2Z3EAw/sUWeVbksb8MiNbhZHg/cDHU5BEipRBTjurWnQS9lGAE88kfGoczkgw/9qDhcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h4G9pHavOA4ffG4wDcXLxqHX3f2MHQNYTwsAqS+jMjw=;
 b=iraiC7qvGIHIiU4ihpo9Vhf5Jw5umiqovCVVT0NYQyCnoFmqeAVRfPwhVPZodYdumE4yJIvO91UuER1BrT76BC+sDapYB/YpbJEX5c1jpi/tn7yJWqpJY8kfNnG4abbm8792/IvO3aH2IJfUgxcrxMFGBET/+XYP4u55EN4hf3A=
Received: from DS0PR12MB9345.namprd12.prod.outlook.com (2603:10b6:8:1a9::10)
 by CY3PR12MB9578.namprd12.prod.outlook.com (2603:10b6:930:109::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Mon, 14 Jul
 2025 06:05:30 +0000
Received: from DS0PR12MB9345.namprd12.prod.outlook.com
 ([fe80::65ab:d63c:7341:edbb]) by DS0PR12MB9345.namprd12.prod.outlook.com
 ([fe80::65ab:d63c:7341:edbb%6]) with mapi id 15.20.8901.033; Mon, 14 Jul 2025
 06:05:29 +0000
From: "Jain, Harsh (AECG-SSW)" <h.jain@amd.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "davem@davemloft.net" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "Botcha, Mounika"
	<Mounika.Botcha@amd.com>, "Savitala, Sarat Chand"
	<sarat.chand.savitala@amd.com>, "Dhanawade, Mohan" <mohan.dhanawade@amd.com>,
	"Simek, Michal" <michal.simek@amd.com>, Stephan Mueller <smueller@chronox.de>
Subject: RE: [PATCH v3 3/3] crypto: drbg: Export CTR DRBG DF functions
Thread-Topic: [PATCH v3 3/3] crypto: drbg: Export CTR DRBG DF functions
Thread-Index: AQHb21rB7NTssVrih0uUyq22WL8o47QmJIyAgAsevmA=
Date: Mon, 14 Jul 2025 06:05:29 +0000
Message-ID:
 <DS0PR12MB9345C8F5A728830DD9ABB1E19754A@DS0PR12MB9345.namprd12.prod.outlook.com>
References: <20250612052542.2591773-1-h.jain@amd.com>
 <20250612052542.2591773-4-h.jain@amd.com>
 <aGs8N675Fe9svGTD@gondor.apana.org.au>
In-Reply-To: <aGs8N675Fe9svGTD@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Enabled=True;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SetDate=2025-07-14T05:06:04.0000000Z;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Name=AMD
 Internal Distribution
 Only;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ContentBits=3;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Method=Standard
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR12MB9345:EE_|CY3PR12MB9578:EE_
x-ms-office365-filtering-correlation-id: aba6f8ea-07fc-4cc5-3481-08ddc29c6f8b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?0fETwVT/3gnDn92rAwxZ4U75/D3vkGKkSY1Xj1XadMrff4JCB8nkVZtFMR9W?=
 =?us-ascii?Q?hD/0fBkoxZLHtKqw5XFY4jVxDQM1y/DlmeNWluvkiWIBEF0VerCrTolTCCqV?=
 =?us-ascii?Q?BHc2WS6jiZH28iRvuRY9rjoofwHyrnm9jVuBcS/NC6tWr6D5kLiP59kKvuZQ?=
 =?us-ascii?Q?HmPyQNZe6NE7khLSzwhOTXKWJKdZR0Db/iPYgB4tfwNYK9awxqFmJ7bzza5y?=
 =?us-ascii?Q?4ap1swy+e4urfTxXGd1tQcumlUg9tFzrmzKd5QfpY5qBVfsoEYQ7i4Gf96JK?=
 =?us-ascii?Q?V7FPvyepbaO+wJ9ghg8pt61qDEyCUaCTdmurvUx5Ps8reTNscvDzJ4hXKQfi?=
 =?us-ascii?Q?slZcje37QsSkHx+0yNpDJkiqEhoT/BRpF/gcWVtaAcy5fCKSfRpBlafTKgi/?=
 =?us-ascii?Q?6tKMfsiYPXDtRGP2vLwcsAsrGlIPJXOkEdDLmpoYgrMSSbQWx+OlwH8K9ulI?=
 =?us-ascii?Q?CkNdl5+spv/k/baAJAthxc8Pif5LY3IxnF7JPB9xes/FCPBg/4fiRZa+zRyj?=
 =?us-ascii?Q?Gg+qDZI5deXjg/aaiXumQZSperdIw0r7SDpzIMPKTvqiL9fQoTQODBtY0sKv?=
 =?us-ascii?Q?1P5LXD4dGRt46+HycnSBBPYczv8p0JdSZaXDFul5EfCxg25ydV8PRXB0DcmG?=
 =?us-ascii?Q?bAN46Ll5PEiyxQtRtESJKYwNY4sJXGc4dDtgq1d+47fxY+48MhsJhgvQVUCt?=
 =?us-ascii?Q?78ZdxouDxmBT5mmCJH1ce+2i6AaR879ZPtPV8cUh5yYsRY/KrQAlgGuaaimj?=
 =?us-ascii?Q?fuJbLAH9K1pyVBNNm1lCbi1yTOr7PZrmaIiH5EVJH/43QGsnapJFSH9eIsdp?=
 =?us-ascii?Q?rdz1pkhOdymdtb71QJ1fTpKNMxJoApLQshxX85H8mvTf8p1gufdueQtt/MbS?=
 =?us-ascii?Q?1h0dyAw50XoWtb8NQlIUchD6POVk+UwfqdG98WpI1zz9dJk2PtVC4iLtKvb+?=
 =?us-ascii?Q?U2O/KpUUQgf+vpL6pYL912Z1/7dw4TE8hYR+bJApen4x/qZG60V3ncnItobO?=
 =?us-ascii?Q?dChGjhh8fRhEW+WnfJ6zatnMJRz3PN7Jed54aFgm3FiqCnnzpmFbZBlJM1sB?=
 =?us-ascii?Q?kjgUGWCXs70DrnNzGV1jU6gJV7f/ZlqwUI25jpvdjkaB5Ct0AON/68jE69hE?=
 =?us-ascii?Q?vWDl/fmMB+6Nk6S9kr9b+6l2aCosJFk1oKEYXpV755PhlFVBjufLOnXVmxJ7?=
 =?us-ascii?Q?RuRXhXnKw7GCTvQQt9TlzaIEwg9OJjo7rdhaAQbCWnvpwcfyqZ36KEOtJ1rW?=
 =?us-ascii?Q?FEzCHmPDcrDvJph/VT/rnxQD8VS0jrc7dBr91421hVham7OQ0Xr/mPNObp4a?=
 =?us-ascii?Q?1gWxaIWlUeOYpPon5Wqtud3Lcbm54O97NiluxONZzR5GrR28sgQDxbT6a7oB?=
 =?us-ascii?Q?kA/r2Pt1AUFAZzXZsP+xinnetG3qWtl8qK1ehtr8atjUw+RiUgSi54SFlinn?=
 =?us-ascii?Q?ikpWAnahpig=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB9345.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?/WCDldAmHO00s0sxIfg1FLQNRheLJR8Gl7EEtWeq6MmhFo5/mKD3kDKFhcp6?=
 =?us-ascii?Q?ebsgmXm8Je0gvNCfBLId8xpNT/TH9VWQYJP3adAGsY084DFmW1pchMB24SP0?=
 =?us-ascii?Q?cUVTs7u6jsEocUUYaLF/Zxf8CgW9OaRvNRbOax/PPr37B5nUmITLFJDD4sjE?=
 =?us-ascii?Q?/uqKgJLgGt0k8e5qPlE9FC0/X3JleCx5RKjtiIUZzg/ClBPhb98qqxKBA3pr?=
 =?us-ascii?Q?kD2+aNw0p0jXHTBUNNfB0B/qCeu6apzYLmic/bz1SQtgUED5iU9AlcL9pHMH?=
 =?us-ascii?Q?AllyokUnLSIpvjxkFFeoJs/609NzFWaHyLWrT547/4Y8iJkl4JHJ92+XqHrM?=
 =?us-ascii?Q?W98IP6t6wH4CYgYOktPwLWSN5wjX7Gl076n1exy849clktD/V2GQq4nbTwIZ?=
 =?us-ascii?Q?pWZGMKrgkWQ+wXl2SkO4USGJMUCcBaahgPJstrh+QXMiCLrv45053s89s1LP?=
 =?us-ascii?Q?Cb4Q22FaaCIBIRTdsaakQj85lRDrOH2KZU5uyQKu6RqxcN3XBTysRHQFfzi2?=
 =?us-ascii?Q?2VZbae8IRd/8TOuzMkLuC1U7+VLosI6/DIROA5SP63tYGtiUgRzjf5wub33o?=
 =?us-ascii?Q?9ebzpMy8lH9xjfwbpgZmvH2OVoQlb1xRR+HZjb82KlIOYx1gPTFDM0V1iBt7?=
 =?us-ascii?Q?jizVYSxTcPml+tuHPGeDld+zzN3uqDck8/PBic+P34y+RXTiAUaRFRbuH9a9?=
 =?us-ascii?Q?WDSk2zoVJcH+8WwciY05HZPKXW/GNRkQt3R7/4SlQJ0n7ZentxeY2q/aLT5j?=
 =?us-ascii?Q?MGOf5mJ92SPGRCV55/r2VFkjTOxJ1wjfZiJNman8cOTLwkc9rIIoVjyZpr6/?=
 =?us-ascii?Q?vdH3fK73quKaMHybxiGiP29f9HfcWYqQWCgy1U+t5+n2g+gyOnyvgoQvJANM?=
 =?us-ascii?Q?oXQkTMasemOV17Ouj/HO6WAfBoPmN6vEruWtFuV/gKoplS/YrhHJK+fjszwq?=
 =?us-ascii?Q?LZ5jIGyQlGdj6FLiNrZaAdT/7ndOr9l3spbYyse+FI2YOtPzIH3iEI7oCdyP?=
 =?us-ascii?Q?PqDgApLoecGDJ/0ihY1jsXIoUGYNPISJIf8opzYxDAsPdune11GB2+uCnyLj?=
 =?us-ascii?Q?JFoNPtKTYuGpqmW5Omgv+/MH/j2kfW84pjD3qVQtfmfg48WJE3QGEfaskbtT?=
 =?us-ascii?Q?MPXyPkA7cqY/07qgGFQKBdrcTHO6Ohs8vZGl8UR4KsXbHWKtSkkjMLuPV+Dx?=
 =?us-ascii?Q?zixp+FlvSz7D/R/UKeXPt0/bj4aQBmwyGI+uyMSgWvBc369EIYKUKaaXMZ11?=
 =?us-ascii?Q?NJxBbWCaudkVfuOqNEgU8kKolmyvGmkJyYrY67Iuk5XVnge2qu548exj9Q1o?=
 =?us-ascii?Q?1TCEkzQR6zPLZSqrmi/gcXPFpFUPitVHwSKKufshnMGVdNBfkr/QVWkeWibc?=
 =?us-ascii?Q?fZt8PFG3kW9Q/AyvMNX/6ZUDn3dgY7PW4zkvBZtbT5CIW7vJx39garwsOvXi?=
 =?us-ascii?Q?eOE0gx6eB4wg1eG6XVhJ8Hnb5CSqKqAOK2AqAexpczHdwp4koFFT05+oi/AT?=
 =?us-ascii?Q?QQtfVAKFrHrzEAxQmF4RRvAUqiOSkTAzc3w5toA1v7lJkCHi6P+EKUbBuXUw?=
 =?us-ascii?Q?ZDTi5+j9RfHHUJyT3U4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB9345.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aba6f8ea-07fc-4cc5-3481-08ddc29c6f8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2025 06:05:29.7983
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iIsMYUsKi1Aoesa4LommC+pm9yBhdJd9ivQA97qOhJie0fM1v7XHZo4trZQ+4M1L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9578

[AMD Official Use Only - AMD Internal Distribution Only]

> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Monday, July 7, 2025 8:47 AM
> To: Jain, Harsh (AECG-SSW) <h.jain@amd.com>
> Cc: davem@davemloft.net; linux-crypto@vger.kernel.org;
> devicetree@vger.kernel.org; Botcha, Mounika <Mounika.Botcha@amd.com>;
> Savitala, Sarat Chand <sarat.chand.savitala@amd.com>; Dhanawade, Mohan
> <mohan.dhanawade@amd.com>; Simek, Michal <michal.simek@amd.com>;
> Stephan Mueller <smueller@chronox.de>
> Subject: Re: [PATCH v3 3/3] crypto: drbg: Export CTR DRBG DF functions
>
> Caution: This message originated from an External Source. Use proper caut=
ion
> when opening attachments, clicking links, or responding.
>
>
> On Thu, Jun 12, 2025 at 10:55:42AM +0530, Harsh Jain wrote:
> > Export drbg_ctr_df() derivative function to re-use it in xilinx trng
> > driver. Changes has been tested by enabling
> CONFIG_CRYPTO_USER_API_RNG_CAVP
> >
> > Signed-off-by: Harsh Jain <h.jain@amd.com>
> > ---
> >  crypto/drbg.c                       | 108 +++++++++++++++-------------
> >  drivers/crypto/Kconfig              |   2 +
> >  drivers/crypto/xilinx/xilinx-trng.c |  32 ++++++++-
> >  include/crypto/drbg.h               |  15 ++++
> >  4 files changed, 103 insertions(+), 54 deletions(-)
>
> Please move the df function out into its own module like crypto/hkdf.c.

Thanks Herbert,

There is hkdf.c and kdf_sp800108.c module, Both implements different NIST S=
pecifications and DRBG derivative function represents different NIST Specif=
ication.
Moving it to hkdf.c may not be a best fit. How about adding new module for =
" crypto_drbg_ctr_df ()"?

>
> You should also keep the drbg changes to a minimum.

drbg_ctr_df() needs tfm, blocklen, statelen which is currently derived from=
 struct drbg_state.
If I updated structure drbg_state, It needs code changes in HMAC as well.
To keep code changes minimum, I added required inputs as function arguments=
.
Do you have any other idea in mind?

>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
