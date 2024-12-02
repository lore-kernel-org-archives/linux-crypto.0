Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2068.outbound.protection.outlook.com [40.107.212.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51316207A2E;
	Mon,  2 Dec 2024 14:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733150589; cv=fail; b=qOHkuHoJywFUY1y15a66rrCoJfXb7yvDqiQkmEuN3Ab0HjiUTWzg1U+tn7wc72cBGLjWD9Ypa2rHF3hYKf3g/YWBlVOl3vTNAdoOcfrnARO8i/zLmSFnwtM7AQJVvnkoOHYiVayQd5KphtzHkvs20y37GfPTv3Mj2SmOjfyGxpE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733150589; c=relaxed/simple;
	bh=wlUEXMpu9q2tPqX7PGAvM3DXiQhgllOfp8LrgFtjRqc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=L3zTXiyxp8KHtGC8P5y9zMMoWGix1kNqn5mHFwPupAGleEnXDpVGbXcD5uTvKrN+cO7sBLbYig4vgpVVLpUBAzNnIrsq/gR8cplCBIpz+QjsJwQA3VEadTpEXlzTQ4yIV86MpnUGEi4ZckpGgWQkSk04U7En3oId1shRiOrTQuU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BE785RWE; arc=fail smtp.client-ip=40.107.212.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BE785RWE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EvemobRjMARTJ2Uk5AzTv+aVwINvh9MSciniM2pnxX8VFXfxKXYXmIuCLYIlaXCXvfCSC+WYXW1Uw8zLusErWGc5WREWegnOLIPfNNx8en/UYMWlh34PpGzM8hC71/L3+MAt4Q7waooOCS+Gw0xU7DiwFj0VWgsxwsHLwXTa6cqVNZuUcZutzgiCo6hz6d6XB76wSUzYpRsab4vn6tlsTeqab1uvq/8PwneOj5esGClHfN1Mx580r/5PQo7SOnvH2dvB6hW80oIORYWUwWj9gvcaJhzY5Eh+4owpgzRKJH7AoZn/ScZFNZyGUrhloPBdHhvD0ygz0c/R19Lt2eFtFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6O9wcmsXuUkvQQ8Op0ytBu1H1j3VkD8Ann4EdBcVW9g=;
 b=ufTPzBfZJOdEyIgotuR08QpsZn/ztAuvyZiQW/z6BEzZkvTzQU0YMF21cNv6/tTLvndvU0NP7QU61UNqupBxaCm5xi7m27nzaoDr5DcjEBoaXxttXplyualKghyamwbcsg/k2B1pOze2ud/zk6POrC1R1KgOqS0WZTklCee2b0Dk1IPmxweDb/BPPFe3iSS+UN6NfEwDL9Wi57i1/31bPWhdYJjVtmE521PDQyp+KPHZiTIIr0PdEGKnNMLKAw5T5nDax04otmGP+bHuv/dMs7+iGcItwad6NocbR7ait/8p2u+kcriCVgfQjWTCtYbSuIDVW5QAMTQdA9+lXqgglw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6O9wcmsXuUkvQQ8Op0ytBu1H1j3VkD8Ann4EdBcVW9g=;
 b=BE785RWEtbk8Ij8iB8eeLlgxqydjmfzWETR6q7Pjix8KdmLAM+roOhlwFR/afN3CKbqJankGWZrYaxpY7qrsMwa4ghOdqdKfYl+0VL0maQmwUko7S5W2cQEeZ3MIqooXw4lCxABfiV1VelycC9pksHA3EzFOWIjcYKC6gwzk8Ww=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH3PR12MB7593.namprd12.prod.outlook.com (2603:10b6:610:141::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Mon, 2 Dec
 2024 14:43:03 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8207.017; Mon, 2 Dec 2024
 14:43:02 +0000
Message-ID: <06162594-21e8-e850-a179-cc42ac5a4c53@amd.com>
Date: Mon, 2 Dec 2024 08:43:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2] crypto: ccp: Use scoped guard for mutex
Content-Language: en-US
To: Mario Limonciello <mario.limonciello@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: John Allen <john.allen@amd.com>,
 "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - DB..."
 <linux-crypto@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20241130135836.338-1-mario.limonciello@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20241130135836.338-1-mario.limonciello@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR13CA0010.namprd13.prod.outlook.com
 (2603:10b6:806:130::15) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH3PR12MB7593:EE_
X-MS-Office365-Filtering-Correlation-Id: 79994603-4102-4ccc-5afc-08dd12df9fe6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TzVaOHB4L29EMUcyMzFIYXVWcnI4K2ZhbEkwYjcrVmpLR0VqM0h3c2ptUTVR?=
 =?utf-8?B?TFRpRkhVT3VDZnhzWksvakZZTCsvZ1pUeHdRZGJwK293L3lyWFI4OEF5N3JR?=
 =?utf-8?B?amUva2FEVzZ1YmsvdnpsaVYyQUFrOWxlWnBUalhWTG5PUlY5QmpQY3paMnd0?=
 =?utf-8?B?cENhU05OVnNudUt4OG5pa3Z1MzRHdWt6MUJQYTdEUmJKWnFMU21zZEgxMlhF?=
 =?utf-8?B?T050Zks5bGREN1o3QWFxTEdnNnlCQWUxblNlcEdZdVNrMHMzTWNtS2NzYlpR?=
 =?utf-8?B?bWhuemRnNUZORUVVYkc5S0Uva0xjN1ZpU3RPNERHQnJXbnZOSHlWSHFQUUZG?=
 =?utf-8?B?WDF3ajR0c05hWmRlalJlazJxOFBGdkJObWxlZHRmNFBVK0NXSXRMNnBvb3hx?=
 =?utf-8?B?bnByZjRYTmlweGNPYXpZYUZwek0rZ2szNHlWcXNPdUt1aW9IU2ora1dyNXQ5?=
 =?utf-8?B?czVNTWx4bkVlUmxqdDlXangySWdUZEcyTXBuaUhPMnc3VGxvNGFpeVFnVE5Z?=
 =?utf-8?B?NmV3TGJUS1F2M3h3V292bVJvakwvOUE3UDQxWVlNZDl6bi81NXJxNXRWZjFB?=
 =?utf-8?B?cHcrSkxUV3FUWW1keGFjRkd1MVlhcjk1Vkg5MjBnbDB1cjk1NThGb1FHcDFK?=
 =?utf-8?B?RG5wTWpTN2FYZ3FSODgrb3hvd0dGWC9ZTWZhMFY0bnNpSmUyb0h2TlRuc0ly?=
 =?utf-8?B?VlRUM2tlaFNPYWRndHBmdnZmYmI1Y2JkbUZwaUh3VHNvamNkM0JYRmNQbGpa?=
 =?utf-8?B?TzJnOFlyS01nTHR1bmlZU0hYN2ZvUEhxclJnbzdDSW5hc3I4eWFCQ2l5Z2pD?=
 =?utf-8?B?eUMzWThDbmF1RVB2S2RKNXZQR09sbUljQ3ZHWVdGS2VCR1drNDIwb1l5OGJK?=
 =?utf-8?B?YW1menJYekpyZTlldUVkb2JoV3pyUU9DaGZKZmhVZzhUY09vcnZWTys1WUkr?=
 =?utf-8?B?ZjVibGJxaDVVNjZzN3hmQSt0YnFTRTFqa0FmVDZjaXJLMFFlTzc2anM2aHVL?=
 =?utf-8?B?dWRjYmYxYkY1cjUrOWY2ZFY2c2RKamkzUmF5TndjL1JMTm1iQmhMLzh0ZExm?=
 =?utf-8?B?Y25naEZBSU1hdFFVek0vbGRGdThRRE9QcHc1eU1DYUV2SjNPWS94Q3hOY0gz?=
 =?utf-8?B?ajlHa2UzRGtjT0g5QXFwZ3FyTFVhRmhzWUs3TDZOeEdpaXlWV05wQ2hUeXpR?=
 =?utf-8?B?eGdWOUhOSndDeHdXeWJkRnVHV283bHNpVFhqV1NmTm9xU1RWV2tHMkVWWHhF?=
 =?utf-8?B?cXB5UTNIcTZDWW5jK1BocktrNkx4WXdJN3dxTE1sTGxWMDRzYnlJVzltbVpF?=
 =?utf-8?B?VmJheHIvOEdvSVlvVDF0VCtZUUtDOWRVMTdCeDBvNGVjOG9XSVE0djdIa1FN?=
 =?utf-8?B?ZUdiNFhKbm5Mb3ovVTJRWSt6b2JBenhLckJTU2hRcGtzUkM3emdnWUxZRVVz?=
 =?utf-8?B?RXNwMElwZXpvc292Q2JScitDVzRxVGQ0WlAweGR1aXU1Zk1vbmkxbnFzVGpa?=
 =?utf-8?B?NmxyMFVLQzVidGNBRDNSYU5ZVWcrTzNvQmlldTJ2aklDcURWd3dQOXFIWVll?=
 =?utf-8?B?UktBVVhpUTBoai9xMVE5clM2Y1p3REtIRENtaDdGankxRWE4WjdmRGlsSm5R?=
 =?utf-8?B?cy9SeWtSQkZaTEkweGh2Si96WVp1SGJqSGpkRnBlcUI2bjl5a0E0U2xkR0RS?=
 =?utf-8?B?MHNiMzRjYWphTFlzUWJDbHdDQ213dElsdW55OUZkN1IvVkExdkVkT1NjWENI?=
 =?utf-8?B?dklhdHY4ekpWYWJ3bitEdlRpMDd4ckdqbURmaVBjbURSYkZWNEIyN2lPb0E5?=
 =?utf-8?B?bS82Q1Vic25raGk4d3dOUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MkJtWlU0bGM5S2ROYy9jdFhxODVFZFJlQVg2dHJnTzRpQUwwQkNyNmRPcVdR?=
 =?utf-8?B?dzFVVkRHTURtZ3Q3MHJLaUZydmt1Z0dFc0NIQk9ocUxKb0MrMXVZS2F3amdQ?=
 =?utf-8?B?RVdBd1grMFhocDZSWmorck5Kczk5Q0EyaGpUMEtLSFc0SXF4UUVKSFFZa3ho?=
 =?utf-8?B?M2MvSDFZMkt5MUlMUUtrWE1keis3NnVqUzhxbDc3TFZwYm9FYWZDYVB3M1hX?=
 =?utf-8?B?UUFKUkJJTWRvdXZHWVFzUTNIOEt3L0hQcEc2dE1HV2JkejJ3YUtyRHQySGxU?=
 =?utf-8?B?dlpEOWJKbE1ta2RrTDVESWt5VHJyM0QvZ3hCWWtPVE50SjBvZ3duRzVpZmM4?=
 =?utf-8?B?aUJtMG9YMnNseHNWcWpyNElINjFOcnlOZ2NqMFptRXkrekx6c05VOFBGa2Zz?=
 =?utf-8?B?OGQ5NnY5VGpQYnJ2ZHpmNG9SelMzQlh3NCs2T0VKNURsZzMzcjc0VDVRUlhq?=
 =?utf-8?B?WGx0QnEzclF6YlVRUTdLUG1UMm9xRlZGbWN3UW80a3lYUXBHVlJMN0tTSTli?=
 =?utf-8?B?SEd5RTFQRWZmWmNqK0tENlNMUkErQ2hQT2p4OEhHYnRBMDZ6UXVLM3RYajdB?=
 =?utf-8?B?aENuM29rQUtXUnpXRXV5cVVLN3JpVE5DVVQyOUVKT2F3WUkvTzFnbVZrYzF6?=
 =?utf-8?B?TXpjaXRIZVJZblFKWVFORmE5V0pzblNnUnFLMzRhYkQ4dytlUlh3V2ZTTDlU?=
 =?utf-8?B?ZksxemV6VGovSXN2S0IwajE1OG9zYlBRK0NFeGJjdCtpeHVzZ0JnVjh6bjRv?=
 =?utf-8?B?ZlJCZktEMkJPa1crb21SVVQrWWk0RnFxNnRuT3FwTDhQWkVVTWFvSmhVUm1t?=
 =?utf-8?B?cTYxbS96VFF6b2FkRk13dmI0OFQxdGxGeURtZ1JOb2xaS1IxaDdlaDNCT1Z1?=
 =?utf-8?B?TElBU0hqanhBNDlLQzFFN1J1b254OW9TSmowZzNKVllySEYyMGdjdVlSUzRU?=
 =?utf-8?B?UmxpM1lQekswT2RWemxjd29FYjJ2M3R6d0QyL1J0d2ZQdEt5Rmw5c1o4MFVn?=
 =?utf-8?B?aGZnajhmWXh4Z1ZNM0l3TklaRzhvMFFWeUhpUENmOW92cEFDTWdvbzBDYnB5?=
 =?utf-8?B?S1V2ZW9iRU5KWGlLYzlKMm5HU0p4NTEwNVIrU2xUVVJWZGV3RUE1S1V2YXYr?=
 =?utf-8?B?RGp5QWlwNkVWdEQ5STVNWjBObGEzTG1ocDBROEl4SzFRMDFCazdSeHNrMGh2?=
 =?utf-8?B?R1psR3AxM0xESFYzZm1XV2paWU54NTJuVjl2NWRoaVJscnhUVzVuL09BcThl?=
 =?utf-8?B?NkoxNmNxbTZxamJLSG5JVitGYkNaT3I3S1dnZGFLbGVTanFZV0hHb3gwWEd4?=
 =?utf-8?B?SlVoZHE3bzVQOFZnZ2t1amtZT0lvcTV4elhLelF0YkZHSHo0Tlh1NFl3RGJI?=
 =?utf-8?B?dHYzQWt4cWk0Y1FMT1dqK1RMV25kZEpwT09rc2FkVVRVcnVhdVBPSWFkWkdU?=
 =?utf-8?B?bUlvcllSM1p5djRRZVdXOW95YTJjcURjNUhxOGd1b2w0WkdLcVN4RTcvQkZZ?=
 =?utf-8?B?d2JGVW93TWNzUkUwWHg0UXFzN2NtNmdwNkorenpNRTE5VTNNSWw2R3hBcm9O?=
 =?utf-8?B?ZFJZQjRyUk9vOXU2Z3Q5VTZqOWVKeW5xSWxVYytDa1EzWFNQbmlSUDhQbHEv?=
 =?utf-8?B?OWdONnVzbG9tOWRXdmxGL2xUQnBpNS8yaVpRa3U1VmdXZ3l4Y24zVDdJVWky?=
 =?utf-8?B?SmNRTmVsN0ZlUE41ZEcrRVJ5QTBIMEMxK2N0OFVyeHNyaEVFN2lxSk1WN2g2?=
 =?utf-8?B?WVQvczhUWUdDZlBWb21neG9HVUtyemZGOWFoblAzam41NisrZ2NtV0VJTDJR?=
 =?utf-8?B?NTErVFFBaHg3aXdoUUt4OEF4eVNob0NmNzE2Q0w4ckRQMnJmN1RwYU5hNHRL?=
 =?utf-8?B?dmxnYTVCNkxsVkpscEpzeGZwSXVyRjhOZ0F6VnZTbVYzeFB5Ris4SGVHZmpX?=
 =?utf-8?B?VUVjT21LeWFrVGVoZEJLUEFySzgyOE5raERZWDN0OU1uT1RJUmhLaEZtSmpa?=
 =?utf-8?B?VHhKdk9LMyt3ejViaFNXOEswSVdJckRrTm9JREV1RlNnZTM4ckV3MjU3ZnVF?=
 =?utf-8?B?T2UyNWFHTGxqMG9uTDZ6VnEvMXVFQkMrcCsydmRidG5XdURQSVd6Q1VUV3E4?=
 =?utf-8?Q?rjlDf349YojcHcf4DMpT2F1SW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79994603-4102-4ccc-5afc-08dd12df9fe6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2024 14:43:02.8149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CeAr3mjljTt+ZySN69Y+T1VeGQhHtmUNVE0t4ULn1L3BZ+OptPQvyB2Us1FT2uttJILT5fycFniP3BvksPto9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7593

On 11/30/24 07:58, Mario Limonciello wrote:
> Use a scoped guard to simplify the cleanup handling.
> 
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
> v2:
>  * return immediately in default case
> ---
>  drivers/crypto/ccp/dbc.c | 53 ++++++++++++++--------------------------
>  1 file changed, 19 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/dbc.c b/drivers/crypto/ccp/dbc.c
> index 5b105a23f6997..a3c6822b3829a 100644
> --- a/drivers/crypto/ccp/dbc.c
> +++ b/drivers/crypto/ccp/dbc.c
> @@ -7,6 +7,8 @@
>   * Author: Mario Limonciello <mario.limonciello@amd.com>
>   */
>  
> +#include <linux/mutex.h>
> +
>  #include "dbc.h"
>  
>  #define DBC_DEFAULT_TIMEOUT		(10 * MSEC_PER_SEC)
> @@ -137,64 +139,47 @@ static long dbc_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  		return -ENODEV;
>  	dbc_dev = psp_master->dbc_data;
>  
> -	mutex_lock(&dbc_dev->ioctl_mutex);
> +	guard(mutex)(&dbc_dev->ioctl_mutex);
>  
>  	switch (cmd) {
>  	case DBCIOCNONCE:
> -		if (copy_from_user(dbc_dev->payload, argp, sizeof(struct dbc_user_nonce))) {
> -			ret = -EFAULT;
> -			goto unlock;
> -		}
> +		if (copy_from_user(dbc_dev->payload, argp, sizeof(struct dbc_user_nonce)))
> +			return -EFAULT;
>  
>  		ret = send_dbc_nonce(dbc_dev);
>  		if (ret)
> -			goto unlock;
> +			return ret;
>  
> -		if (copy_to_user(argp, dbc_dev->payload, sizeof(struct dbc_user_nonce))) {
> -			ret = -EFAULT;
> -			goto unlock;
> -		}
> +		if (copy_to_user(argp, dbc_dev->payload, sizeof(struct dbc_user_nonce)))
> +			return -EFAULT;
>  		break;
>  	case DBCIOCUID:
> -		if (copy_from_user(dbc_dev->payload, argp, sizeof(struct dbc_user_setuid))) {
> -			ret = -EFAULT;
> -			goto unlock;
> -		}
> +		if (copy_from_user(dbc_dev->payload, argp, sizeof(struct dbc_user_setuid)))
> +			return -EFAULT;
>  
>  		*dbc_dev->payload_size = dbc_dev->header_size + sizeof(struct dbc_user_setuid);
>  		ret = send_dbc_cmd(dbc_dev, PSP_DYNAMIC_BOOST_SET_UID);
>  		if (ret)
> -			goto unlock;
> +			return ret;
>  
> -		if (copy_to_user(argp, dbc_dev->payload, sizeof(struct dbc_user_setuid))) {
> -			ret = -EFAULT;
> -			goto unlock;
> -		}
> +		if (copy_to_user(argp, dbc_dev->payload, sizeof(struct dbc_user_setuid)))
> +			return -EFAULT;
>  		break;
>  	case DBCIOCPARAM:
> -		if (copy_from_user(dbc_dev->payload, argp, sizeof(struct dbc_user_param))) {
> -			ret = -EFAULT;
> -			goto unlock;
> -		}
> +		if (copy_from_user(dbc_dev->payload, argp, sizeof(struct dbc_user_param)))
> +			return -EFAULT;
>  
>  		*dbc_dev->payload_size = dbc_dev->header_size + sizeof(struct dbc_user_param);
>  		ret = send_dbc_parameter(dbc_dev);
>  		if (ret)
> -			goto unlock;
> +			return ret;
>  
> -		if (copy_to_user(argp, dbc_dev->payload, sizeof(struct dbc_user_param)))  {
> -			ret = -EFAULT;
> -			goto unlock;
> -		}
> +		if (copy_to_user(argp, dbc_dev->payload, sizeof(struct dbc_user_param)))
> +			return -EFAULT;
>  		break;
> -	default:
> -		ret = -EINVAL;
> -
>  	}
> -unlock:
> -	mutex_unlock(&dbc_dev->ioctl_mutex);
>  
> -	return ret;
> +	return -EINVAL;

Hmmm... not quite what I said when I said to put a return -EINVAL in the
default case. You now return -EINVAL for every successful case.

Thanks,
Tom

>  }
>  
>  static const struct file_operations dbc_fops = {
