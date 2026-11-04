Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.7
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793806831;
	b=kEVyYyPA8s0gCXzARsAFRd29AAYbF8yVe/rvfVvB8n6T/SZWUS9i0N5ug7LI56TJ/W8C
	 q0lpNdw3Hx6wIYrSeVKMN7qD9TSt/4pJr9WREOGAd3xeFEDgYDV+5LCnk25QFluEXCF8x
	 3yMWd5283BogbEIGdw60mvuKhPnMYLQbP+C9xLEVoUuHPOSCOTrA84cdjJhf0NNLTAByH
	 /Bbq7CFQHPq07xrSqwyF/9XUvOhxiv7YGhiZXoVggTqWCvSCDp8ZP/1zaOTQ8/FFV90JT
	 tBNj5u0vdwsIg43YVE0A1MYpHXMV8vGU5EgYKwkuH0D01LlNfrTCglxu9G7RTX9sjPw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793806831;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
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
	bh=xS/N7zxhJv3baKagxOTUiaG8MZuyleQUxILuBLEoppo=;
	b=G5o5JTEOn4nDBlmDfKBI3dGf0OfuIOLINYT27NMIYqIbCcEpIARyEBRnNuw5d03P2PO/
	 X8jRbXsR8B7+rjFRpw0smKDPuS3JTB2Ghg+c3Eks0b5VG6TkkTEc+gYrl+BSo3j9cWGWC
	 nzu+Uc+T90sWur+pBNDfHbDK4SXlek6XRKPnkBPFHOyTc3EVEui0riTy3dGlqHXyaAqVv
	 hEupcArF39iQcxtfhbqNzodF4UkF6GmZrLa8efr+9Y+k1BhD7EjPJI5+PUte5IgvNrjE/
	 frGsgb97qWJkFjz3E8fzkJhSr4IqffBni30FEdH7GRvEOBqutKMluk2WDbYqLmxVVKQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=JeGW5ZjG;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.7
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011007.outbound.protection.outlook.com [52.101.62.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30766082BDA;
	Wed,  4 Nov 2026 15:40:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F30766082BDA
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=JeGW5ZjG
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vQShm8o5EUsl7gD+dvp3TWz06QG1nzol5+yYKO+PW6m5Mopp71XiOHUS8sm3C+7weAjaykRzXerPPVkzFjqb5ikPS8BN6nesoUvsTmIjHtQv4Mluiz7feUwT9yAm+kt+/qrpHsF0afcf8YKNWvOrWWt6nWAFhH+I8XtIRhL8NXch+0GAIFtkr06ayn4gkc7O+3R5W7rONKNj1uqYzZWuohmLtvxqvWSMRctgOS46J4dwqTejX8mzVLYBVGOg8AuzAP0f7wydRWCRmg8igMteXcMBMjro24wVoh0EmpiKCNRwhkVbHtC9fa3QAhjr6Eq+XNaGD7PxHydRmAK38tUGRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xS/N7zxhJv3baKagxOTUiaG8MZuyleQUxILuBLEoppo=;
 b=NyuKMD1lQBnnVz5ae/Oe50mGBz7ZuairYtXveVxx5KEQQQ1cIcNaLBrJdyOEC2S7ejO/tdNYjusm9oSDilrwlZZ10evrlnLsJ35oEDQEK5UYkoVQJ3uerr6k7wKW+U6lnN46WET8ka3jhyxn3d1FIhiZbwroL4vQ2jRw2mAsqxbXJvoTnqzfAJljO7NvNt7gbHpflhXFcf0IKV+CWlz8QD/x9utqrDb7/XY1fiF1OLMFgte/Ui0/CsUjBJb7zmWprW4sG/skDrQ5QTUSrPJLl3pGIG2R1/U6NOEK9CSerfz+SeveMIUCiaFA/N7ir6poA9oc0F2N4gUfvjXIpL+d2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xS/N7zxhJv3baKagxOTUiaG8MZuyleQUxILuBLEoppo=;
 b=JeGW5ZjG+zVeE8715MCrRd6lDQ9zqkbD7kCZux8Xf2A8zx43JEta+F38a+f+yi62lsocS68oX8dvhw1YmmPVQOaN2O+Cofqj7kl4xiLuXqlWGpkV7HKwZC5d6nCZ1NeCY+EiVsgoHE58pZYb/t+huTUjPCjsa9v+i5W+/yVkl5g=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DM4PR12MB5915.namprd12.prod.outlook.com (2603:10b6:8:68::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Wed, 4 Nov 2026
 15:39:43 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%4]) with mapi id 15.21.0592.009; Wed, 4 Nov 2026
 15:39:43 +0000
