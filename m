Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698021E531;
	Mon, 19 Jan 2026 02:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768788325; cv=fail; b=OoOIcUkf1NNYrC6wbM9DZRA+VXSpqaWPX/MkdQ0QT3lNyqkixk38aho4QMpK5Kj+C80byKUpHmliJf1fVqKzEXHbzInKIlOw+CBjzdomEWsD5yJhBgJX4hDF0rUgx+vZhDpn7Yd/cooo6Gp2Fyz3ZEjan4SzlzQBdERo90vz4HA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768788325; c=relaxed/simple;
	bh=tMDvN4JUmO/0dwvmepNeHzu40OmtYIgu6KdByjxdy1Q=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ff07lW9SgB1fvlGNwzDecFBxNGGC2VGeKuhI5uLHy2lEJSi1mQsuOLlfz4fvzhHYMAGZ6xAuvDCTiGjO0kq9IUV0ZW/oK2hJBeOzR8gUk0KynWE+JFSgBwyJp/ad8fyiqElsN+moTtT5UXMCQPFUiyGNdLE/L+p+X2YVA4VX154=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=cixSvgU4; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="cixSvgU4"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60J1UwKs2422660;
	Mon, 19 Jan 2026 02:04:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=6FDP3W6SM9fi0VCDl+gXTW2ll4RTihhc0CoWpElUl4A=; b=
	cixSvgU45lueuaVAomR0aw5LbPjQY9vC0VlyTJLuFa6pVbirR5PB+RQNpXb0/4ki
	bx571nOGdCIWyZd5IijUI7mOhwU2HDEYKmgvmlEcmBrAufTcgMNuG9b2ZeUo2SbH
	ZkamQ/YAaaISgMmmENse6Kx28CieYNYeFjGRc93hfSOnvrrxSj1voMO+tXaWvSbA
	0ynKyCopJ9QqK+RNXapVXBcOCHSrbbMa8S1FSXzslxnuOE4na1Yq5GOSjx4yjkRX
	YkBgSLlrOtCUJEnqyj5MjoTfYakDhwP0dWwqwfSKcoz5vm6I2BlW4piNPCwiR69E
	q59inTzjIecY42XJ9uTy8w==
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011035.outbound.protection.outlook.com [52.101.52.35])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4br1d49b6f-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 19 Jan 2026 02:04:43 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i92BBbAnZEFuklfKiB/NzYBEEdfGptjqqiMnWz88+COhh7SnUG8jSzAZGGP5EKMWUHMT8OaF1Yn+Vesmb/vhwcaj2YM8SHNJxj5HDw5wwW9LYqfJJ2HP58RgFQ1oCpcBXVUGzS3qo2OFiG6imLJM0wbhk/HD4wFQhCY3gG9TDn3qHCN29KtI0DsGBl2nDtZL9wOOSfgcvWd20TCohKxm98XGJUrKD0OaK0j7rzfzIDpBlg0GSpeZrA/yO20Ga7YtJFsyDuHhYYoeYU33nibLOGk9fFQA2gC2x0gaiAPoDgR6wpMQ7DTk5AqZTIw85udknZR5TA+37DVscuEu/EuRlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6FDP3W6SM9fi0VCDl+gXTW2ll4RTihhc0CoWpElUl4A=;
 b=fearF/GpbKWEzdYpxqPGG6xCU/07XuofWzqCb7eTgAyX/0fOq3oMwKLL8Iz41d6gFM19aK9OCKVIXNIbjr4kfzLAbOafvOwsDWxBZXsOs6P9htAFm+EQ+uC0PVzfAqd3VOPb7eAFpv11x9QL4l5G2mwYbp/4uQuhyykk+hF6LlHQggRXrEGnjhovkZ8/b+P9o2B070Xdk8DVoUS+XrgHoXC0CpPWuEKX8z8m4+7sENL+jqtPtLPJmJ8jYtpmxOrEzOVDN11JcjdaIMXbKe+Gxss/HNjr0xCiZFhpOermfmqAKgt19lNvVLqFfFSh8KJc32fJ1rBRbOnWHappSZUvog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DS0PR11MB7736.namprd11.prod.outlook.com (2603:10b6:8:f1::17) by
 MW4PR11MB6934.namprd11.prod.outlook.com (2603:10b6:303:229::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.11; Mon, 19 Jan
 2026 02:04:40 +0000
Received: from DS0PR11MB7736.namprd11.prod.outlook.com
 ([fe80::f7c7:f271:a7b:7a68]) by DS0PR11MB7736.namprd11.prod.outlook.com
 ([fe80::f7c7:f271:a7b:7a68%4]) with mapi id 15.20.9520.011; Mon, 19 Jan 2026
 02:04:40 +0000
Message-ID: <5ccb46f0-b4ac-4b00-a995-1062de841f4b@windriver.com>
Date: Mon, 19 Jan 2026 10:02:59 +0800
User-Agent: Mozilla Thunderbird
From: Jianpeng Chang <jianpeng.chang.cn@windriver.com>
Subject: Re: [PATCH] crypto: caam: fix netdev memory leak in dpaa2_caam_probe
To: Breno Leitao <leitao@debian.org>
Cc: horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net, kuba@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260116014455.2575351-1-jianpeng.chang.cn@windriver.com>
 <4h7joiwvamq3sgrkhyemtug4lucyicnx7beuik3i5foydwb256@iemjvkrs7h2d>
 <4a5b1ada-0602-4f43-b09b-ba1a8da26f21@windriver.com>
 <aijerp5ovv7m5mk2xrfn5rjgkufcynu7vikejqityxloeqnreo@jdnoev2yvfvy>
In-Reply-To: <aijerp5ovv7m5mk2xrfn5rjgkufcynu7vikejqityxloeqnreo@jdnoev2yvfvy>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TY4P301CA0004.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:405:26f::13) To DS0PR11MB7736.namprd11.prod.outlook.com
 (2603:10b6:8:f1::17)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7736:EE_|MW4PR11MB6934:EE_
