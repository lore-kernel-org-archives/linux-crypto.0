Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C3122422A
	for <linux-crypto@vger.kernel.org>; Sat,  4 Oct 2025 06:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759560238; cv=fail; b=SQde1deSRR7IXJOnCGClug2+4wFXKNNUD829+iajneXJd2yXY1nwt6il7RKByGJGdTxLeYy3YoTP/AymWnlUvcbL1tARskHxfm/gH0rv+kggtL0m+B2dt+MnnoW0TiB86THpDJ3UDzJgga3RyA9wHCopk24uqNLRqqHJnj9ZmeA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759560238; c=relaxed/simple;
	bh=HN4kaaivrMw5Rs577HX9NYHtKiPC/RKrsW2WzOinqwo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RFYV5KCiCZsasJQ9kgk+XRUqQ7cxps6tmp3ihoycoqu3UjdnMzbxe9sdE/3dDt/lFJQjd8pllagsi74hiCDEuIJSDS+P1M2MkwnhsSh1QRbXNiWDaHuc3iutn4ngXjL4R3nPi/KVxtTdhOECKF62kKdyfLXfv8kQMg8d2TQ9R6c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cYEWNVLk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bKIj+rL+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cYEWNVLk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bKIj+rL+"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5945toYI004393;
	Sat, 4 Oct 2025 06:43:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ZsPIkSoBKxQt3hl+gCBDKhylYw49PcgXPnMcKs8OoU0=; b=
	cYEWNVLkGQbKrcUHH9nhAgVnLNPIPkgyiBq5XYS6psBLkw+AFYwtDN0KoorA8CKm
	cPAp3PfijejEtsGWW7LOii0r9Lg7A4CBZCjGbtCNbpv/hvb4QkLUs8QqQMLR/xmT
	8eZGU9fgl5UsmdJUpTKsB4FVo7IWuGZxGFY0fLKu4VNnFX5naWyMAup5zr4PkFwq
	QuM2CCjbMmf3Efdx8YTVmDYn3TrJf9+66f0XyCo3VIV70rJy5FK+WyiNuLWHDrAt
	b8TkioJLUtdUKJVbLzZY3rBb7PfQ3Xe1K/WOO+xokmBVeZ7nq3m1ycvGNn5UUvUQ
	H98UiLgnkKrEsKGaGcjUzg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49jv4r82pu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 04 Oct 2025 06:43:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5941YAL6036138;
	Sat, 4 Oct 2025 06:43:19 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013023.outbound.protection.outlook.com [40.93.196.23])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49jt154vsd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 04 Oct 2025 06:43:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bdPWGtEke3Z/OaZdBKFihPZcqvj9CBnF7Un5CRfiPOkIxrwLfVB+DE87z8RIWkcu8FBo6pihtcrdrR3yMGyUcEqv7Y+VT69DiY+ixMFUvYnT6TUBVXX6QnyP3dkUFwPgXbOVusTOT7Pf1xBhjdi7XVkUgkMXcG6pvjJ4DaS6nLEadv5jpl27gpDe90rz4sgfJaDu8bUoPAedvCGnQXuRuFqD3zQ6GitX+im/gtyQpVqWU/uS8S/ebHf095VodNahg/LtC6a1p/msL0sHAue9FEieLGO9NmcAPsNQurZE5TbgakiYOuqx7Pct3kTWCypl8aXUnwiKawJ8mvRchUdqMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZsPIkSoBKxQt3hl+gCBDKhylYw49PcgXPnMcKs8OoU0=;
 b=RfZkPZ5EzdujoGiDZ94Qh2zKDmnLZGfzZTQMxSigDdLnAagCSP5MEp3yztPfpdLfDnCgPeXC2bmHb2WVIKdYytivSnJ5Eu+7hWDmxPcjYf3VvupYpcuPwPqG5hTRDiBI1BZY7z0IVeBKNH2fdzXG93C9txBL6AUyKUd0B8GYyWw/q6aI4CDeezL1vac/TLF/NvWeWmhWNH/satsXGO1LOeBCFNcx7KSmLrr+I9jHfQIzo7fyyaWNLajBNkptQhhPSITkV0xv76bK7ipsZA/IKL2l9YL2zJhmHWM1gpHWwID/PiMKnNMlLVNueaZu8ZgrfnIB0g2QqbPcC2qeFGgdLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZsPIkSoBKxQt3hl+gCBDKhylYw49PcgXPnMcKs8OoU0=;
 b=bKIj+rL+/6KJmP5CO9MV9fbgK9iPyJINAUjCn4wRjaVKTr+mKsqBiu3vTOv5zhRljdE6ON79DhhRYJujWkmmcD9yGN+/MBE/E8VNp/LE6uH1T7mRPYGJt2J8vIaX63QBqJB0B2B2JdqB7YEs6KUD0MdO8aIBLVesVcJ3Z8VLJw0=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by SJ5PPF73A72B96A.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7a8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Sat, 4 Oct
 2025 06:43:12 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80%4]) with mapi id 15.20.9182.017; Sat, 4 Oct 2025
 06:43:12 +0000
