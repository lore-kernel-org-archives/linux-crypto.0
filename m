Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010066.outbound.protection.outlook.com [52.101.46.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E647B318EC7;
	Thu, 30 Jul 2026 20:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785441665; cv=fail; b=ZcO22Uh49fEYtAtBvAz56rliteWz5hXXG02UDjIswDiPLZgbZ7JdfqrmAxkkGoQbi/1MXRkBvUcFjVyQGG8iAAhyWnWZbN8B+qzxHWtkRW14M/ex/CcojwwsUg9jBrx6PM0JnhQvtxYJW5fzxv7i/ZMYGyH8xzzlOkMitXNTk+w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785441665; c=relaxed/simple;
	bh=rrVSLuXFqMXHmxyYFE7Jq1JhO0kwx/po/M6+jSHmM84=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GEiY2dTUkl030V+y7t6kp6hTqsFgKHaBJXUPHZN14Grsu3CqW/fn/Gdy3RBS/ZKfdRt/Jqibuy8HFi5/kQVImtwrpbX64b6/XqDjW6RKJ2LzFLqnGe21ED7XfpY48GDIDrnxZ3hKrPI9IFOXOJ15jGVx4WOTNUrBr0ffEt12C/U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mVTokXDY; arc=fail smtp.client-ip=52.101.46.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mVTokXDY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rcAMRjQvCKz7WF3d29VIdGCfD8jDfvjnRnUfanOUT0cd0ZAPYntZU7cOfNUUlWDVN0+i6sbDWX1eaSzoYVowIScc8WoqnZxcMVOQQnIYcMwO2dHWHr+lptwqvJfihrZJeMQVgdSr5zOOuPPsYEkuHAlfz9pHPDj+iLkGnM2UZBny+VXMTYuqxDEb5+AD87Anx6fG4+Ax2pNfxWwKlgnioMuWvlrH6Rceh2s4/uHmZO186s0/RlyQOsUVk3JXfVKt09fZo6Ois555vXf0I/AHcbhU4FvVgZpjrbrT3L2xZ51oAQvEWA8TrcRwTfyWL52d7CcB/U9nBDyfULVKJOQIHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PlYb3CWth5Evh6VLXLSsag+DikX7UOUOaEV2sHDiB6k=;
 b=XL3w2b9hJVDkDS45NPMrDXMAne8TqfNL/Qj7U1lHZL4BB5G4dPcCQLcD+U7uIHNi5QEebwx5Gsw2r1DLa1nX1flAI24zVFzfZ9Cmpu7Y6BzuhcDXPq+orl8dhfTs1kjZTlbxeDYxyjZMcJcqM5TrJo/J0JjXXk2oT4nmfrZJsWeRxS/dYC99vV+71sBVyPjSdjMBR8+6X6qjpp19tfP/4NmFQ+Li+q7bZcRJPtwTDwXiEDxIRyOGoRsZQ9ieVfixxbnhsPsR9r3nCYVl5YxDhgm67fT9FLkQtV0Cr3gcJSVJibGoe9tzOuGkRiTYtRVY0eX5Y5Ryw8hMt3SPDRPagA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PlYb3CWth5Evh6VLXLSsag+DikX7UOUOaEV2sHDiB6k=;
 b=mVTokXDY3+GQWvhe2ERB54Pm6SAXWTzE2F2hWtU6ACfiNTXmjqzVcHON/whmuoNbldOgdMdE9OgmdnCIAClcEow89FEf7ZgrFv5QwbATlrNoSebzreQg7gn+PjlWmU81NC6kpIjnMKKtYKJ9HdIuNkwh6GWChFXthRwn4an84RM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DSWPR12MB999175.namprd12.prod.outlook.com (2603:10b6:8:36f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Thu, 30 Jul
 2026 20:00:59 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0270.012; Thu, 30 Jul 2026
 20:00:59 +0000
Message-ID: <5a980015-c391-4019-8b44-48d1373eaea7@amd.com>
Date: Thu, 30 Jul 2026 15:00:55 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 3/6] x86/sev: Initialize RMPOPT configuration MSRs
To: Borislav Petkov <bp@alien8.de>
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
 thomas.lendacky@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 ardb@kernel.org, pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1784844080.git.ashish.kalra@amd.com>
 <ff346ea1770cf996e1623270a085ac08d21888c6.1784844080.git.ashish.kalra@amd.com>
 <20260730020704.GGamqxyPy5oJAmC5Oy@fat_crate.local>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <20260730020704.GGamqxyPy5oJAmC5Oy@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0364.namprd03.prod.outlook.com
 (2603:10b6:610:119::15) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DSWPR12MB999175:EE_
X-MS-Office365-Filtering-Correlation-Id: 4dca2162-8068-49a6-2096-08deee754615
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|56012099006|4143699003|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	VUt2pze3QSC0ihz1YkoLmF7oly1EsrwBIvFg9mWUJN9IlMaKfftRVmEPDDZLL2PW7pQevoNz0LosOkBng91f3nFb728jrjLH74V/w4hMn1aAIFKKWs2Hii//LtD78PWuLz7drQgwgjTph/WTVhe/1Lm+B3tMYe8aSPySnHUEh221HQt2zhLz1PQP/ZkLe8aNJmHF/7QEAoICEcxOOYUZvw8hSbM90poSbrvyYnrEAtw5TEcWAnSk3JRo0BS/pNtxJxDKPccPw4z8wCDLCw04lxS0rW1M8ofxWuxTP89JUocJsaAlVyxQCmpehAem2IMrhhyougYBuT8/wLzVrSiUFn3o+hnR0B8WkCtpgF9ASaxZagkLyxb9pyeyt082knytsagX9eOkZDJCKjtCbG4AFQyRuxgP+pIVAScJ73S/uwXy13556EQK7PEUsnq6OTWHwQ23Byp/2q7z07Z5oDcBT/XOAR0xlMiPtpmJIykTeVM7ANBTSfIdas1gOTPwjgfzJTP5XKl5PIwlieZsd22rpfOy4zj3q/k8ll9S7gHFRkaAmjykOqFJWBqWGpRKfWzXLKnPuqTcBNzJqUfaiE+cv5RJHOTJ/ZAivzDU5iDuS2v5cRvEGqpztSsq+YvJuBg+utWRjTuogdoT076lB//ItR3LDPlW+ZYgJSyM63rpaJA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(56012099006)(4143699003)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a3ZUMWlWTytKZlRORzhjS1BCUDdDKysvaDU4TW55OWNDTHhZbzA3K1ZUdndz?=
 =?utf-8?B?UHVIOU04ZFNvQ0FNSlZXckxPUEZpQitjZHhEUWNxR2F5TGF1MitqLy90T3N3?=
 =?utf-8?B?eTQzbngwMDVVcGFXai80K25zZG1mZHREWEErNk5ZMWZEd1cxQ285T2NYQVB4?=
 =?utf-8?B?bldxTitKdEFsZitPeDFhaUVaS1B3eFcyRGNqYzVQVGNtOVNOSkJqRkU3azVj?=
 =?utf-8?B?MDJOZGxCdDV2d3JnWFVPZTZkbzNLeVdoZVNiUHJvUlVEdnNvZ21NS1NpYkMv?=
 =?utf-8?B?cm9ZME5vQlkycmRmYm55bUpHdTRQT0c0UWVrVFo2bnlySlhEYlMvaTIrQ1Bk?=
 =?utf-8?B?ZVdaRWlKbytuZVhPNVBrK0srUjROcEtEYzM4RHpPMHJIMEQrdW94U01kN0h6?=
 =?utf-8?B?N2M4aWVSL0ZSSzJQUmROTTdhOWFJM0lHcnlKai9HL1lOZmFRMXhTQjFYMGdE?=
 =?utf-8?B?Q1Z0N1Qrb1BlUDNPSWtWVEVKMitpWEkvZk5iaGthYTNjeUhjcEhqOHBCTzcv?=
 =?utf-8?B?T2dzbG1YRUlSU09jM29veW5WTDRDUmtqZkZ0WVlIRTZuU1NJc1pweUNqSTA0?=
 =?utf-8?B?bEgwZzZEeDU3bExUU1VvbzNuRjgwMVBwa1R3SlVqa1U1SzNVNEpmbkQ2MUEz?=
 =?utf-8?B?QzYwSFJyUUtCblZvWEFSZ0dBSGUyR3pWMzVGaDJsZkxsYWc5cFYvb2JZMWly?=
 =?utf-8?B?dEhzMWdITThLM2FxUHdHVy90bW0vQW5GZW82WDZWL3NCMjFKbVVsZVFRUVVR?=
 =?utf-8?B?Y3Y0Z2lDMnN5NGk4cnRkRHZHL3lzYkR4dGV6cFhoUFU0RnZHSWZlMFVYMDla?=
 =?utf-8?B?cTExRVV5V2lOT3c2OVExb1U5MHYrYVFtRFRNbXo0d0lmQWZGTDFvUVNPUGlo?=
 =?utf-8?B?RithRktHenNtTGJOdzlQUzNxYUlkREFONENiYlhJckR5M2FsZEczYThLL1c0?=
 =?utf-8?B?elVZdmJyYjJaUHJPSkl4Q0F5MitPdmVRbEhia1dlOEdURElHYkRlRzFUWXFw?=
 =?utf-8?B?aTY5dTBaY2E5MS9PdEFJV2o2VWF4bEJUM3FTUmFNQURLczFNQ0Qvd3F2azV6?=
 =?utf-8?B?T2VZVzRma0F3anB1d1llMTQ0ZEtZY05JTHd5eWFtemlCaFRoNHFKTHB4Z3l5?=
 =?utf-8?B?VVpQb0pYRFQ5N1VoSVRzamVXZ1Q4djNydlBBSmF2bWk5RXJYb3M0YVB2RHha?=
 =?utf-8?B?SkRvTkRiUU54Zlp5UHdYbkFkaXh4SFBud2xsS25rN0VKcWFsMVFtR3RTTEJT?=
 =?utf-8?B?ZUJXMVptc05JbXc1RG56VSthODk5SHBESmpLUHorMXRkVlNyQWdrQ3hJZlh5?=
 =?utf-8?B?VVNIZFRsNUpDSmg0Q0pnVHJRRkg3b1REYjBxZDNaK0VPL1lDOWxMblgwUTBs?=
 =?utf-8?B?SzRERmsySUw3SWJqR3VCNDFrYUlaTXhBTHk1ZnNPbk1XSGFmR2FESFZqbEN4?=
 =?utf-8?B?cHA1eXNJYURIaEppSk9xMlJkOHFpdWZUNEZ3MXBUaWlVZFA0cEo5QndBQXUx?=
 =?utf-8?B?MlQ3WkVvdDNSZmMwSVFzS1l1TXpXZWp2aUdneVBJbFdTalcxcDJSbXZSZFJZ?=
 =?utf-8?B?Z0tVSWNFYmFLK0owbHJVTkk0MzdncVdHSWFaZ2Z0U0pXMkdSWEJCNGxWUnJ0?=
 =?utf-8?B?RkM3bVBJYnpTei9ZeUdZOEVWTHFvSVMxSHd2U210Nm12aEUxSWRub0VXSzNE?=
 =?utf-8?B?d1RjQ1hXNjJjejBRYTYxd2t6ckUvdmU2S0pxOEp0M3pCQWdQTjA3N2tMSW9m?=
 =?utf-8?B?RmwydFhTWW1BOGxwb0hFdEt1ZUI0djNVSFdta0VmajRVVWNhV3BuSU1qVE1D?=
 =?utf-8?B?T1FzNmUzUlFMSDBzdXFRK3BKczhGRzQ1YlV3S2toTnA1SnNWTEYvckhScWJ0?=
 =?utf-8?B?K3Y1a1BIcWZBZEU3MCtnVVE3blRuZ3l1UHJIZVVNZXErNnJLTU9URUdMNVA4?=
 =?utf-8?B?RUNNZW9CVFlQdjFWSmlsTGo1THRUeklZa1ZobFIzS1p5QjExZGdNT3JvdHNT?=
 =?utf-8?B?NHdsRzBuV01MeU9aUHJEdkJtdUpVZUtVc0VOb3ZoUEtGUWVEYjFkVzJyV3NB?=
 =?utf-8?B?SHgzYXp1Wit4SUtYNTVtbFJoOFdmMFRPVkFaTmF1MlVFcXZGVFc1MHlSNlBr?=
 =?utf-8?B?YzkvdnF6R0ZuSTBsdWQwSWZ0WHV1M2kyTzBCaFFnUXNucUFCdW5vTzNzM2d0?=
 =?utf-8?B?ZW05SnZ2WmluRmpuMEZoNEw1cm9RY1Y1aXZMWEtBaEI4ekNQOW93Tk55WVpv?=
 =?utf-8?B?cHlGeHpjTDFZVXhkdS9OdEU4Ny9ic3pCUVVFa0JmTUIyT2lGM2k1Z0dDdkt1?=
 =?utf-8?Q?y9ZK77Q0B2dB5K87Fm?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dca2162-8068-49a6-2096-08deee754615
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 20:00:59.1174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y183B9mobkcpKaHZ8MbBFdy7q1i8Pe61ooXeoMzsVqkQqNKofS2y4ZMKBLt103AvooOFhwrg90LC8Q5UrXt25A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSWPR12MB999175

Hello Boris,

On 7/29/2026 9:07 PM, Borislav Petkov wrote:
> 
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index ca473ca198b8..c002a7ca26a8 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -1477,6 +1477,9 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>>  	}
>>  
>>  	snp_hv_fixed_pages_state_update(sev, HV_FIXED);
>> +
>> +	snp_setup_rmpopt();
> 
> Why is this thing here and not at the end?
> 
> SEV-TIO is supposed to always run last or it doesn't matter?
> 


No hard dependency — it only needs SNP initialized (post SNP_INIT_EX/DF_FLUSH), and the initial pass is async anyway, so it's independent
of the SEV-TIO block and the panic notifier. So i can move it to the end (after the TIO block so it runs last without touching TIO ordering),
but is there a specific reason you want me to move it to the end, as it can just stay here after SNP_INIT.

Thanks,
Ashish
