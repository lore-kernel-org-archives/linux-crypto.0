Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E242D3ECF;
	Wed,  9 Jul 2025 15:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752074064; cv=fail; b=OyXoXG3JQTyzHZhBwVF0f+S1GQpq16xG1TG6Wu2y3/atKL6Nye8Nz6Gjjc5qtQ7S+UMmw91HSbMawmUQC3cHauD6EECYbH7EI6+7vdYBLMOOo+joZgm8haxrcxVICBkLzttcXXsrADXd0jnYen3KlWv/bc661YHeVA/rXl6id3s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752074064; c=relaxed/simple;
	bh=RIhxcX90RACjbGogym6xHLvMnLHkL1taVhSu55GsZCo=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ECLuKPGx1H7qx2uk8BcAV+FViGwWRMG+nsey3TKpw/zsdCZhYtGJdJxo/Ruu9hJznpuwsMHHCgjzDCvnOzUCyXOCCvP080/yoqjvYj8VjatdYdxdr9MOWwVMhN6eR6NUUKKv+50gaTwYPvgfX1KbiKD1nvZIW0lzzMAasAvUY+Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=o5cqtbos; arc=fail smtp.client-ip=40.107.237.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="o5cqtbos"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=byYUORxMODvBNv31vcFvQSVusAwhB1Zjn/C36Y57B/YxgDcno39n0sOnoE23H+LP+JwQLXcDwKuHFtBlHRu+WORn2yN4IWcRwD2p4gfFfozfI+/sV9qlkuqTZBmNzkoxDnQZSdfKoQtKKPEBGVJ76z8wjcPVXkcdn1kywJrzHO8ll+zi1ypVvo2jGtGPh1iZCQGRFSKVXhnxCCXKoMnseFuGu/cdCa1Lv2H3C3WZw613ApTBvCt+4pHcgNjpjjIiItWcc/ndgffNx+hlVP6olnTuOO8T2XAK1Ps+4H1ISPAtNXwJy/gDq8HRZcvWHiuHpSLcapiGl6+yUcnHnjCHog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rXKrkSl4K8XDpmrEB4Khce8QjHhPbxd7P2grPbKH/NI=;
 b=OVgbx/wj/S/t9V45XDFSI0bndRrQpFqxT7UR5Nin5xe6F9guG9ViHkQ8YEBbm1V77Quf31yg6MGVIP7kWfzJeLUHqJZieK9fLpNWK1veqy2jwdsJSCIe2IQdQvKPMaIf0gLy5yGt/sw3ywOUQzFkgvIkcuKYGBOQ8chsTCj5vhjVlIS2xQ/dqDFP2fkBkvlZKV1zT0hO82EPC9F1e6seYGqPLh/RB12D/z0q7uNSySGZOL3hwsgzjlJ1OzgvdMYhPHKx9Y5RjV7S7nHNAMjmQ7/bMj6Hl19CmQvBIEkmMcMK5CWPOUa61Dm+1ZbYcRDpK78jIk8ps3ga2TiiOK8wIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rXKrkSl4K8XDpmrEB4Khce8QjHhPbxd7P2grPbKH/NI=;
 b=o5cqtbosihOl81XfY9LH1ZneZnm6Ur70ruSG/Znq9ra9CqcG5S2CfJHOwVqH90spsUQFgXyA1kuJjVsTEmhTKnvM7MsYM8tqDEvILJZSh1hjH7RL/Qj966wZdlVYOpn7HmMBu/LaeVvvLmzj8MrKQ091AUMmKXYtORCegM6D4Eo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB8660.namprd12.prod.outlook.com (2603:10b6:610:177::5)
 by PH7PR12MB5879.namprd12.prod.outlook.com (2603:10b6:510:1d7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.18; Wed, 9 Jul
 2025 15:14:19 +0000
Received: from CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::222c:662:e585:3404]) by CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::222c:662:e585:3404%4]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 15:14:19 +0000
Message-ID: <a5dbf066-a999-42d4-8d0f-6dae66ef0b98@amd.com>
Date: Wed, 9 Jul 2025 10:14:17 -0500
User-Agent: Mozilla Thunderbird
From: "Pratik R. Sampat" <prsampat@amd.com>
Subject: Re: [PATCH 1/1] crypto: ccp - Add the SNP_VERIFY_MITIGATION command
To: Sean Christopherson <seanjc@google.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 ashish.kalra@amd.com, thomas.lendacky@amd.com, john.allen@amd.com,
 herbert@gondor.apana.org.au, bp@alien8.de, michael.roth@amd.com,
 aik@amd.com, pbonzini@redhat.com
References: <20250630202319.56331-1-prsampat@amd.com>
 <20250630202319.56331-2-prsampat@amd.com> <aG0jxWk1eor1A_Gd@google.com>
