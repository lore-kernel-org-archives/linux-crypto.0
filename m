Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CD03469F5;
	Wed, 29 Oct 2025 17:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.156.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761757580; cv=fail; b=qMlyTUBPz4C/BHIWreMIb1TZljKwaUIZQ07aHspKgqrWsunoxTZgajnM76eONr8Y5GAxwT55cOBXudf8DRISZQTw5bYD0WHHrU54uzd7wuQIyzQmDLf4NqrpSrXrMr97RcuAyNBjRYZT1UKbjtfCYHrEY8PCbCb8desk8vHXXWc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761757580; c=relaxed/simple;
	bh=qdhIfKjX3MwJlLVofWLtWYJehLXfp60YbT2zpk2pn+E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QEykIoSUv+oOyDbT07c1PSkMEYTcQyZCm/7MU5mpq/l9GI7N20e6imW6Qz7+GFEUQ5QgO401iCjHG6MpywfAPoy3Z0XTLdPQmjPjntFjtKLC0zAuFOf1iUHTHasEggfdZPdHRpzlDs69NmORguGXQYfpW/Dfax3W/bTPROnWBaM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=Pf8XqXWG; arc=fail smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="Pf8XqXWG"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59TCffEB3601264;
	Wed, 29 Oct 2025 10:06:06 -0700
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11020092.outbound.protection.outlook.com [52.101.193.92])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4a3has9fah-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 29 Oct 2025 10:06:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dy+Rl1G4HNC0Me3Q7+bsozDO1rlC+tIka5keTK7ynxbXZGzavu4jjHlCgRO5ZZYQrHUS6ttYKRgj+TF7lVeyp94LRr/7ow75H7E0yewoCNH+ZkYsQ8xfz4qwF8QLXxGemtrkIeKdn5LkDLf3SPx2QhkLK0CUWj1GvhdpNkRTmiP8mWoIfxYZrcpDf6ilrbq5ZeJtoAp83fHNsgwoW7rJ3ly+L/3ps1NswyPmrM1bP8ohyj+8mCN64dAZkry4FYFn/nUgc6TmjvorFU0nAXWpdAEqK8bkTp7YcoA38CjePfjsI3wvCpnBvb9EzisNJSqz79A49EL5qkQXiOwe16NPzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w5rVuanAR5FkgVhD2Qp5xWEPKMCoXtV6uc6Cs1MglD4=;
 b=KBi3mA6ZU+9mnHpNBGHaxiotYAVaX4q1uNv5BNBqFxueaY3Rp8DvP1EEhmN+1Cv/IlIklMyBsK3H8LjcgdnmgzvXl9BwLEkKUgDguAEhXOLWZsGP1tBdpI2vFz7GqwFXjvHyOukoesS12uf5cYcS2Q2K+nzq1aL17SOun7HPDFjSmDYPXO3RiS3a8DrnWEf4LOIFPLPigj1aMfSEor3PLP4KVSIv2cc9Gs53kBfi5Px5RiDqvzmWzPv1Ec1QY9LDmNI/82mSWigEsuryjcjeIw3Dv5S13MA0jA7GsBK/wraWD0/MqNJNlQkYeRahk9btxrcNV53pnOXnMh0Y9JHoRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w5rVuanAR5FkgVhD2Qp5xWEPKMCoXtV6uc6Cs1MglD4=;
 b=Pf8XqXWG0m0i+QAw86Ais8KMKH4RvXajoyVmlAp1gbjkeV6rokzba0ay3998eYixnqpgPA42RXjAeLXperHCQQPAzdxJSnL/1DSuYEC9CHDIcrBgSKYwtOHo4kRRtF+OV5sRLVLR5Zfm54SDVtS67Xi6sCV3Ghm+uCxhHUxj7zk=
