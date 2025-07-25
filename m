Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4417239E7E;
	Fri, 25 Jul 2025 04:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753417859; cv=fail; b=Btli7J+QSGBf0cmtsQE1nViIQkxWQmqz0USgoZgh1c3b1Hb0JqURt2fyjRzVvttZe5sxaGEQLrCFGJa8/Op5kPvLm4nfC3Gn97hA8gkFrs012kdz3c+O3/UZx9WiaYfk1CKaeT8hlB6NvcICXvwdZeAC+S5u7dPpLY83V3FRU+M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753417859; c=relaxed/simple;
	bh=eH/EdJvjA8sWTtKFVSnjJ8yp2+6fzVnMLql2N4mxCkU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Prp2NwDfXDgIiP1pOJ0s8/FBCe2fmnaqSOLUjVcVE3PaF/4mVNKq8OWyqDAYS6buV2IxbZiSgoqXKJN33RcHfLJIcTycJVpr4wbDffF7gZucAes7mWQVHfU5UOfeISQxAi707Mv22ua2DOfQBzbQM5puWjmTlanDjObamnWviDc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=c6hYGI6p; arc=fail smtp.client-ip=40.107.243.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="c6hYGI6p"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ptyU6D37MJ5G8HH0JsP/gsx1KqREQcTYO4JFJLtFIoACM2gBt7v8fxfyTwLmk+sAl3yb4ATEAnW2ZLO08wVmbC9ShCDz/OvMQG8uRv8V+1qhKJEGHAUvcNCXKSVpC1dWKWIu2toyNzZfzmrdd7VVn4ptekeMjmfJ4uPkna7HklgbBoLCDPPt3vX3m9Ix4q48x1O11Ws6p5t/XFOEqGDHNql2e8Ia4cGQLohwsptrVC5QMsU4ADZSMWIo1Nw01uTlSa6VRRJzOQTV3gNfcIpPQvno0tcg7BvKO78F4Np3oTTKdjRP5zFvFVRfgyww6Q9If5GeUiagd/cfURlvNM8IZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l6HuSiZOSeAJfu0f987vaVedu+mzVmoXdJ9+cCo3D7E=;
 b=XWY+7uaeQrijshzbSZqKOTMOW8TgVt4VNptMreYfa7BALNs/754HmpN5beTN4MPTqwv2X1eC4p7WMb1paosi+CSIIYj31AE3HTU+B5hUHKs1L9golaLV/cMpuYl+04tZCpswQguzGcfRzfizFrn/WnS0ZnOargDUaLoS7BHota8hVYAnF/JFYvgzNOkLP6WlC5Sbl4DLBPNAI9SZQvvSJzLxH6Bd4R03YPXhhR9bFUiIjiGx+i3gbt8kuiTO9QYwHHFNLvJ2oU0vws19ahmeTrqqhFFYRm6lfNbvBxMStZpyWMMaoMczHHRrqhIBJEnR6mcNz0AO6IZLwHf3Yf96Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l6HuSiZOSeAJfu0f987vaVedu+mzVmoXdJ9+cCo3D7E=;
 b=c6hYGI6pJ3jyM7HVSZe/1ETh1Qse5oIjwLjeqq26sl2LrIKTY+4MD7+iLRF8qzL+pZOUMp3vdpb4IqRUtc0yIVS5x7s9xZp6EOC6W3qUDxr+rFdooDSNM4YPM4SfBrrWaRtsdqH+aXCjunF1B+NGNxUEbW4C8RF/5MZ2YABymBQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DS7PR12MB5864.namprd12.prod.outlook.com (2603:10b6:8:7b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Fri, 25 Jul
 2025 04:30:53 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.20.8943.029; Fri, 25 Jul 2025
 04:30:53 +0000
Message-ID: <8e4c35e7-7a41-4f2d-b838-92811cfa71f2@amd.com>
Date: Thu, 24 Jul 2025 23:30:50 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] crypto: ccp - Add AMD Seamless Firmware Servicing
 (SFS) driver
To: Mario Limonciello <superm1@kernel.org>, thomas.lendacky@amd.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net
Cc: seanjc@google.com, pbonzini@redhat.com, michael.roth@amd.com,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1753389962.git.ashish.kalra@amd.com>
 <82acbf87e782c482ebd8d80092b5ad47d1f4b854.1753389962.git.ashish.kalra@amd.com>
 <7be95f26-3443-4ef1-9761-a9e1551f2ec5@kernel.org>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <7be95f26-3443-4ef1-9761-a9e1551f2ec5@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:806:20::30) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DS7PR12MB5864:EE_