X-MS-Office365-Filtering-Correlation-Id: 355a6025-ddd5-4e20-bfd1-08de56ff1abb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?emJuMTF3clpGVTRpSkphUHpXQXlicU4rMWtwZzlLNkRic1M1N3pkeTJ2czZD?=
 =?utf-8?B?bW5GaDhYcVQ1ZkNURnJFekoxMWFDOSt4RnVLelByRE5IUWU5aGY3ZjdVZ1hJ?=
 =?utf-8?B?dTI5SHIycWtaYSt6dmxCY0YzaGQ3SjdRaHVuZHVBdFpVVWROYUpyZFJYdHJN?=
 =?utf-8?B?cUtqMDB5WjlYbEhzZ3YrT2FnVDVFeUFLYVFNNWZuc1RrQ0RRM1lOTU5KNllY?=
 =?utf-8?B?S2s0R3k2Z0U4Y255anE2Kys2UDdpK3lzNk5BT3VwbHhQUXNKRGo5djNLSUMr?=
 =?utf-8?B?YlZNZVhGNnlEc1ZWd2I3dHBHcjNIdVVndmQ3Q05PeTdQTGdZU0ROUW9kN3dY?=
 =?utf-8?B?TE5OS2RiREYyaWlJZE5lTTE1TTBZWEpaZThPRnBsTFVMNjZiMGdMZks3UUVa?=
 =?utf-8?B?K2JDYXFSOHFMMDQxZ2U1TEd0VS9zR1RHMDhzcGh1NXVRMWk3eStWOUhBZnlM?=
 =?utf-8?B?MENqUE02VG1tMzdNUm1NTEZLL0ZjNGoxVGxuOGY5NkR1ditvSkhyKy9nOEdJ?=
 =?utf-8?B?NjdmSEw0RkwvSFUwOGNYZDY4dHQ5VjVNcEJxTzJZTFlYSjZTcSs4V2VwSmpl?=
 =?utf-8?B?Zy9DcmxTcnd1VjBSdHNoa1FHODQvWS93ajc4dnR6Wnh5d1NoRkNOVTdXTGZl?=
 =?utf-8?B?anhSaHo1UVRjMzVxWk5vMDlOUzJmVVQ3TllSUEdVLzJaa3JNclpZaFE5dVZN?=
 =?utf-8?B?d0VOcGNzVHd2SElMaFVnRWVNZ1UzeVpDNEtaazZ1dTMyMGNwTFNrN0pieFVO?=
 =?utf-8?B?end6R054bzYyMFRSMnBMSS9UNlg3ZUpwQy9NMlg1aTJ0NTFCK2YyUHA0T2Rt?=
 =?utf-8?B?UHRnUnRjVGxyYkt6ZEJsU1liRHFuVit3SHBUcmYyMlpLTlgwRXNRUHg4Lzkz?=
 =?utf-8?B?Qy9oSE52NTIzZzEzeXJwTng2WXVsSHptSkgvS0FIcDd1a3FvZENIWVlLUmZn?=
 =?utf-8?B?b3NYYlpLeTFBd2FrZzJVOS9ybW1WTDY1ZVV4V2NxUng1amRNOUpRNnhDRG5U?=
 =?utf-8?B?Ym5RWjhTa0gzbWljSjN2Si9VeXM2MnFUNlpKM1VYYTF6aHFISzA5Q3FNOHJY?=
 =?utf-8?B?U1NjcjJIUW5CT3d1RUFqdnZKYUhRYWk4d1V1U1pyMFdrbjdkZmVDcEtoRUpq?=
 =?utf-8?B?MExIY0FuNWtrcmRMUGpDL3dmazZPdWc2VDR3UFR4ZlV3Z0RNUEtLRXVLS2VG?=
 =?utf-8?B?S3hrcStycWZKbThnK0xjSDVYaWJPaXNlOVhlSWszMitpeXBJbk9lNDhkd1Mv?=
 =?utf-8?B?Vm9SVnFxb2psMEViNW8rVGZ5a3RZaUR6YTBkM2lKRUc4S0R0MXl3SmtVQkZU?=
 =?utf-8?B?citQTXIvYUhEd1NoNUZISXVOWGZvTmxPbzRTc0tPWGx2R20va2dheUsrZjhM?=
 =?utf-8?B?R3p5SEZPSGgzQit0Y2lsQVhFNHlWNFNzL0QweVkwYkc3amU3d2g4QXZiSlZV?=
 =?utf-8?B?OFFDak9zTnlwVmU3Q0VtQnVyN1lLOEliSUpySE9reUVJakNzcGJ2dTdVNFEw?=
 =?utf-8?B?U2o1d3ByTXZaOU00RzZ4L1BJME9RNlNKRy8rOUlIS2d2UVdLc20zQ0U2VU0x?=
 =?utf-8?B?SXBzc2RPQ283U3diQmhFYkVvWWltbGoyOFpkaEVJL2FYMStvelFYc1JLM3FO?=
 =?utf-8?B?bVNuQnFKcStPOWd0UTlxbUJPYTNzU05MOWM2VTNjK1RGZjB4eE1CN3pqRmhP?=
 =?utf-8?B?K2NRbVdrRHQxTDllRDY5MjVDZ0RzMHJNTHV6Z3NrTXRnUHdSN2JqVFhZYmNM?=
 =?utf-8?B?MVdNUEZZcklsWkx3ZUliS09hWDhTbnVpUmpUZUhvOUQ0Tk9GUlFoZm9sUnli?=
 =?utf-8?B?VE1zRnYrdkJSeGJ6TWdaQ2NXc3NTNFV0ZE13UVoxWGI2OFp6YkF0R3NTTUM5?=
 =?utf-8?B?QTFpQmRXVHFlOEhCSnU5czJNcFhLZVMrZnM3a1JwY1JtalVpeUpzTXJKczNE?=
 =?utf-8?B?L2I0SExEL3praW9LbVhaWEFwWkhibDNpTkgzekhVTHJPQVVSMEUyR3JsWFQx?=
 =?utf-8?B?VmJuN3gyL3Zkanc5OFViN0RHTHBNZkxjSnArNTA2K2x4ZjM1c2d2Q2hyUmZV?=
 =?utf-8?B?YzFPS1k5UUcvNnZmOWxmV0pSYlZ5azNxR2ttcktVZkpLNzQxQTV0UHF3TEVU?=
 =?utf-8?Q?cq4w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7736.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z3hCQ1ViVW1BK2dmQVZ3UmVDUEFZYWNINFRUd0U1SjIvMEFvMWdITkh6eDZt?=
 =?utf-8?B?aUJpTFdjWnkzTVNLelZiZGw2a0dtMGVSNDgxNEJyNFh5VEgrWnN2SDlEYTVx?=
 =?utf-8?B?bXFvYkJMZnBQTDhTV2JFK2lWc0hjUUp0T05zbEpSMUF1K3ZWaEdNZlBIcTF3?=
 =?utf-8?B?RW9VbjZpL3l5em5SQkVTeldyTTlqdlBXZWIzUGh1R2NtZ2dFR1JuR25PWFZl?=
 =?utf-8?B?WS9ZS0NpemFub01KRTFwT2JoeURya0ZFTVYydGdQSWxTUm1kQnZnUEllWnpH?=
 =?utf-8?B?Q1BrLzh1SThwZElPT3J1ZjBoM1Y0OVdlY3NoeW4ySm5iOCtDTWdNanRwWGly?=
 =?utf-8?B?YW4vUUFrRHJaZ2h1eXg4aDFBVjBrdGx4dFZubVc2Z3hBamh3K0E4UXd3aUtx?=
 =?utf-8?B?UkY0b05aUnhRRGttUnNDUElKaDhQYmZGdHB2cTA1OThwaHE4Z09EcklCd2tS?=
 =?utf-8?B?R1I4WXhGN1hNckdpTU9aTENUUk9XZWNVRmk0RGhTOTBQUDBNQ2U5Smp6c1ZD?=
 =?utf-8?B?enhkb1BTMTJrSDhtTW0xajNmVW1rZnd0YnI4TnRhaWtNTzZvT2JvWXBrSStv?=
 =?utf-8?B?UjlCb0xsaGVwSjQxTmsyR1I2Rkw0cUo5VG1MTHdBN2VXVS9wcVBPM09FaTRx?=
 =?utf-8?B?cmJjaW5oWlhjNUQwR0cxVGptNjE5S1N5UE1KSGNoUDIxZXM4SVhBYWFyYkRP?=
 =?utf-8?B?MU5YOW9tWHFqamJWZFFZdXkvLzcwbXFleXNyOURQdk5PeFo4bTVGam56QlJr?=
 =?utf-8?B?a0VCWThSK1NVTWRJdXpoWDU4M3pFNkVpek9ibHRPZUlBQUdtY1R6YTZHZlo0?=
 =?utf-8?B?TWtBeXVRM1E2QUJIVWZrbnJLaExKRXRiL2k1VWR4ek42VFF6MEdFcnArTGNy?=
 =?utf-8?B?QldtTEowbExRVVMxUGdPdFNEOTd0bTN1OWN4R3hwL0xmT3dmaEQ5WERSNmpw?=
 =?utf-8?B?d2dQN1g1cWdzVlFwYS9ldEdXNWMvNVNBMjFBaUpseEg3dXdLRkx3UDhZMkEw?=
 =?utf-8?B?RG9sR0VxQWV4aHVBcGFKWDdCSWZrVGNDdmlrUURoU3c4cUxnMUJOYVpXMGdG?=
 =?utf-8?B?cGwwU0J6S0hPYm8xMmdkSTBPKzlDNzVSU1E0ZlJjY0Y5T045Mzg0OUkwUkRE?=
 =?utf-8?B?VEo0VmRjUHMwM0ZVcjMveXU5a1AvVmpHNEJDMGJLOENFM2lWdlhwRzZYV3BB?=
 =?utf-8?B?OVBZTEo2TGVjeDlDNWpOcjBJNmYreXJVamdiWEswUmRGVkZOWjM0V3VjcDhs?=
 =?utf-8?B?ekRla20zT0lUdWJRc3NYdWRuYmc4bGpKQXoxUlBULytCdDFPMjEzc0NSOVNl?=
 =?utf-8?B?RENBeGE0Z2FyWG5xRFRDU2o2M0xuVnhQcXNwbVFmcjRkMG9OSnVhWjdmKzJC?=
 =?utf-8?B?MFdiMnRFM1FPaUNMNWU0VkFLVmdoTWVqYW1lbnpTT2xzZU9hR1d3VjVIdExP?=
 =?utf-8?B?dGk5ZXJWdWtkRENCNWNyQU5ucTlzY1l2Z25Tc28ybk80eVJDeHNOKzdVM2sx?=
 =?utf-8?B?Y20zSFVDdUd3Rk52b25QZU12UkkxaGNRWnQzNDNCZCsvTHhZU2RPYXJ5b3JE?=
 =?utf-8?B?RjhOamFqVFZabjgza3VLeWZKdU5MTDU1Mk9WRmlKUXlMYzc3TUNCYThFZm41?=
 =?utf-8?B?ODIrQkdqVkxFeTd5OVhEOEhTaU9TYVA3TU43L1NDNGtuV3QybFBxVStNSWU0?=
 =?utf-8?B?KzBweDI5cDRRSDExT08zaFh6UTZNTVp5YXhIN2NrTng3UzNGRmJtSXdUdU1z?=
 =?utf-8?B?SjZuR0NHR2Fjc2ZobU1PS2pMazFSU3VZbWYzbUhjN1ZPaGpyYUwrQ1lKNUU4?=
 =?utf-8?B?eVBMMy9SQlJLL2N6SGNLd2I3a2ZNN0Y2OGIxb0xOMGxNdTZraVc0Qjdtell5?=
 =?utf-8?B?ekZsN3pyVEhGK0ZRUkl6dmQxdTM0UDZtT0xsM1BiNFVhczZ0RWo0QW9PVGlm?=
 =?utf-8?B?aUM4eEdIKzliNjBMY1JKcDVEUzY1WkVBSnFJZ1oyeG0zUVArRlFYZ00rRHdl?=
 =?utf-8?B?U1cxczE0NW1LdVcvYSs2eW1VellGMVRnYWFycHhJa1VEOU90Njk1b0hHaTlH?=
 =?utf-8?B?dXJnalNaR09BdFJSSk1CekJQS1pjQ2lXbWt6bWhNS0tydkVyblVqTEduZ0Vj?=
 =?utf-8?B?SU1VY012dGlTSXpKVVNwSVBGNDN5YzFtS1RkYkxBQVFVdXZUOERvM3U5azN0?=
 =?utf-8?B?TnZES3BveG5BYU9BYU4xUkdXZjQ4c3NtOWg3N0U0R2xrdzhPS282ZlI4NC92?=
 =?utf-8?B?WTdwNUthemFVVUphcjRnY0R4NzNobUpLODR0bEhGL3FwLytadFRzTTFLbEFV?=
 =?utf-8?B?aUZOY2d6aXVFYS94a1ExUXhHR0EwSmUwTit3Wi80OFU4bXRoMXNqOXVpQzg2?=
 =?utf-8?Q?VCth3W6M+8OUq0y4=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 355a6025-ddd5-4e20-bfd1-08de56ff1abb
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7736.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 02:04:40.1158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oqa2kzitkZIqoABrwt0vMKzZiW6EnaggDN+hH8W56BHL86XLQKi31gICJGWoaMlc+CkjQHyQ90H6TYXCivespDYDKYEoagtueSGfj5S+fMk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6934
X-Proofpoint-ORIG-GUID: -9Ad2uEBhzvNzbeYkUbgXuTMUaRCjfiJ
X-Authority-Analysis: v=2.4 cv=Rs3I7SmK c=1 sm=1 tr=0 ts=696d913b cx=c_pps
 a=2EogD3SZGC0twO92opjmhQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=t7CeM3EgAAAA:8 a=jMwly8hnOpOiXLonyBsA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: -9Ad2uEBhzvNzbeYkUbgXuTMUaRCjfiJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE5MDAxNiBTYWx0ZWRfX2xWJiRQ+HfgQ
 6HRyR51oAJIvjqBN02L4eHrEsFqfxNx5vN5PS7te9XVXkSC5jDlFKJDGaJyKUoWdCva0ERzBbaL
 a0JgZvmsyaMGnNPoBXWsjhokO+aRWVJ6mJgzSwYgkhEiZEGkj2brWelPlMZsxB1fRY6vXftDdEd
 ahq1hrVfAkp32mj4rc5QS2JuuUBhVVyjbrwPZ/AWMw94Bp/zMuQMlPyiANOwNRmUoVdJr+bpPye
 OIyPWEQahKo31n2GvNNn1eucZIhq0oMtm4++lk9ujwH6hPZagTYHlrw7yL7V8oC/XaXWXOypWSu
 wKCJ6xIdD7xP+X6ws1fS5PpKs2eVHy9HM/sJAjSzCPQtUVKGDSog86gKku0mo+KLyJZzY/ev/r2
 jShDZp2CSgYxIvJm4HljjptBKHntwsoDLpvVzc3tg55qXnyo8Ulya+tvr0hB7MREWoV4pdqxMPY
 mENdD6Mh3ERKdBT58pA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-17_03,2026-01-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 adultscore=0 clxscore=1015 suspectscore=0
 malwarescore=0 priorityscore=1501 spamscore=0 impostorscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2601190016



