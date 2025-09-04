Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC8733439A;
	Thu,  4 Sep 2025 22:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757024481; cv=fail; b=fikUiICqRA6h7T5M1nwba9YtqAVPPEcV9l5xCf22vp67oGAIbtyg2csMmGpoRBOnYa2Z2EaQev/om04/AR/shvB08NUOu2qR7kNhoCsekYCLB055Lhr2khGxrmXQcHieaDqkE7Ylh8Pt2RtIH4mdmi/ECDt8gMIp1UbdaK87J+k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757024481; c=relaxed/simple;
	bh=qbcxGM4+URRQ/4pmCtkm92LWwbgoC5Ayhc7kbiZhLL0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BVWDchdmUrECH3UTn6qkOSPeFlrX0kzNd7zg/nWwTqzn7lt6lOodAoSGTBqfOu9k4cZa6yIj1Bn+bpucVVIIXwvo78MbvuRQKrgHIip+LhM5kahlsqvDbpZKORct9Tb+mqFL22HHTYxAoyEn0agS9pmCJ17XGe8bsYO9BAUm8NQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GhUk+KE5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VFj4whQi; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GhUk+KE5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VFj4whQi"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584MA4rc002852;
	Thu, 4 Sep 2025 22:21:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=XiFTrXqYQ75b+y2g6DxhBFIDbSdGNC9QAoR/YwR/pfw=; b=
	GhUk+KE5YR3Y0bDojlmzwXv31zDCmm16XVoFKhNvi5LxL7te+MxiHx+ARn/f7Ecb
	rjrguV0io/UiG4MYCmo8MVReve1NYlO9VVjhnKqsHjW+lxgPzvKVUTcHFBjl036e
	JEbXhoUm3i5Vn4OXSUjSS2I5sD7WlDIF9qhjrew2zbVuQMHN1frFIpuLrugKNTaA
	xq9iwKtMoZcMX2aualHmCgtUDmVOpBJhibgmgXW+ah+7h0CV3BXaAZ7EKpUW3zKF
	9/aGAsnjHl805rE3NgeAevKRlbLKVfZn0jlDPc8d7I5+Vn0rwpKx/Il2vdJbjGfv
	OpJjfF5xJ/NA9wNlC/fG0Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ykam00m6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 22:21:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584LkkZW031100;
	Thu, 4 Sep 2025 22:21:02 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012025.outbound.protection.outlook.com [52.101.48.25])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrc82wu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 22:21:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R14Pe1mCNs9aJeAXcXKirQPAXzOhkaNwBJidt0qQgJe3qt9fRQZ3VjUK7a0ypzfzKbTHxig9ql2ISm7YgCLWj4GLHmyef+9E+Jx+NebfZ3YV/F5hlt3atBG4bl/wjXPUHLOCn9/PTTKNeystcBC0bqdAzqzm0yBPXO0CGbin/xX0GjA6c+5E5EOGa5drg2g73jJynfvdG/rbAgiudoTEIG5VyCdL51TODNcoetE6EHlRgBQ491rRR+LdbhZjlgGz9bJZo27D5V1r4P4kzwelUPTZ3YgIS3dKMI9q73JDZU3ZBT5U1poVuBSVJtqL6qWCFVqo1/P+EvUNOFM5/HjgBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XiFTrXqYQ75b+y2g6DxhBFIDbSdGNC9QAoR/YwR/pfw=;
 b=SX5B7+DeqSiKqSVSv+QiLOfWXbdrUSeSG9Xg3x+uunpfIdHOqPfuH5PWswJG0KRmq7ktsQNeHy0hnxswS/Crl+h2hP5EZjZRuYQd6tdvicasMGDiSxnB6axqHU4h1SyI6Q01gb2uVt+gNZTblcVv9m269jWZT44yC27w/2iETyF5EiKBlwmLxyBvqER38sJagP5fK/J7aeAitiT+1c4ke8KFLYXiHBren6PNkNxvB2aV4d0lG4K0BrKIeArqIf5/4V6KevEAMWIyLzc3T4UP4t0XFXXqiZ2nb8RVo+wCtD3GMEmmOrK0Se3mSsZ55goNTHtZS/bNyBX4xv7pZwGD8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XiFTrXqYQ75b+y2g6DxhBFIDbSdGNC9QAoR/YwR/pfw=;
 b=VFj4whQiU4oPyNwJpDgeHsK1CeqN1la5620/eKt9h2aYBHsj/P632ujKXS1sABk46S2jQOgahTMQ5WGyn61+6Tec6Zey9SPTECkCoRRzkPLdI9H8Mc/+Eu7a/7k5GVoKGVfzZHJKCBQQs6zrlXSDvgjnHqrq/gLuGzz+dC9/xWI=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by SN7PR10MB6500.namprd10.prod.outlook.com (2603:10b6:806:2a7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 4 Sep
 2025 22:20:59 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80%6]) with mapi id 15.20.9073.026; Thu, 4 Sep 2025
 22:20:59 +0000