X-MS-Office365-Filtering-Correlation-Id: a6afb5fd-7b61-49a1-9137-08ddcb340a37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RTB3aEs0Mk8rU1FnVFVFV3ZGK2FiOGx1cUNXNzJRKy81MG03YzUzTCtRLzhT?=
 =?utf-8?B?L1FtNkE5aytqK2xwdTB6U0pQSzNrczdzQUtzMWhCK3JvTUJRdjRXUml1aGRv?=
 =?utf-8?B?NStPWnFOb1YySUx3VjMzRS8wUTBGT0d1Vm5NdHQ2U2hmeHA3czRUVkVvMHJS?=
 =?utf-8?B?NWV5REI3dFo0Mk1VcWJNNWRoT1ZsaFJKK2RSQnlwa1dtN1dhK3BZbWd1KzFy?=
 =?utf-8?B?M2EydDdGQU1WVDUwbW91SzVGQW5PZlZNMHkxRmUzbVJkdWZEeGVxekdEMnZa?=
 =?utf-8?B?Vk1mRm5raGRHVlErUnZSUXVGQTN2MEc1U1pteE9oRGN3ZzQ5OGt2VExoWVFQ?=
 =?utf-8?B?RGJoTWFoVTYzdDY1UjNtUTVMaDFJdng3M2UraXNhejhkMkl2c2R3ZG1YOEJC?=
 =?utf-8?B?K2RJeHNFRHZrZDRUd3BMQlhicUs5UXoyUEswNVJlL01VYVE1ejByK2tTMTBm?=
 =?utf-8?B?RnlWZHFCWnV1TmIwVVdheGJNSm1uWmFibG8zc3pSYmEyS1NzOTA0MnFMdGV2?=
 =?utf-8?B?Zi9qUDBiQmVGR1NsdHFVQmFIQmg2ZzBnOHZvODk4V3BLbTNkSGFiTVpLK1BD?=
 =?utf-8?B?cm5RdXR0aE9QSG5vRVIrWUlQcG1ZNktOdytPdFZGczB3cXhYV1FsTGpNRDEy?=
 =?utf-8?B?UFpnY2N5OXpZTzN1RDdnSTZvR1ZCWFBNNFhVK2xGdG04NEdzL0p4NEpoZ0ZF?=
 =?utf-8?B?NmVpNGRtTWZyWUVRdzlsTkh5TGtScUpVOG96NVJKN0EwWkFLQk1LK3lFRENC?=
 =?utf-8?B?OU1mYzQyb2RLeU8rQzl1aVhBTnQ5d0R0RXE2THBlMklad0JOaWtaMy9FL3V6?=
 =?utf-8?B?RXhoRjRSVk10VWhjbzFOYUVoVHVVOE5xWURKNGlINE4zV0szbnJYQlg1RXUv?=
 =?utf-8?B?NWREVnByYmVVQ0FVKzFrU1hjeUpCMklNUVNsSFhTZGgxQWlrdDh0d3cyNjNq?=
 =?utf-8?B?cnQ1TG4vUVBqZGlUVitOdVBvVCt4NDRmV3VvcDRsUUVHUDZZVUFZN3Q3NG90?=
 =?utf-8?B?cTVGK2dhYS9uTkpzOVFHQWlRT0VZKzlhMHRwRzZZV2ZHSTFiMzliOGlBdW94?=
 =?utf-8?B?dU0ySTU0bVVKZk1RMUpjMmlsOUdLK04rSDFnVzFiNlIwcExDWmVYYmoyNGQ4?=
 =?utf-8?B?Q1hQZkVpWHVFZ2ZTNk5GWGFFZENLMkpQMFBOSVZ1ZE96dm95WnJEdGRJb1Ft?=
 =?utf-8?B?aGdWMkJUOHNDVlFweDNkRHhJRUcwK1krY0JiMXJqaXRFazNxTURXL000Yzlp?=
 =?utf-8?B?QVN3eVNjL3pkd3FEZy81L1NMUklKSm1lUVc3Z2cwdER4YUpuL0xoT20yMmxO?=
 =?utf-8?B?SHBKdFNOSkxxWGZobFB2Z281U1RzVStyWE1lcjZjN21Ebm4yUnBJWHFHYmRL?=
 =?utf-8?B?QmVQQUdaZ1hreFlMcXFZVzB0V0lKa3JYVHo4WmdKdFc1RU9nLzBpTDdaZlYz?=
 =?utf-8?B?dEJSYVFFdDQ0dTVmM2FKb09sSVBQNEtHcUlERzF2QXBodk1ERHd1Z0dscEU5?=
 =?utf-8?B?RVF0NDlvK3pFNXVFZ29aNHZTVGhTaFRZMS9oQ2dhODdOcHpiYyt3SThzMkNz?=
 =?utf-8?B?S2FmbWdwWGdPN3dpSWRmQ3U3T05zbm9TbVJIZ1NSWGF1bUM5L0dzeHZIV3B3?=
 =?utf-8?B?ZHg1RnFHT3AxOXJ0Z2Z2N2x3bnM4U1dwb3IzVGZLZUxwME43ZWlRRHQ4Uytn?=
 =?utf-8?B?SnpTVk5KdDNDTUNhckpyRW0yRDU2blo3SFAwVVpqcWdtaWVYYXUwMUtGZnJM?=
 =?utf-8?B?c3VRS05TQzg0ek1DK3FpV2JQbFYzSHVRL2pzR2VFTnphdUJzd1grN3BneTZL?=
 =?utf-8?B?REQ0QTAxSW5kZTlwUXdocTlIMWNMZy9tR3ZKVzFqOXAzR0ZnVmc0Zk94dS9u?=
 =?utf-8?B?R3JIR1RlM21keWJUell1WUx0RWhpTVVtU1ZSV2d3SDJvWkRiSUVaTVNjdW51?=
 =?utf-8?Q?HiMxEpPPKRg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MDBGQnV2WHVueWw3bXJjb3BMa25KcnlNM2F6TjNlaEZNSGVtZXVsRzYvQ1BG?=
 =?utf-8?B?Ym81K2pqRUJxVVJacTQ5Um1Ob2IzbXJ4Ly9zMXJzcm40aGtsaVlKOU5OeVlX?=
 =?utf-8?B?VVRiMjJJSnRjbzg3OW83eFhlV3ZCTkF1YVQvSHlkTURLRVlBUzZjbWN1Y3hp?=
 =?utf-8?B?Ykx2bkVMeGVubnlMWmR2dmhSRjVQZXdQT3ZIYVJvcWVTQ0pIZGpqRk1nRDRM?=
 =?utf-8?B?UmVjVm01Z2gzK1pVZjFHd1VMYUNrWTJIZDByRTZYOGM2blZOWk5vU1FTVzVL?=
 =?utf-8?B?dVFpNUpDTUJSSWx0Q1JYOVVmY3FiU3lkbm5JQ1E0UjdkRkZHM0N1TW5ubUpM?=
 =?utf-8?B?TEswaCtRTENBYWs4R3VqTzFCa2Vlc3hVM09uRm5Da3NHRlBnY2xneTZma1py?=
 =?utf-8?B?eWVKZmZzQStVVFFsTndlYVhRZkNCSHZvQ3Y5ZmpYazhycUpTZEZNTjk2b1VZ?=
 =?utf-8?B?VEt5UEpzejl4eGJMVlRGV3gxbVdiZkJQWDRJTjNDeVdTMDAwalhiRjh2eGh4?=
 =?utf-8?B?TG5nL1FhUFBjWVhVUEMvV3JIRlZNdHRlY3F3K1NZSGVXUVBscGhMVkJuTUp5?=
 =?utf-8?B?Rmt5UTN3T0lJNElZS2Joalh1Tm1uMVRSaE1FbHdFZ0pKdVkwYVJIYk5MbThM?=
 =?utf-8?B?aytMTXJ1T2dab2c3a21nVzVleVV6REdsT1JOaXRha2xaTHVtWHRrQ3IwQlE0?=
 =?utf-8?B?bnVRMnJBcFcyL25UeEdSNisxRVY5bUk0NUNjMDZnNlZnbjFtSGxoVkVNOFFE?=
 =?utf-8?B?Ykc0M2hDa0lEdVh2NVEyV0haYTR4U24zcHBTNGIzalRodjMrWWxpdkJsQ3B2?=
 =?utf-8?B?ekJRVHRha1BuMVJNZ0hvYUxrUmduRlR3ZStmc2JjdG5KcndFbEJxV21QWkNV?=
 =?utf-8?B?OGFHZWpjZVFDdnBWeUt6ZHZjQ2FwTEIrSW1OQjlhLytDSlNYRmpjU29VV295?=
 =?utf-8?B?NHFMd3ZJdTZFaEZKelBGVmZuMXdIakU3UDRxNDlkekxnTjB5T05Kelg3OWN0?=
 =?utf-8?B?QWxBVjhOR1R4dmJhRmwyMDIxZ051bkVYaGQxK1VWUVdTYXVLUDlqQlAvWXAy?=
 =?utf-8?B?UXFsUkRFUHFYdnVtbUtzb2ZsdGJJR0RyN2FXMDVYRGZvNlhBb2pLVTlHK0dy?=
 =?utf-8?B?d0RnYlM0VWp0b1pEcUk3ZFVXSnFMU1QxT2R5a0xaVXMySWgrcWRXeCtHYnZx?=
 =?utf-8?B?QkhMM2NSN1hPdHRyVS9QMEtmMThSa0Jxd3NvYXAzSURGRFFaYWE1aWhWZ0xw?=
 =?utf-8?B?eUtNY2c0ZnNhaFBIWEtlYktOVnYvYlhER3VYOVFGTGVrazVFUTZIRWhldGNk?=
 =?utf-8?B?UEp0ODI1R0VRWlNPOFZtMVk2aUVLYWNUQTlTamRHT1hHQ1ZoWVVZbGo4OCto?=
 =?utf-8?B?SXFYdnpsaUJEdEJBb2c0bXh6V0dDQ2FLMXFOMmplbVZkYXptTGR6MVZYd1Zv?=
 =?utf-8?B?VHRlSUhhZ3h3RXFTU09oOUZxWk1PZnppbE9HaW16S0VEL2crT05tYzJvMnI5?=
 =?utf-8?B?dHgvaE9kbzl1NHMybzFKUVFjWXRBWFFtWlhMSXg1TTUzTWpHQUREZDZ5K1Rm?=
 =?utf-8?B?UTlDNFJDb2R4OSs3dWtCbnorVUVMUzB4ZGxrSi9IUUFDRTFQS1BuTkh3OFdG?=
 =?utf-8?B?ak00RjNuOWtaSXgxMWJIUFZHUmZjeTNjN2J5L1l6S3JyTjBiM2VqbzBKMlQ3?=
 =?utf-8?B?WlpWalRoQlRCWGhDbkpwd0tXZFl3dkl3ejF6Tzdob0cxUkZNWU9EUFVWeldQ?=
 =?utf-8?B?dzR4dGNldmF1Q1BKQmdFQm01OTNDeFllYjdiSHo1N3N1MHdaZE55Y1dUTTU2?=
 =?utf-8?B?Y0Q0Tm5oNkVFOTNDU2hKMUpIYy9xMXBhM0htazhWUWl1UitUQVlOWjJLWUdC?=
 =?utf-8?B?RkVsaUtaVU85UjFTSWtrTWkvRXdpM1JmVDdRUk5MOVBieUNtOXpxWXVkUUxs?=
 =?utf-8?B?V3FGdUkyWDRwN1dGQ2NCeVpSRUtNbGsvNzNWSk1xRkNlWitiS3VnajV6NXo1?=
 =?utf-8?B?TmRmSkZwcW9TRDZ1cHJNZlRNOGI4SlBka2ZlVnZaRkRyZVpEeE0vdUoyWVRu?=
 =?utf-8?B?bVRjTkFvdWVaSVROYUxSOXdLdEpqSnRwWkhUU0U1SDlqUDNMendkV3FnYW55?=
 =?utf-8?Q?D4NWkiF06S9c1ehjOUyM05Xle?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6afb5fd-7b61-49a1-9137-08ddcb340a37
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 04:30:52.9069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qWf96KyqkIuoYljgQ3pOHzzxkjiqyOQju7yZnI5Go+s0bf4bDoDhwqRthdntpFgxLml2ZMcsp3Un9eZbuczQCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5864