Message-ID: <ec2b9439-785e-475f-b335-4f63fc853590@oracle.com>
Date: Sat, 4 Oct 2025 08:43:04 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: 6.17 Regression: loading trusted.ko with fips=1 fails due to
 crypto/testmgr.c: desupport SHA-1 for FIPS 140
To: Jon Kohler <jon@nutanix.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Marcus Meissner <meissner@suse.de>, Jarod Wilson <jarod@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        John Haxby <john.haxby@oracle.com>
References: <20250521125519.2839581-1-vegard.nossum@oracle.com>
 <26F8FCC9-B448-4A89-81DF-6BAADA03E174@nutanix.com>
Content-Language: en-US
From: Vegard Nossum <vegard.nossum@oracle.com>
Autocrypt: addr=vegard.nossum@oracle.com; keydata=
 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 8A==
In-Reply-To: <26F8FCC9-B448-4A89-81DF-6BAADA03E174@nutanix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PA7P264CA0146.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:377::8) To SJ0PR10MB5439.namprd10.prod.outlook.com
 (2603:10b6:a03:303::15)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5433:EE_|SJ5PPF73A72B96A:EE_
X-MS-Office365-Filtering-Correlation-Id: e4125a59-4d34-4df6-57f0-08de03114953
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a2tTQWlvR0dBK1FmNGxzOThyQTdoZk5mYjk2WFZ3QVozNTJHRmZabGdwdlI1?=
 =?utf-8?B?MjdWWTBpWjhOdzFnV1FQNmRZUk1ydFBaZlFLdkRveU16S2hzYldyY1BaK0lV?=
 =?utf-8?B?alpES21wY2lPaXBLQlhqRWdBME1UU1YrZHEvN2Rmd08zTFJzWE9rRGVPczBh?=
 =?utf-8?B?anZ0Zk9KNy9yVHd3WUc4dXUrV0xhMEdoZmFLN1hLSWJ0dFdyTkw4WTFaTkNo?=
 =?utf-8?B?eENqVnc4MjBBTFhia0VGMU9Nakxzemo4RUV2YklGbU1Mai9zR21xYW5FNjdq?=
 =?utf-8?B?SEtuT1dPMEFacUkwQXpxZEhkRy90d0pvcXp6QnE0aFdxNUdqM3Y3Sk55dEtz?=
 =?utf-8?B?K3BHMlhrYngzNGU1YzRlNFF5OEhsVzh2dVVzaUhjWHdYRm96dnNPV3dCem10?=
 =?utf-8?B?a1lPZmlmVktLVThCbWMzSUo2ZjNscUo0OVIvaGhSODFXYWttbEtFMTdTU1lt?=
 =?utf-8?B?OXVMcUxpam5uN3l2SDBadWdGczROUncxT2IvSkR5Z3hKalJIRzlSbTEyVXRa?=
 =?utf-8?B?RjlvREJWblo0OUVGbVNlc0Z4QTg0SDBRa1hLOHV3SDE3cHk3ZUNndC9GbXNa?=
 =?utf-8?B?Nk1kRUVQcHVjM2ZCcWowUEZ2SGo2clBCS0VtNXo1ZUFMa01RUjlzdnBrWmYv?=
 =?utf-8?B?QmhaWml6UWFEMitBaGZMdzQzM0N5WTIwb1BuRXNlc2dEdFdUdDRSK2VOMlBT?=
 =?utf-8?B?dnlzdGFCUEJnSE1wbU54bnFYWGpFQTMyb3VpZXorZGM2ZW5pNkpjTFQ4S0tl?=
 =?utf-8?B?bFJBWUJVbytCRGZpMlByVTRyZ2R1OHpOVWR4bEY3QWN2U01WaDZjZktIZUR3?=
 =?utf-8?B?WU1NSjg1dlVXN0FYamxqajNqa2paUUdQK0RjNTFMazg4OTNja0loTzlrMzY5?=
 =?utf-8?B?WElMc3dwUmhsdnZRZ0NxWkxUbCtUcHV6OHlmTnhJMXpZRWdsZVNrK2xDUVE1?=
 =?utf-8?B?MjMrelJROXdNdTNjZ21NMTRmVHJhTHlaeGh3cVNWMGo4QkJVelUyL3RwSGlC?=
 =?utf-8?B?UTU3dHVBZmpaTFU0dC9IdXRUcFZiSTZKS2RXWUxxTFZuQlRpZDJuZkNQSng3?=
 =?utf-8?B?akFmbVNYOUtlMUx5RDRrZDVxeEJnS3Nzc0VISXpWQzFybDZ1cmV1U21GQXRh?=
 =?utf-8?B?bFZnV2V6ZUM3OWkzMjNudEkzTlBIM1lqSG5FbWtmQWNjNm1MelE3ckpaUG14?=
 =?utf-8?B?Y2ltMnMzTmkwd1huZlNwc1FRTGxucFpLWnZPaHQ4R2NFNHlzMXEwOENDbnBh?=
 =?utf-8?B?UVZRM3JsYzc4ZkRzZ3NNSitQaW4xUThxRTJkdjY0NXRaMkpBWWRsU2ZvSnlS?=
 =?utf-8?B?ZXU2YVVwQU5hSUFNNlZSaC9tdThXUVhjeUxSRW5IVFl4ajVmS1FoZWhwZXNF?=
 =?utf-8?B?dWkxVGlvTUIxcnhocmZJZjk1K3JuRmNVbWNJcS9KNlN1VnFFMXVDaUUxODhD?=
 =?utf-8?B?Y0lvaTYxU2R2c0NOSEF3dFNmc2tGcWhuL3RNdHlHZ2hJWE9YZzFyMTcrbUNl?=
 =?utf-8?B?cUxabVR1ZlgyNnRZRlNVMklvdU9pa1F6WGgvb1JESmNnMnhPNERmVTB0dVBV?=
 =?utf-8?B?UmhodVVBR3hiMlNRZ3Nwd0UvTEUxSUtFN2xENTg1N2wwaytlL1BrSmsxNHM4?=
 =?utf-8?B?UWl0UERCT3JPaXZ6ZjJ1dUtiNU9udi9BNmFOK1lQQTBwVmRIRGd2WTh1YWJK?=
 =?utf-8?B?Y1pyQlZTRjQ0WG83T1lBNXA2K0FBNkNzYlcwaGt1WWNJWGs0VSsrT28rZ3Bt?=
 =?utf-8?B?OGVDMy9iR3NzS21ZUWxBLzl6eWIySUY2elNleTdrSWs2M2JmelByTi9OODM4?=
 =?utf-8?B?d21JMDRDYkVsMlVsdnVkRHE1c05NeEx1ZExRN05ld0dRV1R4cGpPcHZDTk9U?=
 =?utf-8?B?UVR6Sk5OTkJ3S203WkpiRUhVeG5UYTNrdFphM1F0NFRra2ZZNUdhOEJKeWRE?=
 =?utf-8?B?OVFqVHV6S2FqY2graVBmTCt3SS9XclMwZFlxc2hVWDROOS9iK0xRelM2KzBW?=
 =?utf-8?B?T080bGRqSER3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dFdrMDN0WmJLaXplU09TU0tlUDNja0g5aDVodGQwSkRmQm0wT0FqWS9SUitW?=
 =?utf-8?B?dmI0Ky9aSU52eU1GWDc3SU92THkwc2pMOFErc2s1bFZ6S1ozallLelkzYXBi?=
 =?utf-8?B?eTlhQnV2ejBxOVJZZVk4emNYZnZVU0FuUHFzaVNiMEZxNHlxaVlnZGhYQXhW?=
 =?utf-8?B?QlJ4clVEbXQ3R1N2azFqbzRNT040OVV0dWpUZ0JlU0RpNkd3ODRFMkNDRkF0?=
 =?utf-8?B?dWFDbFB1Tlo1bHFPalAyWnZRU3BUY0FXWUR5NmN6M3BUK0l4QkdCSkxjOVJm?=
 =?utf-8?B?QzJnZmx3YVJ0S1IxUjNaV1BGd01vL3E0ckk1RWJmV0RTUlBIZ0V0THBqeEZN?=
 =?utf-8?B?ZG4zTkptbVFUN0NGV1J0bG9HS25rRzRiaU5kdVdTQ3dERG1uVGM0dllaaXd5?=
 =?utf-8?B?anQ4U3htWVMvZXJRTFRnRzlsQUFNREdOYUQ1WWZUVld5OHk5SnJZbnlNY3RI?=
 =?utf-8?B?dzZZM1Bqa21sdWh0WWxWQ3g1Q21UWk5vYVh6bnptVkVsc2x6SVBZR3lSRzFK?=
 =?utf-8?B?aG0zamhUOHdxRldidVNLRVg5NkRHVmZYWi85QmsvcVY4R29vMUsvQ0xjd1Zh?=
 =?utf-8?B?UWk2QVE5QVVkVVB2V3RIL3VYTTRYam1CWm1tYTc5dXU1aGtEdzVQUE00N2h0?=
 =?utf-8?B?MTQrZDZ4SCtEM3hYOVNYb2J2NmVaVTVNSUdLVUVDcTVxWGorczNFOVBxamRV?=
 =?utf-8?B?cWp3dHVUSjNIZ2Z3VFB3cHdlbXhUU1lCTHAvUmhTaXM1MWFuVlBkRWZRUHpT?=
 =?utf-8?B?OUN1UHlWcWdBNFhkelltY3lnMTdYQUJMamNGNjBQZTlXelJ0dHFwQ3dGUFhD?=
 =?utf-8?B?aGtzRlpnUWtmS2FJSjlsUzR6UXdHV2phd1IzQWlOaEhsdUJJeWdWNnRpcksz?=
 =?utf-8?B?cTdqaWNBN3NCYXFvcVhBV0ZZOTB0NXhSeGtFN245MUhHL0NhdTBnY2xXbXdj?=
 =?utf-8?B?WllaZ0J3NWN1bFYrdFE5QVR5WElJWndVSDhLSkJHWFJUQkVTa0VSNlgrbTh1?=
 =?utf-8?B?YUN0bHFvWkE5RGxrUERFNDc0SFYxY200R0FwNHR5VnIxV1F6bG9LOVZ6OVRP?=
 =?utf-8?B?bUpNdjhYVlgyNWowcEVET3hGeUpZMDNra3RmYi8wS045bmVlc2NTck0rS29r?=
 =?utf-8?B?MHVXU2JUbmRSTCtDckZTTmVnVnZDSTF3NDJXdC84VEtYdHpHYjd4bTdhWU1J?=
 =?utf-8?B?YkdTd1VXU01lMHByM3hKMEE4U21JSEtVaXFJTUF3QUk2UDdSK2t4bHZCeE1I?=
 =?utf-8?B?ODJnRWpjdERDckw4eHpld1MzZWkxTEZQQUZMY0J6MDRsY1UrV2NjeTJUazhX?=
 =?utf-8?B?NFFKQUxKUXM0ZVhQbzFtZzI1ZkRwVkRZUmx2Wlc2VFNUWVM5aFRUUnJ3L1kw?=
 =?utf-8?B?NDJmSU1DSkFnRDNILzA0QUN2bGVjU1B5N0FkNTJDeFpDa05VSWtrckNKY3dj?=
 =?utf-8?B?dmxTc2U5TDlLUUFhaHo4UFZkdy9INk1FUzhIMExYVHJqTVY3MExZU2svYm9o?=
 =?utf-8?B?YjJnTGx6SE9EaVFqZTZjVHU3cWV6elErOUJtSndoKzNhR0lZMWpIMzV3USs3?=
 =?utf-8?B?UTh4ZW1zbUtRWEcwTG5LNzhuZndmTCtQSG41clZiM1FKUDgrWms0ZXNLYjc5?=
 =?utf-8?B?YldSQk1qZW9ESmtyK3FqbGRNYnZXRG5kOWh1NG94ak9hUmMyT2RZcEM0dUpR?=
 =?utf-8?B?YlV2SEFTZUw4RnhWUUpTdU5jcFlha0JZWlhTN0QxL3dVOHJ6azJ0VC9ZOUxm?=
 =?utf-8?B?K09QNDNIZ01Hbm5JZ0crNXVWWWE3TVU2d09RNGhzT2RDUjRVWVh3eUtiY2NM?=
 =?utf-8?B?Rkx2b3V3MWpwY1VVU3c5OHBsWkt1cmNzYTZzT2NnMnVDR0hTTFNwUEMyY1Zh?=
 =?utf-8?B?WGJ1L3R2SXZDQW13KzZUSFZoMEtlcm9CQ2dlVm1zajZwSUVHa1hETVhDTGhR?=
 =?utf-8?B?VlNyYldsY0xSMll1ZjZTNmNidU9kQUYzRTBlUGdNSEtqMXh5UWhpLzhkcFRu?=
 =?utf-8?B?MkdzWlRoMkhKaFBhT0poZDdrNW9lQklweUMyVE4rS3dLbk84ZnhYblgwVENB?=
 =?utf-8?B?TVJuYXZTN0JIb0VjQkNFczRjdldCN05vSHpnNTMxTHVyeVpVSTdsRmwxM0Rs?=
 =?utf-8?B?NUw0UnN5SFJlZWJQaXg3eHE3ZXNqakZZa1RpekoyN1R2UXZNdWlFQ0NRU1N5?=
 =?utf-8?B?V2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BRH2aUvLWrAmaQYl+7uVOf7hXn14weOvWBb/3fvk4uqYIZYnQHnlSjIkvPQhPDAY0clIxPd50HMhwhgZ6sGgcTYHI9tH759jKi1iNKpENNdZ29+kk+AoxMA4LDpsqsU+MHR9zPC0taTiO/PniYeUppawDI84GL/42Lx7SDd6sLDbQPcb9pbzeo37a5aTpucAnhkxFsQtV1d/04yNm9dwY48bp/wJ9eHcs5NKYMTTaV4AWVyN0lY9HuymtGeSbR1rlN70fASKlrYeQWbvT9X3+qxb3/cvnk6Zd1NDhE4FKnjVv4cQTFbaW22VM8COIMe0+ICKdo34osXDbcW4XH4YEheCPHDQsg+BGyiGkQKyNWtAC8Evjutg4ciGZ+kul0kkemboagkOhCPBMtulvZs4offnfNg1bP3iM/juitidIrmgqFGRRQYGMLJbBueyroGinqv/RfLGtXM1g6q0wZujEGg6b+/rAY2qFSMa6AJ7bwgFyCtCHd9vnQGSblsxjnxu8UAb0pcWMbm0VDhI264UW7HZRdaZ7pSM+u8HfQKwK2m8qQKeJqNJuKZDKbMXVjfAjp2KeA640zdOD1SsIsy+DTUqLnjGsUVrVMWOvwGFWmA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4125a59-4d34-4df6-57f0-08de03114953
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5439.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2025 06:43:11.9366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WFZglt5a6D+uYMd88soiwFjg1X1O/2uvbZvC+UBHn2DIplAC4XJIP52dlrvv7RYXfgpgXjYfmUp3ekvcY2RoI7LFg6bKZhr/793OYMA3Ybk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF73A72B96A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-03_07,2025-10-02_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2510040055
X-Proofpoint-GUID: zQH6cw-srnWMmj9dLyV5_9iB6xchIRT-
X-Authority-Analysis: v=2.4 cv=ecIwvrEH c=1 sm=1 tr=0 ts=68e0c208 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=IY90hut3vMWu1_8AoUMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12091
X-Proofpoint-ORIG-GUID: zQH6cw-srnWMmj9dLyV5_9iB6xchIRT-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA0MDAyOSBTYWx0ZWRfX58Mqlm6xikT1
 GZx6WIf1LI+b4ApkgqXUHyl0JLkTAUlv1pC4Hzfebr/weLtEPdN+Pp7ysh5YB06kdTFsv2EZgmX
 oUNfm0lC839YzZfn7/tfpuurSSavcOOfCnOtu5b5XpGeJ7XZGtlgm7Bi8P94IUvXMO1POVvJt/4
 H5YhQy3Qr9sjpXGvt7XMRY8Lzo7fQy/qpNoFlNoPVusl8j43j6Mijsb3as56cnhZ6z2iO7z0sWw
 j9FVLIu7u6BsHA4v5BA+mgOACqk9Xo1iOtfkTxhgOF7S8oMwGJ1a9GGgeRwpzmLgEMmClTEi90M
 5p+Ek7gmzmo3UJYjoipEJ/sOicAJWJtKEITfg352ddfukoLzQ97XHvanq69vobNJWz3RKWRPzMy
 iRUXrF9I9lacL7m3h4hlTcq59dLuiRX5DqPkbJhnn4pAGPsoBCg=

