Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.55
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793634647;
	b=oWGsXEaxHw71zTQLbQiRScJktwiqa9NdDC2QwjGWZyzG9qckEKiXkm7wzOmzQWVSpAS8
	 +97KtHvevYRW3xYRoK9bBPWcQcMyKri/kd6pvBVydw5rXrJqsnaympq+EPKX2+ZgKh3p3
	 fFygMXUHxZvJptid9a9rlNuQYKIgNt9tmE7CUs0cyf30GS1IQXnpy0v0oM62tU6Y8eJEN
	 1PzyAvZ1+Roz4xWr7EURfQ2jVWh4b87ZJ9VrYI73VWHfJUNpZcgzVfkYI+5ZrhmyPLTlM
	 PSBp9xDQE2PLfFmdQFL8nM2OrtffSQcpY4hldiDR39B4P8JtkW+kYZEfvN7CRGuDFqg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793634647;
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
	bh=/xXUTYXrFK2qFIqwyvNyqZAxDXNJLoX8/eWMw7SDZ4I=;
	b=mY0mRuQ83CSaYY7LN0/zKZl9PZG6qyQogQ0OEoG1DykzzS6Xt7AF0v9vXRk6w5lu3lNk
	 OI9BIkgXrwYPQTcsrRS71Ca/zvAwKMGm3VSUwa+f2up21eiBQ0ZWXU5by+kDA7KJenZVd
	 4XyUt8IieyxEXm4wjIClXzqgWxqt3nrvI0FdW9ePWEkDbUBwvbo7FUYJgYgJy9aRgz6rr
	 8i0E0ansA1VBQ5B7u+RpBK6WdW3P36tUo0a4r1il8ATZsuVNp/XCX+aU/W/w7KEY0oZGR
	 /MMONWXvd9X8F6enlfhZdrpvqxpyC4yt/rDREgxjoPA/lsXtYt1X17MtX5Qz3or5DPQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=J4gdixjg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.55
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010055.outbound.protection.outlook.com [40.93.198.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D33D6079906;
	Mon,  2 Nov 2026 15:50:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D33D6079906
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=J4gdixjg
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vlpN+hJaddnVfqR0hH0mn1BzYCDg2K3Fa8iDFeG/JxWASRuTzW74104r04oC5U1VikYWoDht4gUeYqmBevYofS92gShf6JzblGx6nzX+fQga4zaMFdC0M5sCIyQfFz+oT/XDIlJywSheoRoeYqQOG5IBkrEd+Nxa1puqUs4j9IYz1+0Hp84UdR4HJj0y9Exd7weqhlUwOUHDdash7blEschOElFjCZ+AdUwroc0C5YQOaLnY4QFlBpn7xmJnh6P5b+HTNziiE26sAk/aJML6cubcJJB9mXLriGeoak6GfMTXDXda2aYn1UBfzveICi6xEN3JyQmbEfkkVaZJ45W/hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/xXUTYXrFK2qFIqwyvNyqZAxDXNJLoX8/eWMw7SDZ4I=;
 b=xyJe2IoJXsODEsszoHY+JE5zowXGjrapzExd3x4TQIPYEMxEmX0knymwnQwafCRResho4G7RiRCc6yuXIKaeiOrkxZazTf8sWE8axj3fcSMIC/uhTOEAWnDujwyLTzb+gOwBXofstJxuXkGfYDOCJon0pdoRaFMVCxJUDZPYcuFCBddrPcIRyxwvYyOzHATwWs5zNwIHdE4IlAjnI8OhS/ZF1+v7BDgCU+KeiwbiywbLrc1E2T3bXExPBGNFrDdvieshOoo2GEffzm7W9arI91NsVqyaTQruU+gFNSbyOM5ERhF+eCkHyEGiB/Ql7HzsLg4zK887G57+sUCYe3qVNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/xXUTYXrFK2qFIqwyvNyqZAxDXNJLoX8/eWMw7SDZ4I=;
 b=J4gdixjgdcAV+XXxqOxjfkOFWURFOoicjWraA8vVVS+1z+adh20Wj6CtMLES1Kh9QFrS/rQ7tuhVBtGQF3I8oRptDla4JFRWtzPDd26PjT3pzcdjzXMjXrRKqcaMRo5uZ12H6bPBHYIXADL53IT68ryAU/gSDoFaopHGqUbovsg=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by CH3PR12MB7572.namprd12.prod.outlook.com (2603:10b6:610:144::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 15:50:34 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%4]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 15:50:34 +0000
Message-ID: <d81f6807-26ac-49b9-a205-c89c394ec1d4@amd.com>
Date: Mon, 2 Nov 2026 09:50:32 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] x86/sev: Clear RMPOPT when segmented RMP is
 disabled by firmware
