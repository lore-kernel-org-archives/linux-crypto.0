Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2063.outbound.protection.outlook.com [40.107.92.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C137A1D63CA;
	Wed, 11 Dec 2024 16:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733933292; cv=fail; b=MrDQIPHWzzufj3t1u2oOvynAL3o/6i3ZlshS336zgpeNfAexPbAkYpsm518PSbHoU3PDz28oxx2JrA1cA33tH4jJMKrOUqO444Yrj6UjzDGdEG45efyEubl3i69scemdiVJ3gD+j8UcYx2WEudLRSyzBfJo2ZWgIXeKGzlky+i8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733933292; c=relaxed/simple;
	bh=QX10CQBQC/YUeufL7OrsztOTC4FJWPh7GrIfUajZnvg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=drvG7aPTuPIC19dfnHhLs+fFZGl3vLyClSLUn9zty3I+P3MK1CGkqjIppPW5bTKsmQETnlxgK2RPkbqS8VuTZtxVUnz9D6P5a5R+EG0k62+CkR/mEkl1IntrqWNvwks/Vtp7wt/WviheZWKQb3fxWMLvWJ1TKacxFgeiH/DuCyg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=r6Adl7WC; arc=fail smtp.client-ip=40.107.92.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="r6Adl7WC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=crhyS5WmPYgdEPSGvWj1O4wbgB6YTaSu9LCQkNvOM54XaFp3LXPxFjTHdiWaclrWuc1sPmCz8YiKtdVrkEBzjjErCogViAIECkYgbogyvf6qZIqfw+WnlJYzSXtuzJY8ApKF0etDKXP1xOpuT8oKpgnKYhM9QcKW69FvrODAd4YoHhSWpBBU0C+ef+0en0xJ6kQmPuklYMXUzDN3URxlsQCAH80bwmyGwEl96lrGcPm4M2AXNIcQr+voReiBoi1DVsEIc0e1rABEsyHrPBcry13hjbQBkxr2/2c3hx2+AeP7nZAGYHwie4HgWNt7oCEogLIFdhtr9Sf9BX00GtKx8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I5BMWaGmM/VjAW7CcORDrwlYyfGZSwr1CpSdVyuFWXU=;
 b=dZVg7mqztp83hLIgJhRFQZ1C3gOPcz104TgaKQMC2QCPLG5YlHrse0cLBvxLCIJq5RBJTQG8sUPNXB1l6Lp2H8YsX9uNGa1INZUfMZYSqn09yQpFScG2mW65IrQ3/7i5zVPl/yZYgs7kA4d3BfnvqTJR55KCu72NCeCjJEOXxyNV82XjHzyq1ZGQ0NwgVrM35l+boaaZWJXAQhqNenRvWWh6UIgKuX5yHmYYb3AJYNYMmkjPNN20wDKxmhmEwZZwx94vJOI9tqitoacbaOFzHvcU+1vs4dpdwD4K7XxEW9eAv2wkz4zaseOtlokFfId28RMP2kJVq+pgogOGVCsBHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I5BMWaGmM/VjAW7CcORDrwlYyfGZSwr1CpSdVyuFWXU=;
 b=r6Adl7WCuR9h+SugMlWudaicqbq7VUcqc2NGWCGGx471gQGYd5OSMbwQNt4L5CuNEpXWvDcIG0rZWV9BVk/O7B5/EscKXtSOZMMgXkRQ7OGd/VGtgTIlH4Pl0H+Tn8EwPiESMhkHrNm4BWcsHJEfrxf4SbQ4od1rSHJfPLjVYXM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB8123.namprd12.prod.outlook.com (2603:10b6:510:2bb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.17; Wed, 11 Dec
 2024 16:08:07 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8251.008; Wed, 11 Dec 2024
 16:08:07 +0000
Message-ID: <ec4902a2-e4ab-9f74-9f61-8c1bab549746@amd.com>
Date: Wed, 11 Dec 2024 10:08:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v3] crypto: ccp: Use scoped guard for mutex
Content-Language: en-US
To: Mario Limonciello <mario.limonciello@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: John Allen <john.allen@amd.com>,
 "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - DB..."
 <linux-crypto@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20241203162257.6566-1-mario.limonciello@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20241203162257.6566-1-mario.limonciello@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR04CA0002.namprd04.prod.outlook.com
 (2603:10b6:806:2ce::10) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB8123:EE_
X-MS-Office365-Filtering-Correlation-Id: d9fb57c0-a768-4023-0cef-08dd19fe002f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WnAxQ29CQUx1QkV2U0F4OVljTGF6ZzdyN1N3OUJKYXUrQk1ldWVROFdDWXRl?=
 =?utf-8?B?Um9kTnNja3kxTDdvV0tKZHZQYTVZSUpqR0I3aUhDR3dSK3BzeHVBRXBWRkdN?=
 =?utf-8?B?SVoyYjhjaGtReE05bVhGa3F6SzBucHcvbUhDVGMrTWpLU1czVzBiTnFvcGVE?=
 =?utf-8?B?WUYrZTg4UVNPeVhzKzc4b3ZCOXpPZDdqRm5tYjhHcjdERDV6OHJqRVluVWZZ?=
 =?utf-8?B?cHh6eGxzOFkxbGt0L0YvRnBWTnYraVVWcERCWnVsZ0VveklYSGRiOHg0QUFs?=
 =?utf-8?B?MGRvUXlEa1o1WkpydWVlK0xORVhFczhBYUxSTjdoUldmelBkaUZ2bzBGL3ZQ?=
 =?utf-8?B?TXpqcWk2SGwvUGg1TExxcG1CbUYydEtxbUxMbXhwTTZGMngxWFlsdnVDN1ph?=
 =?utf-8?B?U1QvcE1IOEwvaWNsazJKWmFNRjcvQnRpTThWb3NBVE8vMXNPUWtBRHVpeCtu?=
 =?utf-8?B?WVNySEZIL2Z3Qk53WTJWWE1Nb0FUT2ZTSlVodWZtSEhvR2t4bGdPMUxzK0JC?=
 =?utf-8?B?NHVQTEtMcVZBZGF1V3llTVBEOGlYSkJiVC9MYnl3RlFrY2t5SGZFTlFob2JT?=
 =?utf-8?B?L0t2SFVNRnc3Z1dyMHRKcU95LzFxRllDNFdZTzlQVHNwZGFHeXY0QkxwUWRr?=
 =?utf-8?B?Q1hXL1dvbTgrb25LNUh1cDBSRUF1Z0hmbHVreUhmWU9KSmU4R1Y2dUdveFpn?=
 =?utf-8?B?T0pqMlBaeVBlNFozVDE0QVZ1ZW5KTXZiU0gxV2lKaE1lRzRGMno5aXUvS2Uw?=
 =?utf-8?B?cFNWbFdjbENnbG4rajM0TktPWnpDMms3WmNGTTl0cm0xZWZFS09PTWVuQzAz?=
 =?utf-8?B?Tm0wMlgvclF6M2VqSUI1M0pqWHhiWnRidk9ZcHpNam9jaG15bHNZU3Z1QlJ4?=
 =?utf-8?B?dHlKWi9NRHhmeHpoNklzUUh2ckE3VmNwUkZBZWt2K3dQSVVrVnJmRjdUMWo4?=
 =?utf-8?B?S0NURXhYTy93dDBrdWE1NU4vRkFuQjF0bGtteUdUQmVvQStkeHJiNnVHSWpG?=
 =?utf-8?B?RWZxSkdkYU5lN0o1Y0Y4UXZQRFdJSVBiNGVKemZ1V2F5eER6bFROZFFLWjZi?=
 =?utf-8?B?MlZ3TitzdGxEcm5Kejhhb3ZkaURHbVYrS0RudHZMZkZlTEEzWFlScUdxekg2?=
 =?utf-8?B?SU8xVHpydGJDek5YVXNMWStVZytyWHVCNDdzOTcvRW5tOHgvYTVUd2orODNa?=
 =?utf-8?B?VWJzWUJCeVI0UmtLOHJZemlDakJqaWpqYnI1Qi9ML0RsemFzK3IyQStucWhT?=
 =?utf-8?B?WDFRdThFVzdOVTZJVjc5aEllS08xWGhVaEE2MTVRNkpSeGdyZnQxRU16aldT?=
 =?utf-8?B?eXNqZ2lEWmorc1VqMUxVa2Zzb284NHlGSXRDWDJBc2ltTGhkb2dQUnFkdks4?=
 =?utf-8?B?dmJKbEpIZUp3OE4zSmFPQ0g5NWx2VmtMNlU4WWNhMDZTS1p5d0o5dm80L2x2?=
 =?utf-8?B?anNqZ0xnMDd0SnlYbGxHaWxzQm1JNXlTQ2dhY2tIaS9jWDlCNlN0VUFFSGtN?=
 =?utf-8?B?SnIydG1kWmhmWC9wNHllM3BOSmptbE9wM3FsYTFhT2tyMEt2Mm9qejFMRnNJ?=
 =?utf-8?B?ZUo2enhaQm90eGVtTi8vbytDd2dpT05vYmZtM0FQZXRUVHlQQ3FSNEF5N0Ir?=
 =?utf-8?B?K0pTTDZUOUtnNlN5UkhCSHlaT2tGcEcyc3hTRXRkRW04NTdDL2ptZE5aQUtE?=
 =?utf-8?B?ZStxYjRWakE3dCtXa015azlPMUp4Y3MyZWhnRm56eGFxZVh6SlgxbVp6Vzcz?=
 =?utf-8?B?Y3UxMXB6OXhYczBsT3lpMHQvcmNzc0VNQXcxcVJZc1BuS3grZDBoQ05mcnl5?=
 =?utf-8?B?ZStHRE8zclZVdWViNUlvZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZVhGN2tiWFZwQTNhWjFNaG50c1JWQnUxVFRZNXY5Zks0MUtmaTFVdDFWejhN?=
 =?utf-8?B?TU03d1ZGaFdLZFU4ZVYvVGJFbFpzQlBEQVZvMUYyb1NOb0tUT2RXTWp1RU1B?=
 =?utf-8?B?aHJmTWd1NW9wSUhkY3JxM3RpWlFxKzVCemRIWVc3MWlOWVUxMlRKUHdIVm9p?=
 =?utf-8?B?Y2MvdHRiY0hQcHV4c1NNRHd3cDZ1L2hmb09vN0FhemNaaERHdTNGQXlXcWFW?=
 =?utf-8?B?QWduaEd1WXQreHdpZjd0MEZCZ0J6dDdERnJTUnI3cTM2cWZBTXdKMHRHRVBU?=
 =?utf-8?B?N2N0dUhsS0hFcWVmcFB5Wk01RjBzMHh3c2xzTDhadERGT3hFUUgyakJVaFpH?=
 =?utf-8?B?OFBUdDNpbmYvSERGOUxBelhkYy9aZmdzbjBNeGl0ajlSeG1udUYzbS9sek9r?=
 =?utf-8?B?NHFFSWFDZzdSN2IxVnpSclpOSmhSRnZoRVVHeVI2elZqV1ZwMXAwR1RUdEpw?=
 =?utf-8?B?bHNDZGs2L3MwMWVHbHZJZ05uRThtYzFaZGxMUUdjb0Y1d0xyaXVJK25Rb3pR?=
 =?utf-8?B?Ti9nSEFXK1duWFR3ZlkzUmxPTk93Wll0aThSdEZMZXE1RWFkZ3dDQS95UE9J?=
 =?utf-8?B?VEw2R3IyUGI5Mktwbm16eDl0cHJhcWp5VGx5TGdnUVdLVDZzRGFLSkMrU1pv?=
 =?utf-8?B?L0NEaDd6L1pvcHBxSjJ3UC9zMkFKY1RldGN3KzEwc29OaVpaQ1VzaTNGVmc4?=
 =?utf-8?B?aWl4YWVzRWRwemdWSkxXQ2VmSGRNeW9aRExiNHhzUHZvRTU2SE9BMXNSNnZH?=
 =?utf-8?B?U0dvMTdLM0tsTnhobnZJakRycm5DWkJGRXpxM3RRNUYwdnEycEZaNW1ZVzJJ?=
 =?utf-8?B?WHdyazdPUkFVVC9mSUxXY3ZsNSsxd3lQSVFYakxFZmloOFo2a2pWRHhVSW91?=
 =?utf-8?B?TTQ4R1NqbVpZWC81V05YTWZNYlB4RWszT3VydEF2akRwbEJ4R1hOcm55K3FZ?=
 =?utf-8?B?S0hFVC8rMGtRZ0JqUElKVEhEY2xzMmlieUFQWVpQUmRiSWtnVE01OXhTdFFr?=
 =?utf-8?B?blRoeE9KS1dMTklDZVZaVENSM2dSYXZ3NHoyVlB1VFM3aTNSM0IwbTNZQ2pL?=
 =?utf-8?B?a01ZOUl1Y0taVGlYVHNxT1hnNlBmcFpybWFLN0UyNXZ4Q0l6YlNHR096OUlq?=
 =?utf-8?B?d0lFTG5zRjFtYWRpZVdWWUpRM0xGcWhhK051Y0hIZG51Tk9tMVNFRXlYTEF3?=
 =?utf-8?B?SVRVQldkVS9xUUxrMG14N1RMdlY3NXJMYnVTQm5sY0xrRWdaandFOUtmRjE5?=
 =?utf-8?B?L2p2TGNuMGo4NFJ6UVpoSFUyRGt5dGswd3lWNlM4Mjd6R2NWV1MyaFpRcytU?=
 =?utf-8?B?eWJMUjJrLzNhalIzRVZkYkFBVW9SK2Y2cDYwdUU4Y2dQZUVVMExMVnBjVVZM?=
 =?utf-8?B?K3p6R0hFUDlDRDlrMllaODNFVVBpQ1NmU3RrK1B4dmhtY3RPT05LbUFQTTBV?=
 =?utf-8?B?WlVZRUl2ODc2cEdZSTUvd1VWNXFKTktUUi9nQkVzMVg1QjMzRGp6bUY5TTBG?=
 =?utf-8?B?dXdQdkVRZWV2Z041Wjl0eWVDL0RKdUFlNTB0Z0Rja2duNHdKcXVlbzEydzVo?=
 =?utf-8?B?WllJcTdaTmNJRlNza1I3WFRlUnZ5djVLM2RhaURVdkk0SDI4aStjMmx3enJ5?=
 =?utf-8?B?NG9EWGdQMktmdCtHTitzYW9HcHlzc1BmL016Smd3NW9Za3NYYXhHdWNVeVh0?=
 =?utf-8?B?aWhwdG1ML01OYndpM3gzL3FSMGhWdUJLWERWZ2hzbHVBVTQzMlNqTCtsYUN3?=
 =?utf-8?B?UWpIYkdQVEJzbjFHMFhORzRJcHM0bW55bjF5MEwvdUMvcnVCbXFsbm0xSnFG?=
 =?utf-8?B?TzZNYU1vRmVZZ2I3a0duQW5YVWhGZVdNcXBCMjA1Vm1Lb1UyZUNvR2hTUU41?=
 =?utf-8?B?eFNSZC9HaWI1RHhoR2RUQzMrR3NBeDRvbWdqdWcxby8vNFA0aGIzalJ1RTI2?=
 =?utf-8?B?U2hRVWVvYzA4b0pYWDBiclNpYzdIWCt1V01tODZ6QzcwQzNGYzB0R1FYeGd5?=
 =?utf-8?B?Z2FNc0loMGs3VkZSWHhPV2MyWHpjaVc5NGF2ZXh0QWFRWFpZSUFja2ZvZmwr?=
 =?utf-8?B?TXM5Y0ZHK2JWUkJzY21Dc0ZyMTNweHdTZldZYzBPcnlyZUdORnpudk1oRXU2?=
 =?utf-8?Q?rvUK+UuQa2sn13mHDHLHyO6n+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9fb57c0-a768-4023-0cef-08dd19fe002f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2024 16:08:07.3866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +xBOAqEGEfX9YuVJ3etMafYmowgRz6eGMvfHFymGO+WW4hWlEQzBFP3OuJZdM74YjCilZKislbwtJL4Ge+M4ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8123

On 12/3/24 10:22, Mario Limonciello wrote:
> Use a scoped guard to simplify the cleanup handling.
> 
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
> v3:
>  * Fix logic error
> ---
>  drivers/crypto/ccp/dbc.c | 53 +++++++++++++++-------------------------
>  1 file changed, 20 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/dbc.c b/drivers/crypto/ccp/dbc.c
> index 5b105a23f6997..410084a9039c9 100644
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
> @@ -137,64 +139,49 @@ static long dbc_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
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
>  	default:
> -		ret = -EINVAL;
> -
> +		return -EINVAL;
>  	}
> -unlock:
> -	mutex_unlock(&dbc_dev->ioctl_mutex);
>  
> -	return ret;
> +	return 0;
>  }
>  
>  static const struct file_operations dbc_fops = {
> 
> base-commit: 40384c840ea1944d7c5a392e8975ed088ecf0b37