On 04/10/2025 05:00, Jon Kohler wrote:
> Hello crypto list,
> Working through testing 6.17 on our platform, which uses fips=1, and
> noticed that we’re having trouble modprobe dm_crypt, where dmesg barks
> with the following entries:
> 
> [18993.394808] trusted_key: could not allocate crypto hmac(sha1)
> [18993.479942] device-mapper: table: 254:6: crypt: unknown target type
> [18993.482967] device-mapper: ioctl: error adding target to table
> 
> Looking at modprobe dm_crypt with strace, it looks to be trying to
> load trusted.ko first, and indeed when doing 'modprobe trusted', we
> see the same log entries from trusted_key over and over again.
> 
> The test case on our side that hit this is a trivial sanity case, where
> a userspace app tries to do the following on a throw away volume:
>    cryptsetup open --type plain --cipher aes-xts-plain64 \
>                    --key-file /dev/urandom /dev/sdXXX sdXXX_crypt
> 
> This user space cryptsetup call fails, and we then see the dmesg logs
> as noted.
> 
> We compile CONFIG_TRUSTED_KEYS && CONFIG_TRUSTED_KEYS_TPM, and it looks
> like we're hitting trusted_tpm1.c's hmac_alg[] = "hmac(sha1)".
> 
> In my tree, I reverted this patch [1] and modprobe dm-crypt is happy
> again, and the cryptsetup-based test case passes now.
> 
> I'm scratching my head as to the right thing to do here, as on one hand
> I agree with the patch notion that we want to start the deprecation
> cycle for SHA1, but on the other hand, if CONFIG_TRUSTED_KEYS_TPM is
> enabled, we're going to run straight into this all the time as it
> doesn't look like theres a way to override this to use some higher algo
> 
> Happy to discuss and try out ideas.
> 
> Thanks,
> Jon
> 
> [1] 9d50a25eeb0 ("crypto/testmgr.c: desupport SHA-1 for FIPS 140") and
> 

Hi,

Thanks for the report.

I think this patch addresses the issue you're seeing:

https://lore.kernel.org/all/20250904155216.460962-7-vegard.nossum@oracle.com/

(In short, it's not that we really need to use sha1, it just means the
hardware isn't available for use with those boot parameters.)

There was also a more recent discussion around the patch here:

https://lore.kernel.org/all/f31dbb22-0add-481c-aee0-e337a7731f8e@oracle.com/

I'm guessing the sha1 deprecation commit should be reverted if it wasn't
already. Maybe we should just add a big deprecation warning during boot
if sha1 is used with fips=1 until 2030?


Vegard
