Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5046208B0;
	Fri, 31 May 2024 05:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717133813; cv=fail; b=dMRc+E6Q+8Fp2kMjYLbUT/gDwnhVYnvA/CHnaAcewY3SrIyhkr4T+E7DnjzeMgzRkVZDCDbxIyKXGgHOKOT2Q1KEj6BRQDZzVolkOwDf96tplFDbRjsR0SXdPcyoVeRzU7+MnIsnw0qBeDca9SV2UsnWoqSjODFdkmV3EjAMJyg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717133813; c=relaxed/simple;
	bh=lVHHyUp7rliEZ6H3Zst1CJkhZEOhPcCbhk32KZxwYow=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T8tk3x70tYaPl5htZeoM0+LNNLGTFqYMU667smQGFaMT2WnqNP1hwRYztevDMpWnUUYKsCom1IthxEbcLuUuy6SsL8faTMfuOGSocuqtdNIYq7rF6ceEBHfctHABG4z4CMtC6mooui8mGecX6XScqGneVWJTzkb6VPbAgNWugQ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=abx9KLJe; arc=fail smtp.client-ip=40.107.223.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="abx9KLJe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IaeMiLUhMX2brmHS/slWaOVpV2E+75kLb+46exZ3R1welBIE07/UO54afm0CT6bmH2HHIWsJdNALL8/shXpen2Ee5J7AxEdzzaIHC8gdMzhxGK+qg7fHrq2SJy/Z0/R1fX19v6IIQw7wRnsD4ZDjfw7MAQae5X6Q86BWcFSEMgLD8kqan9eHWMag93S5LRVBECSc6e9ngRuNrSJksW+GKsBI68bE8aGqs81U2Kfu8H4zFcc9B2DKV5S9lG9avhKoKi8vziYpQ7KEMU+vBuLX2Rn2uBw8CAhRlyxucfeYFNY96wK8YEc6dRNgOUHGTcD0P3HLumyLHjN4Tz16YfeyjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lVHHyUp7rliEZ6H3Zst1CJkhZEOhPcCbhk32KZxwYow=;
 b=Tu9PqWUpJUcXbR7jhf70RpNB7YPhRU7dPqGXgwGxZ+UFmyqJDnZz8V2tYwYMq2XbW1H15slOFOwg7aRg8abZoIWDCx96N+YVoOfiitbQo3opo/MiTvtLLrMNQIe90znNlTlmvViplJRBj7O0vkc9Kd4SLpvP3K4zObkhk+6/BHfl7CDzR5FtZIVGtGjaKQFNuyOE0gdGULEU31hAiP4GJri90vKcE/P5x4/occxysYCxwlChv7dwwv12k7Axqfzdn2pqomCW6LFf1j6PjTSvoQwpnotcC2iBLtx8cX0MG7SrsN04SmvNOHXDkeGu9f9o4fA1fd7RXP3W1uwAB5fynQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lVHHyUp7rliEZ6H3Zst1CJkhZEOhPcCbhk32KZxwYow=;
 b=abx9KLJeMipQl0TzoI9JQHbKb0QfaIyTQGfvZ2YdNhMvhHntLgKB4i5tEXKfCU/UyYxzPxQVo+ejlvN64xR2QLdgzEoYo6NoQ2r5Wv/IyzOfTYRDli+7GRQfjEJLQ7pfuiIP1GEkIZKU/GI8KTdR6zjicWUJWc8yTFOYAVwRbDZmLis0VzcK2VFPCPCarHVktxe71nEoZpd1tt1+h/yQKIrPJcU5ceR1fpfnbc2ZmYVAEvpsdNzf1Ei/PvK2FIMqT0ea/wMekng98J/5NtBjuyfeTK5ZwJYhzHGImYzkUK42gVGUZ+lUiAxZzmwxKYWjm6MunzpjiJZhfm9A9jaSgw==
