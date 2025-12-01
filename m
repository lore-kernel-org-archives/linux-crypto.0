Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010046.outbound.protection.outlook.com [52.101.193.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29D91E008B;
	Mon,  1 Dec 2025 15:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764602873; cv=fail; b=hDzGH8WSIvwfWQrMrpoe2Q95hWHowQy/QS5B3zl2wS4Sr72R5lILXHcWdbG9smcSiYPpK6f27donls+up+IWI72sjV9t3po+PLmZoU8PEXiZSbsQLjGwsHPH2LqmlNW1aLRolUCyNhKisZTT/yAbM0AQjZ7IG9VrQ5BFM59hZtI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764602873; c=relaxed/simple;
	bh=2GpENHjFiebkN8BVo89TIVnQQk+DnzCLsusoqM6PBA4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DGS8RIsQcgiTQzUq1jj22MxinDd7r4Mfw7hYLQHNd2EJrqtDGEyfTONVYz+B0sotJZyOrzCSTNATeQfCMYgkBH4JZwkgudzsKchk2ueIlXi6cFU4QxdkuRV7vbXxaXm+0S+edk+R6KDnJSCeXN1u3ySx1l50Mp3hzJsqit+iQIY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=beTptDnO; arc=fail smtp.client-ip=52.101.193.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="beTptDnO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S2ZpWKcDAMXu3InZeaa/dFsFMOEGihpxD0GXpt96i6J2CWmZM2ypdg72pueVry4zKFc4X6K4THbBkRf9jnOiz9vaU4zv3w/vpuWKPAkhGhlMyaRKjUNCFJDnT/Ufl3zATOuJ+BmPqfVo1FZLqoAkXs03EifbmLW8IBj80i6GDsGFy6crEeGi1xWH4vBGzRmNe1DNaBXUcZ6IUFSOpSzBT1LDtp7aypE4yGIBs6buCJ7Li20EUbjHaAQK5T78Jue/2275cI26U4s5U2IUhV6CDiXih8nXHZyHsW7vonUK+2aMdVkhO3RTaDSq+e4uHejDeJTkQNBYzgcT758ltDfNNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=miBN6O+X8GcLgGntq+OSATq/eZgpkvJm32egvRs3Cqw=;
 b=EvHIUy/gZlfBPJdlnmRE2bfnNVxa62I9K2IWRruUuhhRaNpOk9Z5ogAjRLvXDft4PYwUv6vhBIvMHCejeOvkhLP3oXgNWFBXrSPrVRXcsosR+kTl7mGk3gLlGdHvWcaYaR0Uakjq+GExBBbzYHwLLX1QYQ7cDi679BynXDoViRXlW+KYB/usBZ1fEe91fHvD/Lq0qgOuDbUQgmOe51Xzy3b2/xfAxAvmZi8y9vbkamtIEk8CoLMEe9Ud+voJ+iMVm6ujxI7HRRrYcYlsRHtHo4zOp2E6ZmzEIN62YMzoC/fyY64SzxKEZq1JcwaKIjEAoDiJvCoYZYCJubhOvfVMUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=miBN6O+X8GcLgGntq+OSATq/eZgpkvJm32egvRs3Cqw=;
 b=beTptDnO/6WreiBdqdq3wnNKB0p2uTl6wH2QbnsAVSNsFxyuPtN50VJ6zKu+QQ6kZMcGZQSvzHgqTnCAItTBKkWX125reoDKfFA7pAZA3XMFAWhARXUK5/s+78i1kWgzcrVwzsUqo/s6DShmMndZ43ylCMlpGJNB/7Zssm8U4Ck=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS0PR12MB7557.namprd12.prod.outlook.com (2603:10b6:8:130::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 15:27:47 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 15:27:45 +0000
Message-ID: <2dcb2fba-5bcc-42ba-97db-f275fb859cf8@amd.com>
Date: Mon, 1 Dec 2025 09:27:05 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kernel v2 0/5] PCI/TSM: Enabling core infrastructure on
To: dan.j.williams@intel.com, Alexey Kardashevskiy <aik@amd.com>,
 linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Ashish Kalra
 <ashish.kalra@amd.com>, Joerg Roedel <joro@8bytes.org>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 "Borislav Petkov (AMD)" <bp@alien8.de>, Kim Phillips <kim.phillips@amd.com>,
 Jerry Snitselaar <jsnitsel@redhat.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Gao Shiyuan <gaoshiyuan@baidu.com>,
 Sean Christopherson <seanjc@google.com>, Nikunj A Dadhania <nikunj@amd.com>,
 Michael Roth <michael.roth@amd.com>, Amit Shah <amit.shah@amd.com>,
 Peter Gonda <pgonda@google.com>, iommu@lists.linux.dev
References: <20251121080629.444992-1-aik@amd.com>
 <692613e0e0680_1981100d3@dwillia2-mobl4.notmuch>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <692613e0e0680_1981100d3@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR05CA0086.namprd05.prod.outlook.com (2603:10b6:8:56::7)
 To DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS0PR12MB7557:EE_
X-MS-Office365-Filtering-Correlation-Id: d30b45ac-6b6a-4809-b9c3-08de30ee2cfa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RzdYK0E3QVZvMDk1TGJEaDVhUGVLdTRkSEozeWdvSklUR002Z1pYKzA4cGha?=
 =?utf-8?B?dWg3b3B4Q1lYZHpacFIwWUR5Z1B2cXg5bFdUSHJqYUV2MGlQZ096UGg4RXVv?=
 =?utf-8?B?bXU5L1l1eHlYZUhtZlBHaVZ4YmI0QWhtcXBIMGtiU2M3SEpHSzNKVTZqdGpP?=
 =?utf-8?B?cmRsRXNuRHVGdFdFTHZpcEU5czV5dE1aTjEwRTZZS2g2Ym10U21BY1FwVTJT?=
 =?utf-8?B?ZHV1NnAyM0ZxaGNUWDRLNVFnMHF3d1lVM0tHV2RJQ2QydEhGVFpIeEJ2d3hU?=
 =?utf-8?B?YzVlUGFhL2UrTTBLWmVBSzhQbWlmc2VCSExtV1hZVnNpUlBSVVhTSmdsZUNI?=
 =?utf-8?B?bTdOTWZvZzRJOGIrR2JSNGlSRVl4LzRwaHJJaklEQ0l6b1VieHE3ODJhRjlR?=
 =?utf-8?B?amN1Ni9NVEpkdUxjdjYwTFRNR2JVQjJjd2ZlOHJXTnV3MTU4R1BvM1c0QzYv?=
 =?utf-8?B?cGo3SHI5RXNkM0VjZkcxeFVteGtWMVFsOWx4aHlUZnQ3Z1JDNGlXUXN6Rnhz?=
 =?utf-8?B?djJzdktqSkRHMnI0N0s3aHBmNXU4TUx6cDhXOXBDenl5UVZLMFRLVDZkZ3oy?=
 =?utf-8?B?cW1KZFFGVXRZcDR2L1ovMmdObi9hb0xPRUs5eWZiZDFKVDQvaWdTODlGSE92?=
 =?utf-8?B?RWd3MG5CN0FRYVo0VklxazYrbGJLTmNMSDNuMWhlK1JpY1l4TWF6bFEwTFlG?=
 =?utf-8?B?SmpCSVF3UC9ybTJKcGdDSjhJclZZdnB5cjdIYUxtcVh3dkRwZVQxVFdPMG9M?=
 =?utf-8?B?R3RQb1R3VTFKVHR2NGhlZWZvY1VoUlFrd3d3MlJXbzNqYXpDNVQrck9KdmNh?=
 =?utf-8?B?bW5jRklDcm16U3B0WFd4bEFIa2Z4bFVRcjhjaHAwVHh6M2FpaWR2aFNLbXlB?=
 =?utf-8?B?Y3R5cTVpU1ltU3c3MEx0MkVpcUoyNklwVzZEQkpzM3VBRUc0K2dsRXdTdVpY?=
 =?utf-8?B?Zm5BYVdPOTZsSTkxblE0Y0ZaMU5nUDFpZ1Q3TUdtRUw5UGVtcE8xa1NyL0J1?=
 =?utf-8?B?Qlh6K1NKdXFBdERaeENhRDJYT2xrdENRMXFKVmVlNEpFOUlHbThNcWF5QmpZ?=
 =?utf-8?B?ZVZYbDAvVFAwcldKSFc0cmtPL0NIWjRpNS9oNysrQjF5aEk5bXpNTm43SkVF?=
 =?utf-8?B?aHBlV2lObFY5MEZUQkVLZ3hlQ2ZadUI4Z0tnVzA4RjRFRlpydVQycjRuRURY?=
 =?utf-8?B?a2ZZeUJOVlJxbUU5bkMydXpScEtxN0R3Z2hOakxwQTY1ZGRuNkJjUlJwTHll?=
 =?utf-8?B?UjJjc0JHT0R6Nm0wNEdLdTZ4Wk9ON2JnZi9Bb0xYZHBValJPYmRLb29EenQ0?=
 =?utf-8?B?WmxxU3RZVUw0WjBWZUhrcmRJcmJ6WDhpd0YxcUN3R2UrTVZwQUgzbTVRQy92?=
 =?utf-8?B?Nkt2SEtrN2Mzcm4zZGx2NU9ySkNVMFFUZC9CSE5qQnQ2WThSMWdTRGo4RExq?=
 =?utf-8?B?RXNEVnBTalV4Q0FVQUV2TG5LbGRMSjVhV3JsdmFUTjZXRlMzL01QMEpJNE1X?=
 =?utf-8?B?Zm9Xc2xWa2xoUWhsN25oRXNVQ0lrZ2daeWlZSzlkOVdBMCtWbGxRTHRnSTli?=
 =?utf-8?B?WTBGZWZmYmpnaFY5K2ZOYlU0V2pnWkZOS2VwRkd3bElrOE1od1hVL1p2TG0v?=
 =?utf-8?B?TVhxeS9QM1Y3SWNaMGN2azNlSGpOVmU3RWRvb3RKYi9CdllQbTVwVThpamt2?=
 =?utf-8?B?dGdVbGErb293YkVJMnArNGxFOVJKdEtqaGFpOXRTYkRWSXY2ckFZUWlVVkN5?=
 =?utf-8?B?YTBCN1BaVVMxVksrTTRra2tOZ1BWTkkwV0ZUUWxyUVcveCtRWFYxcUZrV2Ny?=
 =?utf-8?B?aDlOeCtuSllScUEwZzVzVSttcVc5S3haWWpoNVY2c3JzUW1MQmJNd2t3SEpZ?=
 =?utf-8?B?YW03cEdvWGJvVStqYjRGWkN0WTNkYVM1S3RYSFBIdkU4Z3RtOVY0dDVHOEcr?=
 =?utf-8?B?TnkzaWdFa3NIMWs0YVczaDc0R0RGQWJLaHpqdG9lQ3MweitsbzZTQTRTZkRx?=
 =?utf-8?B?em9KVTU1M3R3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eDQ4clhnRVQ4NWV6TnZqVEpOdUhhNFR0cC9WeG0zTmk2Mnl3UUIxS2J1NGR2?=
 =?utf-8?B?Qm1CalZlcTZhbWRsMTg1emI5Y0o4c01GY2hwbms1WWJvd1BFWHhFZmVPc00w?=
 =?utf-8?B?UW8vRnh2U1plTG1NR1RKRXBZVlAvbExtdVFFTU1BdFRDVUdGdmszOUVhTU9t?=
 =?utf-8?B?bzRzRWovNXFrSlF4Wm0wWm5IMHB2UENER0RyendlcWhPSk8wTDBXRXVld0ts?=
 =?utf-8?B?RVMxZ0Z0OTJvaVh6L3dVSTdJOE43YVFjMmRQV2ZRa21GeFFKTzBLcWdENklR?=
 =?utf-8?B?V2VPMzVBS2RJTlArU3R5bFNBTEFML2hxMHdhemdmbmJTeGV3R1JaRzVyclRR?=
 =?utf-8?B?bHhCNmZpdkZjVEhrVXU3UnhBeHAwTWR3bStnUTRpbnNhSm9adDUwbmY0cE5W?=
 =?utf-8?B?WXNBNUVwbHhMei9haS9YaVhtdXhUU2V5eGgxM0pnbFV0L3lVeUNBS2tTNjVQ?=
 =?utf-8?B?eUxrcDUrSFJVeHhGUzNMdDVqME5NVVg0aEFmcFAzMERYcVM2ekYxWU1xRmJi?=
 =?utf-8?B?bkhxMERwbHJGRjB2OXcwVzJEbnpFcFBDR3JEWTZoZ0J6TlhaSTJPdmFjMkIz?=
 =?utf-8?B?QTJlUVhINm1wRXFFaEZZdko4S0lQQ0FIRXRRUGtBY2JHdFVkaVZHc0pTbXJ3?=
 =?utf-8?B?dGt6SitOT2JCMG9vVlh5RUZTTW1xdTdyV0Z0Nmc5aVJvL0FPOXhFUllpOE5J?=
 =?utf-8?B?NmxUbUhMSHNqbzlMaFJsRjVsTUROY3BuYnl3YyttOVVVRVJyVWM1cmxQdVRR?=
 =?utf-8?B?OFhWeThRdy8yTXluTkVGcDBpaW9tSnUvbHdkRlpYb00vMWVtQSswV0E1bFNX?=
 =?utf-8?B?UEEzalBWcS96VUQ0VDh2ZmtXam9EckRGTkk2RU90OW1vbUlFOHBpMG56MDJr?=
 =?utf-8?B?RjNYUWx0NEMrUG1XbzVjYnVFL1BGUjJWWUJjVDBIV0VoS3B5bWtnMkZtam1k?=
 =?utf-8?B?Ry9OdEliUzY5aFBpM3BHQkYwVHVBdWVKMkxlQmRXSHBxMzgvNjJ5VUJ1REZ0?=
 =?utf-8?B?bmpvcWpGOXVpSWdSdThNR2h2YUVlM1JmTk9JVGd1TzJ3ZGIxR3ZxRE1nOHlh?=
 =?utf-8?B?aEd1SWhGdnFIOEt4dWllTGI5SUJlRU1Qa1BhSlduYTRxYi82bThOTHUvbzNq?=
 =?utf-8?B?c0tPSExQRHNOYldNeUVxTFordnczOXRhdnhLKzlOdGZLOStrK2VNTGViZk91?=
 =?utf-8?B?cjl0YUl2U1VOdmxJRnMzRE5ZZFBJWWh3VFUxcTNLejJWbmZYSU5SMmdEOSs2?=
 =?utf-8?B?R1FKM1g3cEs3eTVjQ3YxeG1ralVacVJjYXlSU1hjUUo3WStuK3JCNnQ4TjF5?=
 =?utf-8?B?ZG5WZ2o4cm15SldYaWh4S0pOKzdyV3hNMFVxUXdLMjBtckhncmlsSHFhZ0JK?=
 =?utf-8?B?bzZrNytKVHRydVBHUEdDNUVscVFvT0lOa1NDQnJFZHBtRHROejNFaThSbHNV?=
 =?utf-8?B?clh3V3NvSitMODA5VzN5QlpBbWhTc29lbUtZQkhPdnVOZ0dOQUFWOUdNVEp1?=
 =?utf-8?B?TkdKYXNlQVVDazAvNEZvTmdlY01qbTlCb1Z6dTJOL1I5ZnhSd1RmZWdnOUQ1?=
 =?utf-8?B?U1JUaXozVXZWRE41ejdlaXBtZE1KOHgvMnhGcW0xRDZETVdnWUVVWHRCR2tx?=
 =?utf-8?B?K3dTcVRyRUt2RUZmd1VjK1Q4VmZqOHAvLzY1Njl1MEhUK21xMXlvQWpRWXU0?=
 =?utf-8?B?dGw2aWd0dUlyTXdzN3RzZUlsZmFyWW44VEpxSHZrZGVOMWdkU2MxOVRHZk5o?=
 =?utf-8?B?RzRmd1JYcWVoeFFBcDZyOE1HbEl3NWNoQzl2OUZhUmFvZms0VGtxandFMEtE?=
 =?utf-8?B?QlBXbXRBRFduaEZoRzRNaUZsZ0tJY1B6QmI1ZGR1N3NNOUNMUUhDUHRxZnBu?=
 =?utf-8?B?N0V6YTZjU3JSSUtJL2cvTStCTXlBVFh0aGYwaWFPT0gyc05oUlFRYUpqS1Z2?=
 =?utf-8?B?YUFJMDQwM1hUTDZhejBaTngyZ1JEVjRMaEpIaGV0SWloT3hCczZ4aWp0ODRl?=
 =?utf-8?B?ZCtSWDZVY243eHpKck5hWE9TT0JBeldhR3VtQWV4NkppbjJkRzV2ZUIyaWVv?=
 =?utf-8?B?MkZGMzR3elJobENoMEFpUUt3WEQ0VmtLTVo2V1dlaWlmSllldCtzSUJFcHFG?=
 =?utf-8?Q?tEP+4i84bwYyytPckjdwHzLDd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d30b45ac-6b6a-4809-b9c3-08de30ee2cfa
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2025 15:27:45.1896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2R+hwLW+pXYX33I3TH0vbyMOcvvZ8oHUYa/o5hichgq4GEsjllKRypi3Opj+KU6PBsk3Owg5bO6ikT6xVXhlgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7557

On 11/25/25 14:38, dan.j.williams@intel.com wrote:
> Alexey Kardashevskiy wrote:
>> Here are some patches to begin enabling SEV-TIO on AMD.
>>
>> SEV-TIO allows guests to establish trust in a device that supports TEE
>> Device Interface Security Protocol (TDISP, defined in PCIe r6.0+) and
>> then interact with the device via private memory.
>>
>> In order to streamline upstreaming process, a common TSM infrastructure
>> is being developed in collaboration with Intel+ARM+RiscV. There is
>> Documentation/driver-api/pci/tsm.rst with proposed phases:
>> 1. IDE: encrypt PCI, host only
>> 2. TDISP: lock + accept flow, host and guest, interface report
>> 3. Enable secure MMIO + DMA: IOMMUFD, KVM changes
>> 4. Device attestation: certificates, measurements
>>
>> This is phase1 == IDE only.
>>
>> SEV TIO spec:
>> https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/specifications/58271.pdf
>>
>> Acronyms:
>> TEE - Trusted Execution Environments, a concept of managing trust
>> between the host and devices
>> TSM - TEE Security Manager (TSM), an entity which ensures security on
>> the host
>> PSP - AMD platform secure processor (also "ASP", "AMD-SP"), acts as TSM
>> on AMD.
>> SEV TIO - the TIO protocol implemented by the PSP and used by the host
>> GHCB - guest/host communication block - a protocol for guest-to-host
>> communication via a shared page
>> TDISP - TEE Device Interface Security Protocol (PCIe).
>>
>>
>> Flow:
>> - Boot host OS, load CCP which registers itself as a TSM
>> - PCI TSM creates sysfs nodes under "tsm" subdirectory in for all
>>   TDISP-capable devices
>> - Enable IDE via "echo tsm0 >
>>     /sys/bus/pci/devices/0000:e1:00.0/tsm/connect"
>> - observe "secure" in stream states in "lspci" for the rootport and endpoint
>>
>>
>> This is pushed out to
>> https://github.com/AMDESE/linux-kvm/commits/tsm-staging
>>
>> The full "WIP" trees and configs are here:
>> https://github.com/AMDESE/AMDSEV/blob/tsm/stable-commits
>>
>>
>> The previous conversation is here:
>> https://lore.kernel.org/r/20251111063819.4098701-1-aik@amd.com
>> https://lore.kernel.org/r/20250218111017.491719-1-aik@amd.com
>>
>> This is based on sha1
>> f7ae6d4ec652 Dan Williams "PCI/TSM: Add 'dsm' and 'bound' attributes for dependent functions".
>>
>> Please comment. Thanks.
> 
> This looks ok to me. If the AMD IOMMU and CCP maintainers can give it an
> ack I can queue this for v6.19, but let me know if the timing is too
> tight and this needs to circle around for v6.20.

I had some comments in patches 4 and 5 that I hope would be quick to
cleanup.

> 
> Note that if this is deferred then the PCI/TSM core, that has been
> soaking in linux-next [1], will also be deferred as at least one
> consumer needs to go in with the core infrastructure. It is already the
> case that TEE I/O for CCA and TDX have dependencies that will not
> resolve in time for v6.19 merge.
> 
> [1]: https://git.kernel.org/pub/scm/linux/kernel/git/devsec/tsm.git/log/?h=next