On 7/24/2025 10:32 PM, Mario Limonciello wrote:
> 
> 
> On 7/24/25 4:16 PM, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> AMD Seamless Firmware Servicing (SFS) is a secure method to allow
>> non-persistent updates to running firmware and settings without
>> requiring BIOS reflash and/or system reset.
>>
>> SFS does not address anything that runs on the x86 processors and
>> it can be used to update ASP firmware, modules, register settings
>> and update firmware for other microprocessors like TMPM, etc.
>>
>> SFS driver support adds ioctl support to communicate the SFS
>> commands to the ASP/PSP by using the TEE mailbox interface.
>>
>> The Seamless Firmware Servicing (SFS) driver is added as a
>> PSP sub-device.
>>
>> For detailed information, please look at the SFS specifications:
>> https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/specifications/58604.pdf
>>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>   drivers/crypto/ccp/Makefile         |   3 +-
>>   drivers/crypto/ccp/psp-dev.c        |  20 ++
>>   drivers/crypto/ccp/psp-dev.h        |   8 +-
>>   drivers/crypto/ccp/sfs.c            | 316 ++++++++++++++++++++++++++++
>>   drivers/crypto/ccp/sfs.h            |  53 +++++
>>   include/linux/psp-platform-access.h |   2 +
>>   include/uapi/linux/psp-sfs.h        |  87 ++++++++
>>   7 files changed, 487 insertions(+), 2 deletions(-)
>>   create mode 100644 drivers/crypto/ccp/sfs.c
>>   create mode 100644 drivers/crypto/ccp/sfs.h
>>   create mode 100644 include/uapi/linux/psp-sfs.h
>>
>> diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
>> index 394484929dae..9b876bfb1289 100644
>> --- a/drivers/crypto/ccp/Makefile
>> +++ b/drivers/crypto/ccp/Makefile
>> @@ -13,7 +13,8 @@ ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) += psp-dev.o \
>>                                      tee-dev.o \
>>                                      platform-access.o \
>>                                      dbc.o \
>> -                                   hsti.o
>> +                                   hsti.o \
>> +                   sfs.o
>>     obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) += ccp-crypto.o
>>   ccp-crypto-objs := ccp-crypto-main.o \
>> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
>> index 1c5a7189631e..8c4ad225ad67 100644
>> --- a/drivers/crypto/ccp/psp-dev.c
>> +++ b/drivers/crypto/ccp/psp-dev.c
>> @@ -17,6 +17,7 @@
>>   #include "psp-dev.h"
>>   #include "sev-dev.h"
>>   #include "tee-dev.h"
>> +#include "sfs.h"
>>   #include "platform-access.h"
>>   #include "dbc.h"
>>   #include "hsti.h"
>> @@ -182,6 +183,17 @@ static int psp_check_tee_support(struct psp_device *psp)
>>       return 0;
>>   }
>>   +static int psp_check_sfs_support(struct psp_device *psp)
>> +{
>> +    /* Check if device supports SFS feature */
>> +    if (!psp->capability.sev) {
> 
> Should this be psp->capability.sfs?

Yes, definately it should be psp->capability.sfs.

I don't know how did this got pushed, i have been testing with : 

static int psp_check_sfs_support(struct psp_device *psp)
{
        /* Check if device supports SFS feature */
        if (!psp->capability.sfs) {
                dev_dbg(psp->dev, "psp does not support SFS\n");
                return -ENODEV;
        }

        return 0;
}

I will push the correct function in the next version.

> 
>> +        dev_dbg(psp->dev, "psp does not support SFS\n");
>> +        return -ENODEV;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>>   static int psp_init(struct psp_device *psp)
>>   {
>>       int ret;
>> @@ -198,6 +210,12 @@ static int psp_init(struct psp_device *psp)
>>               return ret;
>>       }
>>   +    if (!psp_check_sfs_support(psp)) {
>> +        ret = sfs_dev_init(psp);
>> +        if (ret)
>> +            return ret;
>> +    }
>> +
>>       if (psp->vdata->platform_access) {
>>           ret = platform_access_dev_init(psp);
>>           if (ret)
>> @@ -302,6 +320,8 @@ void psp_dev_destroy(struct sp_device *sp)
>>         tee_dev_destroy(psp);
>>   +    sfs_dev_destroy(psp);
>> +
>>       dbc_dev_destroy(psp);
>>         platform_access_dev_destroy(psp);
>> diff --git a/drivers/crypto/ccp/psp-dev.h b/drivers/crypto/ccp/psp-dev.h
>> index e43ce87ede76..268c83f298cb 100644
>> --- a/drivers/crypto/ccp/psp-dev.h
>> +++ b/drivers/crypto/ccp/psp-dev.h
>> @@ -32,7 +32,8 @@ union psp_cap_register {
>>           unsigned int sev            :1,
>>                    tee            :1,
>>                    dbc_thru_ext        :1,
>> -                 rsvd1            :4,
>> +                 sfs            :1,
>> +                 rsvd1            :3,
>>                    security_reporting        :1,
>>                    fused_part            :1,
>>                    rsvd2            :1,
>> @@ -68,6 +69,7 @@ struct psp_device {
>>       void *tee_data;
>>       void *platform_access_data;
>>       void *dbc_data;
>> +    void *sfs_data;
>>         union psp_cap_register capability;
>>   };
>> @@ -118,12 +120,16 @@ struct psp_ext_request {
>>    * @PSP_SUB_CMD_DBC_SET_UID:        Set UID for DBC
>>    * @PSP_SUB_CMD_DBC_GET_PARAMETER:    Get parameter from DBC
>>    * @PSP_SUB_CMD_DBC_SET_PARAMETER:    Set parameter for DBC
>> + * @PSP_SUB_CMD_SFS_GET_FW_VERS:    Get firmware versions for ASP and other MP
>> + * @PSP_SUB_CMD_SFS_UPDATE:        Command to load, verify and execute SFS package
>>    */
>>   enum psp_sub_cmd {
>>       PSP_SUB_CMD_DBC_GET_NONCE    = PSP_DYNAMIC_BOOST_GET_NONCE,
>>       PSP_SUB_CMD_DBC_SET_UID        = PSP_DYNAMIC_BOOST_SET_UID,
>>       PSP_SUB_CMD_DBC_GET_PARAMETER    = PSP_DYNAMIC_BOOST_GET_PARAMETER,
>>       PSP_SUB_CMD_DBC_SET_PARAMETER    = PSP_DYNAMIC_BOOST_SET_PARAMETER,
>> +    PSP_SUB_CMD_SFS_GET_FW_VERS    = PSP_SFS_GET_FW_VERSIONS,
>> +    PSP_SUB_CMD_SFS_UPDATE        = PSP_SFS_UPDATE,
>>   };
>>     int psp_extended_mailbox_cmd(struct psp_device *psp, unsigned int timeout_msecs,
>> diff --git a/drivers/crypto/ccp/sfs.c b/drivers/crypto/ccp/sfs.c
>> new file mode 100644
>> index 000000000000..cbca01a884e1
>> --- /dev/null
>> +++ b/drivers/crypto/ccp/sfs.c
>> @@ -0,0 +1,316 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * AMD Secure Processor Seamless Firmware Servicing support.
>> + *
>> + * Copyright (C) 2023-2025 Advanced Micro Devices, Inc.
>> + *
>> + * Author: Ashish Kalra <ashish.kalra@amd.com>
>> + */
>> +
>> +#include <linux/firmware.h>
>> +
>> +#include "sfs.h"
>> +#include "sev-dev.h"
>> +
>> +#define SFS_DEFAULT_TIMEOUT        (10 * MSEC_PER_SEC)
>> +#define SFS_MAX_PAYLOAD_SIZE        (2 * 1024 * 1024)
>> +#define ORDER_2MB 9
>> +
>> +/* SFS Status values */
>> +#define SFS_SUCCESS            0x00
>> +#define SFS_INVALID_TOTAL_SIZE        0x02
>> +#define SFS_INVALID_PKG_SIZE        0x04
>> +#define SFS_DISABLED            0x05
>> +#define SFS_INVALID_CUST_SIGN        0x06
>> +#define SFS_INVALID_AMD_SIGN        0x07
>> +#define SFS_INTERNAL_ERROR        0x08
>> +#define SFS_CUST_SIGN_NOT_ALLOWED    0x09
>> +#define SFS_INVALID_BASE_PATCH_LVL    0x0A
>> +#define SFS_INVALID_CURR_PATCH_LVL    0x0B
>> +#define SFS_INVALID_NEW_PATCH_LVL    0x0C
>> +#define SFS_INVALID_SUBCOMMAND        0x0D
>> +#define SFS_PROTECTION_FAIL        0x0E
>> +#define SFS_BUSY            0x0F
>> +#define SFS_FW_VERSION_MISMATCH    0x10
>> +#define SFS_SYS_VERSION_MISMATCH    0x11
>> +#define SFS_SEV_STILL_INITIALIZED    0x12
>> +
>> +static bool sfs_initialized;
>> +
>> +static int send_sfs_cmd(struct psp_sfs_device *sfs_dev, int msg)
>> +{
>> +    int ret;
>> +
>> +    *sfs_dev->result = 0;
>> +    sfs_dev->command_hdr->ext_req.header.sub_cmd_id = msg;
>> +
>> +    ret = psp_extended_mailbox_cmd(sfs_dev->psp,
>> +                    SFS_DEFAULT_TIMEOUT,
>> +                    (struct psp_ext_request *)sfs_dev->command_hdr);
>> +    if (ret == -EIO) {
>> +        dev_dbg(sfs_dev->dev,
>> +             "msg 0x%x failed with PSP error: 0x%x\n",
>> +             msg, *sfs_dev->result);
>> +        dev_dbg(sfs_dev->dev,
>> +             "msg 0x%x extended status: 0x%x\n",
>> +             msg, *(u32 *)sfs_dev->payload);
>> +    }
>> +
>> +    return ret;
>> +}
>> +
>> +static int send_sfs_get_fw_versions(struct psp_sfs_device *sfs_dev)
>> +{
>> +    int ret;
>> +
>> +    sfs_dev->payload_size = &sfs_dev->command_hdr->ext_req.header.payload_size;
>> +    sfs_dev->result = &sfs_dev->command_hdr->ext_req.header.status;
>> +    sfs_dev->payload = &sfs_dev->command_hdr->ext_req.buf;
>> +    sfs_dev->pkg_hdr = (void *)sfs_dev->command_hdr + PAGE_SIZE;
>> +    sfs_dev->header_size = sizeof(struct psp_ext_req_buffer_hdr);
>> +
>> +    /*
>> +     * SFS_GET_FW_VERSIONS command needs the output buffer to be
>> +     * initialized to 0xC7 in every byte.
>> +     */
>> +    memset(sfs_dev->pkg_hdr, 0xc7, PAGE_SIZE);
>> +    *sfs_dev->payload_size = 2 * PAGE_SIZE;
>> +
>> +    ret = send_sfs_cmd(sfs_dev, PSP_SFS_GET_FW_VERSIONS);
>> +
>> +    return ret;
>> +}
>> +
>> +static int send_sfs_update_package(struct psp_sfs_device *sfs_dev, char *payload_name)
>> +{
>> +    char payload_path[PAYLOAD_NAME_SIZE];
>> +    const struct firmware *firmware;
>> +    unsigned long package_size;
>> +    int ret;
>> +
>> +    sprintf(payload_path, "amd/%s", payload_name);
>> +
>> +    ret = firmware_request_nowarn(&firmware, payload_path, sfs_dev->dev);
>> +    if (ret < 0) {
>> +        dev_warn(sfs_dev->dev, "firmware request fail %d\n", ret);
>> +        return -ENOENT;
>> +    }
>> +
>> +    /* SFS Update Package should be 64KB aligned */
>> +    package_size = ALIGN(firmware->size + PAGE_SIZE, 0x10000U);
>> +
>> +    /*
>> +     * SFS command buffer is a pre-allocated 2MB buffer, fail update package
>> +     * if SFS payload is larger than the pre-allocated command buffer.
>> +     */
>> +    if (package_size > SFS_MAX_PAYLOAD_SIZE) {
>> +        dev_warn(sfs_dev->dev,
>> +             "SFS payload size %ld larger than maximum supported payload size of 2MB\n",
>> +             package_size);
>> +        return -ENOMEM;
>> +    }
>> +
>> +    sfs_dev->payload_size = &sfs_dev->command_hdr->ext_req.header.payload_size;
>> +    sfs_dev->result = &sfs_dev->command_hdr->ext_req.header.status;
>> +    sfs_dev->payload = &sfs_dev->command_hdr->ext_req.buf;
>> +    sfs_dev->pkg_hdr = (void *)sfs_dev->command_hdr + PAGE_SIZE;
>> +    sfs_dev->header_size = sizeof(struct psp_ext_req_buffer_hdr);
>> +
>> +    /*
>> +     * Copy firmware data to a kernel allocated contiguous
>> +     * memory region.
>> +     */
>> +    memcpy(sfs_dev->pkg_hdr, firmware->data, firmware->size);
>> +    *sfs_dev->payload_size = package_size;
>> +
>> +    ret = send_sfs_cmd(sfs_dev, PSP_SFS_UPDATE);
>> +
>> +    release_firmware(firmware);
>> +    return ret;
>> +}
>> +
>> +static long sfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>> +{
>> +    struct psp_device *psp_master = psp_get_master_device();
>> +    void __user *argp = (void __user *)arg;
>> +    char payload_name[PAYLOAD_NAME_SIZE];
>> +    struct psp_sfs_device *sfs_dev;
>> +    int ret;
>> +
>> +    if (!psp_master || !psp_master->sfs_data)
>> +        return -ENODEV;
>> +    sfs_dev = psp_master->sfs_data;
>> +
>> +    if (!sfs_initialized)
>> +        return -EINVAL;
>> +
>> +    mutex_lock(&sfs_dev->ioctl_mutex);
> 
> As it's new code, how about using guard(mutex) instead?  Then you don't need to have goto unlock in the failure cases and can just return the error directly.
> 

Sure, will do that.

Thanks,
Ashish

>> +
>> +    switch (cmd) {
>> +    case SFSIOCFWVERS:
>> +        dev_dbg(sfs_dev->dev, "in SFSIOCFWVERS\n");
>> +
>> +        ret = send_sfs_get_fw_versions(sfs_dev);
>> +        if (ret && ret != -EIO)
>> +            goto unlock;
>> +        /*
>> +         * return SFS status and extended status back to userspace
>> +         * if PSP status indicated command error.
>> +         */
>> +        if (copy_to_user(argp, sfs_dev->pkg_hdr, PAGE_SIZE))
>> +            ret = -EFAULT;
>> +        if (copy_to_user(argp + PAGE_SIZE, sfs_dev->result, sizeof(u32)))
>> +            ret = -EFAULT;
>> +        if (copy_to_user(argp + PAGE_SIZE + sizeof(u32), sfs_dev->payload, sizeof(u32)))
>> +            ret = -EFAULT;
>> +        break;
>> +    case SFSIOCUPDATEPKG:
>> +        dev_dbg(sfs_dev->dev, "in SFSIOCUPDATEPKG\n");
>> +
>> +        if (copy_from_user(payload_name, argp, PAYLOAD_NAME_SIZE)) {
>> +            ret = -EFAULT;
>> +            goto unlock;
>> +        }
>> +
>> +        ret = send_sfs_update_package(sfs_dev, payload_name);
>> +        if (ret && ret != -EIO)
>> +            goto unlock;
>> +        /*
>> +         * return SFS status and extended status back to userspace
>> +         * if PSP status indicated command error.
>> +         */
>> +        if (copy_to_user(argp + PAYLOAD_NAME_SIZE, sfs_dev->result, sizeof(u32)))
>> +            ret = -EFAULT;
>> +        if (copy_to_user(argp + PAYLOAD_NAME_SIZE + sizeof(u32), sfs_dev->payload,
>> +                 sizeof(u32)))
>> +            ret = -EFAULT;
>> +        break;
>> +    default:
>> +        ret = -EINVAL;
>> +    }
>> +
>> +unlock:
>> +    mutex_unlock(&sfs_dev->ioctl_mutex);
>> +
>> +    return ret;
>> +}
>> +
>> +static const struct file_operations sfs_fops = {
>> +    .owner    = THIS_MODULE,
>> +    .unlocked_ioctl = sfs_ioctl,
>> +};
>> +
>> +void sfs_dev_destroy(struct psp_device *psp)
>> +{
>> +    struct psp_sfs_device *sfs_dev = psp->sfs_data;
>> +    int ret;
>> +
>> +    if (!sfs_dev)
>> +        return;
>> +
>> +    /*
>> +     * TODO: free pre-allocated 2MB command buffer,
>> +     * if SEV-SNP is initialized the command buffer has
>> +     * been marked HV_Fixed and HV_Fixed pages remain
>> +     * in that state till system reset, they cannot be
>> +     * released back to the page allocator.
>> +     *
>> +     */
>> +    snp_delete_hypervisor_fixed_pages_list(page_to_pfn(sfs_dev->page) << PAGE_SHIFT);
>> +
>> +    ret = set_memory_wb((unsigned long)page_address(sfs_dev->page), 512);
>> +    if (ret)
>> +        dev_dbg(sfs_dev->dev, "set memory wb failed\n");
>> +
>> +    sfs_initialized = false;
>> +    misc_deregister(&sfs_dev->char_dev);
>> +    mutex_destroy(&sfs_dev->ioctl_mutex);
>> +    psp->sfs_data = NULL;
>> +}
>> +
>> +int sfs_dev_init(struct psp_device *psp)
>> +{
>> +    struct device *dev = psp->dev;
>> +    struct psp_sfs_device *sfs_dev;
>> +    struct page *page;
>> +    u64 cmd_buf_paddr;
>> +    int ret;
>> +
>> +    /*
>> +     * SFS feature support can be detected on multiple devices but the SFS
>> +     * FW commands must be issued on the master. During probe, we do not
>> +     * know the master hence we create /dev/sfs on the first device probe.
>> +     */
>> +    if (sfs_initialized)
>> +        return 0;
>> +
>> +    sfs_dev = devm_kzalloc(dev, sizeof(*sfs_dev), GFP_KERNEL);
>> +    if (!sfs_dev)
>> +        return -ENOMEM;
>> +
>> +    BUILD_BUG_ON(sizeof(struct sfs_command) > PAGE_SIZE);
>> +
>> +    /*
>> +     * Pre-allocate static 2MB command buffer for all SFS commands.
>> +     */
>> +    page = alloc_pages(GFP_KERNEL | __GFP_ZERO, ORDER_2MB);
>> +    if (!page)
>> +        return -ENOMEM;
>> +    sfs_dev->page = page;
>> +    sfs_dev->command_hdr = page_address(page);
>> +    cmd_buf_paddr = page_to_pfn(sfs_dev->page) << PAGE_SHIFT;
>> +
>> +    /*
>> +     * If SEV-SNP is enabled the SFS command buffer needs to
>> +     * transitioned to HV_Fixed page state.
>> +     */
>> +    dev_dbg(sfs_dev->dev, "cmdbuf page pa 0x%llx to be marked as HV_Fixed\n",
>> +        cmd_buf_paddr);
>> +
>> +    ret = snp_insert_hypervisor_fixed_pages_list(cmd_buf_paddr, 512);
>> +    if (ret) {
>> +        dev_dbg(sfs_dev->dev, "cmdbuf page failed insertion in HV-Fixed page list\n");
>> +        goto cleanup_cmd_buf;
>> +    }
>> +
>> +    /*
>> +     * Buffers used for communication with different processors, x86 to ASP
>> +     * in this case must be mapped as non-cacheable.
>> +     */
>> +    ret = set_memory_uc((unsigned long)page_address(page), 512);
>> +    if (ret) {
>> +        dev_dbg(sfs_dev->dev, "set memory uc failed\n");
>> +        goto cleanup_cmd_buf_after_hv_fixed;
>> +    }
>> +
>> +    dev_dbg(sfs_dev->dev, "cmdbuf page va 0x%lx marked as UnCacheable\n",
>> +        (unsigned long)sfs_dev->command_hdr);
>> +
>> +    psp->sfs_data = sfs_dev;
>> +    sfs_dev->dev = dev;
>> +    sfs_dev->psp = psp;
>> +
>> +    dev_dbg(sfs_dev->dev, "seamless firmware serviving support is available\n");
> 
> servicing
> 
>> +
>> +    sfs_dev->char_dev.minor = MISC_DYNAMIC_MINOR;
>> +    sfs_dev->char_dev.name = "sfs";
>> +    sfs_dev->char_dev.fops = &sfs_fops;
>> +    sfs_dev->char_dev.mode = 0600;
>> +    ret = misc_register(&sfs_dev->char_dev);
>> +    if (ret)
>> +        goto cleanup_cmd_buf_after_hv_fixed;
>> +
>> +    mutex_init(&sfs_dev->ioctl_mutex);
>> +    sfs_initialized = true;
>> +
>> +    return 0;
>> +
>> +cleanup_cmd_buf_after_hv_fixed:
>> +    snp_delete_hypervisor_fixed_pages_list(cmd_buf_paddr);
>> +cleanup_cmd_buf:
>> +    __free_pages(page, ORDER_2MB);
>> +    psp->sfs_data = NULL;
>> +    devm_kfree(dev, sfs_dev);
>> +
>> +    return ret;
>> +}
>> diff --git a/drivers/crypto/ccp/sfs.h b/drivers/crypto/ccp/sfs.h
>> new file mode 100644
>> index 000000000000..89b7792af076
>> --- /dev/null
>> +++ b/drivers/crypto/ccp/sfs.h
>> @@ -0,0 +1,53 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * AMD Platform Security Processor (PSP) Seamless Firmware (SFS) Support.
>> + *
>> + * Copyright (C) 2023-2025 Advanced Micro Devices, Inc.
>> + *
>> + * Author: Ashish Kalra <ashish.kalra@amd.com>
>> + */
>> +
>> +#ifndef __SFS_H__
>> +#define __SFS_H__
>> +
>> +#include <uapi/linux/psp-sfs.h>
>> +
>> +#include <linux/device.h>
>> +#include <linux/miscdevice.h>
>> +#include <linux/psp-sev.h>
>> +#include <linux/psp-platform-access.h>
>> +#include <linux/set_memory.h>
>> +
>> +#include <asm/sev.h>
>> +
>> +#include "psp-dev.h"
>> +
>> +struct psp_sfs_device {
>> +    struct device *dev;
>> +    struct psp_device *psp;
>> +
>> +    struct sfs_command *command_hdr;
>> +
>> +    struct mutex ioctl_mutex;
>> +
>> +    struct miscdevice char_dev;
>> +
>> +    struct page *page;
>> +
>> +    /* used to abstract communication path */
>> +    u32    header_size;
>> +    u32    *payload_size;
>> +    u32    *result;
>> +    void    *payload;
>> +    void    *pkg_hdr;
>> +};
>> +
>> +struct sfs_command {
>> +    struct psp_ext_request ext_req;
>> +};
>> +
>> +void sfs_dev_destroy(struct psp_device *psp);
>> +int sfs_dev_init(struct psp_device *psp);
>> +void sfs_pci_init(void);
>> +
>> +#endif /* __SFS_H__ */
>> diff --git a/include/linux/psp-platform-access.h b/include/linux/psp-platform-access.h
>> index 1504fb012c05..540abf7de048 100644
>> --- a/include/linux/psp-platform-access.h
>> +++ b/include/linux/psp-platform-access.h
>> @@ -7,6 +7,8 @@
>>     enum psp_platform_access_msg {
>>       PSP_CMD_NONE            = 0x0,
>> +    PSP_SFS_GET_FW_VERSIONS,
>> +    PSP_SFS_UPDATE,
>>       PSP_CMD_HSTI_QUERY        = 0x14,
>>       PSP_I2C_REQ_BUS_CMD        = 0x64,
>>       PSP_DYNAMIC_BOOST_GET_NONCE,
>> diff --git a/include/uapi/linux/psp-sfs.h b/include/uapi/linux/psp-sfs.h
>> new file mode 100644
>> index 000000000000..e752fa041683
>> --- /dev/null
>> +++ b/include/uapi/linux/psp-sfs.h
>> @@ -0,0 +1,87 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only WITH Linux-syscall-note */
>> +/*
>> + * Userspace interface for AMD Seamless Firmware Servicing (SFS)
>> + *
>> + * Copyright (C) 2023-2025 Advanced Micro Devices, Inc.
>> + *
>> + * Author: Ashish Kalra <ashish.kalra@amd.com>
>> + */
>> +
>> +#ifndef __PSP_SFS_USER_H__
>> +#define __PSP_SFS_USER_H__
>> +
>> +#include <linux/types.h>
>> +
>> +/**
>> + * SFS: AMD Seamless Firmware Support (SFS) interface
>> + */
>> +
>> +#define PAYLOAD_NAME_SIZE        64
>> +#define TEE_EXT_CMD_BUFFER_SIZE    4096
>> +
>> +/**
>> + * struct sfs_user_get_fw_versions - get current level of base firmware (output).
>> + * @blob:                  current level of base firmware for ASP and patch levels (input/output).
>> + * @sfs_status:            32-bit SFS status value (output).
>> + * @sfs_extended_status:   32-bit SFS extended status value (output).
>> + */
>> +struct sfs_user_get_fw_versions {
>> +    __u8    blob[TEE_EXT_CMD_BUFFER_SIZE];
>> +    __u32    sfs_status;
>> +    __u32    sfs_extended_status;
>> +} __packed;
>> +
>> +/**
>> + * struct sfs_user_update_package - update SFS package (input).
>> + * @payload_name:          name of SFS package to load, verify and execute (input).
>> + * @sfs_status:            32-bit SFS status value (output).
>> + * @sfs_extended_status:   32-bit SFS extended status value (output).
>> + */
>> +struct sfs_user_update_package {
>> +    char    payload_name[PAYLOAD_NAME_SIZE];
>> +    __u32    sfs_status;
>> +    __u32    sfs_extended_status;
>> +} __packed;
>> +
>> +/**
>> + * Seamless Firmware Support (SFS) IOC
>> + *
>> + * possible return codes for all SFS IOCTLs:
>> + *  0:          success
>> + *  -EINVAL:    invalid input
>> + *  -E2BIG:     excess data passed
>> + *  -EFAULT:    failed to copy to/from userspace
>> + *  -EBUSY:     mailbox in recovery or in use
>> + *  -ENODEV:    driver not bound with PSP device
>> + *  -EACCES:    request isn't authorized
>> + *  -EINVAL:    invalid parameter
>> + *  -ETIMEDOUT: request timed out
>> + *  -EAGAIN:    invalid request for state machine
>> + *  -ENOENT:    not implemented
>> + *  -ENFILE:    overflow
>> + *  -EPERM:     invalid signature
>> + *  -EIO:       unknown error
>> + */
>> +#define SFS_IOC_TYPE    'S'
>> +
>> +/**
>> + * SFSIOCFWVERS - returns blob containing FW versions
>> + *                ASP provides the current level of Base Firmware for the ASP
>> + *                and the other microprocessors as well as current patch
>> + *                level(s).
>> + */
>> +#define SFSIOCFWVERS    _IOWR(SFS_IOC_TYPE, 0x1, struct sfs_user_get_fw_versions)
>> +
>> +/**
>> + * SFSIOCUPDATEPKG - updates package/payload
>> + *                   ASP loads, verifies and executes the SFS package.
>> + *                   By default, the SFS package/payload is loaded from
>> + *                   /lib/firmware/amd, but alternative firmware loading
>> + *                   path can be specified using kernel parameter
>> + *                   firmware_class.path or the firmware loading path
>> + *                   can be customized using sysfs file:
>> + *                   /sys/module/firmware_class/parameters/path.
>> + */
>> +#define SFSIOCUPDATEPKG    _IOWR(SFS_IOC_TYPE, 0x2, struct sfs_user_update_package)
>> +
>> +#endif /* __PSP_SFS_USER_H__ */
> 

