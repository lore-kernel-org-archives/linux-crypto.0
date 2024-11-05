Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A418F1F8EE4;
	Tue,  5 Nov 2024 22:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730846863; cv=fail; b=Efg62vyFjl8CvMKUiibkZ6w9VGh4TUYlLMYu8sY6k+02MKIF5zdwBJsCOi9sfEjOH+kGZFchqBZ8scAWnuKLTmaVhVbdECd4NH6O+OcFl7Yk8Y3AVHFqdGvZTzkMtcz4pMTwPJbXiiwIwmz26Q/xh1Ky5n1bAGOz1j/Zr54cGic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730846863; c=relaxed/simple;
	bh=S1jNbDOW4gXi9HCnRP3xl22VbzW8evHL2Tx6jwfvqjg=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=dmIhS74J3+c4JbcPHhP+qdA9dT8WJ8HWgk0XKSh91qoUBYoCLI/4fP8AESG8/zsZnlZNtHWCNzmN9NX/XvMq/17UZnufw3QKNT/dLSWlDuk9wc28ojaxu7sRn6h/w+Uw32V+YkcoKvslu2uoofd4HyTa4Yxs/hRJbpztTR3XvFk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Uar12/RL; arc=fail smtp.client-ip=40.107.243.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Uar12/RL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yOhyCcRG9SefaZkGrR7WkcYbQl0vyHWCq2XKzsXBhHmqXaR75ha5Oy5jHgSyh68NPTWExf0zdrpbYm4TK4g5JYplRoqZ7cw95f+SbV3c1jHMFHxVITbDX1ElgUiAVfXShdohfyxs0vpfHzGw7gN1ggL3+iP0vo0nnVmfR7pxbgvCTcozqSIpZNh8uLBDiktOemttHzPw6KDU6dyZVd4GA9nR0qhExnHrXTpkCD3W3LEvQ1F5rbJJD9nWofKvEJ/a/AB+/T5cq4vuVWXPqSkvUImU+O8MgkYL7oit2jwnl1bdI6JVXqOBVM9pzJo48C/XyrgR/V27W2nwG1TyLcqpFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oTKCy9b3A331TwJSIygkv+SyH5U/6LxxN7dn4BK9MTc=;
 b=YUfPm7l5obGf51GOy4hSl2BNXu2hgpk0XyjUTHskzdsl/lQmZZuf8gtvejRZrB2uM2x4dEzzFD8O7fme27+Qo6bH7LNsG9mOzB54I2nrt9jU8xp+ALfLxWzmM+tS6KuzAhSd43b06cWE5UAlG2hnhYE80Gfyb9P0gixtgm18U3g0wMgk45ErRq//AjqL2SfnDm6mIL6h35Ro/epo96TZ+h9ADI94KG7+T+SFsrTdO1cLAY3ib178T8/kfTP5dkXaGhxTKO0c2QkV+a6tW+8WUy0c+mvYpoWJhuuOpmr87qxQgmMqrLC7Ct2gBvw3e0as+OFFLx/LJjVJ5byeNHFQWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oTKCy9b3A331TwJSIygkv+SyH5U/6LxxN7dn4BK9MTc=;
 b=Uar12/RLJrvufWPMWOPsVmduJZdeLIbLXmumPFARBoceuRdfF7+iLiijEBeSQRHcQgWHMIhq3m0/T5Ih7ki+LBEdkdu5i2eKtX0kC+IHpS+QNi6uYc4J4T4ywzr2Q6UU+yr0iPWVIU2LE343TVIseYA2ZF5P3Oez0udJSRoYyzg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6)
 by DM6PR12MB4172.namprd12.prod.outlook.com (2603:10b6:5:212::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31; Tue, 5 Nov
 2024 22:47:36 +0000
Received: from BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a]) by BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a%6]) with mapi id 15.20.8137.018; Tue, 5 Nov 2024
 22:47:36 +0000
Message-ID: <6b9a314b-1051-748d-1624-b76cc50a83c6@amd.com>
Date: Tue, 5 Nov 2024 16:47:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Dionna Glaze <dionnaglaze@google.com>, x86@kernel.org,
 linux-kernel@vger.kernel.org, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Ashish Kalra <ashish.kalra@amd.com>
Cc: linux-crypto@vger.kernel.org
References: <20241105010558.1266699-1-dionnaglaze@google.com>
 <20241105010558.1266699-6-dionnaglaze@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v4 5/6] crypto: ccp: Use firmware_upload API for SNP
 firmware
