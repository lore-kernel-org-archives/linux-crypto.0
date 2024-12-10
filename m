Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20561BDAA2;
	Tue, 10 Dec 2024 19:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733857980; cv=fail; b=V1/w6ZWn3twqYJFUuGWwk2Lb42uzuOGmSTYRcIKggEe51pWteWvUfuJKkjyhvylq2SS6h7pqxt1TAdt6OfBrTU6DrdCm76NYKSfkcToweA3aoo61LsGSBCWm8H/mg+DvVcfV0W1UnULtls7bYTgM4R9RXl0vqvXsNp0KgV0heDk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733857980; c=relaxed/simple;
	bh=IAQvRLmW7mHqT7MwjVkz/snzfbNXWlOgQT8wQlf5xZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LlIIJ9C+veElO8fxhxJwl40/hvqfKiy/xieuTQXU3/Ea2CepQAEDRwrg4Hfhij/zkOUd6nyzkpJi608p/KCZ8gNoYYl5qk7GPS5b1hN+Gh0/n9oUZ91mSqpqcTWDOuHr8vBY57KmHLH2CpEcTTsnQRP721ugoMIjEfjISlJhbHw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=n+tEVNyr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mUojogyz; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n+tEVNyr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mUojogyz"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BAGQm0I003315;
	Tue, 10 Dec 2024 19:12:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=5SnI0+UMJHRXxkH6pm
	TOHjFEeVgUk4sLFGK4qipA3BA=; b=n+tEVNyr1E8aXs3rPtitmGATXrRR3ImfeR
	pFjYmluMBBsFYin78gPCla1XOOac0OAPAP8ppqSojM/eexvGvhSRpIb35gZY3Zqw
	qv0TuNBNDGFMxvVAu1imsfgC4HcHkGNgU6HtXmXCLAtjGtOgJd+tuPYeJ0m0+7xq
	UHH6R6HJvKR6ncjSCDJGAMHIPj13HlQrfdQpdWtXjwmN0I1JwSERm1mfFIUKtni7
	oSEuLgf5vggUzw6ZE7SU9MBQDKse0sa7YjOAOTZc5ooN79d3DNlwRQUUn3QoHtCA
	HXo+my8HLV/03sjDT2z+fuZv9gdJelylSWcByVmsOtENIVFJ8JFg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43cd9appgh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 19:12:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BAIOcgQ021316;
	Tue, 10 Dec 2024 19:12:36 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43cct8r4a4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 19:12:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sZteFBdK5RwGEkxhjC25JJaNts/2nN8KC6C951vaQ+o/M95+OVmw5yikIEJYxryrpsnyBriCGF4KvLeRsTUlRmaDkOqrUhTuyvNofqSZ1YwKQh0jRB6rTA5qc+DYaIiz879QX6vMWEe8VudxjdQ4hcbnL0FUu99N1oLrRZ2bUNBG4IXnCWmbYqpSxepa9tVSJyTSKa+Rw7wMor0IZGkqT0Ws9NB/Ich5cUfVwh+SlKUxWU6a/cYK2NwjASMnXWFeJiBNmIo86dckwvupNvtr4DK1ZG6UNw49jk7kpaBQ69DHmf/+oYasvvMvb14VAAvzDU7K7pSltmkjMmqVUgqfgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5SnI0+UMJHRXxkH6pmTOHjFEeVgUk4sLFGK4qipA3BA=;
 b=uJFH0p2MSzlCMzCEtor6kWCIrQrrVCimr7igtPTyBGYQ9kPObFyjU/VVMIJu+dEM8SqslMOAS7EIcQ/ESEqMTXUzZARoo5UQW3o0PqOuygkGWEUq6WxHihjvOZTvWxj1el0ky8UCbRNEau/huUPbuRwiIz+LMevscgKY2xgIwrTR8/XGZW94QewRgFfyj0YLbBggdphtkRhEG70C4tYMZA8RnZ9AdQT+4XRgARq52uOx5RiINkt12uVL66y/jGZpyT+WfCNZPjXcOG1B6FBbVeZjcSQxvn/dtPBUKPDd8+JGXtmWYBpCFlWpc4XUj3T8NHHXmaTtUYDPE6aSAnoW1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5SnI0+UMJHRXxkH6pmTOHjFEeVgUk4sLFGK4qipA3BA=;
 b=mUojogyz6fkAQ53konsPyyBLeQmjTrL2lUB3v3EI0ZXXDDrczwoGElroBfa7mQxI52mDsGDhjxx4OI1OlzBY2ZIVlBUs6K/Bdv8lN55v0D32PC/+rc9+nW+kxLfthNel9mXthzMDR75co/n/zQYs31KteSf6OR2pXvzr1z5ZxeU=
