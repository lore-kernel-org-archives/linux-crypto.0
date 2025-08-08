Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2082.outbound.protection.outlook.com [40.107.237.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C36B286D49;
	Fri,  8 Aug 2025 16:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754670170; cv=fail; b=hMQP1vQSywrndf0FVLbzzPhYkxwzAqmzJ0UOwKj8SSuUyGmqrulZWJDlvE8TJ6UzE7RMxkPn2qeFFG3DJwFk+OKi//ou/KEjPzvfir5rmqfGM73EQnMwlid1IoIrSWku6P0zuz9nYDQLx7ShOZGvg02z9vIZNCFGUOTeNJ0GjHQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754670170; c=relaxed/simple;
	bh=lFGYBDglLIA8J0OSuorFcVtWKHdK8/r1WSEETlEWnZM=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I8DO/uXjuZ0SdtqJb/CA/ZR/CPbPZxRyK3WJ9VkhSaK81+nEMw954c3Sjnxok7o6rju9fvAmCBNgNixXkIxJyHtaakitQfqPQQfEIPpIaMeGb0SrqtK+TVrV9JKVKsLqumNFEn43tjX6Tb6cYijlqAVfLxOJMKVHUPHa2J29pjs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kRLsQpo5; arc=fail smtp.client-ip=40.107.237.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kRLsQpo5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HjWsL3nbGaRY5shzRte5IS3/r1VtivcHrWP1aBHm1MSVad7u2kNq+TzHrH+0woPYTPl5zw4Qdw3Pdxgb4rn6kI6ceh9bTtQVD0TjJPcHxIHM0ZUQC4feKXTLnh5+mU67kalPl7iivwh0gS+JiiBPQ0UAGC5KNa1WOTfJyosVcTXJ3ntx1d405+q7ShQ9BTVsMdsLB7H4CWLcAe5J7Edojquxt7KjFEiw+E32Qz/faXrSILmo3+1WlOveqsIkBMpSnTTPCs2LZODw8S23rbZDXmgV1eO9/zLsKAHHVr5RfF6dqREqgp2ocsMQP4zZxavhkqRIKvvNccEOwTQ+QLfyfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Aa+9IaoBXEyPphbjRn37OKU4rPBgdnw5Nak80cpjEZ8=;
 b=wprvfoxdYhHCkiRog+VS+B8FPKqBweNjsPRlHXRv4bn1o9EEV+IAIA6c36YuFwluD+xXTZgjFcb8gcHCTcNZS/oN6tVGfffGwvRKLi3A8XE/e+RUh6Gr96wlqH/DEl8NkMLdkIvkgBmZlCkqVh3EJkolLeRjNVgvOsXsVyOde/yQ/vDWKWMWc9hfklsdITywylwjt1VBWN2tFVBRubX6L0ZvtUy2rdVPy6UUd4CnwwMW1CW10qSFIwAd6+p5TKO9SpmcWInq7CVT+xKYp7unQlq1zgqMl7ySrZW6xtAHeTisO2razx4XhBThR3QUYaS4UTV/ZrvAmI6uocW2TqDqkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aa+9IaoBXEyPphbjRn37OKU4rPBgdnw5Nak80cpjEZ8=;
 b=kRLsQpo5xt5LVa6jyX5Qg7JZEShD7zuDEN7tNJxs8RIi8TimsXemROCpTcZyMqbY3UqKgXPNm+DRUlnmVbe0r+4evEhNI290KCeJkd4k4XZoq07NI15NpA4McB6OazywExgqptrjrmCWfbN0XsyWd4CdTGFBA51XXioIlLD3GUk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by SA1PR12MB8858.namprd12.prod.outlook.com (2603:10b6:806:385::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Fri, 8 Aug
 2025 16:22:45 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::37ee:a763:6d04:81ca]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::37ee:a763:6d04:81ca%7]) with mapi id 15.20.9009.017; Fri, 8 Aug 2025
 16:22:45 +0000
Message-ID: <d92b9a71-cccf-4e19-ae87-68627e16fc26@amd.com>
Date: Fri, 8 Aug 2025 11:22:42 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ccp - Remove redundant __GFP_ZERO
To: Qianfeng Rong <rongqianfeng@vivo.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250808074426.214726-1-rongqianfeng@vivo.com>
Content-Language: en-US
From: Mario Limonciello <mario.limonciello@amd.com>
In-Reply-To: <20250808074426.214726-1-rongqianfeng@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR05CA0006.namprd05.prod.outlook.com
 (2603:10b6:805:de::19) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|SA1PR12MB8858:EE_