In-Reply-To: <20241105010558.1266699-6-dionnaglaze@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR01CA0026.prod.exchangelabs.com (2603:10b6:805:b6::39)
 To BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5062:EE_|DM6PR12MB4172:EE_
X-MS-Office365-Filtering-Correlation-Id: c175b2cc-8b05-4088-4fd7-08dcfdebd802
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RStRZkFmbDZKSUFzM1JmYUR6ZjRkOUV1N2ZvQTl2Wmd2VTM0VnBydi9EVUhm?=
 =?utf-8?B?U1BmN1pjeUlBU0VvcXBpNDBIZUFURUhKTEdUaXhiNmVPMmQ3RXY1anJHZWVk?=
 =?utf-8?B?ZmhISW5IUVF3Y291QU5kbWF6OUVVS0xIMDNNRzFibnNTMDcrV3VrNkN0MXVJ?=
 =?utf-8?B?dnh1SnhxU2FHV0pERkFlNWJ6VHUyWFJ1c0FIdG9xQk5xS2VVaDBsREhDd1BE?=
 =?utf-8?B?ek5sV0xrbS9Fei9iS2RtS3RjOGZPdEJlMW9OeXdsMVBjQ2xkUXV4blprQUpF?=
 =?utf-8?B?SlJNM1VhWlpvUDJXY2lCc1FkMFcwV0puRmtIbVVxajBweGwzb0UxbmF2Q0pC?=
 =?utf-8?B?Ym5YQXh6RTdNczIrbmtwNDNkZkYzT0hGT0FZNTd2ZkVxWnB3Vis4K3pSYWxR?=
 =?utf-8?B?SDhtRldIbHJuWWRnZzk3OWZGdkpWT1lGY2x6OERMOXpUUlhiaEJGK0ZyRE9V?=
 =?utf-8?B?VUEyMlRyS2ZFRzdnQ0dsM0w1b2Q0V3hNa1I2NVFzcFZIT1g1bUJ2L3F6ZDV1?=
 =?utf-8?B?MGRkNDVKZldwa1VIMlBFaXc0K3JsODU3TEg5Z1RHSk5iQW9NUE9mZmN0clVa?=
 =?utf-8?B?UEpKNllsMFlXWnNyTTA2ZnFHRmZrNHU3UlhRMUV6MWNldUM0RGpKRnV3TU1v?=
 =?utf-8?B?Mmx2dXBuZ2xRaGtVUkk0eWc4K040QjM5TTVMOTlwV3pEZGZDdHAvVU13N1Bp?=
 =?utf-8?B?NWNqT1FlM0tHYU40NWxENjJFL0ludjQ4Y2w3Tkc1cVowc2o2bHo5RWlrcFQ5?=
 =?utf-8?B?QnJydDFPY25QUWd3RGtYeGJpN1ZuNFVUUXVuR2xadllZYU9rSmZNZkVBOE1j?=
 =?utf-8?B?dm5adnRFVW5HT2EyOGFpQUV4NmxjeGRqQkVFaUZpVkNKUW9xRkJGcFA0Rk51?=
 =?utf-8?B?eE8vYlJjN3ZXYXIyRUlCU0tjcktjUkpjbVVFM2wzVHB6cjAzKzRxUEtVQ1pK?=
 =?utf-8?B?KzB1REczRTFTYWJ2enZlaFFCc3N2UEE2VTJRNzF3TiszVTJBTkJLWGIyYk4x?=
 =?utf-8?B?OU5Ua0ZTcTlCeUFmaHZmZzlta2psOVYzK3hHYWIyeTFvTVFucHlpQ3VWRUJq?=
 =?utf-8?B?RFQySWFGckhSd0w5VU1EdHVsSktKT1FaTHVTL0hMNnBhUEFDUWE5NWtaYWVx?=
 =?utf-8?B?YUcraFd2M1pMOGorZ3dMTkM0WmJqREF3ZFA3VWIzL0lIbU9FTG5uNzR1bldr?=
 =?utf-8?B?RkJURW9STEZHdEFoeXVtLzBUd0pvWnhoTlIvUm9xVVpBOWorVHo2Q3cvRHBG?=
 =?utf-8?B?aU82Q3NDcGNYdnNmNGh4Qm9VTEtwTmdXbXl6OVJuYndlc0JIRDhLbFhiZ2Jw?=
 =?utf-8?B?c0JzZGkwUDBndG4wK1JBNFNmTmdIb2kySXJjN2V2Qkw5WHdCWVNBUG5EYUx6?=
 =?utf-8?B?U2ZXL2VCS0JCWlVVL3A3U1oyZ2I0VWd5OE5lWDBKUzFDVy9CWm9mZVpEZmV4?=
 =?utf-8?B?RFYxemdHcDVFREVsMUhiU1YrTUE4MGJGL3lJRC9ZOEk1WnJBL1lzeUliTVp1?=
 =?utf-8?B?RUhhUjR4bUpwSmlXS1pqRXNWSWNocGJTd1dhaiszeGpoS0doN3hSclNTa2pD?=
 =?utf-8?B?d0RNUXhxV2NjcitXcEZFQ0Z2ckFjb2s5S0kyUTNtSVU4a3BRUVJzZE1TeVVN?=
 =?utf-8?B?OXhuK1l0bEFINWk1WWJhYkNiNGJTcG9qa1E1dFdHNjNsM2FGTzBQUUhqWjZV?=
 =?utf-8?B?TFcyNm4xTUhjdkVFSy9oWm5iWFJkakxQQ1BOM1BRVTVadmdGM3RrbDBIMVgr?=
 =?utf-8?Q?/VvTT4GK/wEpg6LpPa4NhY2YZAo4dWTUfJ2slIZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5062.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d3NIeUVhZnIrQTRRR29COXJXRnFTbjEzVWRaSWJzNTlqb3hwb1JuZUZYRTZj?=
 =?utf-8?B?V0J2ekhOb2psd0pJTU9HelptVTRoTytDc2p2L1lnN0JhZldrU2Z5M0I4MTVH?=
 =?utf-8?B?R1JEYmdqaTJpeEJKd09Zd2pXbERSaWVSWUNuZnptWDBTYm82T2x5blVRQyth?=
 =?utf-8?B?K0JoS2pEazFvczF3TlZtZzkwWDhVN2NWendaY1pKTTNVZXZST254WWxWcVdX?=
 =?utf-8?B?MUt0NTRnM1hRcFNOQzA3Z1JGQnYyUVNVekVsUndzcmFSdTN2dnJ0M2xjaDFj?=
 =?utf-8?B?c1NuSTBwRlNza1hnOWZnLzZLcTNaWHpvWTJtRkQvckd2Y0MzN21tYU5oVVk4?=
 =?utf-8?B?TjMxUjFZQVU2M2pZTHc2VzEyM0VVaTg4UmtJVE5zcUJ5Uyt4cWlwb0dWbmVO?=
 =?utf-8?B?dlpyK0ZUWjhUR1NhaVZUTEhTRXIrajRoNThKWGg0Zm9aV0RGRVExSGlZaytZ?=
 =?utf-8?B?c0VFblRKYjBYM3dGUk1sUkc1WjUyUUJ1WnY0b2ZoRmgrQ0FEeE9tOTlHU1JD?=
 =?utf-8?B?OHk2aXRLZFNQT0RyelJtYmNaZHR4Ui9Cb0k4b1NNNTdyb0F4djg5bkZkV29v?=
 =?utf-8?B?VVdXUTR6VXB5SWM3QS9hN3hXaFljRWgxSGRLdlVRbWRqQU4xZDBxTDdsZjFl?=
 =?utf-8?B?Q0psempxTCtSZXZrZnVxUUFxbVFGZE5UbUgrL0FTRzdEM29keTlIbmZQVHYy?=
 =?utf-8?B?R21RQkZ6MXpxZ1RueXllcE4wbDJDZEErNkxEOE5UdVhiYXFaa3V0aFczdHRH?=
 =?utf-8?B?TGF4ZElyTmRZUTh1U2J1VnFFVEs4Zm16cXZNb3FNUGQzZlBXWUpPQUNoZkhk?=
 =?utf-8?B?VWJmdmRvSU5TYk95ZE5mcXRZMUdSeVB1ZDdIMnpJcm1qZURtemhWZXVjL3R6?=
 =?utf-8?B?M1I1bVVwRTBHNmZkTkY0OFJ4QkNkdmNzenJ1SVZuQlkzM0JUa2NtZDRMc0cv?=
 =?utf-8?B?b1M2SlN4SjIyWkRma1RLdyttaUNndi8raVpDZ0xmTEkxbTNrU1lVT0RYVHlL?=
 =?utf-8?B?U0IwakNjdmxIWk0wWHBTMklCNlY3NVpPSzFqbFlnMUZ5bVNucVhtVVdPVDdW?=
 =?utf-8?B?V1ZjQU5qbGZrR0VVUHowQWN1NVBVZ3dZeXFTc3lESWFnWjMvalRvQ1FpdVBL?=
 =?utf-8?B?cjVOSC9jc1RqUGJwMzlwYU1OMDJudEs4UkRtVlFiT1ExQk82dEdlR0J5SVVt?=
 =?utf-8?B?b2wwQzdBb2hoQjlhY0orRWg5ZDdhN0ZTdXh4M0FZZi95cjI3NktPSWlHaWRk?=
 =?utf-8?B?SExjbVhhdVZjV05JSnp3dytiQThGMkNLUTZhT05iNldSODNRWFBYK2J0Y1hr?=
 =?utf-8?B?QTRIOXptSzcvNEJsTnh5bjVHa2loY0E0aW5aZ1lFd201cHdUc3BlNkR5ZGpl?=
 =?utf-8?B?L282c3A0NDVtdVVQbHk1dktEN3ZYZldaaTlCUjNvM2llaGhJN0JJVkVzLy9J?=
 =?utf-8?B?Ty9oRTdFV0ZMb3g1N0lLNWMrSDFWVC9oc2xqUUp6bk5tUTc3UHpZMnluUFRr?=
 =?utf-8?B?S0ZQVmdxRDd3akVvelJoRk82YlpLeTdBcHZHcDBxVFNaOGtUTG1uK1NVWDBF?=
 =?utf-8?B?bTRIWlBoNlUvUlRSdmdvSlpGVFB0aHVLNDA5VVF2NnRTYlBYbTh4TzdzWnRi?=
 =?utf-8?B?ZHNMMUJTY3U4WThXek1ZV3YwSUdCY1BFeGk1di96dkx6czJHcnQ1dWZhOXhD?=
 =?utf-8?B?Uis1SWtTeHE2V2F5aC9mdUdWUkNFWFdSdTU3NHArWk0zYStVUHBwamxNV1Jw?=
 =?utf-8?B?akFsK0lCdDQxOXhMdHlyVTBCNGVPcjlmc202dXZkUWFSUDloM3kxZ1N1YWhC?=
 =?utf-8?B?WGhTNlpjVndLNCtSM0QrbUtuc3dQdlkxK25ab0d0T1IxSFVTSmdFYzNzRXZE?=
 =?utf-8?B?NU9ZcWxDYnhuSzh3MjNTZ1VTTnNsUDBuRE5aM0VtM25RYThvcVZ5R0lvQi9v?=
 =?utf-8?B?YnoveHRWNWY1dy90YUxTZWRlK3RmcXVwSlprQStQRXk2OXkwYzJETHdQZ0RW?=
 =?utf-8?B?WWlWMG9WOFl5ZVZ0OHlnOXNNMkV0VGZJMlJqVjhhcWNJNGpKT000NXRtRGMv?=
 =?utf-8?B?U0szT1FSNWkwS3h1WFVkRGwwcDJkVEMxNGZLVFVBc21MZE5jZkhqclphSGI0?=
 =?utf-8?Q?3vHMWnTrRVM1TSQtSB+EJs2sl?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c175b2cc-8b05-4088-4fd7-08dcfdebd802
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5062.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 22:47:36.5328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X0mxStoIjEfPcC4u4w+wcXhm62xmBo/BPEPg3Fsf5KpqCiFRprNYA+v6J+Sx17DrBffxqedhgeaB3oxHtCjNkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4172