Message-ID: <6a3d149d-3086-4450-a2a3-01c83f73fda4@amd.com>
Date: Wed, 4 Nov 2026 09:39:29 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] x86/sev: Clear RMPOPT when segmented RMP is
 disabled by firmware
To: Borislav Petkov <bp@alien8.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>, tglx@kernel.org, mingo@redhat.com,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, herbert@gondor.apana.org.au,
 davem@davemloft.net, ardb@kernel.org, pbonzini@redhat.com, aik@amd.com,
 Michael.Roth@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <69ed0d93-f96d-4baa-a587-fade5a0a3262@amd.com>
 <414b2fc2-a55a-4b2d-ac70-4def101c4aee@amd.com>
 <20261102144805.GCauiipTaEXcg6Lr59@fat_crate.local>
 <d81f6807-26ac-49b9-a205-c89c394ec1d4@amd.com>
 <20261102193116.GDaujlBJc3XjG3xzLj@fat_crate.local>
 <9ebcb83a-1c0e-423a-8730-eff6b710634b@amd.com>
 <20261102214343.GFaukED8ep3EMmQxfx@fat_crate.local>
 <30947e17-bffc-4c70-b19c-56504771c9fa@amd.com>
 <20261103004531.GEaukuq9sXbCs_PjfL@fat_crate.local>
 <78bc08d8-211c-4de0-b99a-2932d5612282@amd.com>
 <20261104002910.GBaup8VlLyafsjSbth@fat_crate.local>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <20261104002910.GBaup8VlLyafsjSbth@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CY5PR19CA0075.namprd19.prod.outlook.com
 (2603:10b6:930:69::19) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
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
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DM4PR12MB5915:EE_
X-MS-Office365-Filtering-Correlation-Id: adabeed3-d759-4dcf-ea78-08df3a89d8b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|10067099003|22082099003|18002099003|56012099006|4143699003|261022105027099003|11063799006|261026140227099003|261028144727099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	8fUzbQrtesm3ZMLiEIkNMTuXIw6PIBIHr7aE4Yo1wFAGKFqO+AYNhDkePN2x5tflftiHf+p54rfgf17nxjVBTqozSMPIi8s3bNOgi5zW3/+NoeTlQ6TSsqhgGklOODX5VgJf/ILzOSnAvrhAbe0iY8JlQ8fM9v9RndRMIpaPHbbF5kLb9IYgzN6YT7eF6sLulcM7DJ/AnHulZ2C7ZPXGmSDIFRNcolp6xi3wdsm1mF+bP0f5AtgpB1UsbuQr5GdlsPNrYDHoU6bVVzO7qa0m7AFR3nEGndhn/MFcyOdboQEAWs7ykDNmmTs4PDdgm1npcpapu1gLS5JIiTL1SChG/Xlnk/TBMYVVWEWuy9aVYZfLuZaDOdT8a0h8rlYkfpCngeah5GXA+jJkseHb9ZIfs66ZQwmhel2Mm119iQcNB7ck8//ll1ZW2p39KkI69oA6u6X94rDuCW6kqW2ZB0Hxvd9gYqtZfW0mUefRgL9VAnHd00jOUokRvd3LFrNjW3L1U1irtm1AJ96esj1cA5Qvi4oqrQxIzWH5W7PHzncMV+1QaJUnpLagGYYnPU2s8AjNxTJGN3EtTdx5P64O9SRGy8zWlmknwmpafM1I5lbyjM+8p1q6L9GUB92kpgR07oxn
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(10067099003)(22082099003)(18002099003)(56012099006)(4143699003)(261022105027099003)(11063799006)(261026140227099003)(261028144727099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RmhIUlBuVWJvcFUwL3F5c2liQ1pnY09ZU09Uejlzck5DYUlTUmNOQjJ1MlRB?=
 =?utf-8?B?eUFRRlA5MldLd0gzdUo2K2VmQStPZEhBdDl1ZFNSUDM3UUFZbnArWGV5aHlp?=
 =?utf-8?B?SDNSU0x4OUdPYmpXZmNoMjVUTVUxRmZiQUs5NnAyTDhhVUVIM3UreUtxT1Z4?=
 =?utf-8?B?WlA0WWFrdGk5T3lhR0JNNThSY3NSa3NOV3E1bUNvT0lyVUVDNEZod2RReVlz?=
 =?utf-8?B?V2VpYmJnM0xYZUpZWkZ0OGFzd0pCQ3I3bDFYN3JnT21GV2w2WEZxTnVQZnJ2?=
 =?utf-8?B?bThGaC9JTDhQdXpJNk5nRXd5dE15bjJ0R3NjVjh3dWNidW1WaE4wa2xFSlZr?=
 =?utf-8?B?N2ppWnM1TmNUUENEOWZHOXQxVGdvU0JFRmVOTVVrZ3Z6dmtsTzZGV29vUUVZ?=
 =?utf-8?B?R2NkNm5aWlZ6cGtwUmhiU0V4eVZudXZiK3pZNG1PUnJEeUlCNUFNejhFSFNn?=
 =?utf-8?B?YTI1VFp2OGQzVW9xa1V2US9TSGJ4d3NFM3dyVUhvOHFBKzBBWFVqOE9VRjhu?=
 =?utf-8?B?QWdHOGdoTmdDR3pZaFlsdkNmMDQ4bWxXTFlKeExRNm4xaG1FRFVEYUZ4MlJJ?=
 =?utf-8?B?YWliejU3RHQ5TWlBVTk4bDRiWDI2KzBWcFBDVk4xb0QyTks2cWRVeVNNbVFG?=
 =?utf-8?B?YXJMbDRsakU1MjE3NjZabWdCY0REK0FjMXpXdm1uZDJKMDlBVGQxNjVDNkxY?=
 =?utf-8?B?ZS9Ta0ZLTzNlRnQvbzNQTHJJZW93cVByWGswUDBpTXNrNy93NEMzZTJTMXdl?=
 =?utf-8?B?V1JXL295SVVGSEo0L2VnbUdxa0phNDUvcU1MQUo2MUY2ZHRIaThLYWxtMzRZ?=
 =?utf-8?B?YWQwMVA3aEp4MUtIYnhTYkRaSm5SZHg4eCtwRnAyd2JvSGNEVW1JZWJjODlW?=
 =?utf-8?B?QUVrcUNSTEtmVEd6Um8vNlhISjBINWIyMUlRUWhUZUVWNlFlUi9POStUdXVH?=
 =?utf-8?B?bU5hNm9vK3BvZEo4NGZvSEI1aEpGZkxTOTZJWDdhK1o2Uy8wcGkvZGFNODF0?=
 =?utf-8?B?WFY1RE0zRC8xT0QrTEhraHd2WjRFb0lORStSeHZtUjVDOFVMY2REUFZZWHkv?=
 =?utf-8?B?dDIrM0FrRWlicU1Ha3NETVpXKytvZW05WC9WYzBCTjdaNDcxTDFFVFc0YmpQ?=
 =?utf-8?B?Q2E0MWVDUFJuNWxoelErZTROSzdWZXlZVXBVTEtkU0h2M0VwNjB4SkJMZXJa?=
 =?utf-8?B?R2lZcjZVTUJNT3lZVHRkRzl0YW5BbVMySDM3TW1haWJrK21sMVlnVUxJMnBW?=
 =?utf-8?B?TEdtR2xiVi9vbGxsM1FrSWpoRlU4TWxOMXlucmk4aUxIZEFSQ0F3K0JMbnB0?=
 =?utf-8?B?MHFpOStXK29HbFkwaUlTQUF1V05KVXEvU3lPNXMxVW5rQ1U0ejZyTHhJMGVz?=
 =?utf-8?B?M2pkN3RTdjhuaGhpeS9SSmc2TkxkUVh4SklFb0pqMEdqWG9UZkNCaStBQzA4?=
 =?utf-8?B?QVoyS1hqQWVwSjFpTVRjUDdHSCtIK0UrT1BJTXRIelR3akIyTXB4WWdEV3ZV?=
 =?utf-8?B?emVqUzY0RHNTWDhyTXA0cGlFOEU2Q1NUUklvMTZkUENpQWh2R3pubSt4NExD?=
 =?utf-8?B?UUZuYjdKWjZRNm9lcyt6MnhsbnJQWk5zMVpoU1kyNFVHYitYM3g1V0MxeWRt?=
 =?utf-8?B?ZjB1V1dORUxzYmYwTm1OenVBUUhWKzU5clZCMzY1NC9ta1VWbDRVTFpJODYw?=
 =?utf-8?B?SmRyUXZTWEdjbGdKMUgvN0FmSThycThqWWhaVUprcmtWUXpwVU5qbmh5WEhR?=
 =?utf-8?B?RHBxeTlJcThuRlZpU1o5OTNOTzBJT0dXbnNpZXZQVUVCcmVWWjZBQWMxZTlv?=
 =?utf-8?B?YnArSzVob2lSTHptNlpkaHBCZkNmdWNRS2FDUHhHcjBlUmp2NnpLUEdCWG9n?=
 =?utf-8?B?N1JyOU9GNGN2d3lSVUEyaVZtUFFjVC9VdHk1bjI5akVHZFViK1dudmppUGJ5?=
 =?utf-8?B?QXZCRE5EQ3NlREl1OEVWc3ZCNWN0cnF2UW1jUUdoKy9SNFgrTmptalp3NldW?=
 =?utf-8?B?VzRoV0NhMnhaMDl3L0FCOEd1ZVQzcWwxNmVnRzFEaW00RTdWSkxHNzJUWTEx?=
 =?utf-8?B?K2RNNzhhdzYxQzR3dGZ5L3daNXRaSFY4QklTLytBN1padzh3ZmZHSUFveHpI?=
 =?utf-8?B?R1NuK2V1U3h0S3BKSDFGWHhHOWZPSWFWYUxPdkIxRVIzdDVkbUFzdlpTTTdv?=
 =?utf-8?B?VDdoZDA3c0pnVHpCNWsvbnczOTEzWlVyc3czOXFGL1hvdE9LcTJYN0dLVUlH?=
 =?utf-8?B?eTFWYWk1aW1pdy9TdGpXMUhjendLWVpFaXNMZ1h1RkFyRTlaSjFZS2lZUFJy?=
 =?utf-8?B?S1lTZUdxQ2ZIM3VQSUJIS3dNVlc1bzA4SlBYbWJ1RzNNcElqcjRvUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adabeed3-d759-4dcf-ea78-08df3a89d8b6
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 15:39:43.3265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8ZLzny+qrOVs57fWVcSlARNFIoAnUeLZhABUH9HLRnx5XE25en0+wQhlrZgp4jHZeL6GVrHZzFkrwTznOhuphQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5915


On 11/3/2026 6:29 PM, Borislav Petkov wrote:
> On Tue, Nov 03, 2026 at 08:59:25AM -0600, Kalra, Ashish wrote:
>> I'll wait for you to push to tip:x86/urgent and re-test there.
> 
> With patch 2 ontop:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git/log/?h=rc1%2brmp
> 
> Thx.
> 

Both patches look good — the commit-log cleanups and the [ bp: ] changes are fine with me, no further comments.

Tested on an SNP host: segmented and contiguous RMP, SNP enabled and disabled, and an SNP guest boot — all work as expected.

Tested-by: Ashish Kalra ashish.kalra@amd.com

Will re-confirm on tip:x86/urgent once it lands there. 

Thanks,
Ashish
