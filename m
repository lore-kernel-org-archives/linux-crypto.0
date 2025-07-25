Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C72522A4FC
	for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 18:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753466757; cv=fail; b=RxIriOjQeWrX3z/8LuzbtHM622ohotTkRvcO/qtiBzXjbbRtP9XswD3+FoWhv1G+O9lOHCGXoMdjs8Ld9rSA/Ulyr7GrXoAKWvLNBPiUx9UAP8bWzg1ce2DpKPiCjFegRQkAabKIy6szg8eJTXxAm3RRSJ2fzJzz8bdvLS7qFBQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753466757; c=relaxed/simple;
	bh=+gytv/uqNvlwOabEKjl7JGYuCcHOMCOBZTuL+YMxI0Q=;
	h=Message-ID:Date:From:Subject:To:Cc:Content-Type:MIME-Version; b=lqgeeqwqsTY6955xDyWG1AALbwVED9jwWnWz7mQXYfKRZos0oaYsivY/2xGWV+lLztK2wPzSLD+j8Y/RmCpX5NFxKNL9lUCwbTbJ2fYbFtzxUe8Wq0NY8CSGpv2XEi24TCN7Tjws4FncoEPGOE7itl0vqe7xP/iobSA/6cUtA5g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kbzRmFtE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cSnKDpAz; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kbzRmFtE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cSnKDpAz"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56PGC8VJ013262;
	Fri, 25 Jul 2025 18:05:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=VWM8SN7lFLNqfCzd
	427AxxWcpVl+8005c6sW9JvCT2k=; b=kbzRmFtE9D+dZoGAW50g9jOSAWSsl6rF
	dzMZUde+MXq3TPNNR2iHAUKYAVN8Qb7CfPp+7o4DJAykYwKpNAko9Z/dbeh4k10k
	Q7U5W3AYqWh6kr4LvJiztMlEXoId1CtSQpHe6MlRL4/sMXjJfy6bCfH7Si24TTPa
	ln27+nf8lMsKVUoKqQvaO+zT+qgcPx2t62yiSvqrxnT+t334k1Nb8ABFspHLI0RQ
	nrsRtj+Dp4LYwpbnRQFRlbELUCZm7qoy1fZzji8jbOXcCq7ftxnsAZBRdwQgVYAn
	bSt4Y/BpdaYogRDJsA6OSlV9tUVMIfJhNYVgU6HqmyS9lFuzUirp4Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w1h1jg6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 18:05:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56PGOl0Y038327;
	Fri, 25 Jul 2025 18:05:37 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2046.outbound.protection.outlook.com [40.107.94.46])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tddv5t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 18:05:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VFaK/b8+onvAfRZt/OK8RCeRbGakTapDZH9SR02tAmuqtLl9E6kj26pP7/QTbAJUp6MY8mP1ofq2QIbCC41AHy5PZFnq7eds4V6CU7v9UR0dlN7sM6YrNpRKPcQLD9b8vRPkh7mgMLUPUQTGW0Yj0ggm22tktR+Fy/YVhoZvgHKLevIx9pQ0qNhi5yrrmBqOxOWwxzrPn4U1L27J3WvQyuSlPkZ7JJbf1aKtbHg/zdXEc5DAk+Yb8fC0DtMxXV+LTMzuw/KyqAq3A6mqg09rWYSYbcBJhCfSuLy+FMkEbAZzuFRJ06Qiko/rJnXmev1bUazunvlE20JhYx1N+5S2hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VWM8SN7lFLNqfCzd427AxxWcpVl+8005c6sW9JvCT2k=;
 b=qn/sKR1yh94i3rfiAzk+tbG67JzDr1nV21UZ7vJukMmXyr0uRHTerKftUBH3kI0NjmDZWZM0qruwVcTHX08lrqCdPBrPL5HUjP2u85DbJEmJq08FRUwcvVaE/HXDlbAhqtCHafxXeD2GzLakOucYHRkoAr4LxCCBEVAJFzs8S4NE8ZCvZuSBzo3iTYsXGFn3lrQsNIcxSo3x2GGQRjsa+SnwwbB0tjMkby2ytV3mwsPnOZggBb6j9J9LrI8vnQH9qOqJojCl9PoJTzxn4+zFLJoV72u5KQH0/3YciAmS9ZLI1kpuVtEJL4tRFyh4Ia+cEZdwi8gRXQZCpiXBO1TOUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VWM8SN7lFLNqfCzd427AxxWcpVl+8005c6sW9JvCT2k=;
 b=cSnKDpAzCth7f5ifX6Vpdr+/N/E2eFI74RXRZIbUszbzWdQuGIDoyDZKS4cwWpKe9YDDVAtgG1E0u3ZrsRbfIe50+KBhuoOa/c/UTQ2x10+WvRBqqbRGoudTnx0umYsOThcACJROXtzUhGKvK6qdK68CUySAOG3nmyxYmuFMmOk=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by SJ2PR10MB7811.namprd10.prod.outlook.com (2603:10b6:a03:56e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Fri, 25 Jul
 2025 18:05:31 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80%6]) with mapi id 15.20.8964.019; Fri, 25 Jul 2025
 18:05:31 +0000