Message-ID: <e6fb19e4-632f-47ec-adcd-b9cc8d7f5794@oracle.com>
Date: Fri, 5 Sep 2025 00:20:52 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 097/104] crypto: fips140: manual fixups for
 lib/crypto/sha256.c
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
        Daniel Gomez <da.gomez@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Wang, Jay" <wanjay@amazon.com>, Nicolai Stange <nstange@suse.com>,
        Vladis Dronov <vdronov@redhat.com>,
        Stephan Mueller <smueller@chronox.de>,
        Sami Tolvanen <samitolvanen@google.com>, linux-modules@vger.kernel.org
References: <20250904155216.460962-1-vegard.nossum@oracle.com>
 <20250904155216.460962-98-vegard.nossum@oracle.com>
 <20250904213521.GE854551@google.com>
Content-Language: en-US
From: Vegard Nossum <vegard.nossum@oracle.com>
Autocrypt: addr=vegard.nossum@oracle.com; keydata=
 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 8A==
In-Reply-To: <20250904213521.GE854551@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0033.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::21)
 To PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5433:EE_|SN7PR10MB6500:EE_
X-MS-Office365-Filtering-Correlation-Id: 8182c99b-6c1c-4332-32cf-08ddec0152dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VnFxVjRJUGJnVU9sZUpkd3Z3U3EyNDhpY1VGYzF1NkFMeWRURDYrMWJmSVhU?=
 =?utf-8?B?TXdKY0RoRE9XcjZyWG1keGJNelE1L0VTV2NjeWk1N0tTWUdoNmFyMWg4c256?=
 =?utf-8?B?TjJPUmFOK09ySXlaUFhuZmZGRVZYLy9qZXR1RTJJRlNMbzU0aElBa3QrL3NX?=
 =?utf-8?B?Q0M2aldDK3Z2YTBLYm4ySFNxRy82Q0RwVThXTlErWTNlaHNobzl1d215QkpO?=
 =?utf-8?B?TmgvVGRnOUR0ZVNobWZZZks4ekJqYzVwRlZJYjdLUXc4dU9jdll6Y3VBeHZ5?=
 =?utf-8?B?bmJCdnUxZTNkcUduZVJhU1ZHU2w5aWZRZ1k1aEdQYjlQa0tqSVBEVVFGaDVv?=
 =?utf-8?B?UE9qbWt5eWZYUFlXeHBlSXlFODRWMURuakNXdWE1TXJjQmdNMnVKeXhuaHpM?=
 =?utf-8?B?Nk1xcWFnbXNvOXYwRWxSTzF2QUczazBKWExNUFZpd2dvNm9Janh5VGV4QUF2?=
 =?utf-8?B?REJtYVlIenRKamZESi9ISi9EaEdBYmtNRVF2NDVmcGQzRFBJY3dqTTZTbFUy?=
 =?utf-8?B?SUswSXJGbFNwSlppdzV4ZXM4MWRhd0YrbUJ6bklpbmE1ZVA1TVQ5bUxxMVpR?=
 =?utf-8?B?d004aUtQOTFFQk5Sc1VsdTNsbUN2TGNNNUQ4S1dUeG1zd3F4cWpFc1JBOFF1?=
 =?utf-8?B?S3h3bjlnM0lGanNTNkRXRnJ3S2pub1NKNGhBUm5xQzBQNjZiOXJtTFltei8v?=
 =?utf-8?B?V1IrNkRPVVk0cnEvd2lySGV5Z3ZVTm5Lb25IbHdoWWJUd01tRFVadmZFYlM5?=
 =?utf-8?B?WFRPQjNwd2x1R1F1aFIzcGZrNHM5aUhLNHhOOXFJc284VmdnT2NBZUtjVVFP?=
 =?utf-8?B?ckRCdmtwSDUycHhGQ2hUQVFlM2JHaHJ2RnJBUDlWSUF2b2xDeEFESll1UFpQ?=
 =?utf-8?B?U2ZCVklackczVEN5SmU4MzZZS0NsNTE2MWpKN2RYZUQ0MjMyellNNmR3OTNJ?=
 =?utf-8?B?dXlmTm51eUhHOElvMU8zVldFdExnbmcvdC8vdnBJK2gvd3F3M1dOUFE2U28w?=
 =?utf-8?B?bTJNUDFBYmFuTkZuOTk5TWhkUmFHWm9hM0VFdlBXU3BGejV5Y0JmSWRJeEZo?=
 =?utf-8?B?ZUJHblo2Ty9PQ0tvdVgyaWd0ZlkwV2oySzdzaCswWStYZStna1FpNDRadHBw?=
 =?utf-8?B?cFdwVW1NaTRvVFpuSmlQa01hdzJvRkF5c1d1SEV6eUhzTFhvTG1oUWRtYTYr?=
 =?utf-8?B?UkNwS2thaHpVWDA4a1gwaGZCVlp4SjREY1VzSHBwYjdmTncwQUl0c0ZHVlp0?=
 =?utf-8?B?MFRndk9wd1lXVjRDRGRsSWgzT1lhWTAzM3hvaTNWRTd6bmpCbWZ1QzkzK1Qz?=
 =?utf-8?B?M0lseWVUdVM2dENuSkF4UGx5TzMxbkFUUkt4R0srSkFpbmZ4ZE0wMlRHUjdC?=
 =?utf-8?B?ZTZXcUZCYkxpTEdBSzBnNXRqSGxFNTdwYTBaRDNJc3REMXZHMklNZ1BGa25K?=
 =?utf-8?B?U3h3dnYrRSs3eWQrQ0FQeUg3ZllENUtSVTdwQjRmeGx4aHMvcS8rVVFwNExY?=
 =?utf-8?B?dDdhQUQ4ZUZRaXVhb1ZKWXdFTnhCVlFLdVEzMC9NcEpaRnVYRUZwM21yM0pX?=
 =?utf-8?B?aHdSa3c0V3A3MVJCbnhlaitHUStkb1N1dFlWK09TNi9BR29XODVjaFhnZmFh?=
 =?utf-8?B?Tlg1MWxLY2hwN3k3T1pZSmUrZXhveEVlQU5DVi9xVzJPdlpiZjlFVmxnMFBn?=
 =?utf-8?B?TEFaV1AzckZhM3ZyR0RlMitnbGFkSUZMOEJMV3FEZ3pXWG5LbzY5cm53cXkr?=
 =?utf-8?B?ajlIS3o5b1I1WGthUTVXdlZxUjFJVUNnVjRqbUJwQjhXZzFHUzk2eVZDM0NG?=
 =?utf-8?B?RHBZNVpONDdNVkFvU01sK1pkNkxVa0NuUXBBajdCZEFGbDU0emczM0FVY01a?=
 =?utf-8?B?NVl5U2Jrd1JVdW5hNFlkaDJ4dkJkUnR4TGYwbDMvZDNlU3NlTW4ydG9XOE0r?=
 =?utf-8?Q?OgkXUJhgdNw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d3dFUkZDOE9LQ3pkSmc4QVZtVzN5WldDcjRlejVJQzBGMm95WE4wWm13cFNm?=
 =?utf-8?B?MnpEZUZNT2xsa1JuTHRzRGN0MTNLRDZuWmEyc0Z6VVdYZW5BSEc0RFRkUU1w?=
 =?utf-8?B?U2FndndkQThzYldlYlJwY2VYQVpwTUJKRjVKRytxWVh2d0ZyeGdIUW55c0JQ?=
 =?utf-8?B?NEJWUkM4TEw2azY4b1FqcndwditwN1Q3cDErU3lrN25Od1NCOFc2L1FRci9I?=
 =?utf-8?B?VDJ5dTlyN2ZCdGd3Y2FMb29GQVdWUkh6dWNlWEtKZVNFQjRJRmdmZGZwZG5q?=
 =?utf-8?B?OGNCa00xTzJxKzlQQTRJZXN3TWczN3ZDMmY3cHpGR3VIdmJQM2tjeHE0NEc5?=
 =?utf-8?B?SGZ1YWFoY25MZXNyR1I4NnBUZGsrWTlhcXpOZHBJWUhZczNQUHRHVWlyQksr?=
 =?utf-8?B?dzNjN3dHanlHWHhMRnprT281cmMrMjJNVGtoYXBNK1BjeFVRdEk0QWVPK2ZH?=
 =?utf-8?B?YXdHU2syWDFValR3Q3hzQ3gvUjIyK2RuSzc3UnIrV3IvUmZLVHpIQmdQd2w4?=
 =?utf-8?B?aWRhckFhb2JqUWY2RmRxVUk3NXFHalNLUWpaVEVUbEFPanFzTU9CV2NiM2Jz?=
 =?utf-8?B?bDZub2NUcXdHMzFaa3lqV3pKK1o2S2R6cGJHbGEwUTM3TWNNMS9xWVc1WFE2?=
 =?utf-8?B?emt5RHpSUkZ1a1pEYitqRHVtK0ljOTUram9iY3AzTWJxbVVPV29lODYwc2h2?=
 =?utf-8?B?ckxkSWtDRWo3U3dCVjZCWHBkaE4yMURjMmt0OUsxK3M4TW9vZHY5RjRNYjV4?=
 =?utf-8?B?dkc2ZXQzemZYOU83NnFIdEhOaXBBWU9zUlhPMDVrZW5KaXZtQUV3QTFqQ01M?=
 =?utf-8?B?SExPUG8yVk1nbW81QWpzODNScjdLWGV0S1BrWWc1bWw2UHRCZHJEQVhXa0Y0?=
 =?utf-8?B?aHoyUE1vQVkvTDhLSFJOdHBsWEIvaVQxcUVUb3I1MUNUeFE5czhZQ3h3WTZm?=
 =?utf-8?B?aGRHZW1Cd0VDaDA4REt4RGF6aTBuRGM4YXlIK1RxUlRtY085S2RhZHQvOEtY?=
 =?utf-8?B?MkVsVEdiVUNNNUxPSFV1SHdsRllzSk00eHZxWnpydTA4OEJQYVhWQ1FFa0lm?=
 =?utf-8?B?RXozcGlaQlBvK05sWXMwRUpqVkMzdkJnalBjSThySGhEQjFDQkhNalF3NVZU?=
 =?utf-8?B?WWJZMHBKdTZ1VzExZDBVUlhnQU9zZU5paTg2UldCeGlOYXNKcWhPSCtrM0Nr?=
 =?utf-8?B?ZU1HSTlIOE4zZmV0N3dLWlppUE5PV2g4NHBnalZqSkFPZ3V3UHlxUnJ0NmY5?=
 =?utf-8?B?WUZxdW1RdGEyUC9BeklwQ21BMWNBUHUzQ0QvZmxCeUYrOTlBbUhWZVlIcjdY?=
 =?utf-8?B?WVNmUzBwMFN0QWVuWHFSTitQNmx2WFJmYlltWTdJNERSdi96YmpRTDRCaFEv?=
 =?utf-8?B?QU1oZVhWQ0diSEZFWit2cVV3OGlvYWtMU0Q5L0pWRlZNQ1dEc3lDaHRqRVB4?=
 =?utf-8?B?Kzh5YmtuV2FzMVhyWTVzUUI5UEJubXl2Vk1Ob0pSWkVCa2x3R2h0b1pPVEpP?=
 =?utf-8?B?bmxtcktsRkhKcnZaZlEwTFAxOVVrYzQ5b2dTTHlmR0FsZUZtVzJzVUg2V09r?=
 =?utf-8?B?VTlzWXF2cVNwR05PRGlPTksxWDdYZzZtN1J0NW5WWUFBckQ1SDB6NmhaTjRp?=
 =?utf-8?B?Qms1VldtRkZWZjh1OGFzdjdOZDhWWDBMVGQxeTNjcTZWbjk1SFVIOWRhenBj?=
 =?utf-8?B?VU1vWGFxcS9nN1RwdnlWakxnbTI5MFRiZE5zcWJ6S1p2UjFHZjhYTlY5Q09i?=
 =?utf-8?B?WVJXQTJ6bXUwNjRWMWYvTXkxZzNUb0dCL3YyODI2VEhlU1NnU3FQSUEyME0z?=
 =?utf-8?B?K094bDJXNlVUcGt5Sm5IS3gySW05K0g1SkRyNkZlM0xaU3BuOWNicGd6UDZx?=
 =?utf-8?B?YXJVVjhUdzVZKzlLSUs2aEVlc29hVytnaEFZS2J3TTFTQUYzeFNSOGxVeU56?=
 =?utf-8?B?bW45cW9WZzhoejF1VVlZUmVuTmIwRllYQ0pZYmFmeUpMUnE5Zkw1RVFtYjZi?=
 =?utf-8?B?UFhSQTQrQzlRL243SE1YMWd2SVg3ZTJic1MzVjhaU2RXQlNSRXFMaWJHejlZ?=
 =?utf-8?B?S0RSZUkzNXZ5ZFJVRktud2hXMmdpWC9zcElRYytPcjJkVjZiTFhGV1p6b1NS?=
 =?utf-8?B?MTlJZkFlSzhwMFY2NXNsUVdkRDBjRm9EclhWY3VrL3gvL0Z0RkNCcDdVdEw0?=
 =?utf-8?B?ckE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wgqrqDH3RoYIjE2HZk8bup9AjOI+zqwazs5jGkPrag15twaxpt/IhiaC2O1ANnDlWS4kkjG6/QeXnRnCY/5061DIcS0lc/mG/k12QQm6T4OPhloMZOAWuFPLM/GguiS+nNx167pEak8VPax/kZTVfYGRumYTW0K2MeGanO2GCh2QHZ7GNrPaiW93OUvyKQWTxZAC7q8VlG1lpiNa4C5PhaQg10vbezrzRNH1s0RcIENZ7u0xdCzLmeRqjULJbuqaKtrJwPedHvfygBDudfyQnuzrGzKS8rtbudCYf/EFN0Tp33F2OwCKhkhKaLPWQ1sxuns89wJLOVpoXJ5YU/7zoBPdjHd4eqPmRVCGlh0i3l2rYAVe8HM59qMfyKDqnQYF6Ciph1B3/XAjvjOvYdBlwKOufOxmncI+bwEpEfqx3PkU/3Dnzcmwvh5vSxaMBeFYyGq6uMb+uryz7D0/oL6uD4z/PKZko4BGc5TdUh+Q/wnruT9SnsMwCbmn0vkiJiYZIvb2eYJhjh9hbJnt3sp9Ox9F6BfpE2VolYeYAMOw50pQhJeO/HrUE5/J0HbXHKU5jpaIaqOxbVVzk9DtxXXilAMjpaiXny5k/mnM15akF10=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8182c99b-6c1c-4332-32cf-08ddec0152dd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 22:20:59.0211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gBwC1u8bVF21a1fZQy5eYAt+zNU0tkoBecq0ZESfzmf8+M75ikag02rMG9mAHW1Y227YPwHMvgZ8EaITCOTyK2U3cqCL4cA8z2ZbcTB9I40=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6500
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_07,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509040220
X-Proofpoint-GUID: dEIllILi0tGyC0XCnsJByNpfaxuKH17A
X-Proofpoint-ORIG-GUID: dEIllILi0tGyC0XCnsJByNpfaxuKH17A
X-Authority-Analysis: v=2.4 cv=VKXdn8PX c=1 sm=1 tr=0 ts=68ba10cf b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=JGSo2CHqDGtcXRZwod0A:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13602
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDIxOSBTYWx0ZWRfX/PWkcTYLBDX2
 Cr5iFsjAsR7CCQejtBNXKMwEMyHqSzPSrvrHBKUoIRasP5fc+eZTw5mlzuaw0XlQ30psYHk5ThK
 RtUkRpMhNBA92cqpSXf2SFle02ydk5M7i1GjrZrzu14tY1OYsAauaDEmLsipql6HoNwEDsoyIDI
 ALgFuNIth0JGOusoAGJjrIshijrPXoKHNpfpgnEvKxTa3nAjQw8oVq+4nehgtZ9VQLGBZWCCH1y
 z1HdQbUfNtttotZlsLOG39/GOO4HLDbWNzECI66hY5N2ARjqibz4SLp0XzgE6qDEBj+yx6rJ21w
 uHfVXwQiNGNV3u7f7iu5Ju1eyaZmIh4KZC0Krlxqmg0zTI0QMJYqAsbMUuech3zi3hf+esSzXqn
 HcZyB6YLk9zkzzrOuHWvoxoyNhfhFw==


On 04/09/2025 23:35, Eric Biggers wrote:
> On Thu, Sep 04, 2025 at 05:52:09PM +0200, Vegard Nossum wrote:
>> Don't build arch-specific SHA256 code yet when building the FIPS 140
>> standalone module.

Emphasis on "yet" :-)

> I'm afraid you can't just not support the architecture-optimized crypto
> code.  It's usually much faster than the generic C code (often more than
> an order of magnitude faster), and it's really important to include.
> This applies to all algorithms.

We can easily support it with the exact same method as the generic code
and in fact we do this for the 6.12-based Oracle kernel. I noticed that
the architecture-specific crypto has been reworked since 6.12 so I
decided to drop it to keep the patch set a bit smaller; after all, this
still results in something that can be certified.

I think we can start with the x86 and arm64 code (and only the subset
which is NIST approved)? If anybody has a need for anything else, I can
add it to the patch set on an as-needed basis, let me know what you
would like to see there.

(It might be a bit annoying to deal with the CONFIG_ options for the
arch-specific stuff, but I think we can handle it.)


Vegard