Received: from CY8PR10MB7265.namprd10.prod.outlook.com (2603:10b6:930:79::6)
 by CY8PR10MB6905.namprd10.prod.outlook.com (2603:10b6:930:84::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Tue, 10 Dec
 2024 19:12:34 +0000
Received: from CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::d299:36f1:493b:33fc]) by CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::d299:36f1:493b:33fc%5]) with mapi id 15.20.8251.008; Tue, 10 Dec 2024
 19:12:34 +0000
Date: Tue, 10 Dec 2024 14:12:31 -0500
From: Daniel Jordan <daniel.m.jordan@oracle.com>
To: chenridong <chenridong@huawei.com>
Cc: Chen Ridong <chenridong@huaweicloud.com>, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, wangweiyang2@huawei.com
Subject: Re: [PATCH 2/2] padata: fix UAF in padata_reorder
Message-ID: <mffodsysfv4qakpyv6qbuqxzfpmt54q7cbpgne6paykzjx626y@f3ze6ti7cshp>
References: <20241123080509.2573987-1-chenridong@huaweicloud.com>
 <20241123080509.2573987-3-chenridong@huaweicloud.com>
 <nihv732hsimy4lfnzspjur4ndal7n3nngrukvr5fx7emgp2jzl@mjz6q5zsswds>
 <2ba08cbe-ce27-4b83-acad-3845421c9bf6@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ba08cbe-ce27-4b83-acad-3845421c9bf6@huawei.com>