Message-ID: <4c0e7a68-254e-4f71-a903-952415c609d9@oracle.com>
Date: Fri, 25 Jul 2025 20:05:25 +0200
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: crypto: template instantiation (maybe pcrypt) bug since 6.12
Autocrypt: addr=vegard.nossum@oracle.com; keydata=
 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 8A==
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Russell King <linux@armlinux.org.uk>,
        Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0005.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::17) To PH0PR10MB5433.namprd10.prod.outlook.com
 (2603:10b6:510:e0::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5433:EE_|SJ2PR10MB7811:EE_
X-MS-Office365-Filtering-Correlation-Id: 23a5bded-7da9-42c7-1b93-08ddcba5d7d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OUNDdUN4L2F3N1J4S3JHZFJuSkNyQllDOEU4SnZoWEV3MDMrdkRVb0VMMFZU?=
 =?utf-8?B?bHBwYXhjNkQyY2VRWC80WHozbjdPMzFHUlpIaVdUMklROEJmR3RoOEx4eEtv?=
 =?utf-8?B?eGE0cmdOS1I3ZWhVVXNvcURqYzJKSXN4NUVmUms4OHNxdGpzdkVEL3JuTkdn?=
 =?utf-8?B?UVhpa2NlMDRFWUw5bFZYbTU5V0lLV2NmRmhjSXlybmVxQklHcHBFTzRwTnZG?=
 =?utf-8?B?QkxvNHNxNmNHUXNva2lpNTBoSGlUUlByaThBdFB2UVF5VWd1M1FhTE9Eckts?=
 =?utf-8?B?TkJKU3pvT0JlZ3ZjckNKcGVFakVyV0Y0TVFDVkI3VEhFU0hoUW5HTlROOVp5?=
 =?utf-8?B?c3RIZ3ppUVJQenpNK0V1b1cycDVTOHFCRVViNjhNelJkUlFSUWYwRnhCWVZv?=
 =?utf-8?B?bG0vVHVHcmZGekdyanIrbFhDeUNibzRjY1p4ZUYvWndPZ3gvTXMwTTRzOUVL?=
 =?utf-8?B?a2ZTVnVmTHZGRklPVm40bkU5dDArdUFNNi9zM2gvcFQ1U1ZRUmtCOXVZVmZn?=
 =?utf-8?B?VVFibFdzVjFxVzNMN0dLMUp1RmFvU1VGeXRPc21oaGpuelpnejN0WGtWOGY4?=
 =?utf-8?B?UjhNVDU3bTNCT2IyZ0dnNXhXYnIrbmYwSDdudU1JYWxhcDB5TXN6cURrTVEw?=
 =?utf-8?B?NDRnQXRoY0grbXVhb29TOHpzRWVpeGxjMy9nVUhnYlFzSTI1YlRJbVhYN1Va?=
 =?utf-8?B?WFRSTG01Y09xRnBmdG1rSTRoNENDWjRUdnlWNyswWEJ3V2hYaHAxY2dvbllN?=
 =?utf-8?B?T1oyemhDcXVnUFJYSjFkNmRzdHVsdXU5NG9mWjY0UytOT0ZRUXZkdDFnTzNF?=
 =?utf-8?B?dXlZRm5POUJLRlRIRUhtNEN2L3U2b0JFUldrZjNZN0dCbHZveDZaSytVa3NV?=
 =?utf-8?B?R3Q2VFY1ZWVhUExwZ3JpKy9kZUJXME1PcXY3KzNXNWVSZFBuc3R2WmJRN3lB?=
 =?utf-8?B?THdlSkZvV2VxS0tJd2dFT2M3bEd6dmJ5WGRwTnJNQlBiL1hVa3JKKy9HeW9D?=
 =?utf-8?B?Tno4V05rLzQxb1U3ZnoyWERwTFFodXhhb25OT0wyakFybTdaLzBPYTR3ckJ0?=
 =?utf-8?B?VXBxdHh5dHhYcXNxNllQVjlXUnpkeUdpc2cra0NYU211VmtJTjlUckJuUExy?=
 =?utf-8?B?RTBkUVVRempkY3hlb3dReUlXZjRUYTNEeDczdXFDSEFlWmFyUGNtSTV5VVdl?=
 =?utf-8?B?L1EyUkt3LzBkQlNjdzM3Skw0WkNFWUM0MEJWRkc2bWJad2FqY09vNHJxaU1a?=
 =?utf-8?B?YklERUZ6MWJCR2p0RjZBRDlMaklNK29WcXdZTHFNc0lWVlRRa2xoKzlBZTd6?=
 =?utf-8?B?SjdYMVdzdklHNTVyZjF2dXRPdERsSzk1Y0xSMXpRcTJQdTYvbTIyRll3di9F?=
 =?utf-8?B?UFRaa1JQTTVaaTU3TVN5R1dqNFNHQjJrSG4zTU4wWWwxUXp2TGwzK3AyRlNQ?=
 =?utf-8?B?dzMvNE80UjN3MmY5dlF3a0pjOWtscFRDRHhZY0Y0Qk1scysxSWNrQWwzaUxK?=
 =?utf-8?B?QVpBam9NUWRReUR6alB5NHp2bVlwOEdvWWV3OHZvSmtxcVFncXV2ZU9US01L?=
 =?utf-8?B?OWR1aDNlRWpldDBBSXpSNFpRbkc0OGFPTENzdkx2b2YwdEdhbElUTnA0ejhB?=
 =?utf-8?B?eUZ4MFRxRmV5VmQrZlp6UXlyN3ZJNE1YdlgyUWRuMUQ4OUlQWTYvWG83Uzli?=
 =?utf-8?B?TlpiU1lUOUFIQkN3MEhVVTlaalBFYktDblZ6WUxjQkFNMHJodEJiV0dBOVVm?=
 =?utf-8?B?YlVJcEhXRWVOdDI1QjNCRTFISGJuNmVwZndTd1JEN0JrL3dYaG1kMkhEaXZM?=
 =?utf-8?B?OFNid1UwdEEyQnE4N05KN0k1UWdDTkRoL2trVWN3UEhORkhEd0VhSDYvSWd4?=
 =?utf-8?B?N0tTN25zQThhRmlXd3JDTVFJYk9lRWcvQ3hpYjhSV0ZkMkdDUFhZVk5WWFUz?=
 =?utf-8?Q?pwHoOnPG1qc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a09ORXhMbzlpcWdndU5hM1lVNnF2S29WMEwxVVkyaGVVVkc4emRGVDdXUG9i?=
 =?utf-8?B?UzB2UjVCcTVhNU1PMTBXU1NjRCt6ZURIdTlMMlBrRG9oMnZ5a0F1eGVSZ0dW?=
 =?utf-8?B?NzBLT0pOT1llVHRrSXlnbUt6bm1GSEpGaVdIS3JUa2hnZzBTWFRvK0FsemNJ?=
 =?utf-8?B?ajE2WXkwOE1GemdGRXRiQTltekVmOXNSM29xRFVqbXJUdzVHVXpuSnEzT3Iv?=
 =?utf-8?B?WW1FbU9nekhlYjY0Y3hieGM3K1YxTFFxRTVEY1hBSldEYkZ0bmV6YlAzYzJw?=
 =?utf-8?B?SVZqSGd0Z09Za2JBODZnVURGbU5pRU95ODhQbGYvQVl5SGlBbWtrU2VXOUcx?=
 =?utf-8?B?a0g4eDJtNXdZQ2JyMzdSZGU2dVhpQkU3NXl5UElnRnNJQWpVYjlrU09uZ09F?=
 =?utf-8?B?dFFwV2ZXb0JYR25GTldEZ2xWWkhCZ0dScTZsY0IvdnVhZlkvdTdqSjZCcnk0?=
 =?utf-8?B?ekZmSGRpWjdaWWY0ZTB4cm8rdXV4YTNkL1EzeEE1U2hDY1djTWNDUDliVVRq?=
 =?utf-8?B?dng2aXFYTG9saVA0K2g1YncwR2N3WDRJSU5UL3RzT3JVM2dLb1pNNjV4VUZQ?=
 =?utf-8?B?NDNia2NWOE8xY2ZJU0Q0amNRS2F2Q0JTQVFWTWpEQ0lGS24wa25PbGpuK2FP?=
 =?utf-8?B?eTdETTZKa3hWTkxiUkkweEd2ZjhIRHhVYUtGaC9FaktXVmp0Vzlycyt5Tk1U?=
 =?utf-8?B?MG55enBpYnJsWjNMS2VlQXVPaUdadjVwdDI0M2NlcGRHRDFYQWp2KzhLYUkz?=
 =?utf-8?B?Z0tRdjZNRnlZSW55K3piMGFIc1R0cmR6Z2pEWWk0UFBaeGlDSTErdllnZDA1?=
 =?utf-8?B?VmlFamFHK2twd2UzTFRndkpnTTlqb1BzSlBDbVd5ZmFNOVdRV2tnN0tRVjRW?=
 =?utf-8?B?UE5CWUE3L2luOVZITUNtYS9wUjJkRXA2U3RQdGdiNHFvbVNWU1BxSjYrWHZn?=
 =?utf-8?B?NVBnVDZYQkRQb1VrYkFLRGNPYk9Wam9IVHVJVEFSK1YzN2VSWDhMeXcycGRY?=
 =?utf-8?B?dDhPQk5NU1FENnkxakJFdDlJMEZxVXpSeXEzOHVkSUVaUVlNY296T3JEc0h5?=
 =?utf-8?B?UXFISzUzNFJmaVlFbWgxME5iekxwSDdZWkZJWDI3RFIra3ozblhFWlhhRm5s?=
 =?utf-8?B?VUlWdlBuOUMvZ2ZFTnYzQkVJZDZUaUNUc3NDcDRIc0R0Wm1tYWphYktkL1BW?=
 =?utf-8?B?TkpDdDlxQXUyUDFPWDhWZlpQTnRpbkI0TXU0RmhYOFFTWFlrWFQyZGlUaFBo?=
 =?utf-8?B?dlhqOFdFMHFtekJxNC9BMEplbFFRc08vdG4wR3A3Q05SdEFoT0tmbjhIZG5F?=
 =?utf-8?B?R0x5L2xGZW5mZ3RnLzE2U1I4THE5ZzlmR3FtSzAzWFV0anRRTDExOEZLbVBH?=
 =?utf-8?B?Qk14TmhadllzV1YrRlRnMHRFRGVhYy9mbGYxdzRQaE15UEFpSm9hTHJnUk40?=
 =?utf-8?B?TXJKRGlOM053MHViVEY1K0RJS2tWRDF1SXJVS0hYOXFXM0R1WTVTK0w5by9t?=
 =?utf-8?B?U1JNVndZQzhCa3Z1QmN2RkQ1SndDMVJXYks1MW1JT1AwYVViY1A4VTRLT3U5?=
 =?utf-8?B?NHR5OTlzUnBML2JTSkpPZldzNENqN1hTOFRuOGtBVFV0bnpoTTBldGt4MzdW?=
 =?utf-8?B?QjBpVTUvdmZQYXRJMGlyQUpmR25EQmZCOHozbEh4cTFNanNMMmFtNUNKRUF6?=
 =?utf-8?B?ZklXWktiQUVuMnRNVWVLQ0dDVlFJUHZHdENHZHUrQUdWSW4xU016akhvOVZi?=
 =?utf-8?B?SVlGbmE3YmVLYTJONWQ1UVJDaGxZQTVsNEc5VUFqMjVNaGhMZUoyQ29oWnA4?=
 =?utf-8?B?SzJ1eXVxNk82L0RxWW5BQ0x3UEl3WkJiMnE4RjJ1RURCK0FuNzJwTCtYTEI0?=
 =?utf-8?B?dkZVQldNT1p6L29YT1VncjRQQjBiSlZ3akxnNFR0MWY4QWJ3QnhYS1dHVUNu?=
 =?utf-8?B?UUczdmpUT09jOWlIaERiY3B0SWFIcktoV3ZYQzBaQ3IyWWZFK21GV3RzS2hs?=
 =?utf-8?B?cGlKV2QwZWRjUXg5NTl5aHNOUWFycHBKTjRwa1pZbUc0Yzdjblp2RFppQlJZ?=
 =?utf-8?B?Y00vSkt5RmhQVGlJc1Y4NFpKaHE5WW5MRnJsMk1URXlxem9Fc29nTmtmSHA3?=
 =?utf-8?B?Ymk4a01Gemd5MjBWdkhKUWczcktrTEI4bFBHcW50RDBSVVVjZWw0eVlLbU8r?=
 =?utf-8?B?cFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MuXdVQIuRbEm+ZlZHBLKiSJCCiEjjqbwQT+6Rlei2UL8GKo4VBX3CcZB9U+Q+EyM/+NnFGuOwX/jvxvuHNcxyUhzri1Sjz5BWMDBpl/GelFOM/lihvhx43HF158g/XMOcxCxi2x8+GJVbzvcfbKco+kaCdTQdwjC/HHJSjzI3tdJed+j7c1P3knaQHVpcDxHFNT7jKymwYTuIKE25SbzScHH0feMGwOAJjEB4qbjxrFHr/pYmAkdLYrVP2ctLmcC1pNMg1UiXyi3jTQaP8EnZxKMdC3lGW+bOIU1scnKs+UvG9jWS5eZ/42Oc6D4NbKkcXjvV5JgThLn8LBbhbYADwglsSzEKY8h+H7zkM9Wgbj2m/wAlXFjCPY/s4zBtOmw2i41G/lXsxTfw0eI7S7SnXItdzxGpzMvqOel6etrwIDcfBMJ5OPJ0NQMiiIFJbcal4xkf4KvbWxgNSdm3GtL4+Rtdzd4unl9d0nDROZUZZhgHA9zgxPp4gJjOBXqqtHxPGVuBjiK/aSaYrynA5/tmb/uszpuZXy5OnXENjR9JnJkbbIuUHUYbQMzbJXqeo/hxoZt8qzsn/pTgjZ5ZsrRUCRqj3gVmygtaJfELo2pG+Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23a5bded-7da9-42c7-1b93-08ddcba5d7d5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 18:05:31.1124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GKur69tePx3SKBE7tPS9kDsriOCYZ8XAB4DCikv4Wy4cw+PqvLy2Zu6pK6iBMHX9isWo+ZwRwD0qr4Rtmg2/9bVXViiX8GT17RBM2hPDnmk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7811
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-25_05,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507250155
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDE1NSBTYWx0ZWRfX36YiiQJJ1hUR
 Wc8YDLf75yYkRHjsFPAqPmSRvwAEFghV1A6VBeSa8QlzSGxJMhivczgbVFs0MzGyEGeHharEtdg
 DpgQoC9RMc1d5MljTBUiKzjvKlfSn/1aEDPeZTA6KVT9/XycJkUwuAUq4Sx6iH7LAXVoFwyNZtP
 a8UHng+Qpf/JqwFEV0McUSDGIqZHIFJndToHXXqKPQG4A1/Pe00DSf90FBInZvLDG2C3afXGIu2
 Qcyta0cdGq3iKu+o0CbOa8udwddSUdxVWCDZh/SOH9aC4xWL4/X7U6T+EAq6fO+lOlIVhtnLreP
 lpSdorXxwn5fZ4oLdmqEGCqaQ705sJdrSHCPboiz9/nrIJlCke5PdUp0TmYcfQ4KcjugTWiTOYk
 5RwVT9MIfDssuDtarnVdbS4g0oSXbKb3tVb6K7C42osMw24YHb6A45fVA561vtKxpwKD2un5
X-Proofpoint-GUID: SWS9cFYC-yVenqMchQ-j5h_LV5I4NkHM
X-Authority-Analysis: v=2.4 cv=RIGzH5i+ c=1 sm=1 tr=0 ts=6883c771 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=I_XhYhhwJGe-MZ1iZkIA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12062
X-Proofpoint-ORIG-GUID: SWS9cFYC-yVenqMchQ-j5h_LV5I4NkHM


Hi,

I've found an issue on mainline (since v6.12) where the pcrypt()
template seems completely broken:

$ python -c "import socket; socket.socket(socket.AF_ALG, 
socket.SOCK_SEQPACKET, 0).bind(('aead', 'pcrypt(ccm(aes))'))"
...
OSError: [Errno 36] File name too long