Received: from SJ1PR12MB6339.namprd12.prod.outlook.com (2603:10b6:a03:454::10)
 by SA3PR12MB7922.namprd12.prod.outlook.com (2603:10b6:806:314::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Fri, 31 May
 2024 05:36:48 +0000
Received: from SJ1PR12MB6339.namprd12.prod.outlook.com
 ([fe80::e696:287d:3f92:3721]) by SJ1PR12MB6339.namprd12.prod.outlook.com
 ([fe80::e696:287d:3f92:3721%5]) with mapi id 15.20.7633.021; Fri, 31 May 2024
 05:36:48 +0000
From: Akhil R <akhilrajeev@nvidia.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, "David S. Miller"
	<davem@davemloft.net>, Thierry Reding <thierry.reding@gmail.com>, Jon Hunter
	<jonathanh@nvidia.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org"
	<kernel-janitors@vger.kernel.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "linux-tegra@vger.kernel.org"
	<linux-tegra@vger.kernel.org>
Subject: RE: [PATCH] crypto: tegra - Remove an incorrect iommu_fwspec_free()
 call in tegra_se_remove()
Thread-Topic: [PATCH] crypto: tegra - Remove an incorrect iommu_fwspec_free()
 call in tegra_se_remove()
Thread-Index: AQHarrZLeawWiYOujkiA3zLjv6FXT7GtyrXAgAMNKACAAAGJYA==
Date: Fri, 31 May 2024 05:36:48 +0000
Message-ID:
 <SJ1PR12MB633958B0DC8504F1D7868CA0C0FC2@SJ1PR12MB6339.namprd12.prod.outlook.com>
References:
 <ea775b351a3dbe4cef4056ea89da25084f73df22.1716650050.git.christophe.jaillet@wanadoo.fr>
 <SJ1PR12MB633943D654272A0612695F1DC0F22@SJ1PR12MB6339.namprd12.prod.outlook.com>
 <Zllexnetg3eu6dSW@gondor.apana.org.au>
In-Reply-To: <Zllexnetg3eu6dSW@gondor.apana.org.au>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR12MB6339:EE_|SA3PR12MB7922:EE_
x-ms-office365-filtering-correlation-id: 81ff2466-ffea-49bd-d8b0-08dc8133aa67
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?jDaxGu0/16aaZ1ectdDuRm/P5sBOQbVAR2N8ndk3UiIsaceZ8OBYMkhdsp8m?=
 =?us-ascii?Q?ylW+BVbsyZ2ywz4mBTIa/txvo3955ukeCwRyGWNacgD1QKat9lLWw1BzBNZf?=
 =?us-ascii?Q?uyH5w9M3vmHVRuS7leeMM6+PywROniwMPQnT4rd5p9jzURUFXw/A1VjpRTfk?=
 =?us-ascii?Q?2QrbTGGT3iFGGJlqjPrHTTSV3x7BxEky9VVw1w28Uzw42odH/9kGdZ73xBRf?=
 =?us-ascii?Q?z5E7vqaLw3wHl7P+lK5EBF9D1FsGBzBremRC6wOhAUjpbsCoff1AHlUh1mfy?=
 =?us-ascii?Q?QcbJLXybTZFio8ZKq5je2DkTvXQEZsQLefgCW61LQ1Z2xZERYbFQmXO3FwpJ?=
 =?us-ascii?Q?5CxPXPVzEW8jNQVe47gLt8lMIrFTYux+YOB5FYoeS5JPS6F4ay9tgI2yP505?=
 =?us-ascii?Q?g6UxP8Xz2gaY9dMcuKmciiPQoZX1W00yaoC44rDv70FXmZXQuXCKjwkm7yLQ?=
 =?us-ascii?Q?Y58JzHYsG4mwjt7opZgYZdwUHKm7ms4Et4Nzf4kchjUZxUR5nnf43cLCH0gM?=
 =?us-ascii?Q?j4ay0XyyaCsAcvu2l2lOxar0898PCJejE43LHHyU0ks+fPz2nNt1H/TdTAwo?=
 =?us-ascii?Q?w1JS7k124Kq3ul1SftSmZ3LSXlbymZ+dB2U6yi00ifuRS5ZyCjDMfzngfNyC?=
 =?us-ascii?Q?WUww3SqeCbkdp2EAkRzn5XH1KggDM/VNw30kVrJOP/2IPvkyUC3eOt6hj/Aj?=
 =?us-ascii?Q?fZPSuImOivPS1XHqiti3/eOVNpVeVVBNbkxmBLuXhaWKEQFj7pDuG/dX9BnH?=
 =?us-ascii?Q?QpRMxt3cB51rGrJedhzNLAlxY121uh/afP4DiaHAoJFF/KAVwhrFx7iYbcN8?=
 =?us-ascii?Q?xbBjkcxrCLiRRADJg26384j3GfJjBTN9k7vTObYmt3adnksZjzorFWiC1G/6?=
 =?us-ascii?Q?i7t0Hq9HlrrfimFpSnlvx0ZNhcrgAELt6TX2EzPEh+RTqgPyXlUoq9CmP/MO?=
 =?us-ascii?Q?VYWTxJ2aitU22bHQ2+sdzbYddi1W2HjMlueRRLzykkFSRv73IAEEASJAwWYZ?=
 =?us-ascii?Q?xywZi2HHibslvGEBm5fPmu0oq51TX50cmNo4JGVWSVJyOD0V74IDqCZPt1ID?=
 =?us-ascii?Q?xH3TiRFiVVuyZLg0Ds2T0KutJ10/DeMkkHIHHH/3zwbdFYhE38wogCQMbK32?=
 =?us-ascii?Q?/tJPLnp+OtIxtuPPLqLcyX1M+V0OC0BOxHaFpcHEe2Lg7LqOKRiLwyR5ruAf?=
 =?us-ascii?Q?UmmqeqjJz7qv3+Du/IPgQJgjy9vJ3g3oCUFJWdJoi64j/VET+sQ/l8t/vSxq?=
 =?us-ascii?Q?SXnha53GCM8FMRvs0+Ykit5Jlfw2p+0iEip+WqAGd7LM67Uv/cQbRHR9dOn/?=
 =?us-ascii?Q?R2W8pYF1Sbb/K383YKSfDeLVPy3gk8PSopYSQjQLmFQl4g=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6339.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?AtoKt8aWeSEsYnEQoC0/9RYObs5ZYrBkMilw/iTOdapaqfIjJyGecOmwHQtC?=
 =?us-ascii?Q?K6/tjsfs52Hwc/JGGz+GPaZdsm3ph1o+ZFMV7RYM4T9JfZGy4ecA4CG50Iqe?=
 =?us-ascii?Q?DR8cv2e7DQdYywFPIIU/q8J9WBPOEZHGpL4y6n7S0COJyNn+JuuUrcWKYQdf?=
 =?us-ascii?Q?IcIop/WBYfL+4s6UW9yayCLKYfHbh4q3UVuTFq26uvlNSYSfMqVXZNP9OQsp?=
 =?us-ascii?Q?pi1oMDLNLvBDbtRc0FS/PYD+arvoypyQx3Ekor06bts488Xl3xNm30Sy2wq8?=
 =?us-ascii?Q?BXkKq8/Tcm5zxxSvq1BLrMwAfUcU0v4C3k8nWAoChyDSJXxmOhdOcG0s9La4?=
 =?us-ascii?Q?11DWRRrpOllvVbEdDsx/Rz/od2Kgtw8Zzr9KX28RLZgu1ePVyoyF1vYbsY/x?=
 =?us-ascii?Q?hUtUINUy/A3qT6UJ8sc4IOC/ykbhosefv9ONpaGWkl/DSkCZugyh5LHkjdGf?=
 =?us-ascii?Q?2ro354s9nMQlADC/v0igAQ26KTCbQQhR5lED1tzL8B0j0MU5AMu9W1FXaDHh?=
 =?us-ascii?Q?wd9Ahoau/jAEo3JeLonENlP7KYL6gfW8AJpB7myA8EmHPBZCuJ8W8S+oUcb+?=
 =?us-ascii?Q?KNH0qeWrCAqOsAUdmKa4MMu3nnOMahEN7+2EAKehSH2eO4kr+tD/9nnN4T+7?=
 =?us-ascii?Q?cc82w4gjcCOh6Xv+kGpPbPUTOT2Qxvbea7A3pwmGWLIzlDt2QnG9q+Kuf9aq?=
 =?us-ascii?Q?XMUnUENVvqI5W7XjQHqzFfp2S/QeNvXfUjoMjQhTmAEz8RpqgRzmSluq8s7R?=
 =?us-ascii?Q?17SzstEkxLuqIekKe1/tIDVBV60Ms4alOVVw/35XLzB2xTe/JOpiwnRk9CsN?=
 =?us-ascii?Q?Ieyy0Lp2SZaYBv3U6e98d06S3YRuywgxDEX6HWAdl3+mn+knQ41DdNECbYWJ?=
 =?us-ascii?Q?KiLeG3/dfgr9f8VnRUPhYHLHan0t+nEtjj2TIMyCyzOXCsKFwsrBCnJkVJ+1?=
 =?us-ascii?Q?yczRLRcUC0m/dNUpN0kpLVt2E1RV9IQfPS/LJ5ZTIER/CSxrBTZEyjkGzCYI?=
 =?us-ascii?Q?Bkf/1y27xK3o0sL2BXeVq4/TdrPjHdDV/ynsI6febrmTciO0jjmaV09iVMoU?=
 =?us-ascii?Q?Asf5wgE5GLCQZFnyLhRg71boKmlxRTESGOe3ramVIKPVlvOpI23iLm/NcgzR?=
 =?us-ascii?Q?Cn4rSoP6/NWzcKsNfUkkE2WnBf1Zu7o2TJ2JEQDQXJ6e3zMDAgYeU70O+c+G?=
 =?us-ascii?Q?8MTJ1dr6wcup3hwN3rVXN9d5JsZ+QTyOaaCbAzEFvuI1EytCLjRWwyeSHF4z?=
 =?us-ascii?Q?xR2c9JVwsLiAOUNGaeUtF7SacdEpWkNl19vh9gZPoI4zf8nC/a9RyqsqPY7t?=
 =?us-ascii?Q?IDcSAL2oU4xE23rtDsYcx4XoG9JURZWnjq67P4c4HmFDR4ygYO6DyY171xrm?=
 =?us-ascii?Q?gc7/xeYk3Eu+UgzC1adNk/Z2MFQLQ904uuG+PD521wxbxkdiUE9trfQ/qTOB?=
 =?us-ascii?Q?HHoO5GAkhgXIz099xLlOjnHNJTrvj31ugrKE3HxTzFRrHxd9Fgyelh9qAMGL?=
 =?us-ascii?Q?jIWrtRJSfcxfmIVOe9NVVblT3w7MV+OSLv2HTCIND3lhsMvW9aRl7J2gkPHM?=
 =?us-ascii?Q?4nuwd3MsXRfBaLyOXGIrrzIrxXmmXQYysjRa6W5a?=
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
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6339.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81ff2466-ffea-49bd-d8b0-08dc8133aa67
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2024 05:36:48.1404
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rPz3aeiOZ90wSiTH2bRX4Cih68LUewMB6q6hSwdpfFpXrIuKjTS05XMmRTIaZyN0qq34z9gR9P6SYZYQNejU3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7922



> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Friday, May 31, 2024 10:53 AM
> To: Akhil R <akhilrajeev@nvidia.com>
> Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>; David S. Miller
> <davem@davemloft.net>; Thierry Reding <thierry.reding@gmail.com>; Jon
> Hunter <jonathanh@nvidia.com>; linux-kernel@vger.kernel.org; kernel-
> janitors@vger.kernel.org; linux-crypto@vger.kernel.org; linux-
> tegra@vger.kernel.org
> Subject: Re: [PATCH] crypto: tegra - Remove an incorrect iommu_fwspec_fre=
e()
> call in tegra_se_remove()
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> On Wed, May 29, 2024 at 06:53:42AM +0000, Akhil R wrote:
> > > The only iommu function call in this driver is a
> > > tegra_dev_iommu_get_stream_id() which does not allocate anything and
> does
> > > not take any reference.
> > >
> > > More-over, what is freed is "se->dev" which has been devm_kzalloc()'e=
d in the
> > > probe.
> >
> > I did not completely understand what is being tried to convey here.
> > If I understand it right, iommu_fwspec_free() does not do anything
> > with the "devm_kzalloc"ed variable.
> >
> > It would probably be a good idea to remove this line from the commit me=
ssage.
>=20
> I think he means that as the memory was allocated via devm, it will
> be automatically freed by the kernel and the driver does not need
> to (and should not) free the memory by hand.

Ya. But iommu_fwspec_free() does not free the memory allocated via devm.

I think iommu_fwspec_free() is expected to be called in symmetry with
iommu_fwspec_init(). So, I do agree that the SE driver does not allocate
what is freed by iommu_fwspec_free(), but I feel this line is a bit mislead=
ing.


