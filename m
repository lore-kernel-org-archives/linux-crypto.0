Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.72.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794471348;
	b=COwuLOPWDLqfxl6UHsOPsnbB7RtFqAApXbAPkP3cevVDOAixECFq4LKZXhrqR86V+i+R
	 sKu47bzBN020gRLAgp97Ne3DRvAqW6nA/8MhQFo2y36QpFZqHBisHVvCwJf7ppk/6x1xI
	 +Z6xauVg+hMYVomq+0GVOfsH6GS6ME7m+bwhSdXXTZ3ZCivUVWjZH2h4YPKbbrxGDn4S/
	 pLiU5EowIcn4Ut/NoZGfqs4LYCnpS4WDW0oYC2HVf9xeaPjlEkVrr8DAwmaLCN++9ikAk
	 0MNRQimn9tkR8ibO8ZKwsBmsGlGzB9brDK8KTaObf1f0UKJwJCy9YLyIOB2yveMbamw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794471348;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
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
	bh=1YFU5XNWNogDUuxf0PY9v/rdas8KaYSbW/cc7CWICVY=;
	b=Jskf05TyeHcYK/35PkMd17nQjCnt+viwdOAHfX7MYakCqr0+b2Npj8XvRQezwB2y2fRz
	 6RCQPFgxl7y41Xc5HOEULuNouqVbevSM429vlWYw3TsAJn7TL9W75W0NTRqHJAGT06yW/
	 C+0a+OF2LSllyzleEh4DQOaCpRCo2fU/MHtf/MyJGkyNS7dBJh98NhJiF8mZ2Ru2QsHvU
	 nQH2UhJhWkc53H4cXul3GV9JHK16bkl4UrSdbYgfPGQdYJmMch3RyvjTmzBPI6Hk92YK3
	 ic3aLJafieA0R1WmivJUIn4JonylWakMl5RLgvRNwuIg7JdgLeReRHIJ4fh58IB1m2Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=k7pU4Clb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.72.47
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013047.outbound.protection.outlook.com [52.101.72.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356AD606A327;
	Thu, 12 Nov 2026 08:15:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 356AD606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=k7pU4Clb
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LXWlKTugUjif0HpTakMN2gz48T/LneVl4B9JpvfbXgSaAeHgPiQPcc+f7vPFkqbI7JUuk2dF+EURO1EVjUd52ZOIPokfJ/E7Yi6ujNzdd6FMDAw3uM7PftgdTJeJTgg+KCOYl16atZfg++CiZZVY2JtOGQvCPVyP3Up3mWetVnXESlTw4R2Y9Dx8xF8NL2jRUAo6SiznEVwWUzXZ3FS3canPd1eFEzBPImyJLOt2yqrYqxrzHD3IGCxdl1zaz0nt6ox4naJS8KFULF3IOYL83pdjWnQrxPrHu/tMdvRMmmkfl2o3lPcZtJw05tP7HU2PU84myNvvTvJv3ijNSxKeVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1YFU5XNWNogDUuxf0PY9v/rdas8KaYSbW/cc7CWICVY=;
 b=vcdlSW9StsYVu8/Uodd/k4HpcbGWbOv7B2H/HkC8Up/cIw6qUFGxeoKWd+PFQdxCk8KPbTgjYAqYXaZDh9j15feZ6+Aoy/bPsn7zBo1gw0+XphNoAbv7L8A0+emdccWor4VaSsFHWLng87L9lBDUOz6XlqiaCx0ego8cNXG7YGRoyNL9FKGdlMo/GJG/HzF6q9Wj6YH42M62Sk1Gn3w0bm8+xKBwhNNwmBdqleon9mbUemp87Y5VzpsxNIkQWQCU18oEV9p55jhMAHbi/1ziWS8r0dUis81OE9ZKCfAGJUwXyCKY2iMQ4+/DPlgvOOqPLao7d6SqU5NofQs03LbFrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1YFU5XNWNogDUuxf0PY9v/rdas8KaYSbW/cc7CWICVY=;
 b=k7pU4Clb/J9ifrCKoD5EQRyzTHS7iGHKoWQZ0qAga5aa4n1syOA7KIcj9xPYArF4DHHilnEJ7iDr/KDTic582AyS0soFONtXqdzaAaSNUW2iCpX/p7o1b9EV9n0TCutLyHnRaCqDuoS6bEXBBb5VIWv+TL+wRZ4hGLkFKwB4sp4mQOrMbVTPIr3jLRXp3NJpxhJTT9hSE23svE+bEflfaA4k5pVG6Do03Ac7Rooy0hbty5XuszVMyQvYFZh+Dj+YmPj+C8M1xh7x2IDmZLWJ2sTLQyJHRG0rDMkF+iu31/YBFEHrlZzirN+a+BFEHe256HwJv45wGJV8fsRwS1xVuA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AS1PR04MB9358.eurprd04.prod.outlook.com (2603:10a6:20b:4dc::19)
 by AM0PR04MB6786.eurprd04.prod.outlook.com (2603:10a6:208:184::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Thu, 12 Nov
 2026 08:15:45 +0000
Received: from AS1PR04MB9358.eurprd04.prod.outlook.com
 ([fe80::677:d5bf:c3ce:3ad4]) by AS1PR04MB9358.eurprd04.prod.outlook.com
 ([fe80::677:d5bf:c3ce:3ad4%5]) with mapi id 15.21.0615.009; Thu, 12 Nov 2026
 08:15:45 +0000
From: Sahil Malhotra <sahil.malhotra@oss.nxp.com>
To: Jeff Barnes <jeffbarnes@linux.microsoft.com>
Cc: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	changwei.zou@canonical.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] crypto: caam - fix in-place RSA payload DMA mapping
Date: Thu, 12 Nov 2026 09:15:43 +0100
Message-ID: <20261112081543.503706-1-sahil.malhotra@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261020192511.3389133-2-jeffbarnes@linux.microsoft.com>
References: <20261020192511.3389133-1-jeffbarnes@linux.microsoft.com> <20261020192511.3389133-2-jeffbarnes@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0242.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f5::20) To AS1PR04MB9358.eurprd04.prod.outlook.com
 (2603:10a6:20b:4dc::19)
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
X-MS-TrafficTypeDiagnostic: AS1PR04MB9358:EE_|AM0PR04MB6786:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cc0a310-64fa-47ce-4c03-08df40952685
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|19092799006|1800799024|366016|22082099003|18002099003|6133799003|11063799006|4143699003|261009223027099003|261026121527099003|261028144727099003|261021123027099003|261021121427099003|261022075727099003|10067099003|261102123227099003|261022113327099003|56012099006|261022105027099003|261021135927099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	khNSiaLrhMATBKE+iYwg/QnEzH5AFNI60uXyhu3axhkGno59oZ5LIXlrAyPtzeUjlZnbC1H4varVyo2fIjSuXvdXQZ7dDEwSEgbOasJSwtlX+NmvkVWvdRvtugCU58csQYsc5vbJ+aIsTXdrPpy/07X7afNdQIwoED+CE+3ZfepmM8qU6MBEfY48A3OvUzTzPNdlNgX19+IdD79eybVexsropVaABEUlmaINDpCaZvgH5pdm6nKmx1AqocZExg9gzVqcIXQfuLpUpBlryCQw6ADwJqKQyV+zH1EFCnOLa45FWFKsdG4eofCTTSvDk046CXfPjLSTbnb/3cKLMUsl1lsg9dNCRUNCOt57OUTyCKWyg767SnuavQe2CzcSdIoa8+0e9VjuJE6cKOATBA/AGNIYHtEacyo0V0/gtvUqYUkQTMklWcIaw0lVDyCPEY80Uan9vXudleqVwWIXt1NyTJ5GTXoQYTzwemYoKogzuLhaggarsWN0A2g3OQ0ONjPKpDse4LeSFBbq6sGK24Q9AzU6QoNiUpmRU7vBi1Sgz1688BNCpkQqkU0cYNb4/1c9ttx2QUAoGUtZUu5yLcc08kxhBbTbPs/809WWsDfAO8rpBV6aKIdXWAoqXktCiJcf
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS1PR04MB9358.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(19092799006)(1800799024)(366016)(22082099003)(18002099003)(6133799003)(11063799006)(4143699003)(261009223027099003)(261026121527099003)(261028144727099003)(261021123027099003)(261021121427099003)(261022075727099003)(10067099003)(261102123227099003)(261022113327099003)(56012099006)(261022105027099003)(261021135927099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ODZ3UTNQSm1PWjdlMzB0VWh5aWZtUG5hekZRZGRoQzR0VlNCTmdGcmdqWmkx?=
 =?utf-8?B?QXFqMjJsamRYMTB3WlNqOVY3enhhQkkwY1g2NFpsb3NLc01KVUZLVWE5YXdR?=
 =?utf-8?B?dGRRaUd3SjN1aFRFVUR6NnRzOTN0UTNVN3ZZbXRhVVFDTVUzZE5MMitFaHZh?=
 =?utf-8?B?bC9OeWZYWHFPb2VoQzFHaU0xcFp3dHg1WHY0eDBiZ3pmR2pRTUg5SHN3d2ph?=
 =?utf-8?B?VThyZFB0MXFKa2RoU2wxa1I2NlVlaFV4Z2xveFppaC81UUZ5c1hSSThCN1NM?=
 =?utf-8?B?M1BJcjI5djFldVBHOWdnVlIwK08yTTd6VHBlOHBzeUM1N0xQa0tPSVpsTmFm?=
 =?utf-8?B?dTRTQkRGK2JGOUdtSjhzNDRWNGxzc0VTYUVuTGJCMWZ3OXg2TVJveFpLTDJH?=
 =?utf-8?B?dFNHOVFkK1lLSGhSaG5MbFBHUkVHS3hrR1RQeUljaWdicFNnT2NRWEd6T1cr?=
 =?utf-8?B?WlB6dUVQUjEyVjRsSlJtNExDTmtZSUMwT3pFZVlkbzJTbFJUZ3QwNDl1SkJ1?=
 =?utf-8?B?ZEVFUDFDUmVaWW51cDl5eWgxY2VVU1JnSDJjczE3RUlVSmR1dDdhR2J2bENw?=
 =?utf-8?B?cTR3c0dnQ0tCZGwycm9CSjY5aFM3TVpMTzc4OWdnQk9XSUdGTzh1Um5XV3RJ?=
 =?utf-8?B?dkpxOGlpbVV1MjZtR2wzVm9PQmNueXBVTUZ6OWx3UUgxMG03cFFDeDRzbU1S?=
 =?utf-8?B?dDQvM1UzSE5FSFAzeEkyN1Zxc2RUTTBxTHp6RU5BYkM4cDh6V2dOMktLaXJ5?=
 =?utf-8?B?bHZYZFdnNjBkU1ZyMkV0ai9oQXJrT1E4cVBGelU3VlZrREhaNUFMSXRqaGVa?=
 =?utf-8?B?bnBwTnh5MjRzaEY2eHYyR2pRUFl5U2R1S29naHBpeU1CK1RYU0wyR2RzdHdu?=
 =?utf-8?B?cDZkd2c0Ty9MUFJacHd4UXNDdnpycUdmd00xL0xLdnhnVUh0RzR3L01Zdk5Y?=
 =?utf-8?B?eGcwUG8yRFpVSWdDNE1TMlBWMFdNV2lZeUJYbER1UEhFYjZwdUkxeUdGUFVj?=
 =?utf-8?B?aVE0d3M1SzdoNXZaZWxnY0MyM252cVpkL3IxRGtUOUpXS1NVZklmNE9HTnhi?=
 =?utf-8?B?R28wYWU5UmVnS3QxaTlYcE1WcGM4amZjYUdtbkdxNG9NcnZhcnRhR2VMejg3?=
 =?utf-8?B?U3pDVUVxVFF6RzlJbWk0Ly9naWtMdmVUa0xPcXhWc3lOam5TSmRKMUNkSE5Y?=
 =?utf-8?B?dE0xWEJOd2kweXBYZGEvejBpTUkwTThxRll3N0VCc3cvcVlDOGhIdHNtRVFs?=
 =?utf-8?B?bURnNHlSbWY4U1YyZnZRRDN4TWFld2ZHZ2hyZWNFTThXd0FLZ0c4RW0rcVln?=
 =?utf-8?B?QjhBRldJcFFuRG90UzVjSWRITTI1ZmRmZkpNTHpFdWEwRitVSFk2ZzFWR1pC?=
 =?utf-8?B?UFNFYVV0c3RFSUFOZVB3SDNtYWhrVGh3eU5Ccndlcml2NDZXaE5hS2ZaMXRj?=
 =?utf-8?B?L0JzSWc2Yll2L09VUE9WWThjQjFOemNMSlRkOWc3N0ZYVGZTZWFUK2lzRXVr?=
 =?utf-8?B?TWcvcUpCcDl2NzdiZWludGJTNldaRmJhNTYyV013Vks3bHBqRTBQZnkvL3JD?=
 =?utf-8?B?aGI1SkJ6S01iT0E4T3JNRVl4WVlWdUV5Ylczai95YU9Ici9YVTFJVkE5MmE2?=
 =?utf-8?B?YWFnQVRWMStFMm9kTHVKcjVoSFlqVk5BY1A4bnZHenVkZmNLazhETXpuK3ND?=
 =?utf-8?B?dEZsMWc5Z1VIVys5dXZpSlMxVDVIV2VtKzF0aUZzYUcva0lmVmI3ZFJZSXc1?=
 =?utf-8?B?QjlaYUp2U0FHTGo4OFBvcnVXc05YQThKWld3WElUcFFmVUdQVG1GVTRtNm0r?=
 =?utf-8?B?bzBBK0ppMFc4MEU0R3lDZXdNcG9DUHNrbnhqMUgwL2dzTDFKamtTRDMvOXlp?=
 =?utf-8?B?bnRyUExGSnVrekllNGJEVTBDVE53VlhScWxpVVpvR3ZEV2xNZTBYTGJGMlY2?=
 =?utf-8?B?WEZ1RGgwZmJRaEozcVBKZnBDa2d6SnI2WUpkd3dYeVZ4UURVT080dEkvb2pn?=
 =?utf-8?B?N1dJaFkxMTl4dDFUNk96SDJqSGZQclA2VnNJbEovbFplVTdiM2E4NkhhZlFu?=
 =?utf-8?B?L2YxNFpNZ2UvUEIyZ1BhKzR2dHlaQlBlRmZCc0Z4U0txSlFscXppOENvc0U0?=
 =?utf-8?B?NE5TRkxuaG1vc083VHhVN1pya0JoQUV1cUFZTXExZnNwakduN1FBY2I0S2RL?=
 =?utf-8?B?SDFUUVhxM2hRRjQyRTRkbGk2RnV6M2Ywakh6d0c0d01LeXdQSVpSNlNwN0pw?=
 =?utf-8?B?b0xXeVphV2VrNG5xTWpvRTN0dWEzRkFjVE5mTHE2cEF2RlVqRExoQ2xpZkUr?=
 =?utf-8?B?KzExS3BZeUpyemVzR0JNU1RaY0lmdnJrd3ZrSFBmT2cwQzFVQnFtbmNpajlC?=
 =?utf-8?Q?HVicJ2bBDCV6J2gx5BiVkWRDH35z4HwK2PwbY?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cc0a310-64fa-47ce-4c03-08df40952685
X-MS-Exchange-CrossTenant-AuthSource: AS1PR04MB9358.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 08:15:45.2844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Skc4oMqDqqrnfgjfcGf+ykyndL7AS8uWUiaId5iT+FF/ll5/4qaE+TA1AI0uP+CnjYoWPJX7+bXdTR3oyFRH68uyG9ndLXF+3SZrZ1D4cV6Kjy1a0yXASCD95qHgwhh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6786

On Tue, Oct 20, 2026 at 03:25:11PM -0400, Jeff Barnes wrote:
> CAAM can receive RSA requests whose effective source and destination
> scatterlists are identical. The driver currently maps the source with
> DMA_TO_DEVICE and then maps the destination with DMA_FROM_DEVICE.

Hi Jeff,

Thanks for the analysis, and sorry for the slow response.

To answer your first question: yes. When the effective source and
destination are the same scatterlist, I think a single DMA_BIDIRECTIONAL
mapping is the right model. The in-tree user that hits this is
rsassa-pkcs1 verify (crypto/rsassa-pkcs1.c), which calls
akcipher_request_set_crypt(child_req, &sg, &sg, slen, slen) with
slen == key size. That gives an exact, single-entry alias, which matches
the pkcs1(rsa-caam,sha256) failure you saw.

I have a few comments below.

[...]

> +	if (req_ctx->fixup_src == req->dst) {

This only detects the case where the two head pointers are equal. When
req->src_len > n_sz and leading zeros are stripped, fixup_src is the
result of scatterwalk_ffwd(). That is either req_ctx->src[] or a later
entry of req->src, so the comparison fails even when req->src == req->dst.
The same memory then still gets one TO_DEVICE and one FROM_DEVICE
mapping, through different struct scatterlist. The sg metadata is no
longer overwritten, but we still have two overlapping streaming mappings
with opposite directions, and CONFIG_DMA_API_DEBUG should complain about
that.

Could you either check req->src == req->dst (before the leading zeros are
stripped), or at least state in the commit message that only an exact
head alias is handled?

> +		shared_nents = sg_nents_for_len(req_ctx->fixup_src,
> +						max(req_ctx->fixup_src_len,
> +						    req->dst_len));

[...]

> +		if (mapped_src_nents > 1) {
> +			/*
> +			 * Multi-segment aliases need separately bounded source
> +			 * and destination hardware views. The current SEC4/PDB
> +			 * layout cannot represent all such requests; defer support.
> +			 */
> +			dma_unmap_sg(dev, req_ctx->fixup_src, shared_nents,
> +				     DMA_BIDIRECTIONAL);
> +			dev_err(dev, "Multi-segment shared S/G is not supported\n");
> +			return ERR_PTR(-EOPNOTSUPP);
> +		}

I'm concerned this is a regression on systems where CAAM is not behind an
IOMMU, e.g. most i.MX8M parts, which use plain dma-direct. There both
dma_map_sg() calls return the same addresses, so as far as I can tell
in-place multi-entry requests work today. With this patch they would fail
with -EOPNOTSUPP, and the driver has no software fallback. The dev_err()
would also fire on every such request, and since a user can trigger
these requests, it should at least be rate-limited.

On your second question, I would prefer giving the request a separate
destination over growing separate source/destination SEC4 views. For the
multi-segment alias case: map the source DMA_TO_DEVICE, map a
driver-owned buffer DMA_FROM_DEVICE, and copy the result back on
completion. That keeps the SEC4/PDB layout unchanged.

Changwei's v4 2/2 ("Use bounce buffer for unaligned RSA destination
buffers") already adds most of this infrastructure:

  https://lore.kernel.org/linux-crypto/20261111230221.40297-3-changwei.zou@canonical.com/

so the alias case could simply be one more trigger for the bounce path.

On that point, the two patches rewrite the same block in
rsa_edesc_alloc() and will conflict. On top of Changwei's patch, the new
early "return ERR_PTR(...)" exits here (the sg_nents_for_len() < 0
checks, the shared map failure, and -EOPNOTSUPP) would leak
req_ctx->bounce_buf. They would need to go through his bounce_fail label.
Also, the sg_nents_for_len() checks have to run before his
for_each_sg(req->dst, sg, dst_nents, i) loop. Could the two of you agree
on an order, so that whichever lands second is rebased with this in mind?

> +	if (unlikely(src_nents < 0)) {
> +		dev_err(dev, "Insufficient bytes (%u) in src S/G\n",
> +			req_ctx->fixup_src_len);
> +		return ERR_PTR(src_nents);
> +	}

These checks are a good fix on their own: today a negative count goes
straight into dma_map_sg(). Could you split them into a separate patch?
That makes them easier to backport.

[...]

>  dst_fail:
> +	if (shared_nents) {
> +		dma_unmap_sg(dev, req_ctx->fixup_src, shared_nents,
> +			     DMA_BIDIRECTIONAL);
> +		return ERR_PTR(-ENOMEM);
> +	}

Looks fine. The map/unmap counts and directions match on every path.

A couple of process points for the non-RFC version:

- The double mapping goes back to when RSA support was added, so please
  add:

    Fixes: 8c419778ab57 ("crypto: caam - add support for RSA algorithm")
    Cc: stable@vger.kernel.org

I can test the respin on i.MX8M (dma-direct, non-coherent) with
CONFIG_DMA_API_DEBUG=y.

Thanks,
Sahil