and then...

$ grep 'pcrypt(' /proc/crypto
driver       : 
pcrypt(pcrypt(pcrypt(pcrypt(pcrypt(pcrypt(pcrypt(pcrypt(pcrypt(pcrypt(ccm_base(ctr(aes-generic),cbcmac(aes-generic))))))))))))
driver       : 
pcrypt(pcrypt(pcrypt(pcrypt(pcrypt(pcrypt(pcrypt(pcrypt(pcrypt(ccm_base(ctr(aes-generic),cbcmac(aes-generic)))))))))))
driver       : 
pcrypt(pcrypt(pcrypt(pcrypt(pcrypt(pcrypt(pcrypt(pcrypt(ccm_base(ctr(aes-generic),cbcmac(aes-generic))))))))))
driver       : 
pcrypt(pcrypt(pcrypt(pcrypt(pcrypt(pcrypt(pcrypt(ccm_base(ctr(aes-generic),cbcmac(aes-generic)))))))))
driver       : 
pcrypt(pcrypt(pcrypt(pcrypt(pcrypt(pcrypt(ccm_base(ctr(aes-generic),cbcmac(aes-generic))))))))
driver       : 
pcrypt(pcrypt(pcrypt(pcrypt(pcrypt(ccm_base(ctr(aes-generic),cbcmac(aes-generic)))))))
driver       : 
pcrypt(pcrypt(pcrypt(pcrypt(ccm_base(ctr(aes-generic),cbcmac(aes-generic))))))
driver       : 
pcrypt(pcrypt(pcrypt(ccm_base(ctr(aes-generic),cbcmac(aes-generic)))))
driver       : 
pcrypt(pcrypt(ccm_base(ctr(aes-generic),cbcmac(aes-generic))))
driver       : pcrypt(ccm_base(ctr(aes-generic),cbcmac(aes-generic)))