在 2026/1/16 下午7:43, Breno Leitao 写道:
> CAUTION: This email comes from a non Wind River email account!
> Do not click links or open attachments unless you recognize the sender and know the content is safe.
> 
> Hello Jianpeng,
> 
> On Fri, Jan 16, 2026 at 06:14:37PM +0800, Chang, Jianpeng (CN) wrote:
>> On 1/16/2026 5:46 PM, Breno Leitao wrote:
>>> CAUTION: This email comes from a non Wind River email account!
>>> Do not click links or open attachments unless you recognize the sender and know the content is safe.
>>>
>>> On Fri, Jan 16, 2026 at 09:44:55AM +0800, Jianpeng Chang wrote:
>>>> When commit 0e1a4d427f58 ("crypto: caam: Unembed net_dev structure in
>>>> dpaa2") converted embedded net_device to dynamically allocated pointers,
>>>> it added cleanup in dpaa2_dpseci_disable() but missed adding cleanup in
>>>> dpaa2_dpseci_free() for error paths.
>>>>
>>>> This causes memory leaks when dpaa2_dpseci_dpio_setup() fails during probe
>>>> due to DPIO devices not being ready yet. The kernel's deferred probe
>>>> mechanism handles the retry successfully, but the netdevs allocated during
>>>> the failed probe attempt are never freed, resulting in kmemleak reports
>>>> showing multiple leaked netdev-related allocations all traced back to
>>>> dpaa2_caam_probe().
>>>>
>>>> Fix this by preserving the CPU mask of allocated netdevs during setup and
>>>> using it for cleanup in dpaa2_dpseci_free(). This approach ensures that
>>>> only the CPUs that actually had netdevs allocated will be cleaned up,
>>>> avoiding potential issues with CPU hotplug scenarios.
>>>>
>>>> Fixes: 0e1a4d427f58 ("crypto: caam: Unembed net_dev structure in dpaa2")
>>>> Signed-off-by: Jianpeng Chang <jianpeng.chang.cn@windriver.com>
>>>> ---
>>>>    drivers/crypto/caam/caamalg_qi2.c | 31 ++++++++++++++++---------------
>>>>    drivers/crypto/caam/caamalg_qi2.h |  2 ++
>>>>    2 files changed, 18 insertions(+), 15 deletions(-)
>>>>
>>>> diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
>>>> index 107ccb2ade42..a66c62174a0f 100644
>>>> --- a/drivers/crypto/caam/caamalg_qi2.c
>>>> +++ b/drivers/crypto/caam/caamalg_qi2.c
>>>> @@ -4810,6 +4810,17 @@ static void dpaa2_dpseci_congestion_free(struct dpaa2_caam_priv *priv)
>>>>         kfree(priv->cscn_mem);
>>>>    }
>>>>
>>>> +static void free_dpaa2_pcpu_netdev(struct dpaa2_caam_priv *priv, const cpumask_t *cpus)
>>> c> +{
>>>> +     struct dpaa2_caam_priv_per_cpu *ppriv;
>>>> +     int i;
>>>> +
>>>> +     for_each_cpu(i, cpus) {
>>>> +             ppriv = per_cpu_ptr(priv->ppriv, i);
>>>> +             free_netdev(ppriv->net_dev);
>>>> +     }
>>>> +}
>>>
>>> Why is the function being moved here? Please keep code movement separate
>>> from functional changes, or at minimum explain why the move is necessary
>>> in the commit message.
>> Thank you for the feedback.
>>
>> I moved the function because I thought reusing existing code would be
>> cleaner in dpaa2_dpseci_free. I will add the explain in commit message.
>>
>> For future reference, what's the preferred approach when needing to reuse a
>> simple function (4-line loop) defined later in the file - forward
>> declaration, move it with a separate change or just implement directly?
> 
> It is fine to implement directly, but, I am a bit confused with the
> solution, let me back up a bit.
> 
> First, it seems the problem is real and thanks for fixing it.
> 
> Regarding the solution, I am wondering if it is not simpler to iterate
> the priv->num_pairs and kfreeing them in dpaa2_dpseci_free(), similarly
> to dpaa2_dpseci_disable().
Hi Leitao,

Thanks for you reply, I will implement directly instead of moving the 
function in v2.

I have considered using the approach of iterating through 
priv->num_pairs, but the index of num_pairs cannot represent the CPU number.

Consider a theoretical scenario where there are multiple CPUs and the 
cpu 2 is disabled. When iterating through num_pairs, we would get 
per_cpu_ptr(priv->ppriv, 2), but this would be meaningless.

This is not a critical issue, and I don't have a strong preference 
either way. I just think using a CPU mask to ensure precise cleanup 
might be more appropriate.
Furthermore, there are risks in using num_pairs. If we manually disable 
a CPU and then disable/enable the driver, we would encounter an oops, 
but that's a separate issue.

Thanks,
Jianpeng


