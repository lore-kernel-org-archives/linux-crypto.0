Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011003.outbound.protection.outlook.com [40.93.194.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333452D47EE;
	Thu, 11 Dec 2025 22:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765491790; cv=fail; b=npGWt90vNcqe2pg64a2cW0mw8xeLw3G4TtuAHFTXo41upPySOH1aXALT4ETLSsnlZOtA8vd2QmC09xOUhNTjaNn/S1wYmGXg41H7cqS9Ek7iJJ3HhoYxPSt+5pB7WqnxKynFDgvOuLVktLuVG5thjjVLDptVeumn4PHV/5WkLig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765491790; c=relaxed/simple;
	bh=2D5NYZH5usK3D3t8Sx3K9FRGJz/xKcLPLSvPyYp7Puk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PQTo5jmVLaeP/jKk/KQmieL9rj6XLuCIDRpd+tVoTAnMEmL8+BsN/DSmkDKkb3stxvNtK6DvFbz2KIYpcJElQO3EhmGnRefg4c0B85QhNYaR0EQdyH2DAYM/1X4L9gPJ2S0CZo4NbGJpHeyqzlgqvmd3oS6pxar2a6JcR7Aj9wY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TGyOMioU; arc=fail smtp.client-ip=40.93.194.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TGyOMioU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tad45lqrBe6wJ3SUIsaHF4siTpAK/F3x4a2mlHRiu1vIZbE/uFxygJC4TIyDXdLDfKLBtjhQUud5B98sjRWtZNcM4sseXNyq6tp/bILh4PAQoj19HoMcuWDGWxO7s/57i4bfDOMmpzOBbCNGLTWfHIWKcqsnKvvfMpB59W3DHQltgaz6Tl46fvNzPXRlIeNnsDZ8O/0u59KpkKVtiFyflS5aPEoNp5u6NJaEhNbcYSGwBIJU+GlQJU+gNT2rihoPCJAftOxwH/qzZnfg8F/pHvYn6MPOA3xpvHLmnbvu7qmJ+Wu6llDg3vLJomXoL6AsB9qLitrIjdVJBgGaWb36Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YSmhMeO60AcOkUVSvOGzfdpLSK94oN8mB+UzSZp2AME=;
 b=bET6OSSNlth6TsPjQqnEnbxXAqGj3k36/duj/NP74I/6v/SEnz5BBOoheuOlTQn4NVPnyVd8wx/DHMhvjLqqXGSG9Jlvb7wPo177BhatjF2cuJwlSZM2/48UR81m07WTb38hV7+bZm+1qalN0E2YMQITLQ1UAWDf/Q33/TTzNCDbpqdtJMa59+JF7c9WHdxLlm7WZE401r5H6XgMGgsnx4hQ6u1RUX4av7saDwiMugU3Gbp/bno+lT9Htf9uSViP+/FwFI6jjz5Jimsj5ySAhLH1xmRdncc0+yL7yNbio31xheF/tCAES8lVOQcJj68YXv0ramo6L68SJBPKt6UF6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YSmhMeO60AcOkUVSvOGzfdpLSK94oN8mB+UzSZp2AME=;
 b=TGyOMioUxiYDX5qjUagAvKbiP391Bghp4o+0iH9mU5e9gQV1jMVRaBLsxT0PMfyEXA9a6pmkSf7NNshEjlXbKwF2VjwRk74s4lBRJqTQn4UD7UhbrqUCrA/k/71nxzlnWG2FYCFYftGMQs0hYaQWnQxhIPdbt8jbJ2HHBRI6OOE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB9104.namprd12.prod.outlook.com (2603:10b6:510:2f3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Thu, 11 Dec
 2025 22:23:05 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9412.005; Thu, 11 Dec 2025
 22:23:05 +0000
Message-ID: <27406dfa-6eb4-47d1-93d9-709dc6b893fc@amd.com>
Date: Thu, 11 Dec 2025 16:23:05 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] Fixes for PMF and CCP drivers after S4
To: "Mario Limonciello (AMD)" <superm1@kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: John Allen <john.allen@amd.com>, "David S . Miller"
 <davem@davemloft.net>, Hans de Goede <hansg@kernel.org>,
 "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER"
 <linux-crypto@vger.kernel.org>,
 "open list:AMD PMF DRIVER" <platform-driver-x86@vger.kernel.org>,
 Lars Francke <lars.francke@gmail.com>
References: <20251211212847.11980-1-superm1@kernel.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20251211212847.11980-1-superm1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0113.namprd03.prod.outlook.com
 (2603:10b6:5:3b7::28) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB9104:EE_
X-MS-Office365-Filtering-Correlation-Id: 6119399e-8168-483a-b967-08de3903db1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RGhqWXF0U1FOcy9PelVrQStCU1R6S1QySjgxU0FSU2RPRHBybE9kSSs2Skpa?=
 =?utf-8?B?UlFGdmE4b3J2N1VoWnNZS2k2YUk0NEZWYUlXMkhtNm0xVk1TVitGbjVBN05o?=
 =?utf-8?B?dWF4VTV4dUl0WnAxVmJZMXVaTmVEaWM0SEFoNTRMRm5XUUI2Qlp3UXkxYmdU?=
 =?utf-8?B?MXc3RjFoa3Rkb3k2amRMQWF2dlpSZ2NnRy9ROXZ5Z0RhY1E2SG9GYjZEVXFk?=
 =?utf-8?B?SHR2ZGdJeDFHWXpXbUl3dkFjM05nb1loUTJ2TXp2QmN4L1gwTElFbnFwREhn?=
 =?utf-8?B?UEtnV1p3U0dhdjhGMlY3UDdTVVJmUDJFMjRFa1NteHR1dFl0RjNWQnBMMGlZ?=
 =?utf-8?B?R3NoNnFWVmRCWDJqMm5yMTVlT2V6THhxTTZ1ajdPSi9SczF4YTRpU1duT2Fr?=
 =?utf-8?B?U2pRWW9ZTkMwM3dsNHZSdnNpQjh2SWdtenV2eDN0bE9hZ29lTFl2MDhLb05P?=
 =?utf-8?B?U25DTDdoYmtUZStxNDU0c0QrM1Z6V01GNGxjMmpUTEZSTmFuQkVaMVBpUkZx?=
 =?utf-8?B?UWpsQUw0T3NiTExXNkNubzFzUlBJTzR2T3hpbFhYcVF1bDYrNlFIYThibFdi?=
 =?utf-8?B?MW1OZUZLa2RLM2lrQ1dsL1ZjWWFIZzRZRDFvck5Gbms1NDFpWjFoV0lLSE82?=
 =?utf-8?B?Uy8rRTVyRzJVSFdzOXFPNWNtelhyVFpaVGh4ZGpSRjlORlZxOUY5LzEwNUdG?=
 =?utf-8?B?RTRjZlloaEU2R200bEVHaExyWENQTDRnaEUxZ0FoNjA0UHZlVG9ldjU5aUhy?=
 =?utf-8?B?bmhSVEtpQVFocis3MEFRaUxUbnBSUUhvWXE2QXRnQlpMbU1PZmYvRXk1bzhv?=
 =?utf-8?B?UWRMMURtMklMU2g0VjBvN0p4bGt2ZUpDNTd6YUNXUldibmlybkxIZ2JsYUNa?=
 =?utf-8?B?bTUyZ2hmdW83UWJRaUJ3eDBrVGk0ekpkZ3RURDBldWdJZXQ4TTZkVTlUTFZP?=
 =?utf-8?B?NU1RcWF3bmxua2kvYWwrYWtSRUpRTkxzM3JLSWVhS0hBcnFLL2Y1bC9BUk5p?=
 =?utf-8?B?SllOcVVGQmJ3dk14TE5lMVJpTzM0akJzRlVvbWdibGNRMmZZeElEZ0hJSVpp?=
 =?utf-8?B?aUFWV2lPYjNrVDB1U1BkbnVWKytHU0Nvb0VkSGZOQzVrYXBuZFdqU21DZGU5?=
 =?utf-8?B?MS8wVDd3aUUvbnR0NmlhN1c4MTlLRk1uZlpoMjVDMGQxWHFwaUhRRjZSNEZn?=
 =?utf-8?B?K09nWjVGRDJ4SitzS0lvOGdrdXVvYWxIWDhhZTVCTWZkV1NTYVpJL3VpVzl4?=
 =?utf-8?B?RmZRRWljNi9GT0hEbmZOdkRYUm9LZHJWQTZzQXhMUEFGSjNCTW1MWmZ2aVBn?=
 =?utf-8?B?R1BVTjF0emlUV3ZTcEhONXU3enR0S1lDNWJpcHF5QzE3WjRaKzE4dVJvRVp0?=
 =?utf-8?B?RmxMMXgxZGZvbmwyVmJIeUIyVTM0MXJSRS94U0RvRnZsc3RGaENBa1dkYk8y?=
 =?utf-8?B?L3NZcFVkSWhQbUQxNDZlVHRxN0pBbi94eUYva1d5bU1tSDJab3BpMVRuN3dp?=
 =?utf-8?B?YytNKzJTT3c3T1daWE9EalF0NDF0WUtsQnFCLzZzN3FwOWdUR2RDSW1ZUkZy?=
 =?utf-8?B?b3VrU3l4cFdIZDRRVmR1WHhGcmptNFFQVG5HVEFNMkxRN1IzNmFwdDNxZVA4?=
 =?utf-8?B?VXdlcHc3V0lvWjUwZWhYOG4vZ2JZbG03MVRwS0lsMlhqZnBrY0hmRE9FNUFX?=
 =?utf-8?B?bzhKK0N5Z2hlNVg5SlpOOVFQcEs2eld1WVdFQ29WZm1TSDhaY1p6ZzV2WU5T?=
 =?utf-8?B?alZPWk1VOVMxUnRpOGljNmtoUnlPa2YydUZmR0ZQQmNHUnFTRDlLUlZyOCtV?=
 =?utf-8?B?Mkk1dnhTSHFjRXNhOEZsWWVJd0lHbUpZa2EvcVhtOE9Zd3BUWGtkTGZJdzdC?=
 =?utf-8?B?MjdSWHA4bXBEOWFJMVh3Zkh6bVZERURPeVcwSGVnOGVEeUxJTkRKM1A4Mmw2?=
 =?utf-8?Q?fRc9KxdEObnk3ZC+oCRxwiLMw98Rxf9P?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dVNXdms2WnVpNlJONVExMjNtQVBXaWFkY0FGaEx1TDBmRFBsZWU5VjloTHh4?=
 =?utf-8?B?cUJUejlwNVovWUYvS0NYU2htYW1ISWF3c1IvYkxLdzhDYWExMjQ2d211eFpT?=
 =?utf-8?B?YUJSMUNVNnR1OHpzOU1BSG1WSVRITWJPWHZXdUxIMzhOSXhuRVE5VVN0dFJI?=
 =?utf-8?B?aTRZZGlVcVFmeTdPSkhaT0dlVkp2SDRMVm5aWG52OEtFZTdXTGpvM0E5UVFL?=
 =?utf-8?B?TlkrUWx6MGRjcDY5MHBpcUsvcUNNOHozQUxzYmRBa0Z3QkNkVkdWcDg1THJD?=
 =?utf-8?B?b3lJSVhDUFU5ZTNsZGpMMGxmOHN0MkNPYzdIWmxzYjY1YTBVN2pRVi81Si9Z?=
 =?utf-8?B?b09adTFURzB3MWl0OHQzck5LWXNHeVYyV3NzRVc5WnBPSGZyRllzNW9KNUVv?=
 =?utf-8?B?RG5sTGlCSnRqSjN1VU5PZlBrOTRRdDl4SlZjY2t6R3dkSGFJOGZNRFdmR2pq?=
 =?utf-8?B?bFVHVXNNSjZYV0ZTNmkxckRFNDBxNVNjTWlNc2ovYjYyS2Z1RmhmN3NSZ3A2?=
 =?utf-8?B?WXdtbFovY05KNDJRdkFNWVIxR09DS05pVC9FN3hRTmg3b2VGZGZvd1RiNGtz?=
 =?utf-8?B?cGFoeTkxckJWUWZ5M0Zlc0xQT3VLUjc3QU1rVkFZQVVkUklrOXA0cU1IRUtn?=
 =?utf-8?B?QndqTWVvRHZwNEJxNy9RcDFEVTFiZ3ZLRFpQeEgvSUdad21MUTZJWEdNMXBR?=
 =?utf-8?B?ODdFZ1Z6QmtzLzZhd2FrMmUxK2RrcTFLS2tDUjhSUW1ZbGwzSzVpV1ZaRDF1?=
 =?utf-8?B?SzV4ZTJwWXl6QjMxZHdRUkVDSXBpT0JqeUpLMk1XVDVyTUdzMXA5Sk5Ec1VH?=
 =?utf-8?B?eGJCdnlmZ3BFSzhBdHlGVGVPWGZURUtGSndDb1RJQzRmbFVORUhqNnVoWnQ5?=
 =?utf-8?B?RVV4SkZhQWV6OC9ZYzBRWXRVRmhxcW05L295amN1UDZjcFhuRlhQYk1HbjRR?=
 =?utf-8?B?N09RWnIwTmxLT29wdkEydjNoL3NXV1RhcWV4YlFmbXYxbTEwb1FadzlKK0Rh?=
 =?utf-8?B?T3phQU5waFU5ckw4TGxLd3l2SEtSRkptVTBORkNtK0FPYktHem9ZVDlXeEVh?=
 =?utf-8?B?QzBIQzRUZHlMNEI5NkRPYUl3bUMwRFA5TXFpNjFsenNRcHhGSkthLzdXL3dV?=
 =?utf-8?B?Rm41cVdEWW5iUWRLWWdyUi9PNnNrcmFha1k2eEJyVVhYeUhmTlVaREpTVzI3?=
 =?utf-8?B?R0NEeFdMb3NIdmxoa21FcUJjaWdpRHM3akpCTWIxeG1YY0YvN2E5dU5zVFM1?=
 =?utf-8?B?dmNVZlhINFViYk5sR1pxcWh0blU2clFZa2NJMkRTL20wbmlZb2IwSzU1YzRv?=
 =?utf-8?B?aXJjM3lhRnp0RkJNQis5YytiT3Q3a0YvZ0ZBWGVacnA1NU9pQUpzZ25RSHVt?=
 =?utf-8?B?UHFBem9WQUJHYXdTckNsSGNYelF3THJtck9aRGJGUEhiT0Jla1hPbUZydHpP?=
 =?utf-8?B?QnFZKzM5ZXVzSG0vbzNwQzV4UU9iNlRXOURFejRTVXZsSFhDTEJ3RFRIZmFr?=
 =?utf-8?B?TlBjaThnbHJ1RTR0QU5UVThzU29TNXdJMkVJTUJDZUl3empBQXpqVVdKNFNo?=
 =?utf-8?B?QWR0cEdOV2xBUDJwcDNHQ2ppZytsTkFLWkhzZUdoakcwMTZTaFFWZWtvZThE?=
 =?utf-8?B?Q1kyZVMwMnZKUXgwTi9HNDJvTTJuNXp5blFGblF4S1NPWkZOZjh4SGsvV0Yx?=
 =?utf-8?B?T1RLaWFCczZiN3BBREo2RnVvdmY5cjlrem5uY3NCOGJGdGlkWWhtNkw2S245?=
 =?utf-8?B?MGpxV3kvYnJDckJHT3hOY01jODNVNU9LeDZ3N2NOUmRRY08vb1hEL3J4TlMx?=
 =?utf-8?B?ZEMzakhPTHhpYVluTnBCdEMyNzRKOGQxSmpPd0VabnVJVnlvQnA5K0lsYmtL?=
 =?utf-8?B?Y3dEeStCYXNDUHBmdjczTkdUT2JWQitEWUF3c1RxdmFFSCt1ZmpETm9nSU1B?=
 =?utf-8?B?blNnYkdCdGtyUWxPYWE2Tm9wRUdBQ0dtVnZjeEdGQlUxQlRwRW5ubUcvK2Qw?=
 =?utf-8?B?ajVPQ0daUGVXR2Rmc2dIUmNGbGg0VTJuU0FJZGFBN0d2MlV2cnpRY2J5TU5M?=
 =?utf-8?B?WW9HNVh0L3NHZnZEcnRjUXR6QTYzVENKYlZpdmQrdS9kYm9jRzJ1SlcvSWxW?=
 =?utf-8?Q?a4soNZ5KxoZolhTOwgkJ25IXf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6119399e-8168-483a-b967-08de3903db1b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2025 22:23:05.7984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WO8q1swNcFmecRY06SKtPeuAlkGQytTZkasS1CDSNthTS+wm7ghYZ6Kgopt7PLwZZ6UdOilDV/AzAtcS4ZdXxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9104

On 12/11/25 15:28, Mario Limonciello (AMD) wrote:
> Lars Francke reported that the PMF driver fails to work afer S4 with:
>   ccp 0000:c3:00.2: tee: command 0x5 timed out, disabling PSP
> 
> This is because there is a TA loaded to the TEE environment that
> is lost during S4.  The TEE rings need to be reinitialized and the
> TA needs to be reloaded.
> 
> This series adds those flows to the PMF and CCP drivers.

You should also include Rijo Thomas <Rijo-john.Thomas@amd.com> on this
series.

Thanks,
Tom

> 
> ---
> v2:
>  * Fixes for potential race conditions in hibernate resume
>  * Fix for error handling if tee ring is never destroyed
>  * Fixes for dead PSP (which can lead to hangs)
>  * Fixes for LKP robot reported issues
> 
> Mario Limonciello (AMD) (3):
>   crypto: ccp - Declare PSP dead if PSP_CMD_TEE_RING_INIT fails
>   crypto: ccp - Send PSP_CMD_TEE_RING_DESTROY when PSP_CMD_TEE_RING_INIT
>     fails
>   crypto: ccp - Add an S4 restore flow
> 
> Shyam Sundar S K (1):
>   platform/x86/amd/pmf: Prevent TEE errors after hibernate
> 
>  drivers/crypto/ccp/sp-dev.c           | 13 ++++++
>  drivers/crypto/ccp/sp-dev.h           |  1 +
>  drivers/crypto/ccp/sp-pci.c           | 16 ++++++-
>  drivers/crypto/ccp/tee-dev.c          | 17 ++++++++
>  drivers/crypto/ccp/tee-dev.h          |  6 +++
>  drivers/platform/x86/amd/pmf/core.c   | 62 ++++++++++++++++++++++++++-
>  drivers/platform/x86/amd/pmf/pmf.h    | 10 +++++
>  drivers/platform/x86/amd/pmf/tee-if.c | 12 ++----
>  8 files changed, 126 insertions(+), 11 deletions(-)
> 