To: Borislav Petkov <bp@alien8.de>, Tom Lendacky <thomas.lendacky@amd.com>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>, tglx@kernel.org,
 mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org,
 pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com, ackerleytng@google.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1793216372.git.ashish.kalra@amd.com>
 <56da047d63b22f03a7e709fc172a5543da894d67.1793216372.git.ashish.kalra@amd.com>
 <20261102052841.GBaugfibOXxGorZKgq@fat_crate.local>
 <69ed0d93-f96d-4baa-a587-fade5a0a3262@amd.com>
 <414b2fc2-a55a-4b2d-ac70-4def101c4aee@amd.com>
 <20261102144805.GCauiipTaEXcg6Lr59@fat_crate.local>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <20261102144805.GCauiipTaEXcg6Lr59@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR03CA0092.namprd03.prod.outlook.com
 (2603:10b6:5:333::25) To BL3PR12MB9049.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|CH3PR12MB7572:EE_
X-MS-Office365-Filtering-Correlation-Id: 4040cc70-924f-424e-1bc7-08df38f907da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|11063799006|4143699003|56012099006|261009223027099003|261028144727099003|261022105027099003|261026140227099003|261026121527099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	p7H77r3CTdQU2MC7b00HXMaZI1mYqca1muUWMkqBuY26iJNroM9ZQ0tpD67M1v3csxSVZch3uC0wCZ3StRTiK7W7lAWPcmIaMfiONEpTo1LJbG6z0j6x1880PEhddeElRprn6SRbqpG9QvwP9gtfgl1Q2/96mmRGGZs13DhFlkAR5Ovth1lWrauqdkYtDQsnCulXogKv02+CwfhfuEqeAWE1P+pgqNQzxaV2KTizOYK9r4foOYK+5UkcZQpiHt4ny4n1phxd9cD44Rih5IesQvYYn/4rm5jaHze7YH0rm9Ri31YXBWV3AF8s/ardqLwFDJVc+2hTO8dLN6PxO3PX5p/MerYNcD4OnIu2WIK9JZUw63qygVK+pEW/s6cMa0TEE4vvFuSnyxyNPpYYdLBc0dJWoV4DtzcepyyRhkgXjy1LCvzao9PMUdQWT/dMorRmwfkLJdHqiBS6SydNmJgp1cXgtF+KMK5KrUtAM37nC0EvJanzaAZut80pUFqhB3me/zM5Pol/brdNNdPDKuYEz5lXqj948YgkjWe9vqQ/sAydopm5xE1lRvqJafPKQSWbc/Q/7foQs1VTQfhVf04NdGJbFV/hOOP0VW1lkXz4e1WnGqwM7Z2HQF9gydiE38MIOdyas/OoLAcGoj7k+Dl/ACRf5V2ih2MzaKogZEZxevg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(11063799006)(4143699003)(56012099006)(261009223027099003)(261028144727099003)(261022105027099003)(261026140227099003)(261026121527099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R3BRZUFxR3hub1NlNnVHK0dBS3V0dUVkU2pkRVZ6byttbDAxL0hGUmRIMnVn?=
 =?utf-8?B?N2k1Y0diMHVNcVNlcEpnTFR5NnhSSG5pL0FTSERQVFpHOFcrbGZLbUIxdVpH?=
 =?utf-8?B?WjhUVmhKY3NmWmh6WHZiazZhZzVxdkdZTmFDcEFOSThLSTJIWjNhK2hJbHBr?=
 =?utf-8?B?V293ZkF0OVd6bHllb01RVHlRSTRaeXdpNlRrMDhJbVlManV5d29VSnFsZzlz?=
 =?utf-8?B?T3p6SHpBUG9LclNLZzN2NmdGRllmSmxWdFJxdWczUDB5eXkyV1hmWjhSa0RX?=
 =?utf-8?B?T2VJQ2FmTXdSRnF2WmI2NFkrbzdyd0VEMWhqTXB5RjVzYnQrOUJtOS9vNUJ5?=
 =?utf-8?B?VnlDYlpnRkY2UHRLMnNDU1NMbmJkWXFjY1d2RnBmbnF6Q2cwbk1XSW4wOXIz?=
 =?utf-8?B?OFNQQ0F4Tk1qL0pFTVMwVzU5cWRHN2RSZkk4WDhYQUQ3TlpNYkxrRDAzejdF?=
 =?utf-8?B?QWtnWFh0SW5vZXJPSGI3djJxeERidHBqRWZzS2tyUTltVnZqTHJGcU1SSTVX?=
 =?utf-8?B?K3JPWDFmeDRDcVVzNUFtejkzTmN6KzQ2TWZySVM5eGtOSmFQRUZRNnI5eFpz?=
 =?utf-8?B?dmxVdnEzOGNCQ3l3QU1BVldHWS9kUSszWnZNR1U2KzBQUXRrZFdPUFRvejNj?=
 =?utf-8?B?VkhSNTJKMzlYRkpOT3lncWNYeFZGWmlSUjNRWUZSbUN2Z2RuMVBDVVRqcThJ?=
 =?utf-8?B?d2FYZFBVUUJjMWlIWVgvMmY1dmQxU1VpU3lqRWI5SU9VT1laTmIvbnI3eFg2?=
 =?utf-8?B?U1p3SE1nQmtPNUY3dWx1M0h2SW4xR2hiRkVzRlY1MHIzeXUvblVHd243eTdU?=
 =?utf-8?B?bFBOKzNBbjZma1B6MFNlbVVsNzlrdmpLT2c3YlRIa2FLMkpTRUp6a0hVVWkz?=
 =?utf-8?B?bDM0N0p2dVRTNGpnOVhCZWZXdDlMSkd3c1kvY1luMUNtalIyNllMNnJjRFFo?=
 =?utf-8?B?dkYzK3BCclRySVRYU24xanBFbm0rWmJVSjBBR1lWVllkcklIR1dlT0x2YjBV?=
 =?utf-8?B?RTFRaXVDMkNldndiaDA3NE5GOHJHaWRGM0Z0YVhuamIvRGZncG5sYWsyQ2x6?=
 =?utf-8?B?MDFKcFlVOHdEdWZLZkd0VE80T1ltZE1pSTExZm4vVUlRcysxQlFZcStJaUJB?=
 =?utf-8?B?MFk4di8wa3IzTm1QTnNmc3VIYm1PQVJpV0c2S01MTDIxVTNrTzhPY1J0T205?=
 =?utf-8?B?M1JPZjNHdldLTFpHTWRWRERlYzV0TjV6WWcwZDRqMGtYUWNqa1RxYzE1dE9q?=
 =?utf-8?B?UnlBNGhJTzBrRUZoTW4rSUVXcTRxbnM3V1llUEE3d3pzaUU3RDRveUlnTFpu?=
 =?utf-8?B?RlJJV0RMeHE4Z2J2bm00L2pMbXhrWkduNlV3dzBnSGFTZVV5WU1Pb015V0pM?=
 =?utf-8?B?R0pmTlRHVVYzQnZuZDFxWC9tMHRkckp1cDRESGVsMjhURHJYdlZlcGFjaEdY?=
 =?utf-8?B?Q1FFSTFKQ3ZnU0RjRGhDdFdmcVI2WUczeXkrcnZhYzFNUFpraFE4UFBYM0dQ?=
 =?utf-8?B?Ukk0bkpKUWlEdjVvNzdCZWZLSzdqSEtHUVBYcDJVQ3BXZ3ZLQ05OdEdlU1J1?=
 =?utf-8?B?M2VnUHprUzFaemFpSlpoeStCaVNCUCtDUVN0ZHo5UDV1NCtrU204YmlWYkdX?=
 =?utf-8?B?L0VtSmc1eEIyNzhrM2Z4NDgxYkNYUnFhMzFxRThEaVB1enB6bG9OL1lsemV5?=
 =?utf-8?B?WHQrMlpwZjhxSWY4ekZBNE80R0FDSkNmSDVleExab0lZOWNxQkNKREM4WkQz?=
 =?utf-8?B?ZFgxTlc2VnpYeXhyYUpyQmJLQXJqZ2R1T0djU0kreXU5a09VLzl3THROcDRq?=
 =?utf-8?B?dWtZV3N1T05ueElGbmd0ZkhBZ0Z4R0NiSmxWdlJDM1QzNDZTZWpjZEcwRzhw?=
 =?utf-8?B?bE44dWdjZlh5UUVVeEx2bzF2RlZlL0Rydy9pbktIYWY4V3JoYnVudTNCR01K?=
 =?utf-8?B?N1p4bWJ1cXdGMWRGQkh5Y21qNTVSV1dzc3gyNnJMMTJTSi9OcFJMQmtmNXZI?=
 =?utf-8?B?VFNqaGJVWVlCSVg2UW90VlhjVDk1aE9QN0lXL1VjSG1meDZZQ1FaMGpsd29Q?=
 =?utf-8?B?aHBvZWFhd0t5M1Boemh3NU5IamoxZ3Z2bTQrOU9BK2NpOHJnd2xZNVZqb1hw?=
 =?utf-8?B?T1pPS2RIK2ZHaVRHdS9uSSt6RmtVdGVaRTFPRm50V2hHSlllUWZLTHpXSXVV?=
 =?utf-8?B?bzRaTVA2dE1SbXIrZXhKWUd6eW1ZSDIyTnMvcGkxSTR0dlgzOWI4b1FWdXk4?=
 =?utf-8?B?bVZ6cmdpTkVFbTB5VUNIUk5uYUxxSWlHaWNFNkJWOERzRHo1UktHc1poQitB?=
 =?utf-8?B?dzRJWldacmZxNEZPYkdBSUZRSWdLdUptWTBFTU5XU3B0ZmEzOCtvUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4040cc70-924f-424e-1bc7-08df38f907da
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 15:50:34.1055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vZX5wbb2V2OSqOeIb6H+52LhmVKHAOXq5t9MeN5dq69zmAFq4c1/KqqFilAT/xqeHhoDxICC10TyiWnxOu8UeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7572

Hello Boris,

On 11/2/2026 8:48 AM, Borislav Petkov wrote:
> On Mon, Nov 02, 2026 at 08:12:16AM -0600, Tom Lendacky wrote:
>> Heh, I don't think that is a nit, it is broken.
>>
>> I think the code as it was read fine, but that's just my opinion.
> 
> Lemme see if you like this more (pasting it in applied form because the diff
> is unreadable):
> 
> bool snp_probe_rmptable_info(void)
> {
>         if (!cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP))
>                 goto out;
>         
>         rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);
>         if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) {
>                 if (probe_segmented_rmptable_info())
>                         return true;
>         }       
> 
> out:
>         setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
>         return probe_contiguous_rmptable_info();
> }
> 
> No repeated code, no if-else conditionals, just what needs to happen.

The original patch returns false if segmented RMP is enabled but
probe_segmented_rmptable_info() fails, your version falls through to
probe_contiguous_rmptable_info() instead. 

I believe it makes sense to keep the return false there: on a
segmented RMP enabled platform the RMP is segmented, not contiguous, so the
contiguous probe shouldn't run.

That's why i think the original patch looks fine to me.

Thanks,
Ashish

> 
> Thx.
> 
