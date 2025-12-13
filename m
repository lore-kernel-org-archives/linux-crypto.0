Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010066.outbound.protection.outlook.com [52.101.61.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254A6146A66;
	Sat, 13 Dec 2025 19:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765652743; cv=fail; b=ekDlWnYGq6aRl+JvcLojqECMGLBwwbuGgxovWaStG/bYKS9HKKYHIxTf4ZwkWvO5tl+F5+578wdL7yc+B50am4bes4nNLRzr4Tv6vMPIfe6zQyHBZly6d3xNX1HlN+xBuVxJwyVDFqth0kmWrAY+bke2JpXcIrk+GG/lycjzjHQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765652743; c=relaxed/simple;
	bh=avQY88qE288Db9L4snfFBAMJdFPffNtiI2XN62O5kjI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Qb3pPpx37UqMcl9baWMalH1Q8W5q9Nda9uIR+My19/VosiK0kzcafEMPefNIKAZOCJvgoGpzrvJ9Xlu2aJlTL4agKg0h8ssnMiDb0yhZxRuSf52UwpmjVA0kFomZbsZBtQnqJqxYp2SP5PRWyeMJJ/bzixyjTlvNtyWISANu0ww=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NMymnqWk; arc=fail smtp.client-ip=52.101.61.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NMymnqWk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uuacUiwjAxvBABzVXvQo6Ll/vaP+fDZmSon95o3RrkPvkajvUVThRMka3AJnlZhgwszoWx+p/a8vggXZtntvcKz4kaZ7us7VUEku0ze4BKIzHTHMPmkq5DbdFTNGOq5FET/eS8BU+fu16FE/n8OCgVFnHSUHYVCZN7mS160zucj0ikOkguW31/xskGPHC27XOixfclRjzQu3PAtVSPFAQSDamNYb0bbco9STf3xEEgOdW1tY2YM5/9JmUOe/Z44IDjun1LYJzaSNuei5yIXuNSmq5BMk4k9EuCLBxMPOJZWjBlCGq7+pemYDAp4uDpRijI5CDSsizpc3oRGmQUy3jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5L2I2arNBSdqu4EQmhi2mfCdNMucxI1yz/WaVjsP37I=;
 b=cg09gKAWv91qQGTw1k9Oe7Y/AEYC1+bcEZ6x9xwgm8m/pgwk4TwoouDzwdgGadK2Dm6hkGwvL3MU39QNixXUKuJNBHWdy2kBHDr/xPUVUmuifS5mIW3hlPpg22HYVKqJFmFWI0bTv0i0QrcQ0WEAZBSBgnr/8eAxs1l+6VWP7HeAV/bf0LzAUcqAvcVtyXJSVTdWKwp2vB94rpy+zQzTF4nIs2BsF3uFGmNR9kdnYOcBWM4Z8vLpNBH1j11J2nH9g0pxC3cZ/uqemb6MCfR6gxEkC/vFEpQvywnxmg1BNxv25gegNOpNOrQOlqjX8G1OadHW8k2WvkSjLXFQ6sVVuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5L2I2arNBSdqu4EQmhi2mfCdNMucxI1yz/WaVjsP37I=;
 b=NMymnqWkc2G2Bo6JMRZDGs+qW316lSD1yyBDvexHNzfq4xTpCPINrUcovFcrqVn0tqid7/xUXjy+FkPJGotV0UJNvic1bp0oz4rSo6AoSLoVU1Kje6RojD6MlpywmqTAcNJrSMMxTIGRwu7XxNxIldoSlRuL9TIwnjliNJxkn4s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5176.namprd12.prod.outlook.com (2603:10b6:208:311::19)
 by CH3PR12MB8711.namprd12.prod.outlook.com (2603:10b6:610:176::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.12; Sat, 13 Dec
 2025 19:05:36 +0000
Received: from BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::ed5b:dd2f:995a:bcf4]) by BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::ed5b:dd2f:995a:bcf4%6]) with mapi id 15.20.9412.011; Sat, 13 Dec 2025
 19:05:36 +0000
Message-ID: <e9c913b1-4788-4b36-a29b-63a1910240a5@amd.com>
Date: Sun, 14 Dec 2025 00:35:33 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] crypto: ccp - Send PSP_CMD_TEE_RING_DESTROY when
 PSP_CMD_TEE_RING_INIT fails