Received: from IA2PR18MB5885.namprd18.prod.outlook.com (2603:10b6:208:4af::11)
 by SA1PR18MB4661.namprd18.prod.outlook.com (2603:10b6:806:1d4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.12; Wed, 29 Oct
 2025 17:06:04 +0000
Received: from IA2PR18MB5885.namprd18.prod.outlook.com
 ([fe80::f933:8cab:44ed:b231]) by IA2PR18MB5885.namprd18.prod.outlook.com
 ([fe80::f933:8cab:44ed:b231%5]) with mapi id 15.20.9253.018; Wed, 29 Oct 2025
 17:06:04 +0000
From: Tanmay Jagdale <tanmay@marvell.com>
To: Simon Horman <horms@kernel.org>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org"
	<leon@kernel.org>,
        "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>,
        Bharat Bhushan <bbhushan2@marvell.com>,
        Sunil
 Kovvuri Goutham <sgoutham@marvell.com>,
        "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
Subject: Re: [EXTERNAL] Re: [PATCH net-next v5 08/15] octeontx2-pf: ipsec:
 Setup NIX HW resources for inbound flows
Thread-Topic: [EXTERNAL] Re: [PATCH net-next v5 08/15] octeontx2-pf: ipsec:
 Setup NIX HW resources for inbound flows
Thread-Index: AQHcRoq2QfUbOrubK0eRU3D2EF4HL7TXYwKAgAH7m4Y=
Date: Wed, 29 Oct 2025 17:06:04 +0000
Message-ID:
 <IA2PR18MB5885208D2E361105CF118564D6FAA@IA2PR18MB5885.namprd18.prod.outlook.com>
References: <20251026150916.352061-1-tanmay@marvell.com>
 <20251026150916.352061-9-tanmay@marvell.com>
 <aQCe50-IRGsxbqUv@horms.kernel.org>
In-Reply-To: <aQCe50-IRGsxbqUv@horms.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA2PR18MB5885:EE_|SA1PR18MB4661:EE_
x-ms-office365-filtering-correlation-id: 0f8c3161-c9e4-49fa-3cbe-08de170d71d5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?m2XsCgT6kirAmD//NWvXJBYOON8rmti0yIC5bRkd/Ko+L+DvJ0HIc+hjm7?=
 =?iso-8859-1?Q?NLRnQdQzLjfmOKuin2WElM025jhojDyzV1QG7UMc9oeps6u6pzIGAkhRrp?=
 =?iso-8859-1?Q?RvfERe6xuvNKgzU7hmlkGJ1bFToUfN3g+y+byfdTKEZtFbH9x7aaciV8un?=
 =?iso-8859-1?Q?UPQKqTm6kTjj4rHfPvD2p9aRbBks/bItNkHbU45Nle0brDl4QUidzfNiZC?=
 =?iso-8859-1?Q?1PapZmRXczDA9oiIC2BCdvV+msae1mgFZhjTwA9Zt6I480NCwCbIZrHGMn?=
 =?iso-8859-1?Q?so1CNwH37UkIfMOti+V/0PtwI8pcPzEFJ/pJfiyDLcPb2oIAcx62jXYAew?=
 =?iso-8859-1?Q?eD6S87602LzXVJxYjvLLXtlTXniAuwCQ+v5zi9T/yJ0+FeT3clhWArO4UH?=
 =?iso-8859-1?Q?kIEZmx6cErCTAOhjn+7348VhKRr5uLWoD9vIB06SkoqNBoKH3wCGkpSDta?=
 =?iso-8859-1?Q?w9x7uu04x+XO6EGzf8QvxSN4KTjIyBz45EwUcQdeWUDT4yBePr/k3a4z+w?=
 =?iso-8859-1?Q?NM3xRZ7g3zgTcTD6FgyVy/V8cGUoyqfcyPtpMI+w/jIbo+sIWUrXUZGHi3?=
 =?iso-8859-1?Q?R4ckqZfzFwM5DqgJZaOx2gw3hM6p4qaevPc+9EzTRX/RBoDw6IBEA+L+P4?=
 =?iso-8859-1?Q?gXj3xl7RfzVCAfkh1lgbYBiuuO7uK5KOCfZrND+2HQLVZSw7MfgMgBpcZG?=
 =?iso-8859-1?Q?XnLupCB60/J2ajhETtU8w93wysLEnlQ/G9cndfvblr+zqTc34f927hP4oZ?=
 =?iso-8859-1?Q?AIyHjcS8XBYsautOpTp2z8TaXneSnpc7yrzerE1zONJJojZA+2FKWwEJ0W?=
 =?iso-8859-1?Q?YABFZ623atqfiPMCqcX0BSClS0FhKMH6JDFJTPBQIAJIvc5fzrXBnsCQhr?=
 =?iso-8859-1?Q?IgtWrXmNb1vpuWEZG5oQtBFeRraSDE7WsCgTjAwNdjwsSpokHTaUf4lc0+?=
 =?iso-8859-1?Q?LJBPKLeOpb1hSs2scZ/8J10j5DRvWlkFU/Yil0Z6hTs/jBKOo4PAkbNFRu?=
 =?iso-8859-1?Q?PUYFzCDPLxCIifFq8w8Tv8M+lZa2fLTWVIFgYrFxUnWcbD7Wu6tbSftUo/?=
 =?iso-8859-1?Q?mq/LoLflG6N6irnsxY3hjyE42D/De/LDFR4W/WPqHF31NlNaP6ZvmInkwS?=
 =?iso-8859-1?Q?H1Xfj62tTXIwACjMjXvyapS7QCjbpphAng8xE1E3pETZzgcdQ9QQkSA2GG?=
 =?iso-8859-1?Q?PAx5NdASVsgm2d2PtxnUjA5192aVm8C6mlqzHluFErNy3QkobEC7IShiVR?=
 =?iso-8859-1?Q?qA79T7m/ZNUgwPCTqR7fqg0sw9aiKZn/Ds67pOsd4IbPY63c7VkSc9VG5t?=
 =?iso-8859-1?Q?J2klFPkwP9XhgcDNywcla6nE9WKEjJzD52pqlHOia2eV0fEXh2nbHe3q+X?=
 =?iso-8859-1?Q?+Cp59l4iK7E5uwzwJD8tugZb7vqbx6q3IWKA+a6yPP4JdydiHS1Pz3iovS?=
 =?iso-8859-1?Q?rANi5QwaSyjbRurqIZbHqm1v4NWfnWcnOpqlSNB2bpwgJuAvsWUrYw6ajr?=
 =?iso-8859-1?Q?1fmU/ygdFEFrPpuy8Ipjk7vUmlByivvFnHup81dKU1Cb0m2PxqsbcTpiO0?=
 =?iso-8859-1?Q?zUauBSHQWDl5GcenKzpOYUs5AH4/?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA2PR18MB5885.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?pxdZAA7BsReBBui6lOnAJC1vuaN6reHBbDXSDU+ulU0KAW41oAMnqa5ilq?=
 =?iso-8859-1?Q?XndPjnTz1RPtwoGNeYmji/8kIXY7yZQJKJxtLNbAzMKe7wb6uQVoMHUXFB?=
 =?iso-8859-1?Q?c9ov1rkmhe8TWNPivyJLgbPVBfE4lGpOjh2B++748rrMp1I3XgAdge6zDI?=
 =?iso-8859-1?Q?R/m1r1EZhBtu6UebRNptWviDpSrvtPjNkfie/yZA35CHX6BTWKb4f5Q7Fi?=
 =?iso-8859-1?Q?WJQiaCOw7czkiNEeE8hZfwJPT+FXe4gxaSZpBUvXouEGFho0pe32rWRQUO?=
 =?iso-8859-1?Q?5U35WNKsWqTmg7D84hsQ+Cu1F1DqYJTRUWICPz/joSGYOorH25qwdu7jlX?=
 =?iso-8859-1?Q?gOpbJ/LolSh/OSzT9k53Cn5S2/irpM4brR4gjFAtNQWFdi/RUtgyrRNMNM?=
 =?iso-8859-1?Q?zcJ/JxBjldQ7Pjmar7VBHP0JAMhxAJpEIEFd/E+w8apeTl2N9qRRwkoJWf?=
 =?iso-8859-1?Q?dDzqYKNqM/aMrif31Xu0C3HVzrgFvAG1rf0HrJ7OQCBzw8+JzMw7WdD4gR?=
 =?iso-8859-1?Q?14kjKr3Zz3O5cnbo2tW35MTAoNTvGAeytNBhTYlgqujgBJs7X1RRSvGBQW?=
 =?iso-8859-1?Q?a2SR+BFshd27suWIdiQl5QFKG1bnzQBCuBfoxF3Ax1NmndJZfeDDjBHDLA?=
 =?iso-8859-1?Q?Lzz5nt+2CAxfMGvOCfqQdOGb7A/QvjcwzeQzR7be1ZBzaQ6NhzKGiwx7P7?=
 =?iso-8859-1?Q?CFu5YAVAb2Ps5/6ztg8uUBiz93p5qMueIoJ9CYAx0aM4yrFvw5N1pTz+g2?=
 =?iso-8859-1?Q?LSRdVKun90iS/xwVy1rQbyWqgDtL99IbJEH/EGyANNu7var4nxcENmE7PC?=
 =?iso-8859-1?Q?waRhqGnnuACyxPy6h29/ygLw6vgcmJ+yVTxf1nNzW6Jb/h4jPkuW1k22dA?=
 =?iso-8859-1?Q?w6jdAKPvvCxFOxUwrbhcSOsjazkiJKBsORoy0jlIp9bjq8nIpuQR6MzEzY?=
 =?iso-8859-1?Q?SXnHdafoWVosocwIQ9Of6IUacbK4JGIJ2NbDNdDimVSiswjatPJjQp5lJC?=
 =?iso-8859-1?Q?t6eaL8BAbuVkhXg3QV0YCO+rQ2lIVxxwsdRNa7duYCCCO3Htzio5jM2kKn?=
 =?iso-8859-1?Q?QKoaguzQNye71dhWML7CBnr3cGl/Rxc8PF0R77E7fQrvvVpO8CtH0xhRSA?=
 =?iso-8859-1?Q?rCH8vZOC5xtnvB/WLhcMEPNH8cw81fB4sx8RmMb4IDcC3AZEhh61jOn2I3?=
 =?iso-8859-1?Q?Jx+wi5XaibSk54yWLYSfZPwqnsxaCWDdGb7co0DucGAGKZMYxIGjPSDDuY?=
 =?iso-8859-1?Q?+JRvJ9GyuoGWg//ovljTdzUOM9BcWFuc3fB2VgfM8G6vbRzCfo+N7SNX0z?=
 =?iso-8859-1?Q?nBoOq2irjtiXLwUS8z2086SSoUl4k8CLGBgLpTuzYGrBJsOvr/FM/Om5zf?=
 =?iso-8859-1?Q?ijjPTJRr0/3vrwEVgEfFE2GZnYeNIqPvG846fOMf7vscEu9NG39TYnAS6h?=
 =?iso-8859-1?Q?TboB8+7J6B/YObzteg+4JPQmmOp4pDASfEr6z7YH32aoMlV/vrF1GobE83?=
 =?iso-8859-1?Q?n4qeuEXi1bwdiYVRbHCASmGUXN4MRMJfK5TXqRXsHNl0IESREpWSlt0mjw?=
 =?iso-8859-1?Q?gnmLD5sX1JrE0NREiQEBqVIff/3MBr99v1Nr/xSChq7xNb0aBEMy+G1GAR?=
 =?iso-8859-1?Q?Se5CHh6lZI/Xo=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA2PR18MB5885.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f8c3161-c9e4-49fa-3cbe-08de170d71d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2025 17:06:04.4770
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: em0/B7zSchnW68pjU93E/5ybgMGDLUz2xi4IiUNKoQYZcJpPXUL3T+GEEBn4ffRarIbXAJ3QKPlqlW/PduuSdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR18MB4661
X-Proofpoint-GUID: 2EBBwegiU8Frd5KPMqVJ0tfAPe-HQB8s
X-Authority-Analysis: v=2.4 cv=LJ5rgZW9 c=1 sm=1 tr=0 ts=6902497e cx=c_pps
 a=xUkxIiuLuczgirDP/m2+WA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=x6icFKpwvdMA:10 a=-AAbraWEqlQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jNIrgoIfKHujF-ElI00A:9 a=wPNLvfGTeEIA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: 2EBBwegiU8Frd5KPMqVJ0tfAPe-HQB8s
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI5MDEzNCBTYWx0ZWRfXw2gjVMFmcs+V
 CTvYLSn9kQjVULlrcv7noTtrESOrxbV2MlKrmyIrmMbWTHbWeP3sroeju1WjuhDmxglG874EwRv
 cKPfabhheF5P0mHMMOQeRJq1zuVUTCORh+r4uRtD24a/rM5cF5hSR048eEDBhhMGq5QuDH+VsFF
 GSUTlqmFWsPbzXe09gwNTfbSF2oGJtFwSRbPkavDpLKFr/iWd97iu12dLNKpFpJWUSTUBtp55zc
 riPO7f07XI71Qm66kXiWUsb+9fMZeV0lIRKvaMrtnABHL15K6aM83oNY2+cDO7FQMvhGsKd5ppO
 /1XA7B54UQm82Ir1OnDgbbCagGGSongvIutM2O3EgeNsmoEc9CsBUVsRoLvCiQPP1CLAH44SDjm
 lktRuuHtYWy46CfIdy2FypBZwD90CA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-29_07,2025-10-29_03,2025-10-01_01

Hi Simon,=0A=
=0A=
> ...=0A=
>> +static int cn10k_ipsec_setup_nix_rx_hw_resources(struct otx2_nic *pfvf)=
=0A=
>> +{=0A=
>> +	int rbsize, err, pool;=0A=
>> +=0A=
>> +	mutex_lock(&pfvf->mbox.lock);=0A=
>> +=0A=
>> +	/* Initialize Pool for first pass */=0A=
>> +	err =3D cn10k_ipsec_aura_and_pool_init(pfvf, pfvf->ipsec.inb_ipsec_poo=
l);=0A=
>> +	if (err)=0A=
>=0A=
> Hi Tanmay,=0A=
> =0A=
> Not a full review by any means, but this appears to leak mbox.lock.=0A=
Thanks for pointing it out. I missed it.=0A=
Will fix it in the next version.=0A=
=0A=
>> +		return err;=0A=
>> +=0A=
>> +	/* Initialize first pass RQ and map buffers from pool_id */=0A=
>> +	err =3D cn10k_ipsec_ingress_rq_init(pfvf, pfvf->ipsec.inb_ipsec_rq,=0A=
>> +					 =A0pfvf->ipsec.inb_ipsec_pool);=0A=
>> +	if (err)=0A=
>> +		goto free_auras;=0A=
>> +=0A=
>> +	/* Initialize SPB pool for second pass */=0A=
>> +	rbsize =3D pfvf->rbsize;=0A=
>> +	pfvf->rbsize =3D 512;=0A=
>> +=0A=
>> +	for (pool =3D pfvf->ipsec.inb_ipsec_spb_pool;=0A=
>> +	 =A0 =A0 pool < pfvf->hw.rx_queues + pfvf->ipsec.inb_ipsec_spb_pool; p=
ool++) {=0A=
>> +		err =3D cn10k_ipsec_aura_and_pool_init(pfvf, pool);=0A=
>> +		if (err)=0A=
>> +			goto free_auras;=0A=
>> +	}=0A=
>> +	pfvf->rbsize =3D rbsize;=0A=
>> +=0A=
>> +	mutex_unlock(&pfvf->mbox.lock);=0A=
>> +	return 0;=0A=
>> +=0A=
>> +free_auras:=0A=
>> +	cn10k_ipsec_free_aura_ptrs(pfvf);=0A=
>> +	mutex_unlock(&pfvf->mbox.lock);=0A=
>> +	otx2_mbox_reset(&pfvf->mbox.mbox, 0);=0A=
>> +	return err;=0A=
>> +}=0A=
=0A=
Thanks,=0A=
Tanmay=0A=
...=0A=
=0A=
-- =0A=
pw-bot: cr=0A=