Content-Language: en-US
In-Reply-To: <aG0jxWk1eor1A_Gd@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0057.namprd13.prod.outlook.com
 (2603:10b6:806:22::32) To CH3PR12MB8660.namprd12.prod.outlook.com
 (2603:10b6:610:177::5)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8660:EE_|PH7PR12MB5879:EE_
X-MS-Office365-Filtering-Correlation-Id: bed56eb5-66dd-432b-b1b6-08ddbefb46c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q1ZRM1p0bTRXamJnZXJZOVBTYkVTWS9NL2NHd1gwQlVPeFBQcnJ5a0cxZUFn?=
 =?utf-8?B?dUtxRkwwWENWOWQvaExxNEc2RitkTHFZSmEwM3U4WENMdG5IRzFQSXE2V255?=
 =?utf-8?B?RzhxTEJtdTRVUVBMWXhlVkJTSWdrZkZXZkhBZ0JMajhYWEVUblJUR1h0QUNw?=
 =?utf-8?B?eEFJekxKVytKTnphVmpGcmRvVDk4T2hBMWVQNFJxSmY2b3ExS0RUYWtmYVRE?=
 =?utf-8?B?MGpEY2lWRkZxTWNqNkxtT3FxT20vV3RoM0hjakpmZmFtOU14cWdPN3d2Zm9X?=
 =?utf-8?B?UVliRVZ4ZWE5MUNhTUVPL0p0YWMrTkQ3OGR2Zy8vSkJIZXFYK1FucmFCWjM2?=
 =?utf-8?B?STZZcGZJd0taMU4wbk1qSkpiVEhIRGNPWkF1Wlczd0VrV29VODBuWm81MkN3?=
 =?utf-8?B?U3ZQanNTLzVFR1BTS3ZFV01XeG5KWkRqTUpET3dKK3RxUllrV2VDU1M4ZXpz?=
 =?utf-8?B?dUVHQVJheitlenluTjJ0OVNqWXNyL2xXZUs1OUhLY1BKdmhWc2tPd3RkNE9x?=
 =?utf-8?B?cEI3bFJKVFFvUUJQaS83cGhteDFuTnpEcGNWemNFV3pNUnBwUDJRV2VJenBy?=
 =?utf-8?B?NVZrZk1zUXFMeUtaV0dJOUdFeitrRDhveGQySWZ1Y0ZBMkZHRWE5aERKT014?=
 =?utf-8?B?dGNXdFZHU2dRR2RHQUJLSUQrWG5LMWRNdGdCMzBON2xKb1BXZGVZb285UjdL?=
 =?utf-8?B?aUdwTFBFQU9oS2lmVXlPdHhlY2Ewa2VDRzVDVUdvcktOZTV3bWxFUnNYM0FE?=
 =?utf-8?B?Ymg3bnJ5R2pKZDdKRnNmRk9QQ2crRjM0MUlvUHAzR04zT2owb2p5TXFURTZW?=
 =?utf-8?B?Q3RVRGgvNmJweGRWNFNabVVERy9jNnJqRkhSbjZBQkU1aDJndnRlTCtPNEdl?=
 =?utf-8?B?UDlwNVMxLzN6WityamZyc3ZKNlV0WWpGT0VwV1p1bVhGRkRVWG9tMFI5MXRj?=
 =?utf-8?B?MkhUSmh0OEpiOTNYbXozdzVxTFVUeUJVaGQ4QlZTOGJndWZPZmNwNmpMU2JD?=
 =?utf-8?B?TFczMjVVYlQvcCtjTGc1dlkrdE14MC9KTC84REwrbjZyWDNRODBzT3hQeEtX?=
 =?utf-8?B?V2I0ZTZ6T3UrYUNsVnlDaFpQeVRXdnFLSFRRV1lWUVc1bkVCYTUwcU5veVhu?=
 =?utf-8?B?QW8yU0tDZDh2Nm9WQ0JmdDVINnlkQWYzdDJxMTZNMi9oRkU0Zmw0YUxRZCtS?=
 =?utf-8?B?V1MxWnN6MVNlMTJ5UFpQc203MEEwYmp0SWJnMDMvRVYyQ2p2aUUwVFZybHFs?=
 =?utf-8?B?YmszREs0WWpKendXNmhoeEVDVWZOSzN3VTdCdVhOeWxPL0JaT1pSdm5XVWRw?=
 =?utf-8?B?U0NTQjAwRWtWOWhJbVlrK2M4NWl6MHR0Y1hpT0RPQkk0dzcvM0YxaU55ejVT?=
 =?utf-8?B?bGV0RUFNU1lMWlZkczZRbkNPSnNqSE1SaWpxaWNpUmZ2OW1YWkhkM05GZjhT?=
 =?utf-8?B?VHRjSElGRDhpdTdzSDdIczF1cXp1Z1JRVkFaOUIwUTg2OFRMMjZ4dWR0SjdX?=
 =?utf-8?B?Q09OM0I4YWo2d1BLUG1CNk1TTXErL0Z5bW9nc1pIeFBBbVR0Zk1KeHlUaUFQ?=
 =?utf-8?B?bVNSUXhoVGpsYkVnWElUbXRnVjU2U0cwcStiNit3Vms2L1dCeVdpTjNlZys4?=
 =?utf-8?B?OWUzR1lLLzhLN3lpZFRZMjgzOFNWWG5oOUZWZm1XcGRNKzFqbVFkSjFic1Bv?=
 =?utf-8?B?VDJuTmNZYitOTnM0NWJwZzZNMmhwdUtPUGtZMTV4ZU5TT0g0WFZKN0EyQmNU?=
 =?utf-8?B?SW1POUM1eEwyRGt6b25rRDJLQkZHMmRlL2p6UjQ2ZFlMVnM5cGpHeTF0R3VT?=
 =?utf-8?B?QVYvQTJCblNiZ0Qwc2FpU1FxK2txcHpkcnNNc3ltNGpLN00wVmpZZ2Q0dVpo?=
 =?utf-8?B?Z0hlalBDWmVkM3hjSTVRZTdmVlZuKzBpWSs4aUFsRHphdWZJOExCOXBYb0hk?=
 =?utf-8?Q?nB6atL0goWY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8660.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bU1XZVpEZ1FwT2hZODFRRU5NY3JIMlg2bTNobnQ1cFZhZFQveGhPdUxVVjV0?=
 =?utf-8?B?SGFWVDBLeDFra2VpeW1zUHdOblJMT210SFZzRWVkTDdVQnNzeTUvSE42OGZY?=
 =?utf-8?B?ZW14TWZ2WG1veThzem9KTkRqN1kvQ29Zc3pYdm13Rm5ZVVlUMDFHWDgxRjRO?=
 =?utf-8?B?aFN6SURITXBOc3lUdUNkVU5mU05Kckd3UlZnSGYvYzNXdzdXclJaNGtsRWpJ?=
 =?utf-8?B?QUY0ZzVZbXA0MFgvcDh4QjhLMHFBY3ROZDJoejUya0s1b1MzNVk2RDZZTmRz?=
 =?utf-8?B?TVdMRFNUNjRLUEFYaUpSTUdyYzVnYnMySisvZ2YxbjluMEx0MmxkZDhvZW44?=
 =?utf-8?B?ZnNzZ2tiOFRiR0I4NnV4dzdLMmRRaVM0VUx1L05JMC9XUU1xVW5CVTJrbVMz?=
 =?utf-8?B?YVBaT3JHbHdJaUkvSVBZMVo3YVlrRjFWR1NSWUpNUGxhSHIrSlpoeFZHZmxL?=
 =?utf-8?B?Qm1YMTNqeXAwV2hzS2p5Mng4SmNNakdrOTVCT0lPazdrYnJGcXk5d1B3WllV?=
 =?utf-8?B?Wk1GSTVSQWpSOVNBWWpNRUYyVHBkR09tOEdUTDhseXEwcFIvTnBtUFBRZUZ6?=
 =?utf-8?B?Rm03aFpWOEY5N0ppaE1Hb2RQaWVlajRtdU01NGtZTTdBYUt2aXdtTWFQWCty?=
 =?utf-8?B?SnVRU2xyYTlhWTMyMmdLZ0EvVm1JTGc3WHJPQVZ6eXcwWjliTXRINVZnSi9s?=
 =?utf-8?B?SFltVXFkNlJnaG5TTDNyRXJEdkJLSU5LT0NvYXJScm1zVUErWHVtVGEvcHQy?=
 =?utf-8?B?aXo1QnRnOGc0R0czYzhYeHM0OUE3cm5Ca2xEMklmK3A1V2hxSFJ1YU9wN1g5?=
 =?utf-8?B?V3VSWGlZODZvNmxkUTZHWHgycCtZYlprbkZSR2IzRldPZUZ2bEMrSWMzMHRU?=
 =?utf-8?B?OGJ0UFh1WG8xR1BVZVRWYjNvZ05jRTlwWDZFOFY0eUNBeUNuanViK0lBOU1u?=
 =?utf-8?B?Q1NTbURxcHFPY2dnTXhWdVo2TCtmZ213VEtqaklMNFo0TGZDdGtNRGlpK1NO?=
 =?utf-8?B?RzdZU0pVeUoyUDFrRUp4bEIybUxyZmpvem9iYVBYL3FvYVZQRXl6eEtMNEtV?=
 =?utf-8?B?NmM1MHE2RU9ZWEwyTTBQMnJuUGpZTUNFK21WMHBsRHVZZENCK09ET3JBbXlM?=
 =?utf-8?B?K0dvNWgzN1VUZ3Jad3JneUhTSURQaEhoK2o0UGM3SUNNTzArYnlCMjE1dmpL?=
 =?utf-8?B?Vzd4all5MGNia0NLWkIrRXJ6bVpPTFk3c0x6aU5qcVdWZmd1bm8vc1NZNDQ3?=
 =?utf-8?B?UnlKTG1JN3BPVW4xZ0dia3VjMGNJV3BWSm1qUWNSTVorTHFkRUV6Zk5ST0p4?=
 =?utf-8?B?dDMrZzRRSm0xejYzcXgyYklFQ3J3eTY5VGNSUkNZczFDamRrMmhLblloaGUz?=
 =?utf-8?B?TjE4ZFZuSWdKSzN3OEFjcDNtaG15SHRyWTVneDBENDFaMXdvM3pDOGh2MzJO?=
 =?utf-8?B?NCtiVU4vdmtaT0FiOHd1b3NzQXVUTU1meElPbXhQU2x5Q2tHZVE2aWpMZ2tG?=
 =?utf-8?B?dUhoNi94OW1kNHBPYk10QVRxMDJkNFNXQ1Y2Q2pxM1JGMEhMQmlhUUJwL1hK?=
 =?utf-8?B?YkRXVXpVR1RMd1lSS0ZBY0YvaGJxTmZzZ2FCNW9vQzhWWVFkU2VuTXZGeDRk?=
 =?utf-8?B?dGdUZEtLUjhVZEhXZ3M2U2c2c1kzYXp5RWNpWTRNVS9GYzU0NjFFQzVHc3NM?=
 =?utf-8?B?Zzh6bzcrRzhiK3g4c2laNjd3aENBWS84NWhuM3NnMlQwRnRONGNWYmFIMDhI?=
 =?utf-8?B?K2dJL3ZHcFJ4TzQ1My9TS2NMamN3STNSQmo0NDRlNmhFZXMvd2VRSDdCNFdo?=
 =?utf-8?B?bC9FYmN4TTV3VUZpOFJyMmgwZ0JmdEVVRTVTRzBXYVZjZWhIcFRzQWd5b3hF?=
 =?utf-8?B?VDN0MFlpWW5qbm4wZ3FmZEdzblB0b2J0UDQyQkhFQU90Vy84STZBWHRscWtU?=
 =?utf-8?B?OFBMYlhFdGFHTGpTd1pZSWlCRklYZUJ6Q0U4dFNtRHR1ck5kc2l5Z0xVclNx?=
 =?utf-8?B?eGtpbG51VmNhdzdzWE9zTjR1MHI2eEJLOUZrNXY4UmxJbjAyUVhFZzJRelhJ?=
 =?utf-8?B?Z1V2aDZpdnJtalNtUytqN2FtYWJENUlwUEpJdVJvRzY0OXpkd0pwclNaQ0Jq?=
 =?utf-8?Q?kjVh6uO4j8N4fiIK0BQFrN5GH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bed56eb5-66dd-432b-b1b6-08ddbefb46c0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8660.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 15:14:19.1993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nTCGPsZi/7tU2i2SZ+WfudCYMb/R+ee0BAMXgq6tAE06creMz7Svoz/QXm3l3TYH/7H3gp7euS3jyTjr2uBjXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5879

Hi Sean,

On 7/8/25 8:57 AM, Sean Christopherson wrote:
> On Mon, Jun 30, 2025, Pratik R. Sampat wrote:
>> The SEV-SNP firmware provides the SNP_VERIFY_MITIGATION command, which
>> can be used to query the status of currently supported vulnerability
>> mitigations and to initiate mitigations within the firmware.
>>
>> See SEV-SNP Firmware ABI specifications 1.58, SNP_VERIFY_MITIGATION for
>> more details.
> 
> Nothing here explains why this needs to be exposed directly to userspace.

The general idea is that not all mitigations may/can be applied
immediately, for ex: some mitigations may require all the guest to be
shutdown before they can be applied. So a host userspace interface to
query+apply mitigations can be useful for that coordination before
attempting to apply the mitigation.

I also realized that I could use SNP_FEATURE_INFO's cached results from
Ashish's CipherTextHiding series[1] to save us a firmware call if the
verify mitigation in the ECX vector is unsupported.

[1]: https://lore.kernel.org/kvm/cover.1751397223.git.ashish.kalra@amd.com/

Thanks,
Pratik 