On 11/4/24 19:05, Dionna Glaze wrote:
> On init, the ccp device will make /sys/class/firmware/amd/loading etc
> firmware upload API attributes available to late-load a SEV-SNP firmware
> binary.
> 
> The firmware upload api errors reported are actionable in the following
> ways:
> * FW_UPLOAD_ERR_HW_ERROR: the machine is in an unstable state and must
>   be reset.
> * FW_UPLOAD_ERR_RW_ERROR: the firmware update went bad but can be
>   recovered by hotloading the previous firmware version.
>   Also used in the case that the kernel used the API wrong (bug).
> * FW_UPLOAD_ERR_FW_INVALID: user error with the data provided, but no
>   instability is expected and no recovery actions are needed.
> * FW_UPLOAD_ERR_BUSY: upload attempted at a bad time either due to
>   overload or the machine is in the wrong platform state.
> 
> synthetic_restore_required:
> Instead of tracking the status of whether an individual GCTX is safe for
> use in a firmware command, force all following commands to fail with an
> error that is indicative of needing a firmware rollback.
> 
> To test:
> 1. Build the kernel enabling SEV-SNP as normal and add CONFIG_FW_UPLOAD=y.
> 2. Add the following to your kernel_cmdline: ccp.psp_init_on_probe=0.
> 3.Get an AMD SEV-SNP firmware sbin appropriate to your Epyc chip model at
> https://www.amd.com/en/developer/sev.html and extract to get a .sbin
> file.
> 4. Run the following with your sbinfile in FW:
> 
> echo 1 > /sys/class/firmware/snp_dlfw_ex/loading
> cat "${FW?}" > /sys/class/firmware/snp_dlfw_ex/data
> echo 0 > /sys/class/firmware/snp_dlfw_ex/loading
> 
> 5. Verify the firmware update message in dmesg.
> 
> Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Tested-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
> ---
>  drivers/crypto/ccp/Kconfig   |   2 +
>  drivers/crypto/ccp/sev-dev.c |  12 +-
>  drivers/crypto/ccp/sev-dev.h |  16 +++
>  drivers/crypto/ccp/sev-fw.c  | 213 +++++++++++++++++++++++++++++++++++
>  4 files changed, 241 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
> index f394e45e11ab4..520b1c84d11f4 100644
> --- a/drivers/crypto/ccp/Kconfig
> +++ b/drivers/crypto/ccp/Kconfig
> @@ -39,6 +39,8 @@ config CRYPTO_DEV_SP_PSP
>  	bool "Platform Security Processor (PSP) device"
>  	default y
>  	depends on CRYPTO_DEV_CCP_DD && X86_64 && AMD_IOMMU
> +	select FW_LOADER
> +	select FW_UPLOAD
>  	help
>  	 Provide support for the AMD Platform Security Processor (PSP).
>  	 The PSP is a dedicated processor that provides support for key
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 32f7b6147905e..8c73f023b6420 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -485,7 +485,7 @@ void snp_free_firmware_page(void *addr)
>  }
>  EXPORT_SYMBOL_GPL(snp_free_firmware_page);
>  
> -static void *sev_fw_alloc(unsigned long len)
> +void *sev_fw_alloc(unsigned long len)
>  {
>  	struct page *page;
>  
> @@ -853,6 +853,10 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>  	if (WARN_ON_ONCE(!data != !buf_len))
>  		return -EINVAL;
>  
> +	ret = sev_snp_synthetic_error(sev, psp_ret);

A comment similar to what you have in the commit log would be nice above
this call.

> +	if (ret)
> +		return ret;
> +
>  	/*
>  	 * Copy the incoming data to driver's scratch buffer as __pa() will not
>  	 * work for some memory, e.g. vmalloc'd addresses, and @data may not be
> @@ -1523,7 +1527,7 @@ void *psp_copy_user_blob(u64 uaddr, u32 len)
>  }
>  EXPORT_SYMBOL_GPL(psp_copy_user_blob);
>  
> -static int sev_get_api_version(void)
> +int sev_get_api_version(void)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
>  	struct sev_user_data_status status;
> @@ -2320,6 +2324,8 @@ int sev_dev_init(struct psp_device *psp)
>  	if (ret)
>  		goto e_irq;
>  
> +	sev_snp_dev_init_firmware_upload(sev);
> +
>  	dev_notice(dev, "sev enabled\n");
>  
>  	return 0;
> @@ -2398,6 +2404,8 @@ void sev_dev_destroy(struct psp_device *psp)
>  		kref_put(&misc_dev->refcount, sev_exit);
>  
>  	psp_clear_sev_irq_handler(psp);
> +
> +	sev_snp_dev_init_firmware_upload(sev);

Shouldn't this be the destroy call?

>  }
>  
>  static int snp_shutdown_on_panic(struct notifier_block *nb,
> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
> index 28add34484ed1..52a423e7df84f 100644
> --- a/drivers/crypto/ccp/sev-dev.h
> +++ b/drivers/crypto/ccp/sev-dev.h
> @@ -59,7 +59,13 @@ struct sev_device {
>  	bool snp_initialized;
>  
>  #ifdef CONFIG_FW_UPLOAD
> +	/* Lock to protect fw_cancel */
> +	struct mutex fw_lock;
> +	struct fw_upload *fwl;
> +	bool fw_cancel;
> +
>  	u32 last_snp_asid;
> +	bool synthetic_restore_required;
>  	u64 *snp_asid_to_gctx_pages_map;
>  	u64 *snp_unbound_gctx_pages;
>  	u32 snp_unbound_gctx_end;
> @@ -72,12 +78,22 @@ void sev_dev_destroy(struct psp_device *psp);
>  void sev_pci_init(void);
>  void sev_pci_exit(void);
>  
> +void *sev_fw_alloc(unsigned long len);
> +int sev_get_api_version(void);
> +int sev_snp_download_firmware_ex(struct sev_device *sev, const u8 *data, u32 size, int *error);
> +
>  #ifdef CONFIG_FW_UPLOAD
>  void snp_cmd_bookkeeping_locked(int cmd, struct sev_device *sev, void *data);
>  int sev_snp_platform_init_firmware_upload(struct sev_device *sev);
> +void sev_snp_dev_init_firmware_upload(struct sev_device *sev);
> +void sev_snp_destroy_firmware_upload(struct sev_device *sev);
> +int sev_snp_synthetic_error(struct sev_device *sev, int *psp_ret);
>  #else
>  static inline void snp_cmd_bookkeeping_locked(int cmd, struct sev_device *sev, void *data) { }
>  static inline int sev_snp_platform_init_firmware_upload(struct sev_device *sev) { return 0; }
> +static inline void sev_snp_dev_init_firmware_upload(struct sev_device *sev) { }
> +static inline void sev_snp_destroy_firmware_upload(struct sev_device *sev) { }
> +static inline int sev_snp_synthetic_error(struct sev_device *sev, int *psp_ret) { return 0; }
>  #endif /* CONFIG_FW_UPLOAD */
>  
>  #endif /* __SEV_DEV_H */
> diff --git a/drivers/crypto/ccp/sev-fw.c b/drivers/crypto/ccp/sev-fw.c
> index 55a5a572da8f1..97ce90f2af29a 100644
> --- a/drivers/crypto/ccp/sev-fw.c
> +++ b/drivers/crypto/ccp/sev-fw.c
> @@ -4,6 +4,7 @@
>   */
>  
>  #include <linux/firmware.h>
> +#include <linux/psp.h>
>  #include <linux/psp-sev.h>
>  
>  #include <asm/sev.h>
> @@ -115,3 +116,215 @@ int sev_snp_platform_init_firmware_upload(struct sev_device *sev)
>  	}
>  	return 0;
>  }
> +
> +static enum fw_upload_err snp_dlfw_ex_prepare(struct fw_upload *fw_upload,
> +					      const u8 *data, u32 size)
> +{
> +	return FW_UPLOAD_ERR_NONE;
> +}
> +
> +static enum fw_upload_err snp_dlfw_ex_poll_complete(struct fw_upload *fw_upload)
> +{
> +	return FW_UPLOAD_ERR_NONE;
> +}
> +
> +/*
> + * This may be called asynchronously with an on-going update.  All other
> + * functions are called sequentially in a single thread. To avoid contention on
> + * register accesses, only update the cancel_request flag. Other functions will
> + * check this flag and handle the cancel request synchronously.
> + */
> +static void snp_dlfw_ex_cancel(struct fw_upload *fw_upload)
> +{
> +	struct sev_device *sev = fw_upload->dd_handle;
> +
> +	mutex_lock(&sev->fw_lock);
> +	sev->fw_cancel = true;
> +	mutex_unlock(&sev->fw_lock);

Does this really need a lock? Also, I don't see it being set to false
ever, so the first time an update is canceled it can never be updated again.

> +}
> +
> +static enum fw_upload_err snp_dlfw_ex_err_translate(struct sev_device *sev, int psp_ret)
> +{
> +	dev_dbg(sev->dev, "Failed to update SEV firmware: %#x\n", psp_ret);

Blank line.

> +	/*
> +	 * Operation error:
> +	 *   HW_ERROR: Critical error. Machine needs repairs now.
> +	 *   RW_ERROR: Severe error. Roll back to the prior version to recover.
> +	 * User error:
> +	 *   FW_INVALID: Bad input for this interface.
> +	 *   BUSY: Wrong machine state to run download_firmware_ex.
> +	 */
> +	switch (psp_ret) {
> +	case SEV_RET_RESTORE_REQUIRED:
> +		dev_warn(sev->dev, "Firmware updated but unusable\n");
> +		dev_warn(sev->dev, "Need to do manual firmware rollback!!!\n");

Please keep to a single message so that other messages don't get in
between when outputted.

> +		return FW_UPLOAD_ERR_RW_ERROR;
> +	case SEV_RET_SHUTDOWN_REQUIRED:
> +		/* No state changes made. Not a hardware error. */
> +		dev_warn(sev->dev, "Firmware image cannot be live updated\n");
> +		return FW_UPLOAD_ERR_FW_INVALID;
> +	case SEV_RET_BAD_VERSION:
> +		/* No state changes made. Not a hardware error. */
> +		dev_warn(sev->dev, "Firmware image is not well formed\n");
> +		return FW_UPLOAD_ERR_FW_INVALID;
> +		/* SEV-specific errors that can still happen. */
> +	case SEV_RET_BAD_SIGNATURE:
> +		/* No state changes made. Not a hardware error. */
> +		dev_warn(sev->dev, "Firmware image signature is bad\n");
> +		return FW_UPLOAD_ERR_FW_INVALID;
> +	case SEV_RET_INVALID_PLATFORM_STATE:
> +		/* Calling at the wrong time. Not a hardware error. */
> +		dev_warn(sev->dev, "Firmware not updated as SEV in INIT state\n");
> +		return FW_UPLOAD_ERR_BUSY;
> +	case SEV_RET_HWSEV_RET_UNSAFE:
> +		dev_err(sev->dev, "Firmware is unstable. Reset your machine!!!\n");
> +		return FW_UPLOAD_ERR_HW_ERROR;
> +		/* Kernel bug cases. */
> +	case SEV_RET_INVALID_PARAM:
> +		dev_err(sev->dev, "Download-firmware-EX invalid parameter\n");
> +		return FW_UPLOAD_ERR_RW_ERROR;
> +	case SEV_RET_INVALID_ADDRESS:
> +		dev_err(sev->dev, "Download-firmware-EX invalid address\n");
> +		return FW_UPLOAD_ERR_RW_ERROR;
> +	default:
> +		dev_err(sev->dev, "Unhandled download_firmware_ex err %d\n", psp_ret);
> +		return FW_UPLOAD_ERR_HW_ERROR;
> +	}
> +}
> +
> +static enum fw_upload_err snp_update_guest_statuses(struct sev_device *sev)