Yeah... :-)

I've bisected it to these two commits:

e7a4142b35ce489fc8908d75596c51549711ade0 -- hangs
795f85fca229a88543a0a706039f901106bf11c1 -- bad

Basically pcrypt() seems trying to instantiate itself on the algorithm
it just registered (...a larval?).

I made this handy stack trace to try to understand what the flow is
since it involves multiple notifiers and kthreads:

bind
- alg_bind
   - aead_bind
     - crypto_alloc_tfm_node // loops over:
       - crypto_alg_mod_lookup
         - crypto_larval_lookup
           - crypto_alg_lookup
             - __crypto_alg_lookup // iterates over crypto_alg_list
         - crypto_larval_wait
           - crypto_alg_lookup
             - __crypto_alg_lookup // iterates over crypto_alg_list
         - crypto_probing_notify
           - blocking_notifier_call_chain
             - cryptomgr_notify
               - cryptomgr_schedule_probe
                 - cryptomgr_probe <-- switch threads!
                   - pcrypt_create
                     - pcrypt_create_aead
                       - pcrypt_init_instance
                     - aead_register_instance
                       - crypto_register_instance
                         - __crypto_register_alg // iterates over 
crypto_alg_list (+ adds to it)
                           - crypto_alg_finish_registration // iterates 
over crypto_alg_list
                             - crypto_notify

I tried a bunch of stuff but unfortunately I didn't manage to come up
with a fix on my own so far, maybe it's easy for somebody who already
knows this code though.

You'll obviously need these to run the repro:

CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_AEAD=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_AES=y

I do think it's probably a generic template instantiation issue but I
just happened to run into it for pcrypt.


Vegard
