Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.66.13
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794480117;
	b=vUN4Hz4sJdVnvJ1o/HyyMfbOUCMUJ0+wjaPV/Tp58QYvsV71193cjRCb+73fqoFRz+BQ
	 zIG0vimBcJcSdR8CWjeyxGaEAXC0XNgxIYbwHAdKOJ3HkxCj5Y6qEiMb6wcoz1esf2IBK
	 Sc8EMmWRo8HqHK5ZNe2KOkjUU5dOZFwkRCDqIGKXS7EJn370oY9jYnUHI7WVaC53nhpKN
	 P585jtqwt3hqZTvOrkQ+Jpr0nSlolAsm3r4EaP/SYfxQLSBZsdp3cj4UmOnLx4VYdMPac
	 N5vrpEhLvAzAko0Iix1h3rAeSTew1sd8HMuYUBepEQJClLtJ6QxWUzKc0y+M1vu6xsQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794480117;
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
	bh=2Mrgnsv8CDWNAWBrXKr7svRdRpjOfnz5b/OUT8LBuM0=;
	b=NvNLsh2h5dcugx5CfYTjyhbSZgWBbyWlJMhnfR5YTPMt6YzRPqGw39SCPhALUSyweRXF
	 xVKIC7Dc1F2cenQIvgjP2j3NQw5RYni7QBSXuK2AMJbTvj7+5yHfHq1ilXB1fjSc7xaR4
	 4dkFUZEcEoSI0VOQnQI/GBDZPJaxfz/2Zqj7hgXte3dyO7tIjYFX+agPMfsVWegc4DOlt
	 vvRmJcy99N0PbSR9Dv0kutz+pAuY5ia0hOsUrbj2W9dY2edv0hfDNkrpZKsADSlnDEWhQ
	 jLQJIz/dAT3+zyOqP920IBvuhEmJv9v8DSQp5SVLKDN7IuPFgnjHlo2ltTnNZau5gcw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=DIjyDHn9;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.66.13
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012013.outbound.protection.outlook.com [52.101.66.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A1F606A321;
	Thu, 12 Nov 2026 10:41:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12A1F606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=DIjyDHn9
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lYH2oH1H1uELu18DMIOSt0Y7feWVb0AO43XCsTLgLnvqsPgDtBPdmv3eyUqWpwyPIl5I1xpylDs6nSCoA/8aImWtehH6bhS/wG+KN9Rdh0oXPQK0YmBQbcQ9p4Y4ld/446D85Yi/SMIPOIX/JLyk7r40NQucmEpPRLpmb7ipyAkSxhvVKXtRT6XVJUaEkwcRgulIDYUCTmas/FjwXWqG73GBOh8loeI8MpTfgJsOEN/sMb2RCs0XwcFTN5mNDbieOS4aBMvwdXzskGMMSa3RX9w2g0ia4mSfhWeiGl4pGk/WYC6vzPozZKo6QTr5wgpGNAQL7wlvybGeAzVTssGmAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Mrgnsv8CDWNAWBrXKr7svRdRpjOfnz5b/OUT8LBuM0=;
 b=BfuPic2TdHZ9jBIl5ZiIlXzAW8fOOv3glXehRBpkCzmZHuAJCDjZoJsf21aaAFaCnHJ76el7VhvzA/RBRBuE7IjVqcl/1VaWVs/Tmf93GIaTiDpnSMiIQxxtG5/Dd3mnUJEoKaTWCa+Q0Gl1e0OUqisgiwGSttZhhDhypvducCBoldxoRNqW85yiZW2g08coMNKB0+mXRmdiW2Hg5doZYUCQ/bVc2HGPO/zs3jxrGQLEl0tnlACRgHNqhl68Pk3GmtTbWZXZBg2fsaY3XJit1S2TlwipfT93X1ngwafCdOhcReHNKm+MUDw6WM0xsHkgygTHbLiWYum3mjc/e428sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Mrgnsv8CDWNAWBrXKr7svRdRpjOfnz5b/OUT8LBuM0=;
 b=DIjyDHn9RIoo4ynYjJgRh7psDnud1QkcTUOlHxyVR3WDRLHwCQOWME+2helcl8a278qWNe0DldMrT6td47w+6+P0rmFtzmVtYmMZnPwUhAkFASFTfjn8/zXALn1Dz4Y6DO+x/NVetLkQ9bWkP/K77zL8XqEsK8D3Lz5IGpyvmxy1dxBDVBsgtf8Wh4ShKiIPVnpvGhq9ShW0RLLX7I49MBxugj/HjEysFduVxVq1dJVSViztgnJ4bJE7kP2J1Zp3ZTWL7M+Vrj/+Jdfz79QTO5+IUNxOHgLTFs8R/bTJV87/+8uMJhn/yxbr9aV2jfqfpooomv3AcEiHoLLlazqGSA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AS1PR04MB9358.eurprd04.prod.outlook.com (2603:10a6:20b:4dc::19)
 by AM8PR04MB7281.eurprd04.prod.outlook.com (2603:10a6:20b:1d4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Thu, 12 Nov
 2026 10:41:53 +0000
Received: from AS1PR04MB9358.eurprd04.prod.outlook.com
 ([fe80::677:d5bf:c3ce:3ad4]) by AS1PR04MB9358.eurprd04.prod.outlook.com
 ([fe80::677:d5bf:c3ce:3ad4%5]) with mapi id 15.21.0615.009; Thu, 12 Nov 2026
 10:41:53 +0000
From: Sahil Malhotra <sahil.malhotra@oss.nxp.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Fabio Estevam <festevam@nabladev.com>,
	herbert@gondor.apana.org.au,
	horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: caam: jr: Use dedicated shutdown callback
Date: Thu, 12 Nov 2026 11:41:51 +0100
Message-ID: <20261112104151.713649-1-sahil.malhotra@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261028132825.657546-1-festevam@gmail.com>
References: <20261028132825.657546-1-festevam@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P190CA0005.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::17) To AS1PR04MB9358.eurprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: AS1PR04MB9358:EE_|AM8PR04MB7281:EE_
X-MS-Office365-Filtering-Correlation-Id: ce2e9886-841a-4252-ad7c-08df40a990b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|19092799006|10067099003|11063799006|56012099006|261022075727099003|261026121527099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	NDhv2ki0u3H5tSuonTFB55VxzzPRGPQx/y75UmclmY9VcczubBxXjk3lUrekkgOZbOUb1VJxpoUCRFLctgKTunwpcu4J93yDsnKuoQvtU4P8sMCfuLzfctGcxyAgkCQ3LrbotiPGEoDLWbWz/avYtohBVng39jygROD5ac9kHgodCrY3z9Wt5tP/rSMA9XpZduypRr53oP8CTyAgeLmyH34wI3NvZA1n80P7kSy8DwlSnonzqOReRX6XONN61l/jsE7IrXG9GJ/YPDOtaJP+oNIH+H+UeWKhkR2TkxWtd+d1Ka5E6zUoBWkLasjhAJ0q1Xcae79cpyMhr3Eb5hcLH2ly5KV9Jef2HkBkp2nLSccJBxI5uZhFEfZUWJ5pEJ2AV8rxmiFlMYJhZAfZSs52FJ+axwHLgQFomAX3hJZ6zJP6AFnfLkCrS+Eipzk+HuMWJ+BmJFAWI3m/3jCYN9M/wOSSkpkDmuZiZ8B8avQdONAx7MOTvMUYkCvD0M95Bh9E/9per985WpLzysN4VMIDNZejuVOl6f9M6eRp0O4ELxvC93DJQa0V7ivvgJFV7GqLsNWzNNYMs/qooN/i53JZ+dNdLKwZuZEvPGxI26gbpowHZtrhzPyZgra7NA7ysGTtvTPQACgT3H4ncCeW9tV/qC2muuH/BgzHyOMEDRZzY3g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS1PR04MB9358.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(19092799006)(10067099003)(11063799006)(56012099006)(261022075727099003)(261026121527099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ejhWbDV1ZWU0RzV2YzY4NzdHVDkrR2VDYWtmYXZwM0hZSTV4QTh0RlFRK1NY?=
 =?utf-8?B?YUdRL1YrUlY0V0taZWJJd1gvWXhEdGtNazAxOEFZdmxWU1BQQ2s5RnNvSkM2?=
 =?utf-8?B?RVVRLzN6elh4T3k4cTY2bEJsK3ZYREUySjh4MFRBMHU3czdnSGtaUXJWYXJ5?=
 =?utf-8?B?MTBXVW1IUDBmSGRQSjhtQ2QrVWU4M3VKRWR0ckVLcGV2MjdzTUhVTTZJT1Uz?=
 =?utf-8?B?K0xDdmEzNnRPanBpMklyRWRILzNBV2YxNytaN1N3QUpnUGJNSTFoTlVaZktS?=
 =?utf-8?B?cXZRd2pEdDd4cndTNjNXMTZtbEZWTXFWWlZJRUF3b0hsMTA2MnQ2SC9HaFhu?=
 =?utf-8?B?OHhtZHFGaGwwWGFUM2dNTk1TQWZlSjh5b2FQem4zM1grRGc4RHVYYUlQRWdl?=
 =?utf-8?B?MUxld0c1K0tlRjg1Qk1xZmxHYU41RWRubCsvTHpHTTJvYVQ4MHEwcFA0aGYx?=
 =?utf-8?B?WXBlS3c5TTlTaHdZMEFRZ1cvWXlhdzd3bXdyVDJZTTBSWVhmT3BvaFBwMWsv?=
 =?utf-8?B?ZVZtRWt4bFlWZDRuWSsxZzJsb0xQZ1VqTStOVWZ3VGJpQ0lTSk9YMFZQTWlD?=
 =?utf-8?B?Uy91MkdPMHFBamVhZHJ2R25pTlFVM2hKL0NGVXlhaXJkaG9ES1ErL1J6elJs?=
 =?utf-8?B?emlOZ001QVV0QXBNbjVBUmpSVmNPZ24wMkNWUnlSUEhidWtQTkVHY0hOL1R1?=
 =?utf-8?B?RkcrajZudi9HbnEyRG9NYk5TOGpkbUV3SU16UnhwajN3QlhDNEYzSjN5NFNJ?=
 =?utf-8?B?UlU2cHl1cTlwemxPN0g1S2RZUEJMVW9SanVrZHoxNEd6K2ZoQ2NSRXVTdzdr?=
 =?utf-8?B?WEN2bEc2azhQejZMKzIvb1VPRW1uSjJyeTl4RnJheEYwSVZEMm8ycWpKb2lP?=
 =?utf-8?B?SGp2bDFoUkYwY2VTV0dYZFExOWIrSFBuSjNHM3FNSTY0Qm5YVVpQUmErVjF4?=
 =?utf-8?B?NGFrajhyQlF4V0tZL0VlVDZua2YvSzByWE1scVEwUkxtOUordUVJVVo2K0JR?=
 =?utf-8?B?dExscHlBd09WZEc3bHRmSlFDTDdNTG9oREwvK2s0Q0hqV3FGcG5jUzQ1R2xx?=
 =?utf-8?B?aDRiVFVJWnZHMGFrMXY3VWY2QkkzakY4alQ5VDdzUEdWZG15bWdVQWxVQVNH?=
 =?utf-8?B?ME83VU5tdDlJSHROM0tmWlhLQ2dBbzJEcUNEcXdML0tyM2RWaUFQb3VFYldk?=
 =?utf-8?B?dVdCVlpGdFA2YUxQVTE2eTFoL2NQRnNDdGVIbldYZTBpcThmSURZWTNabW85?=
 =?utf-8?B?WVJZM3lXS1pDZnJ4UEcrbm1VdUJ4TGVmdFU0OFZCMGtLa1JWZlhsRkJnSE5r?=
 =?utf-8?B?TzZKaDc0aHpPQUtJTEhmOEMxRmxwb280RkZqWWIxNldvQXFtOVFpMFhEUDhV?=
 =?utf-8?B?aUJibjlUWTdsMHgyV3h1SFJyWm51R2VrMWUzSUtvMDNYbG9EU0pFT2toU3Zr?=
 =?utf-8?B?SzNxRGVRdXVrMlIrM3pCbUtzeUJMcmhITFZsQnVLWU1JRTZjcm41STBPYlJl?=
 =?utf-8?B?bHdmVXpYTEVxQWYxckxjcTVHU2pybmNIMTFEREkxR29tanp5NXNnRkI1V2Zt?=
 =?utf-8?B?MGNybG1pb29wT285cmxkQkVmUFMvNUgrcG1jbGdMVEsvUDdMaHAzd3JtUDBH?=
 =?utf-8?B?bllZUGkxdHRJQ1RUblFkdEYvam41RlVnRnNXaTdvamptcDV2bU5RSHd1TEZm?=
 =?utf-8?B?RFdnSjRPRE1JRUpHakZZcS8zY2orOEcySlV3VUcrWkl3LzJTS0JBWElaSWNm?=
 =?utf-8?B?bXR0MmZndDEzM0xidjFMYTR3cnBHcXhYOFlrcHZHRmdzVmJtOXpMeFJtR3lJ?=
 =?utf-8?B?VElhbnJncGZUc243cHJwbzZ6ZXBZWUR1aDB6cnMyZXlWV2JCY2llNkdCWVo2?=
 =?utf-8?B?Z01OakQ3dlJlWmJoL2M5WWgrMzBUdDdoZzFqNHowREc0Z1F2YXpxM25vR0FC?=
 =?utf-8?B?YlprdWpENm1BLzlvdUY1RXZBak9LRFdJVTdKTlNpaXJqbm5UUEU1emFzNlFP?=
 =?utf-8?B?QzhNbFdEUDJvMUY0c0svVk5yd3dHZld6ZSt2YUhaVGd5dERHZUNLcm1tSnNX?=
 =?utf-8?B?UnYyTnRzN2svNWdMSUhrODdMWXZNT3cwbGxkTkZQNVVLMHpFSHVWWmV0Z1FG?=
 =?utf-8?B?MVo3cWRxNDFubXFkNTNuRmIwNmNWTmxDZ08yN2NWRVhwVnMyeTNHS1V2UXRX?=
 =?utf-8?B?YmM3TVhaVUNkZ1p3ZDYzZjYxbW42dERRYlVGc0p3QXpOWSs0SVlqWSsvL08v?=
 =?utf-8?B?YS9tb3U2UFBndFNPT3NubVM1WGdwWWFWZlM0MGJEL0FzZkdxa01yb1JGY0Fx?=
 =?utf-8?B?a05MT0I1dFRmWUcyZzZJSzlLOXQ1c21LOHVoV0M0eVEyVWNXMlVaa29UMldz?=
 =?utf-8?Q?+k1PGBPLTv2uQqbPHW7U29cj+pJXrZu02BNIL?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce2e9886-841a-4252-ad7c-08df40a990b7
X-MS-Exchange-CrossTenant-AuthSource: AS1PR04MB9358.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 10:41:53.4908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZKlOu+7wknXgIt4vcuTxO0diItYvL2nbs/BAfZdx6UbaD4wEkbXePbtDh6y6Am6P4zStCiqWT9G6Bt8MBtSpHsCciUvB0nTEfa6yRTdbL35Un/EAeE3NwWE0rzVpH2uE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7281

On Wed, Oct 28, 2026 at 10:28:25AM -0300, Fabio Estevam wrote:
> The remove path refuses to shut down a job ring while crypto
> consumers still hold references to it. This is necessary during
> driver unbinding, but causes the following warning on reboot:
>
> caam_jr 30903000.jr: Device is busy; consumers might start to crash

[...]

> Tested on a i.MX8MP custom-board.

Hi Fabio,

Thanks for the patch.
Can you please tell me how to reproduce this issue ?

Thanks,
Sahil