snp_update_guest_contexts

> +{
> +	struct sev_data_snp_guest_status status_data;
> +	void *snp_guest_status;
> +	enum fw_upload_err ret;
> +	int error;
> +
> +	/*
> +	 * Force an update of guest context pages after SEV firmware
> +	 * live update by issuing SNP_GUEST_STATUS on all guest
> +	 * context pages.
> +	 */
> +	snp_guest_status = sev_fw_alloc(PAGE_SIZE);
> +	if (!snp_guest_status)
> +		return FW_UPLOAD_ERR_INVALID_SIZE;
> +
> +	/*
> +	 * After the last bound asid-to-gctx page is snp_unbound_gctx_end-many
> +	 * unbound gctx pages that also need updating.
> +	 */
> +	for (int i = 1; i <= sev->last_snp_asid + sev->snp_unbound_gctx_end; i++) {
> +		if (sev->snp_asid_to_gctx_pages_map[i]) {

Let reduce some indentation and do

		if (!sev->snp_asid_to_gctx_pages_map[i])
			continue;

> +			status_data.gctx_paddr = sev->snp_asid_to_gctx_pages_map[i];
> +			status_data.address = __psp_pa(snp_guest_status);
> +			ret = sev_do_cmd(SEV_CMD_SNP_GUEST_STATUS, &status_data, &error);

... and
		if (!ret)
			continue;

> +			if (ret) {
> +				/*
> +				 * Handle race with SNP VM being destroyed/decommissoned,
> +				 * if guest context page invalid error is returned,
> +				 * assume guest has been destroyed.
> +				 */
> +				if (error == SEV_RET_INVALID_GUEST)
> +					continue;

Add a blank line here.

And add a comment here about synthetic_restore_required being set.

> +				sev->synthetic_restore_required = true;
> +				dev_err(sev->dev, "SNP GCTX update error: %#x\n", error);
> +				dev_err(sev->dev, "Roll back SNP firmware!\n");

Single message, something like:

"SNP guest context update error %#x, recommend SNP firmware roll back."

> +				snp_free_firmware_page(snp_guest_status);

This is done in the goto below, so must be removed.

> +				ret = FW_UPLOAD_ERR_RW_ERROR;
> +				goto fw_err;
> +			}
> +		}
> +	}
> +fw_err:
> +	snp_free_firmware_page(snp_guest_status);
> +	return ret;
> +}
> +
> +static enum fw_upload_err snp_dlfw_ex_write(struct fw_upload *fwl, const u8 *data,
> +					    u32 offset, u32 size, u32 *written)
> +{
> +	struct sev_device *sev = fwl->dd_handle;
> +	u8 api_major, api_minor, build;
> +	int ret, error;
> +	bool cancel;
> +
> +	if (!sev)
> +		return FW_UPLOAD_ERR_HW_ERROR;
> +
> +	mutex_lock(&sev->fw_lock);
> +	cancel = sev->fw_cancel;
> +	mutex_unlock(&sev->fw_lock);

Same question on the mutex, I don't see how this helps with any timing.

> +
> +	if (cancel)
> +		return FW_UPLOAD_ERR_CANCELED;
> +
> +	/*
> +	 * SEV firmware update is a one-shot update operation, the write()
> +	 * callback to be invoked multiple times for the same update is
> +	 * unexpected.
> +	 */
> +	if (offset)
> +		return FW_UPLOAD_ERR_INVALID_SIZE;
> +
> +	if (sev_get_api_version())
> +		return FW_UPLOAD_ERR_HW_ERROR;
> +
> +	api_major = sev->api_major;
> +	api_minor = sev->api_minor;
> +	build     = sev->build;
> +
> +	ret = sev_snp_download_firmware_ex(sev, data, size, &error);
> +	if (ret)
> +		return snp_dlfw_ex_err_translate(sev, error);
> +
> +	ret = snp_update_guest_statuses(sev);
> +	if (ret)
> +		return ret;
> +
> +	sev_get_api_version();
> +	if (api_major != sev->api_major || api_minor != sev->api_minor ||
> +	    build != sev->build) {
> +		dev_info(sev->dev, "SEV firmware updated from %d.%d.%d to %d.%d.%d\n",
> +			 api_major, api_minor, build,
> +			 sev->api_major, sev->api_minor, sev->build);
> +	} else {
> +		dev_info(sev->dev, "SEV firmware same as old %d.%d.%d\n",
> +			 api_major, api_minor, build);

Maybe something like:
"SEV firmware not updated, same as current version %d.%d.%d"

> +	}
> +
> +	*written = size;

Blank line.

> +	return FW_UPLOAD_ERR_NONE;
> +}
> +
> +static const struct fw_upload_ops snp_dlfw_ex_ops = {
> +	.prepare = snp_dlfw_ex_prepare,
> +	.write = snp_dlfw_ex_write,
> +	.poll_complete = snp_dlfw_ex_poll_complete,
> +	.cancel = snp_dlfw_ex_cancel,
> +};
> +
> +void sev_snp_dev_init_firmware_upload(struct sev_device *sev)

snp_init_firmware_upload

> +{
> +	struct fw_upload *fwl;
> +
> +	fwl = firmware_upload_register(THIS_MODULE, sev->dev, "snp_dlfw_ex", &snp_dlfw_ex_ops, sev);
> +

Remove blank line.

> +	if (IS_ERR(fwl))
> +		dev_err(sev->dev, "SEV firmware upload initialization error %ld\n", PTR_ERR(fwl));
> +
> +	sev->fwl = fwl;
> +	mutex_init(&sev->fw_lock);

Probably can't happen, but shouldn't the mutex be initialized before
calling firmware_upload_register()?

> +}
> +
> +void sev_snp_destroy_firmware_upload(struct sev_device *sev)

snp_destroy_firmware_upload

> +{
> +	firmware_upload_unregister(sev->fwl);

Should this check that the sev->fwl is valid before trying to call
firmware_upload_unregister()?

> +}
> +
> +int sev_snp_synthetic_error(struct sev_device *sev, int *psp_ret)
> +{
> +	if (sev->synthetic_restore_required) {
> +		*psp_ret = SEV_RET_RESTORE_REQUIRED;
> +		return -EIO;
> +	}

Blank line.

Thanks,
Tom

> +	return 0;
> +}