X-MS-Office365-Filtering-Correlation-Id: 277ace26-1a02-4c53-34b5-08ddd697cea7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aHZFSUFHa1pRZE5DV2RPTDNuTDFORHNtQ3ZhQlhOMFJDa2hkd0pvYnNlSXdE?=
 =?utf-8?B?ZlRaWStmelltTGdqTDBvOUVuM1M5OHRzRDkvVmtjQlg0eWVDeC90NTM1dzhW?=
 =?utf-8?B?c1F2VUVmQnM5T1Jyd3ZpdnAzekZsM3dvM3VLazhzZzZWdFVxOENKdGNDM0lJ?=
 =?utf-8?B?eG5zdVBzVVJGTXFXYmlhcm9CaHg4cE5IRjZmUGp6WkxXeWNsWkROczRpTmlw?=
 =?utf-8?B?Ty9XWjk2c2QyZWVpNDhlaUlSVGJTT3cxWUs0N2V4Vm41TFR4MVp6b0gzZTZF?=
 =?utf-8?B?T0RyZ0d4KzRuK0Z4a2o3alA2UFhzY1JsdGhiV28rUmsvMlpvcnMwZDlwb3dO?=
 =?utf-8?B?THZwOGcxNmw4MmlMS0ljTWVDR2NXeGdBc1diY3d1blhPekFFUXZCWTdWY2lt?=
 =?utf-8?B?TElaa09saDM2akgwbGpxVCsvSXdlTFl6U2ZDVUpjWWZacEg2MFFQb2dIckhi?=
 =?utf-8?B?TGdQNVJDSkwvTnhhTndZYzRCRGVnaFJ6VkFrTVczRVNTNjZObFZDM3puaG96?=
 =?utf-8?B?SjFiOXBXS0krOUpIaGVoUmdScERqcEtGNC9YV1ZNbk9ldzh0QzdDZk5TVTIw?=
 =?utf-8?B?K0ZpeVhTeWRKcDZ4Z1U3alQyR2JMZGd6QTRWckxYMGwzV1A2anBDeTRLMzhh?=
 =?utf-8?B?NFZTNTJXUHlUYkJ1SEhkbGhrTkRJODlsTlFNNWlpcnNpV3hFU2ZuMkY1cXJI?=
 =?utf-8?B?UnNVWklFN3h4TldRMUtULzdQYWRkWE1HZnh5dDhoYUhRM29XcWtZYXdIaWdW?=
 =?utf-8?B?TFdjSVQwZE1WcG43bS9vUkNHWTcwa2NFQnQwUm10c1dGclVteVpCSmp3OEZL?=
 =?utf-8?B?UFFwcUtYSzhUb0lwanBVQW1KRzJVWFpKWkFFSHA3aTJzMThZenRyL0lCQU9a?=
 =?utf-8?B?NFY2Sk5UNFdYcXlOUG1Bd0k2ZVF3M1JHcTVmT0RzQ0RYai9ESXd5WVRxRVZz?=
 =?utf-8?B?UWdtTnVsWHhta3JGRWwyOWN4V0I4K3ovdUdxbElyVTFjbzhuZFIrL2xkOGdq?=
 =?utf-8?B?QVlCSFltWUpmalJjOUVVOXo3b0FpK2tOZkVOYkFmS0dmcForeGdCNzNwbEx2?=
 =?utf-8?B?TWlSM1FTUHRRTTVoYlZpNkkxQi9GZmJVcW43UDFVVVR3VGY3MjVCNVA1L0Yw?=
 =?utf-8?B?Q3BHM3MyVzRsSFBLWVNVUitWTzF4RXp6ZU12QjM0L2doREt3YS9qUzRVVGVB?=
 =?utf-8?B?SmM0M2tGOUxVSG9hY0VZakE5Y0psZXJkRCttYWVDVzBWQzNzSDNHcmNPcEZZ?=
 =?utf-8?B?TUd2ZFh6RDh0U0JwTUEvMTcwSGhPL2pFSGFaME9KRzRCK2JCY3BwanEybGJl?=
 =?utf-8?B?UVVWTXpyVUZTb25VZ2ZPVDFwVGs0d3lYTGdmSGhIY05neWQwTWk3WE80UWZp?=
 =?utf-8?B?a05Ob3hUU0dCYUFBNFVkN0ttSWVCQzdKcEhyTERjaDA2MjFzOVQyS1JmZE5a?=
 =?utf-8?B?cnhNT1VxODB2RDVSQy8zVVZQQy84T1cwazRCZzl1dS9mdTMxbXBNNW1BN1Zo?=
 =?utf-8?B?UmtSRTZqbWhBSHVBMXdqcEhpa2MxRld0aHdub0ZiZEVjOEFXTkJmemxNUVdD?=
 =?utf-8?B?dDZNUkV6WXk3ZHFnR0FVK05kdmVKeU5vblVoMkJHKzBpY2ZQb2IyWGM0dmU3?=
 =?utf-8?B?MEIrTHpUczkrZEZRd0FxbWRUbUM3dkoyR0w2SzBMZHhqTVA4SUVJWEFySkRx?=
 =?utf-8?B?VzlaWkROZUhCOHN4ejNYRVdtNjF4WmRFYmdEVDNlS3ZTSy9uczMvZUgrUkpG?=
 =?utf-8?B?eXRvOStyanFQcjhDdFdjY3BCbnFwd0RHdWJjRFFlKzNOdWVKV1k3WkZZNmhF?=
 =?utf-8?B?em43bVZ0RDVDWVV5WlE3WGVRSUxmcDVJZ09KZ25Nc3Y4LzVMbDV1QlhPMHZC?=
 =?utf-8?B?c1NVczRVTDI4V2ZqUzFuVzUvQW14Y25VdmttcFQ4Q1kzWDgrZ1JQdzl3TG1a?=
 =?utf-8?Q?FQbbiY0/aBA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eVMvaHZMMG1Cd3htdHRqVjhiTlUzb2JlcnhnUFVFOTVpN2NORUNKem1GaWtW?=
 =?utf-8?B?VTFsSEJESEUvV0JOZUY2WTU4cy9JMnl1U0o0ZGcyaXFzOEM3S2twdmNjRmYv?=
 =?utf-8?B?djVaWDFkUHlNbzVXWG1EeFNQdWx1ZW1sdjk3M3l5YnhvMkRNb1lZcEpqWHJB?=
 =?utf-8?B?MVRydzZDbmsvdmNkNUhTQjRHQ1B6MVVZSXhjbXhST29qZFNQeG5zdnRaL0hO?=
 =?utf-8?B?SDdoUzVLQU9QVjhmNmg5THVoUnBEVzlVWkJ0ZUQ5S1Z6NDhWUnV3TDVzeHY2?=
 =?utf-8?B?RVF6SVczMy9mTk14VzZ0S2xUR3Y1WUJUODUraUdUK1ZLaFdhRUFHa2hBQklz?=
 =?utf-8?B?ZXRYalBkeHRRbjk2OEJ2VzJJaDRXVmJTY2dGQkVBa3dhTkRnM3NpTHV2WGdQ?=
 =?utf-8?B?K1oyNEIrWUJteE85R1dadDJBekJRS04wakdaMzRCdjlwcEdZQ1V5bW1YdXdk?=
 =?utf-8?B?alhmRTErWEJRVzRPTzlGdVo3cERyMkJ4clY4UEJnUGlnZnlIbWJzLzZvYlky?=
 =?utf-8?B?aFhqTzg2S1k1aDl4ZW5rV0ZySE1RRkV4VHVnNDIzTE1jUlc3cS9BSTF4YWtk?=
 =?utf-8?B?ZWxzZHBuMWtBSXBkVjl1bld3R0tEUDhpVVZzbkE3UU9sa0hNeDZQa1o3MU5z?=
 =?utf-8?B?QnRtTmx2SE45SHFkR0ZYcjR5YlZlUnlsRHhuaDYwWDRvSytrdVowV3VBei84?=
 =?utf-8?B?Zlo1WmZEY0Vndit5NURxRjZNL2FiQnNOUzFxOVdsNnpEWFU0RG9VSnA2eWVX?=
 =?utf-8?B?eUhmb3Z4WmZQZnhVRGc4ZWNTaWVFbmZVOHJISEJpSVNTdlJXYTNDalcyMHdp?=
 =?utf-8?B?R0lyVjgwMFNlVDJUOWJrNnhLMFN5K3pnVmNaTmZSQ0I4bm1YZ2gvM0Q0WERQ?=
 =?utf-8?B?VUJ2ZTBXODhQbHgwVUNhRVh4Z2N2Mi80aWlvVU1ha0lsTWNHamlOTitKMFRs?=
 =?utf-8?B?cmRHU2MrUHlQMTVJeW9BTmZmM3FHb2EvYmFsL20wYXY1emFmN1AyVktZaks3?=
 =?utf-8?B?ZW5ISEpWcExnNDlBSHIzL1ZMWHNBT0xGdWduTjZINnliL0V6U3QzL3dnTlJY?=
 =?utf-8?B?b1orTU9BR2E1MlprTUJaQktWT3pFYmUyV1UvQWJFRjcrbm94WGsvTmJ3dTlO?=
 =?utf-8?B?KzNzNjYwaUZpaEVITjZZbStMN3F2d21rRmRjNEhFc1RDejdiWmtScTFCL2Q5?=
 =?utf-8?B?c1JhTC9pUzB4NWpxZXN4YXA2V2RPeUo2aDFTTFdITm9kT3FTUDJVbERTbkxi?=
 =?utf-8?B?azFFU0Q0ZkF6SjRHM0c2dThIdHVsbTY5dTA1RUt6T3ZvbmtNS2xlaDg3bGht?=
 =?utf-8?B?K3VmT3g3Ky9xNFQ4bDlQNUFndnN4bGVjdFVZaVJNaXBKc0FQZWtCR2JoWTVT?=
 =?utf-8?B?aUpLVzU1dHpWUjlRcmhCdmYvbEp3bnRKdm9RSlRab1dsOVpsczczUk9NRGpq?=
 =?utf-8?B?VXNoekN5VERlMEdiTEdMd3RPcll6SlZqdWVVZU03bHVaNG55UUZVYzhGcHJ6?=
 =?utf-8?B?V05telV3WGhnVnNEc2QzMlpEbENsOXhXWDg4T2VwT0lUdFhoN05vU2tLNUtn?=
 =?utf-8?B?OGlYMDhsT2k2d1hJMWJTemVUNG4xcnpxSEJvYTlpdzUrdUtuOE94U0lacXhU?=
 =?utf-8?B?YmVvUEtuWnpWNEVacHRhZ2EvM2ZkTWlRTTk4ZWZwQXdqMG40aVN4T01NRm1v?=
 =?utf-8?B?VWNsUG5NTXppNCtFdUwvcWs0QzNtVUtJOHdTZ3Rubyt6YTNZUnlUWjlPNFJC?=
 =?utf-8?B?VXFBbU1zVE5wWUgzSGdIYzJnUThwVDBabmtCelp0aE13blJNb1ZMdlNrVzI2?=
 =?utf-8?B?eFdHbERzOVhUNmFJb3lsN1VHN01IWnp2MVRYdlZ4MWdjd3VNN200cDZ5Sllm?=
 =?utf-8?B?YzdmaTR1Um1WSzN3SklzWVZFeEo0bytBWkhtRnZudHN6ZDFrT2xQaXYxMVBr?=
 =?utf-8?B?bUZYN2d6U3ZrcmJQQXhmSkpnZkJpZENKeXlWUHprWDQ5cmpEcEN0Wk9GQ2k0?=
 =?utf-8?B?aFZTU1p4S0hHdzJKRG5BdXNSZmw0TlJqWTJYQjdzUWJMa2o4SFhxTzNYRDFr?=
 =?utf-8?B?RWtpUmpWcFVPM2dyak91a28rQ25vK3Bha1JMaHBYRjJGeUY1MkVLOUUxb0dT?=
 =?utf-8?Q?68AlnbK67rqAnMRkPuKUf6rZT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 277ace26-1a02-4c53-34b5-08ddd697cea7
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2025 16:22:45.3786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BIfG/B9K3BBuZVzDHVX1hMZY9IbO2oFBbXr1GNHWK/Une0nxgacTwI3H7o1q2yqEKkBexQe424vJimWE6Hmq+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8858

On 8/8/2025 2:44 AM, Qianfeng Rong wrote:
> Remove the redundant __GFP_ZERO flag from kzalloc() since kzalloc()
> inherently zeroes memory.
> 
> Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
> ---
>   drivers/crypto/ccp/hsti.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/hsti.c b/drivers/crypto/ccp/hsti.c
> index 1b39a4fb55c0..0ab3708951af 100644
> --- a/drivers/crypto/ccp/hsti.c
> +++ b/drivers/crypto/ccp/hsti.c
> @@ -84,7 +84,7 @@ static int psp_poulate_hsti(struct psp_device *psp)
>   		return 0;
>   
>   	/* Allocate command-response buffer */
> -	req = kzalloc(sizeof(*req), GFP_KERNEL | __GFP_ZERO);
> +	req = kzalloc(sizeof(*req), GFP_KERNEL);
>   	if (!req)
>   		return -ENOMEM;
>   

Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
