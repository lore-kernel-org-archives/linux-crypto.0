Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2064.outbound.protection.outlook.com [40.107.236.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CCE1A29A;
	Mon, 14 Apr 2025 17:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744650302; cv=fail; b=G6JxbMJ59pxsasA0a2cNGTbFo/EdgMOGg0+IEh74eRgbrUlHfe9JHYoz4k9AdBHh/x838QBjzt3YwUP5QTKW39YCKA07tm+gFnhANC2x9O0NkKPBIl6si2SAkoPAkyvtro2q0xhinUKPnulQHzRt2TTse9F+acop8VUOV3aMcNI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744650302; c=relaxed/simple;
	bh=rekw+DDwB1K9JmFKLcLp9tXy9FjQ5545i4vThlzCeWI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KA/Qi4qr+5528k+I9jhlfJTpTDRfI9xKb3eftykrhKaXqrLLaoaSuft/4mWCszEQS+pe8Y2zBX8eCcpIahvrjmI8lNPC6KDEcHqtkDtBeMaYN15KAix9xrVXpF3CjfAMDdqJ05bIr8iXCpsqVvBsY7afGA98dMQ0AptnC+MakLA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PWvDz2Ej; arc=fail smtp.client-ip=40.107.236.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PWvDz2Ej"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JuWzgqGYIQdF4uBGYJOQL55Fh/F7H/mgMw5DYOyGHsE74FGxmToQMLyMke/r+D/mw69MbzvNqGSR1T6hkpFPIDlCCXsc8tMTMXULz6UPwftU6JUdiF7IHBzk5aASyz1SIcKrSizlGOpym2lraRRwYwMEeJKqs88xnv8EmvbG8Et+8kUDIM9jkPqE8/A9mei/uF5YqEW2ISw3HqSEujDr8Pxduo6i1sbSSqibC+DLr4Ghfd532GP3yIcGXyO3zvYsCyMdfmXbmvuYiRufJgXLSyQwmnOkgQJt15OiOzBwxEW/IuV4dxWTiAmtqVyVoZ2SH99oy9IjtfsWeH5L6b9w4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VzedopDebu8ArhrRpTNm2FQElnn85NvLxDIo2y8VpZc=;
 b=a0jzDgaJhBbZSvfMbTd/BPFyDfaT16M3MzWZCyKzSWVmk+M9boHmxI7MDB2UhhjkykBDE++jYilsAkO0u7SuRPlX1TZDVibitPnuHFASPQl2hzXOCfBUIs+T5BSLBVNPW9yMpu9OkKjR/oPqwcp0t51m4NJiYPD8QObBdepQs/JNN8M4ol7Sb0+0UZaQqq97X+TWl+gEi6D33anU80XAqpA0+iFmTRx90oliUdZn+IcXHjCJhtHs1hWmcflaeD02hIEueW7FCupgSD9CTdDuGEySfW6Mr6fkCNaqt/Mlj1/hGc1njiGPNWsjjyv1RCoYxmFKwwPNsHYvOkdAvWIUPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VzedopDebu8ArhrRpTNm2FQElnn85NvLxDIo2y8VpZc=;
 b=PWvDz2EjO+N68QwrOOtAn8Gow6jay79fpQxt6+rL9207FXFPgPO+tmgtSfaL4fjh6I+RUKwzhimcs20S+qTUJPr30k0H50ktmMo4hAMubheJ03MFijpdqAP8mhBGeQy8ab/RQeSXEhvejbqcopW/EUJR+/JGIovmP7Xqls1r0ok=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA0PR12MB8862.namprd12.prod.outlook.com (2603:10b6:208:48e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.35; Mon, 14 Apr
 2025 17:04:58 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8632.030; Mon, 14 Apr 2025
 17:04:58 +0000
Message-ID: <edc4c309-6936-c7b5-9050-106220fb3fcb@amd.com>
Date: Mon, 14 Apr 2025 12:04:56 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] crypto: ccp: Fix __sev_snp_shutdown_locked()
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, dan.carpenter@linaro.org,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250409193429.346501-1-Ashish.Kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250409193429.346501-1-Ashish.Kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:806:f2::19) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA0PR12MB8862:EE_
X-MS-Office365-Filtering-Correlation-Id: f4c34e0e-2eef-4199-a014-08dd7b767c85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cUVUd1FVZTdhQlpMa0MvVFFrWW81L1A1dTBoZFdRaDZDcjE3c2NNd25MY2RV?=
 =?utf-8?B?QWh6eVJaM1hMd0hwbFZUTXhRanNYNjhldVBJVHNnblZRNTd2MlRaR2F5TlFQ?=
 =?utf-8?B?a3FRMk1TaEVYUGRwckpkNjdqa0YxdmxpNmZ5dUV4V0MrQ0JHSlN3cThZRlJY?=
 =?utf-8?B?VUdRRk8vK3NtTGZaOHpaMXcvU3dZM0hCWU4xVkV6NzlyZ0RpYW9EWVg0N2kw?=
 =?utf-8?B?UW5iaE81Z1Mzc1pvbUwyaGNkRVV6bTJtc3Z4WEZuN0l2YkRKbkRMOWREV1JY?=
 =?utf-8?B?Q1Q5M0dBWVNEQlcvM0c2SStjUGN6MDRSTzF4Kzc0bHRMb2RlQ3NDUXptRlRS?=
 =?utf-8?B?Mk9SWDNadENrbzBPN1Q3NHRSeW1wdmNndFNrRHZjOENTV2xzUGpTcFc5NXps?=
 =?utf-8?B?czVDWjJvWEVjcW1yOC83ZE8rbWs2cWlHSXBVemJ4aFdFTUlxQ3ZEN2lkOW8x?=
 =?utf-8?B?TzVEbkJtczR0Z2NjNXRvUzYzdlhId3cremVSUlZ6WUNSY3BRQ0EyU0JNUFor?=
 =?utf-8?B?Nkx2eUpKeE9IR1JkVFlLa1RLRFNvWmZVWTNWanlLTnNEb1ltb0J3bndrRGdX?=
 =?utf-8?B?TTd3U25EdDBMeVVYUEgxOWw2MnQyMmtSeXNLaXB5TFdPUnh1MFFHTHBqdEdX?=
 =?utf-8?B?M2NlSkNIdGFVMllwSHZQNWlldjNIZTNpZWRsR0FxdEttaWpZdlZpUHc3RnU2?=
 =?utf-8?B?VnMrRlpQRXNzT0MrazRqc3ZxckIrSURNanBQcFR1QTZBS3Y0MWN4c25PL0Vx?=
 =?utf-8?B?WWJOWDlmZTM5SnV0Z2dJbDR6b3dJeC81RlRsdTMvWWNUb1VUb3VMeXM3Ukc2?=
 =?utf-8?B?RXRtdk9zVm5ReVNZeVdXeklveU83N2JvTXZWZFBOK3VFajhRSDcxMlI3UUpL?=
 =?utf-8?B?MmovSlhSY1RjZ0MxczA2STNHMDN6UUNkMmhVVjZENHdBQXBsMk9TdDVCZU0v?=
 =?utf-8?B?eWxXYndZUUcvaExxb0RHdHZ3SWFGMTljTWlNM2xyR3lmTHlIWXR2WUFqTi95?=
 =?utf-8?B?bzlqNU5PRkRCdFFWZ3d4Q3l2YXRKR3BLSjN3TjVCL3owd1lDM0U0enBlVE9T?=
 =?utf-8?B?N0hEVVk3VUxrM0dKYXVldnpMZjhnbmNVaVlKNTVTM3Fzay91N01OWVo5ejZ6?=
 =?utf-8?B?WEtIN243U3Mva0VkTjNuSXphTGZhN1hrRUllOVdlT3o2UlNlckx1YTl4UUVW?=
 =?utf-8?B?dytFS2xPWUlTNzZUQzJqdjNpT0xOSzcxY0xGbFdFZkZ4UmdrRklSUmtLU3FI?=
 =?utf-8?B?bFR3bEV0bUpxOGZHc0cvcXNlZENmMUdJY3dMbkZkUXEvN2NxSFRJYVZvRU1C?=
 =?utf-8?B?UGVOQ09OeGl2MHp1YVZRdDlzT3M4ZlFvcFREdWY5RG1QdUdlaVZZTmxtTWNH?=
 =?utf-8?B?WmgzU203bXhna0NuSlNpYk5zNm9FeWJMVFJwbnBKcEtUWXRjSVlRbFhwSW42?=
 =?utf-8?B?WDlpendsMFlsQVVlMkFubUlZU256QVllZVZ0cE1wenAweC9jS2hIT0wwUzhm?=
 =?utf-8?B?Z2E1dTdERTZVWml4NWFKckNzUmtYT2FIdURzdTBMZGdBV0NSaXdZMDg4V1d5?=
 =?utf-8?B?ZUZxNEFUN2dGMkJlNXdKb092dGFQdGJjNXZGYXl0WUZEdWNoZVlManVMRFly?=
 =?utf-8?B?ZHoxUHBrVSs5WmRERVVyc0hGS2F2OEwra3AzN1hDb1pMZE4yR09WVUtXM0Vq?=
 =?utf-8?B?aW9QcEd1TGRZek9FZHc4cWF5eUExV25Da2ZycmlzTFhJc1gvQjRMdHJ1T3lE?=
 =?utf-8?B?Nk1MN3E2WWdiVndVYyt2OUtoMlBmQWdhYkZzYXJaRVgwcFVWOHpWOWw5enZY?=
 =?utf-8?B?UnhSc2grc2cvTHdoeGJDa3pxV0hTNmVpOUE5ZjlHMmVDN3J4Zk13Y2MweXMy?=
 =?utf-8?B?akFaV3pCTmt5aXd6ZkJDSVpQT0dxQ0ZzLzh6WjZyRjFLcTYxVjE4SEVZYkJl?=
 =?utf-8?Q?ENZq7QHMWRc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dkZtQWc2Z0RmNU16ejE0RDBlN2FTMUFzK3hiN0tHSnZ1VlR3a0s4T2lWeVk2?=
 =?utf-8?B?MVJBVDJ3QW1pdWpVMTZBZ0RURFBDYTNGU3ExbHJmREZjM3JYd0kwb09ucXV0?=
 =?utf-8?B?QWlXSzMydEdBdEpLOW5pOU1qQUJ5UUJTZlgzQm02UGJGZUNyZ1RoYWxQOWpY?=
 =?utf-8?B?UDl0M1ROZWNqNWprQVd5cjRZU08rL1hXcjFYNkZDMVNYeDhtRmQ1Tmc3S2ZC?=
 =?utf-8?B?S2UrZHVtczlVSWoxdGphbnZCRTVHSGNhaVV2aHZINkhTQmtXOHJJWmd5eDI1?=
 =?utf-8?B?dHNESFJkWE9MdlUzTDRIVmJpODRNV2gvS0svRlNGVUhuK2UrNHBrTHNTVU5p?=
 =?utf-8?B?RnpObDE0dTg1WDVmeWtuQ2hFbzFvZWNrVitCS004SjY2THpxYUlYWUlnVzVO?=
 =?utf-8?B?ZVpsUHdYYjM3RFFMbllZTGlvTWcwa1lxcDRna3o1bnRHMGQ3Qkc4NHpmcnBh?=
 =?utf-8?B?M2tvVWEyb3phVUprRThYalo4ZDllVkdhS1BZVEwzVUpLNGFMQUFJN0JPQmhF?=
 =?utf-8?B?U3o4U0ZLV3E2ZWY1Wmx2bG9ISkh3Nkw4aEc4c00zYXRKdnQxNXBIQlp2TE1G?=
 =?utf-8?B?S0pPZzhqY0xmTXpZdkExUUxjSXJUL3RWTWhod2FhRXpXaWdkMGgxSGoxVUl0?=
 =?utf-8?B?NkxLS3pXYktIQVJyK1NvZCtIeGNGNW1jeUg3ejFtR2MxaFVVMTRrd1NXMU5q?=
 =?utf-8?B?cjhveVdpK0haRDRpL2RGSTF5R21sSFJsbWFZUWdqYi9NekdLakxUc0cwRXZs?=
 =?utf-8?B?YThUUjhJS25DTnB2MUpMYisrNVpxUnpkbXd0ZC9JY0pwWHYyU0FuL2p3cHlB?=
 =?utf-8?B?SFBHTWZtdmR4OXVqNUZkMUJDT2g1NFdwdVVJcko3aFVHVVlEZzlVZWdtK1Y3?=
 =?utf-8?B?TGtUMmR3a3R5djdybzlFL2J1ZDJGQnl5QnVJSzJsZVdVNHA5cWJnRFEzQ1pB?=
 =?utf-8?B?dDhBbkpYUng1azFiY3IzWmttTmNSNEdESCtYaXY2N00ybWNSR3RuUk0ycVpE?=
 =?utf-8?B?RzIwN2FvVUt4YXE5c3FSNDlrQTVLWFhyRkJZak96eG0xWHNkUjdxb2tpUzg0?=
 =?utf-8?B?eWxOckt6SXZGaE5MRUVnell1bnFBS3RidEJmWGQzdlJtRmlxMld4bHZNbnlv?=
 =?utf-8?B?djhSb0VOYUtNeUppdXk2aGJlRWNlRGFWcm5PeE1oN0x1bE1UbUx5dDYzVWRo?=
 =?utf-8?B?cUJJeTVGcnhDbk11WGd4MVZoSGJ2QkdETEMzaXlXelgxTUhFU3g1VG9mVUlU?=
 =?utf-8?B?NkpyNTZOMFhqUGx1cEpYNXVkV3gyZGMzQTFJSUJkRDZtMXF5RnlrTGV0aVpT?=
 =?utf-8?B?T1VsVFYyVUpmU1lObmxDNXBiRkY5bUs0UmRraFo5eEtaMnNKNjdVWEd4RWdw?=
 =?utf-8?B?ckdaWmxFQ3V5ZUlkZWYzWVh5ZXdDWWtoek1pYzhqWFlmRFoxRjI5dDFlT3E2?=
 =?utf-8?B?UnZzNjFCOWxUbVErdVVxZkJOTGh3eFNvSXNNK1hLbGRyK3VQc3JZODdKZjVz?=
 =?utf-8?B?QWlNUkcxcEpTS0pRVHdFeFMwcG1mRWw4b3IyckpEVzRuM0VzcDlUTEFRSTVX?=
 =?utf-8?B?b2tqVURqSUlPdG9Rbk56cXVFa1NLU25Ta1NOUnc4aG5pdnkrWEJUR2pkWHZp?=
 =?utf-8?B?dGNpbjJWNkZ6K2tZelJwV0hxK1YzMTd3OWtNV0VwL1NzUGRCTnRISXlZUU00?=
 =?utf-8?B?aDBFUVE2eWRlTmttUlJjTng0L0w3MHRlSWd6LzBHWk1TZnBPbXVGU3F2bTMv?=
 =?utf-8?B?VWl4SUZnTVpHMEdHVkk0SU5UWE54YjArZTNYSnFsZmZPRkdJZmNaTmg3ZVU2?=
 =?utf-8?B?TXdxV2I0THAxNmY0RlJJNElFellGZGxOU0xkMnNvZVJQZXk1T0JFT0J6bCsr?=
 =?utf-8?B?Q3lCZk8yeFltUERBVlZDYmF1V2RUL1pFTTgzR1hPWGRscWp1WGVySmNxajNQ?=
 =?utf-8?B?L0swek1hUmlURUNFcEVwSkVRUW96aWVmejF3Wk8zYitsVXVvZE5lcEYra294?=
 =?utf-8?B?T09rSmdvQXRWcDFUOFVIMFdrUEt6ZkVDdU1KbThOMDBOMFdRQ2J5bktCUzh3?=
 =?utf-8?B?eGhSQys5aFlHS3dyY1dHSE1zLzg0UjVFblRMWXRNeGVYUm50TWtEeFVUVXZ6?=
 =?utf-8?Q?fB756S/piqBdstm9E5MW0N/EL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4c34e0e-2eef-4199-a014-08dd7b767c85
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2025 17:04:58.4053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VAyIIKUQtIKKJjliMzgvl1142svDd6vj7/vpVKcnWBtgZ9aLQAy+cqbU7VvkNw6J7w/WL/BfdC/pzduuw1pVXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8862

On 4/9/25 14:34, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Fix smatch warning:
> 	drivers/crypto/ccp/sev-dev.c:1755 __sev_snp_shutdown_locked()
> 	error: uninitialized symbol 'dfflush_error'.
> 
> Fixes: 9770b428b1a2 ("crypto: ccp - Move dev_info/err messages for SEV/SNP init and shutdown")
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Closes: https://lore.kernel.org/linux-crypto/d9c2e79c-e26e-47b7-8243-ff6e7b101ec3@stanley.mountain/
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 19fb51558a7d..1ccff5e3f4bc 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1744,7 +1744,7 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
>  	ret = __sev_do_cmd_locked(SEV_CMD_SNP_SHUTDOWN_EX, &data, error);
>  	/* SHUTDOWN may require DF_FLUSH */
>  	if (*error == SEV_RET_DFFLUSH_REQUIRED) {
> -		int dfflush_error;
> +		int dfflush_error = SEV_RET_NO_FW_CALL;
>  
>  		ret = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, &dfflush_error);
>  		if (ret) {
