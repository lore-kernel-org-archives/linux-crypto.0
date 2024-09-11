Received: from CY4PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11020100.outbound.protection.outlook.com [40.93.198.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18196185954
	for <linux-crypto@vger.kernel.org>; Wed, 11 Sep 2024 14:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.100
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726065769; cv=fail; b=fp6q+MZUcU1/Dx0I9IZbFMLZswMKDyL+qPvwJjXwiACWv5mM5Ca3RUYnzYARS3Orozof+spdzKdhyn5Pp68au/AFWeI+7TzzXJRS6zz70wWj7pD3zXbtd3qODFrxKgusftfxJasPyhkYMpfT2ZwCyRdbddymsOJEpnIeVkmcQC8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726065769; c=relaxed/simple;
	bh=FJ/PZd8Cr58wFICZuqlXGpms+LNC6S9lKYoTbwcWLc4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=E42vHd2/+/Qfqs11WdmNt8e6hpiLErl74qq2YR7RZGrOd8yAtNb9qYU5YhaYyOHWuLV6zC2SP+XO8P7LCMl3rpjYDLOcDf4Qy5Jg16hvLxlPjZJPM9hSra75NmQ0IJtRnlLOmjqH2WsaSD/yW4ZBC+EHg5eeGr/MmqFBVFEnu0U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=SkdcrnPN; arc=fail smtp.client-ip=40.93.198.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="SkdcrnPN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GY1nifi1QAUgKUWqArE41Wnw4H5SdnnKMJNRVIeqlxDmj7P/T2nubw8AnXIVQwLCqo4zer0LHe65nhMivBVZSbqjIsduzjR2IOneH8yHgo7Wt1i5VJvt1SbUYZ1Cb5mlLvvCrPKof1DGEFnAgXCtLvnEa9eFA9G3IJcZMEoDBry7+fsO1n7nunSzjPa3fz17dboX38HUeuDvFLRu/O9+aAZYezoqiDVJAkvPdfJyMZ2ETl5ysMePfERlcrTgYbuhcQe1TzgoKV0ZTkt19Vv83L4r5GtgxbG+4PUFsnS1y/lYOIuXZYHdRV4/Fuz9pbPY997ZHnkT8oz0eyDQRSGl2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iiERnoLTPC/AlYl8X1GH5mo0l7EUnwku1yJbYSdpfUU=;
 b=wBojhlNj8EdmgdO59JL4bYbpaZpC4ylOglzeb1e6OUe5ugjTBsQUzVVe0bksZwiGpzbtZaH9gxmYHdkhTj4LAnwINbidEk/sEF4YigaTevRofRvb2Thzzb1+dRwUHc/fzEn7sGhY0VV67p9zzSJZg8v2auEgRyeUOk5hEhKg577TDanvs3rLowxUjyfRiYWrGAl3K3L8/fUKCsJm97PHS65Re+tFCQ5BcGDAaZ8ePZEiSoRpsFjrSlESt4ADmoP09lQmjzILlFewknTouq4XX4LOGge4pyeYT0ta1FRZx0LLGpM/6DygRASdHqlhoteOXBsjjR22scRtaILfTK1G2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iiERnoLTPC/AlYl8X1GH5mo0l7EUnwku1yJbYSdpfUU=;
 b=SkdcrnPNU4WRuS1NIyGPEayJq08jqLC4CQmKghowK4fh5stOkUN73UuaE+kuveIN2ttYRicW2rvpSxfpJyv8FztlifwpOekUCyzcisvwba+dyNzJz8MhE0tcRaP2hOJfmU+ora2pc40UzgW4h+O102J/i+IN6XaVlM7/A2SPlPU=
Received: from SA6PR21MB4183.namprd21.prod.outlook.com (2603:10b6:806:416::19)
 by BY3PR21MB3034.namprd21.prod.outlook.com (2603:10b6:a03:3b3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.7; Wed, 11 Sep
 2024 14:42:43 +0000
Received: from SA6PR21MB4183.namprd21.prod.outlook.com
 ([fe80::7726:9a7c:85b5:245e]) by SA6PR21MB4183.namprd21.prod.outlook.com
 ([fe80::7726:9a7c:85b5:245e%7]) with mapi id 15.20.7982.003; Wed, 11 Sep 2024
 14:42:43 +0000
From: Jeff Barnes <jeffbarnes@microsoft.com>
To: Ard Biesheuvel <ardb@kernel.org>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [EXTERNAL] Re: Incorrect SHA Returned from crypto_shash_digest
Thread-Topic: [EXTERNAL] Re: Incorrect SHA Returned from crypto_shash_digest
Thread-Index: AQHbBEwSCNhYTkgAFUirBdo85cqkSrJSmpWAgAAOgnE=
Date: Wed, 11 Sep 2024 14:42:43 +0000
Message-ID:
 <SA6PR21MB4183FA8C1786EFF29BC7676EC79B2@SA6PR21MB4183.namprd21.prod.outlook.com>
References:
 <SA6PR21MB418301113B9F45171814851DC79B2@SA6PR21MB4183.namprd21.prod.outlook.com>
 <CAMj1kXH7ubpkNQbSrvukvbJHnDDGSq+JWyMaPvPtUcYH=Mvsvw@mail.gmail.com>
In-Reply-To:
 <CAMj1kXH7ubpkNQbSrvukvbJHnDDGSq+JWyMaPvPtUcYH=Mvsvw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2024-09-11T14:42:43.533Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA6PR21MB4183:EE_|BY3PR21MB3034:EE_
x-ms-office365-filtering-correlation-id: 37d0734c-2235-4bde-7534-08dcd26ffedb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?KFRmTzsbfAkPemNTqi4hYZ1LphACYK8jwfRTRbJEp/Tmjq6OZAiMddNOBF1N?=
 =?us-ascii?Q?NxtkxAuEs2H3Ijs3VXfmCqcKInMr8F9GC101AYz6/UhF6guZHg2rvqBVjWb2?=
 =?us-ascii?Q?S+j0MMPLs1eCdUiZCwBQWoKu4XRML3XyOqJVUOUbPdA/oChGFBpzZFC9fExC?=
 =?us-ascii?Q?S+WBF1QZBnXDoOwyaGLvcagrBDvtw0YE2z5215USGmrfhZcF62WmvRWAbE7F?=
 =?us-ascii?Q?0Rnaq6Zuf+ur+AFP3KsEkHGQ0PVV71Bhek3KQ/nTwBOImjbld5putWjIYzzo?=
 =?us-ascii?Q?Nu2bg013Pm/kus6sQJiETGAxiR0inmmx3a4nh3pC6orU7jcA1RotS6pjg+Ad?=
 =?us-ascii?Q?1aW9KADGVxO8ic/HsxSDh0UP4TiBOpFi7xeeeh7C5CF73DfWeGNKUzGwhyvH?=
 =?us-ascii?Q?HWf/4/3OzcjeTkIbFg1+8EfnXR7cS6z6BiGukZARDNnPov39gu4gJWSKqWpl?=
 =?us-ascii?Q?6tqbBFd6xz1zzxe31bLKbMpvREtZbaJwD7ovQvYU/gyIJj/bkmuxoqzrSexb?=
 =?us-ascii?Q?oSjVfkO56l8MK48dPdOIhFoHAyIN8PRCEuKqRpEFvqThTbvg/Yo57X9ZNaeN?=
 =?us-ascii?Q?N+8U0SjrAmN4DeIui3I8lyqj0qTfvr9aRY1h3OGP+QtUpH5z6ev1ieJu4lEt?=
 =?us-ascii?Q?QCMPQkztdLYQ6qX4D7dwxC9y91C4CT5KOO8M93lZPiLOLPMdt72W1P7+mQNG?=
 =?us-ascii?Q?/+mAkVrSgSlRpw4bai5jmV7A9xAGv2nTF0QBSlLMMkQ5vK8sLFfJ1HlNB6qI?=
 =?us-ascii?Q?B438a9h46nfa/R19603dBZheKGU0GxUu7CBE876bZmUw4kNbB34zERTPEUWl?=
 =?us-ascii?Q?7XD8/ON8pehDShZf6AiCbGPi4+UUjfgivksIJ+EVIevF36wNVbK7eWLW5q0i?=
 =?us-ascii?Q?az+lwXKqz+ytBT3CGzZLwzQdYCXVE7Zx/vy3KdNgUBgZjmR89SCU08dn8ErD?=
 =?us-ascii?Q?qjX4mDhbY0qxOUw5X8XyVV2kpv/V/Wza5daI3vwuHXuWrxEISkri+fHHpy5y?=
 =?us-ascii?Q?29I02rWPHwAnlWRYXgptiYLSu69e2Dmvg0mGhnbZJOp4bEg48S5N2CpA75Vw?=
 =?us-ascii?Q?rhqU6zXasi/+ZkGIKRxfeP26csJmtIoIhJZUPTnOHG3n+j4xenqPu6XKGgiP?=
 =?us-ascii?Q?Pk7S3GROVyFi13wm0MzCvLP4v8kvVg4Id0e2lXsWcT2UOy3UCDIY+/i8Ftvp?=
 =?us-ascii?Q?P9Kf6XzU5kbrCyaoGs2oYJQ15rYAZGnTVIf39Rd4mctdZHgPtEn6fd82Bcsv?=
 =?us-ascii?Q?82SN2QqjsCHqh7rymzg51pAo9nsmtwbidFVYyoW0Zcv9kQZlkDySsg7AfhfR?=
 =?us-ascii?Q?qsQDJXK3YAaCc2zFxiPuogm2KmI+E70PnoB8RGn3THl8YKnveOK336vNweQX?=
 =?us-ascii?Q?bc2fRsj70X6PN1Ix4R68TigGccs2irG+itulg7OF+GYVMPqULg=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR21MB4183.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?PuKSofWptOoIcOoa2sOIjds5fsCMW8kVOn3UsYAI3R/feV+kb9pJkCosSl9Y?=
 =?us-ascii?Q?TMdWJlWHnyrXAk2pIOmNRRGNqhh6j8S3x5m87MceI+mRY0JS6cNDf2rXL7qm?=
 =?us-ascii?Q?0XN/AI00vjo4mew3YEHkxdunAMM2CHJhX1rOe9bJi8t+d2Wv8E2LLRociQtT?=
 =?us-ascii?Q?7dKfGyKrtSBe749YbgX6Ca0rGI6zQrSfZJ8Ur4Twrchv3z/rjgytYjt8BP6p?=
 =?us-ascii?Q?ztfWRAX8E/yZjONg22xTmq+a7HtObqQcMzplY54xosBd28DgT0DIe1+Sxf1w?=
 =?us-ascii?Q?i8CtvkcrIXCBJAKgU5B1WrYro7/mQVcV1K/qYCVAh7Q+UEC8tP48boZ0Gxs9?=
 =?us-ascii?Q?67Mf0+lRyM3DQE5sxQ9lE7VUYIAJ99iq2DeXfOlq5tLSm01CX6GugdBdGShG?=
 =?us-ascii?Q?Sdql5nAG1iy8E4LQ0T4TziRnK4Hb1XHbIH9sn5Q1vZwzt62x8KZYlqsfLADN?=
 =?us-ascii?Q?5zr5WdfCnIF+Dq8slZkaaSzLS9mK02limze0VH6sZl6MrKVi4M72DxXT1dEk?=
 =?us-ascii?Q?mVLQ8/sGllEC2qnxK2s/NWJB+cmwf6Vx2XKha9X7H4x/uUPzruUWGygB3OSq?=
 =?us-ascii?Q?D1EZrtXQMjVIfAAv0AmXmEV5qf2yI9/WBcEHoMVNCC73TSPf8EYgIAGqIijP?=
 =?us-ascii?Q?EcviuZFDkfwsAwnWiQ/elO4WsfJsrbaOujfzTEshibTnt22Auv/iyADJMk38?=
 =?us-ascii?Q?hAGNNcMJYit5duRTZ+gqLJRvtGw56d1F+uFoP65eZfOIsKCVGHo17BSKjned?=
 =?us-ascii?Q?CYRXUVsXR5DvrREiUJ07XGbeklzT416ZSJqRMx/CNl9n3wS1mzjBn1CtBvug?=
 =?us-ascii?Q?jCADoSkNyoBKRRlqHCFTOHgIpYM+mAuB7Oocgm9I3q26x+23ovf7SHRyu+1+?=
 =?us-ascii?Q?cYxXSvZ1zg6YH5r6izOBL6COJWo4IIt4+R10H0dl/Z4zTZqiZnlJQW2wmECA?=
 =?us-ascii?Q?Dc+DiEHNZZJYHx7sofPuAjnX9hZTg947qWOljBI8Jp33KnDhPtaJitF6gdOU?=
 =?us-ascii?Q?9KMRBU0SzzrRHP23mFMQ6czDAc96kEYQEAznBW80C9JbZw53+0cgCpVe198f?=
 =?us-ascii?Q?VMMEj0nz0Q5ME4ExtFMmaffMD6/TXHt8jkGGLnYLK7QD7867s5dUvL3IcC0h?=
 =?us-ascii?Q?5+uI7p/JS+BGmA0sNLP0/8iWyjPoN7v1/c/LeHCfmptnDbwKGbEpexmlp+Jo?=
 =?us-ascii?Q?I62qMbaJx36xEFn7tE6C/5zrFcDfw74Z2jrIc3Y9YN2j17dFm7nV2mmV3tXx?=
 =?us-ascii?Q?7ww4tNW19LumjhYgm3Z46XYYO3abZc0VZvbIGy+jQhFNrQCVGW7uuZphuXVl?=
 =?us-ascii?Q?moZImxw2LUdD3FD0Z/sKaiP+ddNg0Ht5iAkSP789JhxJW17HAlyap+K6Mbo4?=
 =?us-ascii?Q?nIfMDTEmyLvvsCzcsejOI8QyohIpVGtoA+OhF1kAM6OPJvrz33xzylIirngv?=
 =?us-ascii?Q?QzoLoJqWJrgTpGCditPb1tG0ypE4Jy9AY0VwATJ+H61Q6pzEIJSsExveBPqy?=
 =?us-ascii?Q?ulydWzUJou/FBwRHd/gwa0XndPpIwy5IEc0e19lu0dGviyJEFsG7rbOkC5/9?=
 =?us-ascii?Q?MN33mMCyKub18YQVVb+N7ZW4MxnR6nS6FQDssS2b?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA6PR21MB4183.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37d0734c-2235-4bde-7534-08dcd26ffedb
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2024 14:42:43.8240
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sY/qxYYD+RMTG6uyS2C3L5j2ljKks1HXJq4F1xGx1jRlhpGgO45YEczUCJLm+YWnT2IXhF/VQqkIuyAOThKujUF4/40/KcPm0TlqtSaE42o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR21MB3034

Thanks Ard,

data size 1073741824 in range, less than 4294967295.

That was produced by this block.

        if (tc->exp_len > __UINT32_MAX__) {
           printk("data too large\n");
        }
        else {
           printk("data size %lld in range, less than %u.\n", tc->exp_len, =
__UINT32_MAX__);
        }


Looks like 1 and 2 gig messages should work.

________________________________________
From: Ard Biesheuvel <ardb@kernel.org>
Sent: Wednesday, September 11, 2024 9:50 AM
To: Jeff Barnes
Cc: linux-crypto@vger.kernel.org
Subject: [EXTERNAL] Re: Incorrect SHA Returned from crypto_shash_digest

[You don't often get email from ardb@kernel.org. Learn why this is importan=
t at https://aka.ms/LearnAboutSenderIdentification ]

On Wed, 11 Sept 2024 at 15:17, Jeff Barnes <jeffbarnes@microsoft.com> wrote=
:
>
> Hello,
>
> **Environment:**
> - Kernel v6.6.14
> - x86
>
> I am currently refactoring an ACVP test harness kernel module for an upco=
ming FIPS certification. We are certifying the kernel SHA3 implementation, =
so I have added test handling code for SHA3 to the module. While the Monte =
Carlo tests and functional tests are providing correct output for SHA3, the=
 Large Data Tests (LDT) are failing. Below is a snippet of the code I added=
 for LDT with error handling removed for clarity. The sdesc was created els=
ewhere in the code.
>
> unsigned char *large_data =3D NULL;
> unsigned long long int cp_size =3D tc->msg_len;
>
> large_data =3D (unsigned char *)vmalloc(tc->exp_len); /* 1, 2, 4 or 8 Gig=
 */
> cp_size =3D tc->msg_len;
> // Expand the test case message to the full size of the large_data object
> memcpy(large_data, tc->msg, cp_size);
> while (cp_size * 2 <=3D tc->exp_len) {
>     memcpy(large_data + cp_size, large_data, cp_size);
>     cp_size *=3D 2;
> }
> if (tc->exp_len - cp_size > 0) memcpy(large_data + cp_size, large_data, t=
c->exp_len - cp_size);
> err =3D crypto_shash_digest(sdesc, large_data, tc->exp_len, tc->md);
>
> if (large_data) vfree(large_data);
>
> I verified that large_data has the expected data with printk's.
>
> I also tried using update/final with smaller large_data sizes, but I get =
the same incorrect SHA in _final as from _digest. When I run the equivalent=
 test with libkcapi, I get the correct md. It seems the kernel needs data t=
his large to be sent by send/vmsplice in userspace for this to work. Is thi=
s correct?
>
> Any help would be appreciated.
>

Hi Jeff,

AFAIK the crypto APIs generally don't support inputs larger than U32_MAX.
