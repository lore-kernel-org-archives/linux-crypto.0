Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011042.outbound.protection.outlook.com [52.101.62.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106603115A2;
	Mon,  9 Feb 2026 22:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770676939; cv=fail; b=XUN06RHYEdcgmTY9UDqcXhuRIqioBo9RGrGp6MDi1HO35U9O/EAvSVTRC1wmOLZmZSiUpQBAeP/jFK16hTUF3yR2z9VqQydbMhE+0Jzwc7WZB7rcRadK7mdhWkErkfFQgADTh1x143YGyC2if02eioyiFuRNf4usvH/8y8PSxek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770676939; c=relaxed/simple;
	bh=PuX5i15vfgM/Qmb5k3QCikiw72Z71ChUzgPYWxw6e8k=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=W3TfrixSGysKiueAyd4luzlVpm8mFXqZdn9wFErQa09T2AzS7pcnKXErD8jWf32aZM1TRpAdflV8hqteUFWTL/XJfp0yuNhy6dl8KjgQqZVPwf4Zj921b/sXDUlioi3bjL4ILF4YXMFBYyKQkn7T3XmYDIvKRMb0C+/R9h6LV+0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jKBu9/U3; arc=fail smtp.client-ip=52.101.62.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jKBu9/U3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lvgn9a7Uwls51Kr+U61AomrwtBwECazQzd6ag8naVUy4f/QUmTcqGILvjyDgW7iSQDuEZNaKdjSWRRDe01oQFodEcD55UfV1baGpz3M8rybpqrTQfxua0/SJmktIzV6QCy5y5d4aYWhuRy0H0qhguxUjdutHamNM3SQpp3wEPYQ/j806Fm7lB8Y/TDxGAkX4czDCDJ7VjeQD5u4Rw+fWjWAx2YFWe+i0VK6ay2vvzUphfSVKq8DkKmDD662Sx8WK+fOwtC2F79he5T6yF+8Hh7V/6y58/oXgqjiqw8z3dYp2lsH9wMMbEp9SXRBTIJhGheDmz77xIRPOwgO1nGfCZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BEXVLEJzlUdbT/rGquSa93bS2/GN8KzA7Ngx7g4kuIA=;
 b=wcGtgzgxrr/ogchqhgUq4iNdjNBCUma/SApLf6en+Nr9P26LX6OwX6KvGEMrk6wFjCmgAHkv29dBUQ8+WeUEdFzBhpEuljRkSmP51sf29wEr3HwliMUmFPq3RbBIQpV+itYgjJ4e9gbp7mzHRkUSVSJNaKaZHhMlNNH8wNNl87wNDhEZGfZNIpnK6So+8ABG12r8ODvUaMGbg3kBbksfMNPMfoFoBjWWDodxVqtO07BbivG0kmhRSONAKb3zD5frVeFHilt9HG2CFqX7/aDsQdWjjLAitHuJ3jpcsCGMsVk7PbPCLmZUBGhx3q7vlj3FPuO4BeETdhTSKiB0ATHDTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BEXVLEJzlUdbT/rGquSa93bS2/GN8KzA7Ngx7g4kuIA=;
 b=jKBu9/U3otsYl4wlt7rL5DWX6SY2Ti+nMYv+w+/PIel92Hv9P27WxnvZJ1ABXL85AFEt9yX8zftbIbSgmrmjuTOZ2ffYX6PQlhNpaY6Ta2k5gg+ct/N369UUoHXt8B3zXWFJ4axYvdnBMageK3zdLaNi1JM5n2j5QjbC4rRdyoY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB9128.namprd12.prod.outlook.com (2603:10b6:510:2f7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Mon, 9 Feb
 2026 22:42:14 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 22:42:13 +0000
Message-ID: <d7b552b0-78d4-4d4d-a710-7366e23d80e0@amd.com>
Date: Mon, 9 Feb 2026 16:42:08 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ccp - allow callers to use HV-Fixed page API when
 SEV is disabled
To: Ashish Kalra <Ashish.Kalra@amd.com>, john.allen@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, bp@alien8.de
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-coco@lists.linux.dev
References: <20260206212645.125485-1-Ashish.Kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260206212645.125485-1-Ashish.Kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS0PR17CA0024.namprd17.prod.outlook.com
 (2603:10b6:8:191::29) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB9128:EE_
X-MS-Office365-Filtering-Correlation-Id: c72b55f8-937e-4577-24fe-08de682c7784
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZTlSN0RqQmFZL09PQjZ0dzVML3FpUnJGVWVBeDl1RWNObTZNaFNPQ25ScmJJ?=
 =?utf-8?B?a0IrVnlqS3l5NDlJdGNaeEYrNzRoVCtJQnFMeGNSbW1FMWo2YmkrRzRVWXVm?=
 =?utf-8?B?SFpON3hoSEc4eHNlUkpLR3VqU2R0Rml4UTBQeFhLZTAvVHlWQ2FVV012N011?=
 =?utf-8?B?VVY3MFliOVNLNjM1MlIxb29URGRKaXNvUG1ZUXkwbUtFd2ZjbkNEblp1d25B?=
 =?utf-8?B?a0owenVldm5Vd3k4K0JxWTJNS2djbnNrRHVIZlllVEcxM2ZhRmJFZVdyR0th?=
 =?utf-8?B?elREcFMzYkdjdVZmYUw3V3lMUGdkdVhIeEFDODM2dHRnMklpbWJqODJaYWlP?=
 =?utf-8?B?OUlWUUtEa3NsbFZRVHpvYUJLVDdiK0NiZ2hhM3FsWDlUbXBOdVdQcHBPSVMr?=
 =?utf-8?B?RU56eHdvbWs1c3JEcU1TT1BSMmVnYW1WV3hUNTdFMVdEU011b3l3dWxCaEdS?=
 =?utf-8?B?SnllQXpCSllPakc0ejlVUzlMNjBxb1J2WEM5cDU0US84ZnRKNUx3TVI1SjdJ?=
 =?utf-8?B?eHpUYjdPNDhGbkFDK0c4WFVreUZjM0p3MmR4WUJ0aURZakZjMFZkcEN1YWU3?=
 =?utf-8?B?Zk1xNnBTdDM3L09MUmVsb1RpNk5uTmNIOEM3Mm9KZGJWQUpxTUxaWXp6VmpU?=
 =?utf-8?B?dTdRT0dLY1JNdXo0RXM4K1M1NHFSMTU0ZmtFdTIyZFpZRzdxYkp1UDR3Z3dj?=
 =?utf-8?B?cEp4MzZua0pWczM2QkYzMGJWTThQRnFwOE9hL2RnSjd3bWFPRG90OHh3WkhB?=
 =?utf-8?B?VHFDSjFyUUpVNFN4VEoyYjl5MHdNZXEyNVJBaHZYcXdpZkk1V1RsOE9pNXpV?=
 =?utf-8?B?YjZvQ3lHSUZjc0VwUCtLNG5xM0EwT1pxS0g3QTg2b1RkR2pVYi9EOXp5anpZ?=
 =?utf-8?B?WiswRkYrbHNsMm4veTRvRlQrYTlHSHlWTXlrSzNVOFhObzBocFhzNnlXNTBv?=
 =?utf-8?B?V0IzU3J6ZllpRU95OThIOFpSYkpNY1Y1VWo0T1pIZkJWNjNDbHFQRXFVdk1s?=
 =?utf-8?B?N0RGNEZleWlHczZXWXhoOCt2WGZaSVBWd1MyRjJ3dHA4RUI2bWh0SVQ3aVRO?=
 =?utf-8?B?TE5GWTJlWVJJVy9STnBZN3FHNk5DOE1DbEZKemhmSUtocTRNOEtmbEo4T21G?=
 =?utf-8?B?SDdUcm5WcGVSY3BlejZCNzJFd3hqemhyN0tkN0NMaEpCQzVNUFFHbi9UUGN0?=
 =?utf-8?B?SFJTZHRCMFJPSGtrR2tyY2RiZ3lIbXJXY2lrZGdHVng1dWdBdFEyNjVOdkgy?=
 =?utf-8?B?alN6QnB4M2RXMFNqcFFRMVVDSkoyTFpkb3l1UDdQQkNpQ0FqdDVZR1lKRjZi?=
 =?utf-8?B?RXlmc3JnUDVodDRvOUtBdGJhNWdFWUFoWDdwT3JEVGZySFhZa1U1WEp0OUNp?=
 =?utf-8?B?aVU2dzMwMTRYU1liWTllQnRFaGxUQUZSU3BtQk1UTmtGWk9lbnkreDlRN3F6?=
 =?utf-8?B?YlJDYlhCaG5yOSs2bENIZm5YTG5leFVBd1hQNEN5Z1hQS0ZhdWQ2NHhxSUxZ?=
 =?utf-8?B?WEJHR0ZBYkgxanN2WUFXRWF0SW1lYndSWTRrMXYzcEVaakQvVVQ2dmd4WUVL?=
 =?utf-8?B?TjFBYk9UZEFRaTBWVVFLWXREMDUyM3dRcFRQSmwzQ1JtLzdXSVYzK2VIWjVq?=
 =?utf-8?B?Wi9zZWFkYWJIUVJGd3BoN3pGK2I3WlN1VWhyckFhUHU3ZElCY0IyZVdtYWs5?=
 =?utf-8?B?ZFFsMjNMYTBjTkI3Zms1bytVMkc1VGVDU0EwMThWUHZTT2tTVk93b3FnTE1J?=
 =?utf-8?B?ejExMEdxcWJQYUo3SFNJKytGdnhLYVk3dW9KY1UxR1Z2bjFhWVFXVmw5MzQ3?=
 =?utf-8?B?eFNPTTZZeTBmc3NMQWsxU0NFWUtzOTdBODBBOEJtV2N5ZGxpVTdUY29sendE?=
 =?utf-8?B?NzJkakErR2RpQW5oc1BOOWIraG16RmVyQzBMSSszdVl3bTVJMUF5Y0crQ0Ez?=
 =?utf-8?B?NlhYcWUvRWkzVGRzbTdZV2RhUmxnTmFjZmtid2xsT2FqT3RubjU2QWpqbGVW?=
 =?utf-8?B?Wk1sbTUxQzB3QXZoZVhJQkk4L2NudklIcVBlZUMrTUk4NE9KK3dYZTBXU040?=
 =?utf-8?B?S08rOGlCN2lQMUZXQmRxWnR5aExkQU9JV0h0V1ZMa3VoZ0R0WHlocVBqOGJi?=
 =?utf-8?Q?6mic=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SE9pZ2FhZVROSnBuS1RZMG5iZ05oM1NDeEMrK3U2SGpEdHNVc0U1UjFqeFZ5?=
 =?utf-8?B?OGl1YlZmRjUwVkhLdnBYQk9STHZUN2NFSWVWUzVtd0dmQWRibVpISkJxMFcw?=
 =?utf-8?B?Ym9EYStVLzNGd0ZSR3kxYmFrYVJ2amVuSmIxRmh5WnE4dGlEMFN5cEZKcjdu?=
 =?utf-8?B?Ynl4ZHdhcVlZam0vbVIzU1g4NGFub0dybDR0Sm9reEhDekplSisxV3ZmYks0?=
 =?utf-8?B?V0tKbU9uMDlZSGFSTFNORmQrTDdMYW9OVTRIdFAvSGpZRGd1L1oxVlYxZGxu?=
 =?utf-8?B?NnN3aVYwK0loeHk5cmVZZkFCRWI1V0xtRm5HOVpDK1FGVjc0QXhhUFBQRGM2?=
 =?utf-8?B?MXFkY0kzVlp4ZjExR1M5N3hmSjVDcFR4U2FhdXQwM3cwTjlPdDVDMW9WbXlm?=
 =?utf-8?B?OHdUd3ZQTTNSY0JrQ2Y3SkFPbDZhYVBKT25GRlBQNnpobDUxb0VnTmpOQklN?=
 =?utf-8?B?VEtBa0V4aC8vNmQzeWRpMTBrMVFjakoyZGFtQmZmZFRpQ2FMRWxDOVN4WWor?=
 =?utf-8?B?YWZIZExZWW5OWTJYRlBiWHd2bFY0WlhYQWlSM0IrNzhySFVaZ1U2NldnZjh0?=
 =?utf-8?B?WXdMdjZUYVh3bUNWOFlZUWdNS3ZTSUUzY1NDZE5hdktNdFNBWnlYZGNqZFgw?=
 =?utf-8?B?aTZ5TXNQZHJQSlgybkRHUlU3Z1o1UEZMYldFdHVkMkdCalc1TFBvY3B5cElR?=
 =?utf-8?B?U2hwa1laRzhkTWU0UGF5VTl2MUUxYUVYalF5b29vQmliVzBOSlAyS1V5Unlp?=
 =?utf-8?B?MDZKYk9TUzdmWTB5RWloQWhGSDU0aDlLL1dwNitZeUdKQVo5dE1oOXZPaWh5?=
 =?utf-8?B?QU03azhLWFVsWWpGUm96WHRVVHlORE9CZkc3ZGZJNmRsVHQ5eDdHYjdyK1Q3?=
 =?utf-8?B?ZWpnSUc3cGdIQjkxbkRJRXlacm5WMmZ0ZmlOVlRXclBINjgyTnc4ZmhxQzB4?=
 =?utf-8?B?OU1LRmRrMmxjbHEyNkMvVy9BSzVnRVNMKzBQZVNGaGhvRXFQSW1xNm94Mzdu?=
 =?utf-8?B?UnYwWGVSdHBjV1N1UkhyVHFFdGZCR0JWYkh4N1pXRDBEYjQ2bTRVZ2svSVRB?=
 =?utf-8?B?d3dYNkoyYVNyeGlscFU3OEhESzBaaFBhcGwxN3BzZ2JsdXRIVEpZZjlodlEz?=
 =?utf-8?B?UVpUTmc3ZDZtcUFhZDJPeXBnS0dZWEpQNXprZjRPOW5VSkxqZUpOTUE0WlVj?=
 =?utf-8?B?UGZYNSs0RW13T2tObWlKSHIwU3hoUWZUdndyalNDYmFHbUF0QnRjRzNqekgr?=
 =?utf-8?B?bzlmaWJ0OFlVUyt6V0pFUGkvNFExK3krMlcrdDBTY0wrVzZkRkNVZU8zVXhm?=
 =?utf-8?B?YWIvT3R1dFlFdGk4TExWWHRvUGxMWm9vSnpJdmJueUNETlIrRkJWSFA0T2cz?=
 =?utf-8?B?SlpLMW5OcysvU0ZuMmpWYjFxMjg0ckNWWjlGMk5LU2ZjLzF4OGFwUm1RNG5y?=
 =?utf-8?B?cjF3SExyd1FSc1Njb3RpTi8vUGpnaDZHRDVJUlhGUjF4MVdMMEpRWUI5dVAz?=
 =?utf-8?B?Vm1qUE1wMnMrZlgxY0VRZDc1ZGgwbGtaMU1jbU1jMjZFRFVwRXFYY3c4MWlj?=
 =?utf-8?B?d0g3RnNGcEJmQzVva3d2UklsdTltVnZWd0Q3cmdDdU41Zzl4SEhQNWhXTUlt?=
 =?utf-8?B?RnlpMmRlY0lFdUgxdFZWV1RBcHgzaWx2bHVTdktJbzkzaGExNkpuMXQ5SmFM?=
 =?utf-8?B?VDNycy8zZCtmcXBPZXBET201a0VwdDNVRjMxbmJ0Ym4rWDlnbndDQ29pVmJo?=
 =?utf-8?B?RVhoRFhnRFh1RWdvUnFLYU5YVzlFTGplcjZOTDdUT1ZRcFVxMFhLTjM4SVJi?=
 =?utf-8?B?d2dUSDQrN081andmMXhIdW1nV3M1MFVMVVgwNmwxa1ZkQnZpWEZsWW9zUW8w?=
 =?utf-8?B?ZHA4MzhNOC9YOGd1NHE0R1BqbFAzQ0Y5NTgzSzdQa0xQamZCVVd2M2NVVEFH?=
 =?utf-8?B?bk9rVlVBeVlGOVVQck5BVFdRS3dXVjc5dU90NFdzSjVjTGxVT3BQa2JobEMy?=
 =?utf-8?B?OCtCb245WllRUFlwSyt6VEkwUDgrNGtUcXB4VDdMcnJBSG02cmxJd251N25p?=
 =?utf-8?B?bXI4YnpCVDBGYWVaL09lQ1NjNTE1WGFOaHdTYnFBdko4cmtueWduaWpuK2dC?=
 =?utf-8?B?aDNRNHp3alpaaTlXa3M3N0V5Q3FOa21hV3lzZkw2TU1nRGJXQUZ0aWo4UVh1?=
 =?utf-8?B?eTlkdzlrZS9Hc0dJVGlLVHEvdU9Qb1FoM3RuMlRXN1YyNmdsZC9vMUQrb0JL?=
 =?utf-8?B?clhQSWFPVG5xeUlkTkNZemRrQ1lEcUdaUmY4YUFKZE1kUldPeG1HQnpRVFVQ?=
 =?utf-8?Q?RtcJGQAK8J4CUACKfY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c72b55f8-937e-4577-24fe-08de682c7784
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 22:42:13.3354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fONR9i29dYsgzg532eRPO8MPGipLo/U/TqaJMHcHKebfOI4hVlY+QB8caZtJE8m99RQawQ23Ngyn6Iw1JDkX4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9128

On 2/6/26 15:26, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> When SEV is disabled, the HV-Fixed page allocation call fails, which in
> turn causes SFS initialization to fail.
> 
> Fix the HV-Fixed API so callers (for example, SFS) can use it even when
> SEV is disabled by performing normal page allocation and freeing.
> 
> Fixes: e09701dcdd9c ("crypto: ccp - Add new HV-Fixed page allocation/free API")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 1cdadddb744e..0d90b5f6a454 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1105,15 +1105,12 @@ struct page *snp_alloc_hv_fixed_pages(unsigned int num_2mb_pages)
>  {
>  	struct psp_device *psp_master = psp_get_master_device();
>  	struct snp_hv_fixed_pages_entry *entry;
> -	struct sev_device *sev;
>  	unsigned int order;
>  	struct page *page;
>  
> -	if (!psp_master || !psp_master->sev_data)
> +	if (!psp_master)
>  		return NULL;
>  
> -	sev = psp_master->sev_data;
> -
>  	order = get_order(PMD_SIZE * num_2mb_pages);
>  
>  	/*
> @@ -1126,7 +1123,8 @@ struct page *snp_alloc_hv_fixed_pages(unsigned int num_2mb_pages)
>  	 * This API uses SNP_INIT_EX to transition allocated pages to HV_Fixed
>  	 * page state, fail if SNP is already initialized.
>  	 */
> -	if (sev->snp_initialized)
> +	if (psp_master->sev_data &&
> +	    ((struct sev_device *)psp_master->sev_data)->snp_initialized)
>  		return NULL;
>  
>  	/* Re-use freed pages that match the request */
> @@ -1162,7 +1160,7 @@ void snp_free_hv_fixed_pages(struct page *page)
>  	struct psp_device *psp_master = psp_get_master_device();
>  	struct snp_hv_fixed_pages_entry *entry, *nentry;
>  
> -	if (!psp_master || !psp_master->sev_data)
> +	if (!psp_master)
>  		return;
>  
>  	/*

