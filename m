Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.14
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795767375;
	b=aNbh/zvHauEpsImzdvYOBSR0ox+0gPJe/uk7/dD+Xoif1+uyvc6NCI3NBzW4fw/N+FIk
	 x22peFiMlARbnHePIjnJywtYAUkSVZ6xuJklQt5CORIIK7uIjVW0Pxc2LQY5HkPDGHWuU
	 gYS8gHLK5x0hDet22PvsCTkDE5JcW+/3qHN6XeSBPhTjmQnKYzOlKgdOgfVfDS2Dn7ESd
	 EFGKa80ivONoLnChxm7QLsFqtLWd7oalS9O1/qJL7EGg+515P9FBepKqS+UIN0QVTkVn/
	 FW6k4nW4RGxtpDwe+pkkANWInFmoC3OgHpL9o5l9HnmpVlPVzU9cw4hvbF3d0Jugasg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795767375;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-AtpMessageProperties:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=CeoyH9OfgA7rt7oM2F7FPn4xVXkfy15w73Tz7bphlhs=;
	b=X1f2jVwvKECe+QLhvEdgzDoFrfc0DxTWgem9BId+2I7XZ2QX+IB79jSWY0YzIaQtRkCH
	 fVyLlMjxlLU+f8na4qSS6lOUGS9w2aw9f5gU7RD2PryAgMMCfbUTRs0Q6VrxvTjQuWUhy
	 6WQiWLPUQdKkUNT93fCF9ScptFolmZimSTFQVezXB0MoreEf9h5GO1Hn+noUuZf5OPoVu
	 nkHPjB6PvL6xP/nhqlNrj13Z9ymSqTiHRIfjm9wpf0UCntm1evfr4jXH23zcXiBPjVG6W
	 j35MUjyACO8XmFpcZzSblnkaz6BLZVDaBqtN5iFhz8DlMyDz7MBxR/m+9VHvrGt1cIQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=altera.com;
	spf=pass smtp.mailfrom=altera.com;
	dkim=pass header.d=altera.com header.i=@altera.com header.a=rsa-sha256 header.s=selector2 header.b=GIxbaxf1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.14
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013014.outbound.protection.outlook.com [40.93.201.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F67606A321;
	Fri, 27 Nov 2026 08:16:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65F67606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=altera.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altera.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=altera.com header.i=@altera.com header.a=rsa-sha256 header.s=selector2 header.b=GIxbaxf1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h98O2LU/1LXCKAGlwjC9dbblJtB2fl+oijwxYSTv1J7jdQjKTY2sGO4fIjl/wjt0vVw0z1G9SNvlIS1ZktH8+FPYXzryHHXWn5yp8FFqxOHlU9kNGG172ygeftOtyt6R/NGQWonY+HiDfXeWxDJ1Q7rx6B8tytAQw+hltQGlcr+TNUmeXnPV/mdgsFucOZhhF/XFyDAqIx4Q3C92pCHL0qnjtwoiPzMkQPvg7PVRvbqXM31QrB+OfuM/BN/eRAa3Uoj/gKP2iO1uGIHLJh5UP7JS4ksbsMCDZy1JTv+KmzM0xRTKNGzQU+mI7Jbn6oiCS/y7HGKEMrcSdXnYce21ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CeoyH9OfgA7rt7oM2F7FPn4xVXkfy15w73Tz7bphlhs=;
 b=MH1yDFgImlaWJDpMhi3XSSpwe8x8hW5pypxJr/y8NOE5/qvlXQgZ/S/keRaTdn53H1h8kNxHabsaxHzoDYTpRH+CE2Fz9oBie2FJferbjRkGeanyLljm6iqwKbeHp2Rbh5qHiGERsHzb+a12h8/0h8F2wjzKD7jGJzBLWqNZtDM62GKB3A2nLMd+KtDitz0+eD6jRlLRfI4MQIMQbaNNxxvIsHyfvEEsl34oe7DKsF6A52buRwGqfcQTKMMneF7TkBP9N/GtWgPOCAa/KE4Ulptu+L/T3Gffx+ocCqx3fA1HuHYKkbN4S3XD8jHreK2lPXbbtyNOZHgvK7mbf1XBsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=altera.com; dmarc=pass action=none header.from=altera.com;
 dkim=pass header.d=altera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=altera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CeoyH9OfgA7rt7oM2F7FPn4xVXkfy15w73Tz7bphlhs=;
 b=GIxbaxf1/mYV6zudQ2o7E/rHn8u/NJMFOJoFQ8Qel0Ob1eN/h5HeX3ipzADYOCEtbZsO+0C9MwFsZfklCHWn/HDedDfRKDz0WUhaM3UrYpcqrbzpG+AuTAs+gHJVrnUb5f4JLjoWaUgsViSM75zV+bPvHjNk+QUr5baeLUhvccQHdlZGJH7/7wLv7dNCgIUn52llhGPbb+ZdMEIh8KV5afTXic0ikm5PDhSt09cLHqVjxZfpIyD6lPXRG/eeymagUNdxJpyiYdSiVyUbo89Re5IarY2pXJOgmxDBKquF+mwv9AzPJzUXND6pRFyU6D5t1Ca0e4Q3zzzbWZ7/BsOACA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=altera.com;
Received: from DS3PR03MB097838.namprd03.prod.outlook.com (2603:10b6:8:546::7)
 by CH9PR03MB998594.namprd03.prod.outlook.com (2603:10b6:610:339::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.10; Fri, 27 Nov
 2026 08:16:11 +0000
Received: from DS3PR03MB097838.namprd03.prod.outlook.com
 ([fe80::fa39:2c18:c265:1d59]) by DS3PR03MB097838.namprd03.prod.outlook.com
 ([fe80::fa39:2c18:c265:1d59%6]) with mapi id 15.21.0662.007; Fri, 27 Nov 2026
 08:16:11 +0000
Message-ID: <80b90b90-5f3c-47eb-9891-561249ac5f0e@altera.com>
Date: Fri, 27 Nov 2026 16:16:04 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/2] Add FCS Random Number Generator (RNG) driver
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Dinh Nguyen <dinguyen@kernel.org>, linux-kernel@vger.kernel.org,
 Olivia Mackall <olivia@selenic.com>, Eric Biggers <ebiggers@kernel.org>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Wolfram Sang <wsa+renesas@sang-engineering.com>, Frank Li
 <Frank.Li@nxp.com>, Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>,
 linux-crypto@vger.kernel.org, muhammad.nazim.amirul.nazle.asmade@altera.com,
 tze.yee.ng@altera.com, chee.nouk.phoon@altera.com,
 genevieve.chan@altera.com, adrian.ho.yin.ng@altera.com
References: <cover.1795167624.git.hang.suan.wang@altera.com>
 <awkLTH9XLvWLBjdJ@gondor.apana.org.au>
Content-Language: en-US
From: "Wang, Hang Suan" <hang.suan.wang@altera.com>
In-Reply-To: <awkLTH9XLvWLBjdJ@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
X-ClientProxiedBy: SJ0PR05CA0207.namprd05.prod.outlook.com
 (2603:10b6:a03:330::32) To DS3PR03MB097838.namprd03.prod.outlook.com
 (2603:10b6:8:546::7)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR03MB097838:EE_|CH9PR03MB998594:EE_
X-MS-Office365-Filtering-Correlation-Id: 91019fa5-f376-46a3-bdbd-08df4c5eb249
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|10067099003|56012099006|260925022911599003|260925021911599003|260925021311599003|261026121527099003|261026130827099003|261026135527099003|261026140227099003|261028144727099003|261022115727099003|261022113327099003|261022105027099003|261022075727099003|261021130227099003|261021135927099003|261021133027099003|261021123027099003|261021121427099003|261102123227099003|261009223027099003|22082099003|55112099003|18002099003|11063799006|4143699003|6133799003|4133799003;
X-Microsoft-Antispam-Message-Info:
	xrvfJ9lVvg6BqTS7yIdR5FiegNsxMrGot3zwMbX3Lw6rkUnI29xEEIAPn+xTsNpwaU1UZM3BDbf1oowCqi6PiJsL/i7TD9JahrnXtr8iKBcJ7rQ7yexMEJ/IN3HXVOh9w1AaQ9YRgAhAVdPv5QXuuvJ9MU/K7chTvIy1IC1xg/6aZVIkLzwfldHoBwxzp8qGh1sYVjAoZbANomtD2A7ZSqAfDsu4slJgroxM/vfQ27yj7Tp27e+a9PtJA2UnGdXUEEe261i//X/M6i7GfB/PSDBDGXk7Xue3I+66BxSG68NQYDuFvcL1Eg8oKQRIRKLKxEUz8BhLUChYIrlU+5mBHgrN7lQTgEsNBw1cqi+ci5jJvA2OYpcQRuanEprslm3HkAuogd5YOgd20SJNMqnanb0jKKrd9yizSn2fHJaHjddYAP7wYCMxKbE2F8XbNwVQriytAbSDGnJ8IWQSmtLeOoiZ4Wsyy9gdMa/pc7szRq4vGS+9Ct+LPPcEIN3ouaWNsGFDrg9PLvohCkuYX7d61RVVBQO+dGkGPUakyjwbl/z35Zu48ttalDLSDVoTsDTdAhhCI9p9F6/2Vsq3RaITHbKwtO7YFnNgp22bEd2IPsc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR03MB097838.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(10067099003)(56012099006)(260925022911599003)(260925021911599003)(260925021311599003)(261026121527099003)(261026130827099003)(261026135527099003)(261026140227099003)(261028144727099003)(261022115727099003)(261022113327099003)(261022105027099003)(261022075727099003)(261021130227099003)(261021135927099003)(261021133027099003)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003)(22082099003)(55112099003)(18002099003)(11063799006)(4143699003)(6133799003)(4133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d3RENlhWRHRpNUdhTWFFNlNMZ1NHOGhwcUNvMVgxakNlanRPTFp4c08yUy9J?=
 =?utf-8?B?YkZQc3hLcWNIM0pNTDFZK0pyaWM4R1NrNVhZK04zcm5OcGRBb25lQVl1emZN?=
 =?utf-8?B?SENGSWNSeURlUHpEK3VxVE9OQlVlSlVmVkFUdUx5bDgrdElmZ3UrSStWd2RM?=
 =?utf-8?B?dVZWWTF2eUg4K1RTd05QbTlLOEZqczJGeHFXTnJkTGh6SFVERmNHa3dDemQx?=
 =?utf-8?B?ZlIvclVKcFhyZjR2dEx3SVZWbytoUU1UQlRIK2FnOElvMzFiOGNFUDR3REV2?=
 =?utf-8?B?ZnZ4UExOQk9nNWVJMlVwaHE4RVlNQkNxYThQWmM4Z2xuYWh3NXRWSUVkdWEz?=
 =?utf-8?B?NldYUjBoRmdMTUhxOTkrOXFSK3RNQ25McWkzUW5uMnJsdlBBcXN4enZIcWEx?=
 =?utf-8?B?SE9CUUdlejVMSnpwNnVNaEhsR05kZWUvdmxzcWFxejlaRTdTV25jbDFYcVBk?=
 =?utf-8?B?QldWbTZLdmZXZ3RkN09kUHJaSzVnYVpDNUM4UzBiN0k4TUl3YkV0QVRVL2JV?=
 =?utf-8?B?RzVramxnQTMzVkFEalpmZEo0d0RXY3VTSTBPQnB1aTBHK2J1bVJoQkhkMStE?=
 =?utf-8?B?bVU2ckJlUjZCcGllRDFMWGxxYm9odDFIalR3M0dwSTZYMXZKZURNSmxQK0hP?=
 =?utf-8?B?cFRQTUg2bVZkS3NqTWpyTkM3SnlCaldBZnptbWdUazJtaUxBS1JKUmRkemRK?=
 =?utf-8?B?a0Z3V0JHQS9aUTRkNFptUVc0YzZRWFFiaW9tNzdDSmhGYTNKZWpKa25tVC9W?=
 =?utf-8?B?bjcyMThPdEd5d0gxZm1GOEtaeEZTaDU1MFlzWERrOElIMkw1c0dDVTVQT0VJ?=
 =?utf-8?B?OEZvSWpiT01xQXpJbUNCQ096ekFZejBiSDVWWm8zdG5qK2VPalhVR3FBa0xn?=
 =?utf-8?B?aWZId2xmVkpmTUNabExUcTVDeGRkZjBOZjdkb2ticDZyUjBVeGlQVVI5RmNy?=
 =?utf-8?B?SXZuWWNnYkhxVXRZTGNrems2UjBaZ3JpbDZYU1Y3YjFmMWpIakhMdjJpTHg1?=
 =?utf-8?B?Vyt1YnlEV052MXZCamJ2N1V2c2Rjb0RyVENvazdCd3FqOVdlYVFkb05VTUVD?=
 =?utf-8?B?ZkFiRDN0OUNmM3psVEFwR3dkV0dVb09KS3Z1Vm82VWlmMVlPU1RqdE9pWEha?=
 =?utf-8?B?L3F2eUJCSTdtRlBPalpjcU1UOWxOREN3b2Nybmp2RUlpK1o5ZFRjL3dZTFFM?=
 =?utf-8?B?emxUTjJHK1FTdWJ0REFTbjE1Sy9nV3JqenRlanp3MnlERzEvNFF4Ry9yMVBF?=
 =?utf-8?B?SHBQUUlNY0haWkNxbEtyaVFyTEJxcUlHekIvLy9STWczLzNQLzhOcG5Ydm5v?=
 =?utf-8?B?R0tGaml0YzRZRFpOaHM3VXdVd3dvVHVyNmgyWWVoSGFJL2ZBajhJM0k3Ykw4?=
 =?utf-8?B?emI3R0Fua09nbXUwVnd0dmVCcVZaTXk3M3JaV0hTRDFaNnNJKzdIYXFrR0g5?=
 =?utf-8?B?dGcrTURjL1J2S3ZLazZGSDlsVXlSVmNEbXExK05LT244Y3V4Z1k2YXMrUm1a?=
 =?utf-8?B?Z2d4QUx5Kzg1QXpjWU5RSUtVaWFyQTJhVFJUdk5ldFUzT1JDeFhoRWlMZjBu?=
 =?utf-8?B?Vi8rc3MxWDNsSG5ERXVaZlI1MCtQTjN2emcrYzB0R3J4TFVML1pWeXc0NmtH?=
 =?utf-8?B?SVlzWjkzV0h0aFZZS3dIYXFHYlZLWGc0amRuSUxxaHNDTFJib2xmWjBVU25Z?=
 =?utf-8?B?bnRhckVsWGk5amlNNC9xa0FuTE10anhidW5scTdUQVNWMzBteVdYejFhK0pk?=
 =?utf-8?B?akRzTWtxQytpdXg3NHlLQ1YyMjdzVUczVWQycDFKOWVNM3FidVpyNDhFbExS?=
 =?utf-8?B?OTBBYzlNNVk2M0Y3TmtRWVBveVQvZE91dStPRzRuUEowZEM2Z2hGbVJ4bDBr?=
 =?utf-8?B?YjYvdGZJVE0rMytOdU4xMGdTaXlJTm54cjYzZHFIby83Yi92SE13VDVURmQ5?=
 =?utf-8?B?NXorNmxRcFpaRTJ3TCtNdXN0TUVXZ2QxSkc5SE5IbGM3cmpsaVZnVEhBd25v?=
 =?utf-8?B?N1NXdmlvY0ozWktvc2g1d2daOVFMeXF0WEExenNnWEpxS0hKWmhkbnYzYzFQ?=
 =?utf-8?B?S3pkdnBPdlZEOU5Qc1RxckVDUEJtMEkwdWdIYjBNaUNtVFJnV0VrQ0ozejBy?=
 =?utf-8?B?NG40cVpPdDZzbm9rMVd5WUh2YXRtWUZnd29rQ2tGQzlENDFmL2JXVFlscmRC?=
 =?utf-8?B?OVVlZmdtREdoV1NobndFV1MwekMydXBCaXgvbmtDSGpQZUtUR0o5aG9raWRN?=
 =?utf-8?B?b0FnUTFyUy9mZUhyTkZKMm5IYzl1bUxLTnFlS3djbGRNNE9zZU04eldNamN6?=
 =?utf-8?B?RWpqMW5oZi9LbUVURFBSRml5U014N0c1Z1IzQ05WNER6V0plbHJZdz09?=
X-OriginatorOrg: altera.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91019fa5-f376-46a3-bdbd-08df4c5eb249
X-MS-Exchange-CrossTenant-AuthSource: DS3PR03MB097838.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 08:16:11.2435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fbd72e03-d4a5-4110-adce-614d51f2077a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: THTUOWqHaolOWOKM7HzvoQ/Ds4JcHu/BtwWXlCwCZaNnmlg3DGutDCzr5S7ws76oF9DXy7RPMYCuRCdMg2dxXeMJDMJ8uDIzUHp6KZgb0HQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH9PR03MB998594



On 27-Nov-26 12:47 PM, Herbert Xu wrote:
> On Fri, Nov 20, 2026 at 01:51:31AM -0800, hang.suan.wang@altera.com wrote:
>> From: Hang Suan Wang <hang.suan.wang@altera.com>
>>
>> This series adds a hw_random front-end for the random-number service of
>> the Altera SoCFPGA Crypto Service (FCS).
>>
>> The driver owns no session or service-layer state: every request goes
>> through the FCS core, which serializes access to the SDM crypto session
>> and forwards it to the SDM through ATF.
>>
>> The SDM is the hardware security controller in Altera SoCFPGA devices. Host
>> software reaches it through the existing stratix10-svc mailbox, which uses
>> Arm Trusted Firmware SIP SMC calls.
>>
>> The Agilex FPGA series generator is an SP 800-90A compliant DRNG hardware
>> block in the SDM, in particular, Agilex 7 is SP 800-90A compliant DRBG
>> generation flow and is seeded with the TRNG hardware block.
>>
>> Unlike existing hw_random drivers, this RNG produces data only while an
>> SDM crypto session is open (for example, via FCS_IOC_OPEN_SESSION on
>> /dev/socfpga-fcs). The session belongs to the file that opened it, not
>> to this driver. With no session open, socfpga_fcs_core_engine() returns
>> -ENOTCONN and the error is passed through unchanged: read() on
>> /dev/hwrng fails with that error, and the hw_random entropy thread treats
>> it as a transient failure and retries. The open and close session ioctl
>> was added in the previous series:
>> https://lore.kernel.org/all/179492434088.3111216.6016447945055810112.b4-ty@kernel.org/
>>
>> The ATF accepts only a non-zero, 4-byte-aligned length, from 4 bytes up
>> to 4080 bytes per request.
>>
>> hwrng.quality is left at 0. The hw_random core documents 0 as the maximum
>> (1024 bits of entropy per 1024 bits of input), and with the default
>> quality of 1024 that is the value applied at registration. That matches
>> a conditioned SP 800-90A DRNG, so the driver does not publish a separate
>> estimate.
>>
>> The series is organized as follows:
>> Patch 1 (prerequisite) extends the stratix10-svc service layer with the
>> FCS command codes and matching SIP SMC function IDs.
>>
>> Patch 2 adds the RNG driver: socfpga-fcs-rng hw_random driver. Add
>> FCS_DEV_RANDOM_NUMBER_GEN_EXT in the FCS core. The socfpga-fcs-rng child
>> device registered by the FCS driver. Also, add MAINTAINERS entry for
>> this new driver.
>>
>> Testing:
>> Built for arm64 (defconfig + CONFIG_HW_RANDOM_SOCFPGA_FCS=m).
>> Tested on an Agilex 5 SoC FPGA board
>> root@testsocfpga# ./fcs_client -R dbg.bin -j 64 && hexdump -C dbg.bin
>> 00000000 15 fc 77 a9 86 17 0b b5 91 b3 db ce a9 39 48 f1 |..w..........9H.|
>> 00000010 65 00 80 9a 63 b8 1e 99 df 56 6f b4 ef 66 73 f9 |e...c....Vo..fs.|
>> 00000020 91 66 c6 94 94 38 f1 9f cd 3a c7 6e b1 63 1d e2 |.f...8...:.n.c..|
>> 00000030 03 ec 29 01 4f 27 4a de e7 7e 67 95 c2 44 e7 04 |..).O'J..~g..D..|
>> 00000040
>>
>> Set timeout to 1000s for operation: rngtest
>> cat /dev/hwrng | rngtest -c 2000 2>&1
>> rngtest 6.17
>> Copyright (c) 2004 by Henrique de Moraes Holschuh
>> This is free software; see the source for copying conditions. There is NO 
>> warranty;
>> not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
>>
>> 	rngtest: starting FIPS tests...
>> 	rngtest: bits received from input: 40000032
>> 	rngtest: FIPS 140-2 successes: 1998
>> 	rngtest: FIPS 140-2 failures: 2
>> 	rngtest: FIPS 140-2(2001-10-10) Monobit: 0
>> 	rngtest: FIPS 140-2(2001-10-10) Poker: 0
>> 	rngtest: FIPS 140-2(2001-10-10) Runs: 1
>> 	rngtest: FIPS 140-2(2001-10-10) Long run: 1
>> 	rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
>> 	rngtest: input channel speed: (min=495.429; avg=52178.721; 
>> 								   max=10000000000.000)bits/s
>> 	rngtest: FIPS tests speed: (min=47.329; avg=70.926; max=91.699)Mibits/s
>> 	rngtest: Program run time: 807497698 microseconds
>>
>> ---
>> Hang Suan Wang (2):
>>   firmware: stratix10-svc: add FCS random-number command for Agilex 5
>>   hwrng: socfpga-fcs - Add FCS random number generator driver
>>
>>  MAINTAINERS                                   |   1 +
>>  drivers/char/hw_random/Kconfig                |  12 ++
>>  drivers/char/hw_random/Makefile               |   1 +
>>  drivers/char/hw_random/socfpga-fcs-rng.c      | 133 ++++++++++++++++++
>>  drivers/firmware/socfpga-fcs-core.c           |  71 +++++++---
>>  drivers/firmware/socfpga-fcs.c                |  33 +++++
>>  drivers/firmware/stratix10-svc.c              |   8 ++
>>  include/linux/firmware/intel/socfpga-fcs.h    |  23 ++-
>>  include/linux/firmware/intel/stratix10-smc.h  |  46 ++++++
>>  .../firmware/intel/stratix10-svc-client.h     |   1 +
>>  10 files changed, 300 insertions(+), 29 deletions(-)
>>  create mode 100644 drivers/char/hw_random/socfpga-fcs-rng.c
>>
>> -- 
>> 2.43.7
> 
> Sashiko failed to apply your patches.  Please rebase and resubmit;
> 
> https://sashiko.dev/#/patchset/cover.1795167624.git.hang.suan.wang%40altera.com
> 
> Thanks,

Sure, will rebase and resubmit as v2
thanks.