To: "Mario Limonciello (AMD)" <superm1@kernel.org>,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: John Allen <john.allen@amd.com>, "David S . Miller"
 <davem@davemloft.net>, Hans de Goede <hansg@kernel.org>,
 "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER"
 <linux-crypto@vger.kernel.org>,
 "open list:AMD PMF DRIVER" <platform-driver-x86@vger.kernel.org>,
 Lars Francke <lars.francke@gmail.com>
References: <20251211212847.11980-1-superm1@kernel.org>
 <20251211212847.11980-5-superm1@kernel.org>
Content-Language: en-US
From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
In-Reply-To: <20251211212847.11980-5-superm1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXPR01CA0086.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:54::26) To BL1PR12MB5176.namprd12.prod.outlook.com
 (2603:10b6:208:311::19)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5176:EE_|CH3PR12MB8711:EE_
X-MS-Office365-Filtering-Correlation-Id: 36c61ca0-78e2-4845-662a-08de3a7a991e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZFVuYmNkVGRkT3Q4d2o0aEhhbm9NWnNUMzloK3FDV3lyWnN6VENuRkRNejU5?=
 =?utf-8?B?QXNaQm1TL3FUM2orVmN1dDY3c3VyNThCNlpna0M1bkVFSUxvTWdjSTdHVE0r?=
 =?utf-8?B?SVkwSW9ScVNKaUZwaStnK295bmorNFE4VmVDWm8zR2UveS9IQUhwZm9sOVZE?=
 =?utf-8?B?OWttN1hsdlYvb0ViaUpTZk1lYmpvdjViek5wdEJVL2ZGU3ErL24rK0Zsa0VL?=
 =?utf-8?B?cGdaMS9uQ3gvcUZRczNHbmt2QjBkejdQWkV3YlJXZzBuU3hlcUo0QTIxaVVU?=
 =?utf-8?B?SXdaeE83N3NRd1BkUTRxd0FwaUpDemc0U2tkVyt0TzFKYmtLVkxyRm9pU0Ra?=
 =?utf-8?B?RVVNSDNJeTRpckJLWFhubVdyR1FXTmhBMWRCeWNNUkF2dTlqeGxNSkxlTzFX?=
 =?utf-8?B?OTZGdHd5T3BpQ3o3MUgwQVV1VUg1WitLSEJhYk9EZm50Qmk3K01aVENMOEJE?=
 =?utf-8?B?emkrU0lvOEhXTDIyRWtUaC9pN3ppSU9XY0NvM0ZQWmdiM25udlNqU2hPUDRD?=
 =?utf-8?B?UFBNcGowbmdvT1NRYld2c2laK1BTc1RZMFdNVEJEcklvOEZiaWMyZzMyR1FS?=
 =?utf-8?B?emFicGZwQ0E5MHR0dzUxNDFUWHJtbkN4UEZDV2FLcjVEeU9vZmlEVm5LaHFm?=
 =?utf-8?B?d2t0cGhtRitXRG5uOW95ZDc3Skw2SXlzTUl5NkVqRU13bnd5bzZzN25EYVpn?=
 =?utf-8?B?ZlFZUi9xQWhEZmI4NVdEUVB1NmxocS9RSG1KV0hXR2hPdkk5UVk1MTF4RWlq?=
 =?utf-8?B?V0VvZHA2N0t6TUs5OWxIcmx3Z3RudnJ3cFJ2bjEwdDJFdTVIOGlWT3FPUnNh?=
 =?utf-8?B?TjBNaFhQUTdmWDVWK3hheEsraWFzM3l4VTNSNVc0K1kxbGxId29JYnVRazlq?=
 =?utf-8?B?RmM1emhHS3BDVnpWcVhNNUNlcUYxQm5nZDdOVVp5M2dXYUczNUQ5cjBRNEho?=
 =?utf-8?B?VWtVUHUxcmswMzBhdHpiUFhaYmFvOFlvd09YeGxrMVEyUFB4K282U2F2Nm90?=
 =?utf-8?B?WHA4UDdZS3FFR0pGcVNDaGRGMHdlMThvbHE4UDdDZDRobDMvc2lyMmo4aDBU?=
 =?utf-8?B?eVNjTEdGTDZzZ2VlSHA3blZtSW9FMEgzdDdUMmRadk55b0tPKzM5QWpINVZw?=
 =?utf-8?B?TFM3ZFVLTVBnbUFBKy9OTzhiRklBUVVUcSs2Nmg4Z1pCM05SR0lNRkpNNzVQ?=
 =?utf-8?B?TDgrRjlaNlJmNUFZbDdOQThxVSttaDROWUdVcnFta2FHTjBkdmxhRU1kUHpG?=
 =?utf-8?B?KzVjaXcxRDBRdUpRZUdabk95emNDa1lHZlN3MkdUWkNFYnR1MmVhNjl3cFNR?=
 =?utf-8?B?UWQzcCtJVlJlKzg4djZma2g4cE1NYmdvWjZydTBic2NiWXptRElHY0NwdFpw?=
 =?utf-8?B?MWJ4cFU0Y0wxNy9wRDB6VnYwNkZYZGQwK2puSUk3bEJXekZKbFpnTUpMMWZF?=
 =?utf-8?B?MDBRdTVWUWVtVmt0bE1lTW9FV2ZNajJGcnY4VmtPSStUQWd3YmxFZnV3eTV0?=
 =?utf-8?B?SDdJZTF6dkNNSjlBTWZZSkJFcUlrNTlFSFhBYUdmaEVFc080Z0w4UTZnRjhk?=
 =?utf-8?B?bDlDdUpMQ205YWdaK2FoaTd4c1FtZ0RnMFZaRTdvS2dkOVJXeU9ja3JSMmlW?=
 =?utf-8?B?V2oxMkd2WkZsZUZmcVI4bWovWTVqVFZ0ZzhZR29BSUNWcWlrV2xxTGhISjI1?=
 =?utf-8?B?a2ZvUThNRTdTMU9sd3h4K3NWTHJzZ2xrMzcwNEhXYUJkNjBWbERWSldWU1R0?=
 =?utf-8?B?MzBEUmpRWTNUcElzanNKWDZzQTEwQTBmdW01Y3BSaFc1eEcrcGN1dHJIcUx3?=
 =?utf-8?B?MkFjRXRHU0VKRlQrRlRBYVdISEZ4VDRiZmIyNU5VS2FHbjhVWEMvU1d5UmpB?=
 =?utf-8?B?K3U1U2FjakVxWXYxSk5IQVQvbU5HWjhNMCtyMGlMbWh3UU52ZW5teUphSVBE?=
 =?utf-8?Q?doN9W30gFnFhOjoClxtCJLVXMCqTYM3U?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TnNEeEdBb013bjl3RkJMSWhmTWwxTUhodjFpTkhOM2N5WjRsUm13MlJZTEsy?=
 =?utf-8?B?RXVoTEYvdk9BSFZ6Szk4dnB6WXRZb1BYQTUxcVhOdjVoVDdxZkl6S1NPQ1Ni?=
 =?utf-8?B?K2pRSE9pS3NvQ0NudHdIZ0dueGRmMVllQXlwVk9PTHY4amNPMTFDWFBGRnZ5?=
 =?utf-8?B?RHducklYNFpRSFpVM0N4cDhnZU5jY1JDMWJDTjNETVF5NjhCSTBldFJuRURk?=
 =?utf-8?B?L1B2V3BSREZ4NkdHS2ZlUjZUMGJrcnpubmZlNVg2eWZkRHBmU2tHamlZSXVl?=
 =?utf-8?B?eTEvNWtxR1E5ZTdVMnIxblc2b3dzOUFmYUNsZDl6eTJtOGJKeUZWMDd1QXNB?=
 =?utf-8?B?N2pwMDkwcmE1aXZuQnQyMWphWVM1bVJBaHFqZzJlM2hycFg5UDJCZmx0bHB1?=
 =?utf-8?B?QmpuNEVtbmZQK1NSYmZpWDV6ZXcyYmp1MXlPWTYwWW5vcjdFZzFCS2U4WUdE?=
 =?utf-8?B?Vk5YOUJ3elc4enhwNHV1cFV2d3V2bzREVmNwRFdQSTFjTzYvRnVzL3VmaEln?=
 =?utf-8?B?RDF2MkRYcjFEVWtoY1NXdHl5SW5abjJ1TlhBcDR3YW94QXJhM0hDbmc0aXZZ?=
 =?utf-8?B?OElsMmJEOWcyWVQvaFp0bEQ2WVdjOFFxcGcrUjRVcEtMWXhwTlZjZDQvaEJQ?=
 =?utf-8?B?SVd5SlpPR0dyeHgwQ1EzUVlVS01SVzV5NU9RNkhtVW5JaEIzWHlmYjRMNURi?=
 =?utf-8?B?NElQZjJTaHRvT1dBSFRVTDdEbHNDNi8wRWwraWVWL1pMcFpwVFlHQTFNUEg5?=
 =?utf-8?B?ZVlleVNUN3c1eWc5dkFpcTBCWlVnME9rSGJ5WDdjbG5hdzlJOWdIOVhVU0dh?=
 =?utf-8?B?Tlg5TU9qM0tvZDRKa1ZJcDBKbFFNT0ppVW1FK0swVUtwWkxsZWppNTBNb2M0?=
 =?utf-8?B?MUZsVk9MT3VpcDIxQlNCT1F4QVBUVkxlakZsYS9rK0JTNWpJazdObFdLSm9X?=
 =?utf-8?B?N1dDNmd0OU16UFp2N1hwamtTRDM4aWlITnZkckVBNWM1eEJaS3RQWllQbXlK?=
 =?utf-8?B?bFpueGRBMXo1WGhZUUNlQkZ2bVgxL0c0MU9MT2NuYnFKem5VQTNmTXFOU2JH?=
 =?utf-8?B?di9pMmJwYWE3THRwRnVXWjdUL2ZTUFNGSWhDOTBCVFpqczFhZ0hNRzB0cVRR?=
 =?utf-8?B?ZGYxRTdtVlpRdmcwMmtqbEdFdVhQR0pya2o3MCtiWnFkVkRZdVkxcktEUnBJ?=
 =?utf-8?B?OUl4Vzc5QnVIcnF2bWZYbk9XeThoanRjQ1c4aUhGL2huYlFrYXJNYVZIWFY2?=
 =?utf-8?B?S3d1YjkrY3NMTFZZUmJqVFdHSndmSjJDN3M4b3dMc3RsNitnbWp3ZnZLbHdv?=
 =?utf-8?B?SGswNUhsQ0J4WkczalY5VFNLQnVtejE1QlllRUZtOW00Q0ZZeVh1ZU9TaWRN?=
 =?utf-8?B?YkVXaThEaFJ6TDRCT0Mvb0w1V3pvNnJrTEVqbzVSVkRUbGl5UEl3TDZYZjZv?=
 =?utf-8?B?eTg0bFB4U2xzKzc5M2d3bUtpRXdOc0NrcnVzZEhyKzlsODFKay9oeUQyempa?=
 =?utf-8?B?LzdtV25Oc1h4czBFYTNUcTk2UjBGOExaeG9jZEJoZUUweXZDVGVmVmZKTnFZ?=
 =?utf-8?B?NklMaS9TWldoSXY2V25NVkVQT25TaURtaGxqS3c4Q1JrOVhialk2aUdtUTUw?=
 =?utf-8?B?Y3dNV0xkS2tqMnorT21JMVQvVSt1Y3ZFc3BGbG1Ia05nVkw2bms1UWE0aWZy?=
 =?utf-8?B?NndpeG5ldmdaa3FXaWJFZEFrUE1BU2I4TkcwN2xLMlJOOVlEb3dtTjREQkdB?=
 =?utf-8?B?TUJTMXM0OWpTd3dwWWVtTmd4eTdMMDNsWCtQT1YvNEV3a1pNc2VCVGhLVnNY?=
 =?utf-8?B?VGZVWFE2MWtOSTYyNUovMS9Qcysxa25iOWRlQmREcjc3N2UxWWR0Vll3V1p2?=
 =?utf-8?B?YWRWLzJUS0hnNCtuZjRNb2RyMTAwNmlINTJQSmZGYmxsME01cXk1K3FSWUVn?=
 =?utf-8?B?NWpucWloN05VWG5WQjlqK281eGZHQ0hoSW1LVXRuaGl1bFJFNGd0ejNTMnRk?=
 =?utf-8?B?YzRmU21LS1V6KzdWL29CU0Q4anRWSDduK0ZlakNlN3BEd01iYkZTSkt5OERL?=
 =?utf-8?B?MXNOcGFmeDkxVEg2Uzg4SjBWdEZkZkg5SWtRejluZW9ZYytBbE92bFBPcXVE?=
 =?utf-8?Q?CaVEOYFXPT0sh8R9rqqQAPOMY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36c61ca0-78e2-4845-662a-08de3a7a991e
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2025 19:05:36.6936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9CdOm4em3kz8kjuzveIB2sQqtUrFyCS0XXu4/Fe3KcFDQJ2uptGA+2SVsUJYNzb2M6XSqKsPEV1xazHf0uo98Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8711