X-ClientProxiedBy: BL1PR13CA0351.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::26) To CY8PR10MB7265.namprd10.prod.outlook.com
 (2603:10b6:930:79::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7265:EE_|CY8PR10MB6905:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e400bc9-69f4-47d5-342b-08dd194e9a4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dvNGzcfhHkl8aiBdvRhigCqLFGDME9hSIFB8c0dotc7uat48mqWgt+1oH+Sa?=
 =?us-ascii?Q?xYoVkPC2LGdUhEmRP9zmrAyBL7SXGGxAH3kxH0Kb33bMvrGG2UYxXoQD8xV7?=
 =?us-ascii?Q?dxxcb/YkpMdMDHauZI2VJDeQgQYE/QsKz0b6CYOPHLTBJVjem8NAp/buZoOL?=
 =?us-ascii?Q?dRYR6wn/ZDvsemgwkXHzMQd4xCd1R/32Guk+6Wu1DXaVilPjvwwhgbEbLafA?=
 =?us-ascii?Q?XZdkvFmrpK34uz8BfAvcNfcDltjYhg+raGgti3NFPxSyLxZaa6XXQajzOcKv?=
 =?us-ascii?Q?vUCJGDtySw3J0CBOdELWUZj04L9ADkEGqXYqG9RkRxcuZq21O4EzIwXbbi6M?=
 =?us-ascii?Q?8iapqSKlWwOWmMMldiqRNgUcBePZr2Xcaj5t0+oYdCRL32HN+ORaElI5VT+i?=
 =?us-ascii?Q?jtJKi6Eg27rfs1XRHPyvFISMm7PeytpMyDqomK1Ztf+oyz43puHT/jbatXQY?=
 =?us-ascii?Q?7PW7yTeFv7kLJOf9mYMFg3lkH37wEdlYuUz1LW9IzLrGneAZdYh9UBQmN5sP?=
 =?us-ascii?Q?XnwLIwXkq6IXhq6lwSV5vnkMcILBHSc9K79RBkFIP4AQ7I01aXcEiRIr4wFw?=
 =?us-ascii?Q?KCPXayNjhzFS/rtiX+1kdzhqQWZMXKw8XKMyg37jfn2hDBixTqQI/6EIbl4n?=
 =?us-ascii?Q?/J66zaEIdkGsIKe5JfClwTaTGULnTAneKoIKkAwDJfMh/c3/tH4b7DNVO0qC?=
 =?us-ascii?Q?Zs7r/s1Q3bA3GV3UtRVPVaRZM0TlGK4mAWw0BRtHT2umyuyOoUKR8nTytPmT?=
 =?us-ascii?Q?6GAMI7Esws7iLQGAFuf1RLMdHeqqqsnBLKDCo1Wuf8p75btCS9B2yEpWsMQD?=
 =?us-ascii?Q?TtvxtKc1DNAj1hoyGtiE/Z8FMSY0rpkLl25fMlXYXRXT52VCXpnRpu7l342x?=
 =?us-ascii?Q?kfjXVRUOsCeI0Tafrrx8NzWrwrK1P88kdf5/um78xLb2hOnfLPFvnYvK723F?=
 =?us-ascii?Q?ZyZpP9Co2l4pGxAtsBdmXtrs0zoJ/p6ACt9WRrlihBvdRmbETUOzFpxBosq7?=
 =?us-ascii?Q?Hzpedpm0rtN5i175R6mxLM3gStWB9kjvB6gFpMNupptuFeFwZKxz1g+seJZf?=
 =?us-ascii?Q?/QBo51mY4gJuFQzdcicGXTiVG2BhIEObDvHTWil6KU5gffchA7Q7YpvSY0zR?=
 =?us-ascii?Q?sylhE1nOF2Xcxrtmdvkde5j1CZ8OaVK5hjQ3qQkc6G4lp8Eger82rgBEVWSO?=
 =?us-ascii?Q?FuZI77UXNBXGc+D6FN0hxl2eZmvO0nJs77qwH4IZrl00W/6idLcNmWmkkRM5?=
 =?us-ascii?Q?u5GrPr/gBX3Mub4bIpoEsY+EpB8qdmr/oeMSmyTu8oOOB6Sm/A56I+FAIggQ?=
 =?us-ascii?Q?XTYlqxCFEurQ0RtxPU0L0xW11miZdzkfy9wuVZBZjM7SO2GJSEM/ThL6OUGi?=
 =?us-ascii?Q?y3O5dOI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7265.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?U6vYU4pO9Yz+1IzP2bCDYzKXMKw6ag78JF8FgNm+QHmBHkVmjFEMy1w9R3jU?=
 =?us-ascii?Q?QSyxkvG6lKSqF6zTpJ70l1p8p1saN99HdfLl76b2FdYbae/fNenFdWpQDN/0?=
 =?us-ascii?Q?pqZAcdozkBaJ6YO3fQdlSzDhJv4oNYeMFcxt3OpxkakjLQB0bawXRDPZgS8V?=
 =?us-ascii?Q?s/dh+nOc8yt0lSaKMcHj2JWVzj+YFH+s5BWL+a92ZdkW1j/gkLXYzP64AwiC?=
 =?us-ascii?Q?j8oUGKLbmHAt0DM7UWYRDuIjNUUEoeJpaifgiZoU3PRAxfDxhZf/YWudXxMs?=
 =?us-ascii?Q?Kz206M43TsoU92jPgH1dIFg+KF0b2x0NE2zP9TrGzeabj2K4/9mGisLEOasX?=
 =?us-ascii?Q?lNoc9jsgX6y6GRQ5gWhu2d8GPPip98zIxvOZFMUqpnYVjp+vvTxnrT3emLH2?=
 =?us-ascii?Q?BpqqXNiMGtF5yw29peu2qWmhj87yqdradyHVIa5L4uWb/BINy+MDTh+swNWa?=
 =?us-ascii?Q?piogcfQZxRgNxIF2gu/ZJqNzQF1KjjRm25gcLSiENfcxH7o8f8as39rzI/9B?=
 =?us-ascii?Q?BZ+CKDys1Ef/fbmAVvqQ7FFtle//56O+ahAx0JNYcVeIy/G/Ps5rQIkMJNcG?=
 =?us-ascii?Q?K6G2PzVn2GCDtvaRiIi7JqwzOwlf1oBquYkSELN/8YundneBJ3WsrbXfeyN9?=
 =?us-ascii?Q?ftUaSQuxVMresTmIZPywMDESCjoN4jpn0yiVBRbfkT9aLnUaJdxR0ZyP1rsE?=
 =?us-ascii?Q?DSbet/7dk6BoVZQ6Ea6iAM4Q1ytVr4A9wKthoDbUcNXq9UcHM+39Y+NUSG7U?=
 =?us-ascii?Q?qHb13SdsTxjvg0ogM6rx+4hd5CsVJZvMUp1MID1FTbN1jjD1ecWmEDClVG9d?=
 =?us-ascii?Q?Qz9j9iivuZDRuOm8+9Am68Icv1h8Q6Pph1yAPwrG+sS1/XjAXxMNTmMLRJoO?=
 =?us-ascii?Q?nDG+14izAHxdc/hs+ysY2Bgv/anfKlgJTccWbrKNCZvvGZuwaCHlccSIfSR7?=
 =?us-ascii?Q?k/prVhSYHA+/hmWLfyqIfskNES8arktLGBoP0qqhxdVaCsvsZQRWF4J+rhJz?=
 =?us-ascii?Q?8bFEcqjk23ZrgyXWGWGJ/I4kvj03bI14nSoNJwkZL0Y4StYuwG08b3Pio/8Q?=
 =?us-ascii?Q?rWkCo5bM7tocU5oL5tLq47xTgCGmV948rDzCI6NGS4iHmQXQI6FKgJAQRvYS?=
 =?us-ascii?Q?VsvNO2pA7TSfUqJ/nW/0O4lRbaph2ZwgqzbqDVctXPaYj+68XUbv0vQ5vzBa?=
 =?us-ascii?Q?m1eDlhXw2BKt+5dwNnyx7YvQgU9DHIAdoRqwrdkpcjBN9EY6gBmNqi1mDTS3?=
 =?us-ascii?Q?lEc64byNiOun5t0X/32WSBLn/2sfPyto6F2OOYPB9qNNcrD5fTVu/N1XcozE?=
 =?us-ascii?Q?1fpU/c+HmF1AMBSS1EiWm62k5yR0oRK7Z1M8GUaLlwbagpmDoCgPWBsUFth2?=
 =?us-ascii?Q?UqeXvSn2ErBZ37JrFASuOQgAC3NSldo7vmrBgkok6u5SV6jLXy4BtX5ClvnX?=
 =?us-ascii?Q?tgv7fuSXvR063P5LejEOeEw8TZY9PhsJ6qiO0LMB2jwctfmYNXh8D8cXNsq/?=
 =?us-ascii?Q?TYgLNPzE5pXW5rm8DuCQ00HQLdyG0frVTQpl6nDhkh35V9xnsczmkaREaJ68?=
 =?us-ascii?Q?brIci+PDxRq5E1kgDVEjSKM3HhISQKaH02333LTSe37Ei+4ZLRp5a1S6yUnx?=
 =?us-ascii?Q?FQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Bxc+KfpX/ZH5w3nTQNrDaVkdFhghA8zRYk054uiL0uDc8MsizDvUOpXn1Lx7ZBydK6FOqoJeQoSuub6RQ480FjvrJj0TyaKmrGETrLt2jd5BHLs/bJzuFs0UEaUlThcDjEXhiuwUnjtX4jQliHEdBSEByl8qqTaXBzPTY8DoQxuOnWG/hsjg1nkAuTkREQtttYBSK3Lj2a7J1lKJI3PoAV+rOhFChiwY72CwIfxPokADb5eEaRyvPgi25EEyyW91ptJsx32G2CJqhHXECrpECphQ9yHXrmMWu2UvlPg/Z8E6jRTxX13uWWnw6tJ9ob5s2ozUjOjeLalk+R2uwrYHApKhqI8f2VoBmlxGoeOLnKAqka6jMMZRx6i/k9VQTjwVH/w1jSmG3shZ3JB3eeJ9wElsWWM18spVp7hWmSgscwMtszGRS8JtAv+3cUPL2326yb2M4EtE+ZIYVTWPAYfxT3Ty4wSo3W09pAuSNGJugyRyUP0oHhMp7rW1SiEaoRju574PiI6SZElsybU4A1CibKv1tss4V4tDyU8KbaSS4WsAmT5LMYQMaAB2Xad/zF7uZBJ124GzfdCoS/Ot4itDdWLdt4wbUFLtgbiZkbvzT9s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e400bc9-69f4-47d5-342b-08dd194e9a4f
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7265.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2024 19:12:34.5642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VMIHpEQOtfXfu5aNtux3dNT09tZBIYBDBEI5uugQqkny35qLZP4Jaf+vBkt/gdqIaElHKyjBBKgGRb4H78DbpzgZcbi7yhnCvVOaTniYHZg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6905
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-10_11,2024-12-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412100140
X-Proofpoint-GUID: BEY0B_bOS1QoEc4txZcdcm9GoSBWTOYj
X-Proofpoint-ORIG-GUID: BEY0B_bOS1QoEc4txZcdcm9GoSBWTOYj

Hi Ridong,

On Fri, Dec 06, 2024 at 11:48:36AM +0800, chenridong wrote:
> On 2024/12/6 7:01, Daniel Jordan wrote:
> > On Sat, Nov 23, 2024 at 08:05:09AM +0000, Chen Ridong wrote:
> >> diff --git a/kernel/padata.c b/kernel/padata.c
> >> index 5d8e18cdcb25..627014825266 100644
> >> --- a/kernel/padata.c
> >> +++ b/kernel/padata.c
> >> @@ -319,6 +319,7 @@ static void padata_reorder(struct parallel_data *pd)
> >>  	if (!spin_trylock_bh(&pd->lock))
> >>  		return;
> >>  
> >> +	padata_get_pd(pd);
> >>  	while (1) {
> >>  		padata = padata_find_next(pd, true);
> >>  
> >> @@ -355,6 +356,7 @@ static void padata_reorder(struct parallel_data *pd)
> >>  	reorder = per_cpu_ptr(pd->reorder_list, pd->cpu);
> >>  	if (!list_empty(&reorder->list) && padata_find_next(pd, false))
> >>  		queue_work(pinst->serial_wq, &pd->reorder_work);
> >> +	padata_put_pd(pd);
> > 
> > Putting the ref unconditionally here doesn't cover the case where reorder_work
> > is queued and accesses the freed pd.
> > 
> > The review of patches 3-5 from this series has a potential solution for
> > this that also keeps some of these refcount operations out of the fast
> > path:
> > 
> >     https://lore.kernel.org/all/20221019083708.27138-1-nstange@suse.de/
> > 
> 
> Thank you for your review.
> 
> IIUC, patches 3-5 from this series aim to fix two issue.
> 1. Avoid UAF for pd(the patch 3).
> 2. Avoid UAF for ps(the patch 4-5).
> What my patch 2 intends to fix is the issue 1.
> 
> Let's focus on issue 1.
> As shown bellow, if reorder_work is queued, the refcnt must greater than
> 0, since its serial work have not be finished yet. Do your agree with that?

I think it's possible for reorder_work to be queued even though all
serial works have finished:

 - padata_reorder finds the reorder list nonempty and sees an object from
   padata_find_next, then gets preempted
 - the serial work finishes in another context
 - back in padata_reorder, reorder_work is queued

Not sure this race could actually happen in practice though.

But, I also think reorder_work can be queued when there's an unfinished
serial work, as you say, but with UAF still happening:

padata_do_serial
  ...
  padata_reorder
    // processes all remaining
    // requests then breaks
    while (1) {
      if (!padata)
        break;
      ...
    }
  
                                  padata_do_serial
                                    // new request added
                                    list_add
    // sees the new request
    queue_work(reorder_work)
                                    padata_reorder
                                      queue_work_on(squeue->work)


   
                                  <kworker context>
                                  padata_serial_worker
                                    // completes new request,
                                    // no more outstanding
                                    // requests
                                                                      crypto_del_alg
                                                                        // free pd
<kworker context>
invoke_padata_reorder
  // UAF of pd

> pcrypt_aead_encrypt/pcrypt_aead_decrypt
> padata_do_parallel 			// refcount_inc(&pd->refcnt);
> padata_parallel_worker	
> padata->parallel(padata);
> padata_do_serial(padata);		
> // pd->reorder_list 			// enque reorder_list
> padata_reorder
>  - case1:squeue->work
> 	padata_serial_worker		// sub refcnt cnt
>  - case2:pd->reorder_work		// reorder->list is not empty
> 	invoke_padata_reorder 		// this means refcnt > 0
> 	...
> 	padata_serial_worker

In other words, in case2 above, reorder_work could be queued, another
context could complete the request in padata_serial_worker, and then
invoke_padata_reorder could run and UAF when there aren't any remaining
serial works.

> I think the patch 3(from Nicolai Stange) can also avoid UAF for pd, but
> it's complicated.

For fixing the issue you describe, without regard for the reorder work,
I think the synchronize_rcu from near the end of the patch 3 thread is
enough.  A synchronize_rcu in the slow path seems better than two
atomics in the fast path.