Hi Mario,

On 12/12/2025 02:58, Mario Limonciello (AMD) wrote:
> The hibernate resume sequence involves loading a resume kernel that is
> just used for loading the hibernate image before shifting back to the
> existing kernel.
> 
> During that hibernate resume sequence the resume kernel may have loaded
> the ccp driver.  If this happens the resume kernel will also have called
> PSP_CMD_TEE_RING_INIT but it will never have called
> PSP_CMD_TEE_RING_DESTROY.
> 
> This is problematic because the existing kernel needs to re-initialize the
> ring.  One could argue that the existing kernel should call destroy
> as part of restore() but there is no guarantee that the resume kernel did
> or didn't load the ccp driver.  There is also no callback opportunity for
> the resume kernel to destroy before handing back control to the existing
> kernel.
> 
> Similar problems could potentially exist with the use of kdump and
> crash handling. I actually reproduced this issue like this:
> 
> 1) rmmod ccp
> 2) hibernate the system
> 3) resume the system
> 4) modprobe ccp
> 
> The resume kernel will have loaded ccp but never destroyed and then when
> I try to modprobe it fails.
> 
> Because of these possible cases add a flow that checks the error code from
> the PSP_CMD_TEE_RING_INIT call and tries to call PSP_CMD_TEE_RING_DESTROY
> if it failed.  If this succeeds then call PSP_CMD_TEE_RING_INIT again.
> 
> Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
> ---
>  drivers/crypto/ccp/tee-dev.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
> index 11c4b05e2f3a..34096cb6ebdc 100644
> --- a/drivers/crypto/ccp/tee-dev.c
> +++ b/drivers/crypto/ccp/tee-dev.c
> @@ -90,6 +90,7 @@ static int tee_init_ring(struct psp_tee_device *tee)
>  {
>  	int ring_size = MAX_RING_BUFFER_ENTRIES * sizeof(struct tee_ring_cmd);
>  	struct tee_init_ring_cmd *cmd;
> +	bool retry = false;
>  	unsigned int reg;
>  	int ret;
>  
> @@ -112,6 +113,7 @@ static int tee_init_ring(struct psp_tee_device *tee)
>  	/* Send command buffer details to Trusted OS by writing to
>  	 * CPU-PSP message registers
>  	 */
> +init:

label can be "retry_init".

>  	ret = psp_mailbox_command(tee->psp, PSP_CMD_TEE_RING_INIT, cmd,
>  				  TEE_DEFAULT_CMD_TIMEOUT, &reg);
>  	if (ret) {
> @@ -122,6 +124,15 @@ static int tee_init_ring(struct psp_tee_device *tee)
>  	}
>  
>  	if (FIELD_GET(PSP_CMDRESP_STS, reg)) {
> +		if (!retry && FIELD_GET(PSP_CMDRESP_STS, reg) == 0x0000000d) {

and while you enter this condition, a comment would be helpful.
Something like:

/* Handle stale ring from hibernate resume */

Also, you may want a macro.

#define PSP_TEE_STATUS_RING_BUSY 0x0000000d  /* Ring already
initialized */

> +			dev_dbg(tee->dev, "tee: ring init command failed with busy status, retrying\n");

This is an unusual condition indicating hibernate residual state?

So it can be dev_info() or dev_warn()

> +			ret = psp_mailbox_command(tee->psp, PSP_CMD_TEE_RING_DESTROY, NULL,
> +						TEE_DEFAULT_CMD_TIMEOUT, &reg);
> +			if (!ret) {

Should probably also verify FIELD_GET(PSP_CMDRESP_STS, reg) is zero to
ensure destroy actually succeeded.

i.e.

if (!ret && !FIELD_GET(PSP_CMDRESP_STS, reg)) {
  ..
}

Thanks,
Shyam

> +				retry = true;
> +				goto init;
> +			}
> +		}
>  		dev_err(tee->dev, "tee: ring init command failed (%#010lx)\n",
>  			FIELD_GET(PSP_CMDRESP_STS, reg));
>  		tee_free_ring(tee);

