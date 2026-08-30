Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011044.outbound.protection.outlook.com [40.93.194.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C3038D41A;
	Sun, 30 Aug 2026 15:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788103152; cv=fail; b=PLIHfSWCsuPxDUX/I6hSL0fxLN3zxbZGxCKqbogfP83epLi+31qhLgNUqJQi/W2LGjqjSrWLfHymntZTn/Lppn/SMi+N6i1tbLcVpNebM/bMWMUZefh1n4IS9QYW1/FmIZmddv+9GH8O1dw0D3PyVRiNbCFimqAXs/nGBDNgE4U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788103152; c=relaxed/simple;
	bh=yM0sHOgItqoeSuS640UBnKu4ymqEyWJr+41Nek2NvbA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Z2ITWCf5oAfaVQOsHqALO1+zmFaEG0hNSM9ZoqZCYo2+LajjV8AH7wa56YKNVf2iJfAG4vCHqiszav3on1Xao0ZDXS6hMGLItQMhk3ucsOnoWYbIMy57PFDrkfl3+1TkEjfGmM3ykM8Y8EYC+cAa+dmNcsB7Vu4ty8v7NMZT1vg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SP9aC3vj; arc=fail smtp.client-ip=40.93.194.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SP9aC3vj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EpCbfWHdJ695hzaYGvJdpCURJSTvNSmGSdiuRQuheJnBqeNreKWqhkZr3DjB08e/5tKQYwJ/2XK9H1iwk7QA5g5yASK12ZUA8Up1jsxKeKE7RkuckozMKbW4DLRsN5LtKpNHj/B/2mGc7ZRZRBcA+GS8c+FMkrbligWtN0U0NJVvaGovOBi4HxZ1Vsxo29fZ8MEPdjVMFiI9sdY7VNIlwaTzoEEfefeL+QpujFWFL3BZh+6f1J1DiyKzHghzLLS9ZB4wrN0PjJXNWZHkwvgVo6OZvwrVOZN10iF1ULraiMsgF0wE/MFiHuuA2k1ITkkr9FnaCLJjGrq78W4kwDCpFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PtkImv+cXVaPVy/mQlrnJ1ljLq1XaDL+YTREmrcGseY=;
 b=tp/4sgJtjFP7bFCYDUMDn9oODGdk5wi7Ccf1pr5DIQXzhfB/xfYr04OpR4oHwpNdBSyV4XZxBlpcHVQf6iXALEKcWgZbvcnZ4AhlPsxUAT5O7Io26RCWgZdG5kNOIpliwUJ08zIlyiHYJFGbUkQExX3YjxPT5yNdVJEghkAc0uf77ybLPWrEIcOWDU0HH/NiwFLd46lB86Dz5i5tXENzKY0D0RjqqWIladIIGPm9myhpzR20nb7FJRyY18A4ycfnsihAHe7m59p/zUKs439cYCD3WsAjLXlAc5zO/VEgDxK7yNAzBY35J/nmheXRXQgL1CEoVdHioIV3pmYo1jq+Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PtkImv+cXVaPVy/mQlrnJ1ljLq1XaDL+YTREmrcGseY=;
 b=SP9aC3vjWf8J5V8SOajsOZX/OCbuwRrf7bH6NxxFmBhH2PwrD0kGSqOPHsG5AFmaXAdmtve+Hu5LvQAkLPqGagJ2FTyRGL+AVDdw5g5mCzjCY9RTaZz/hqgsQeR3uzZMqMLu1jR0BfSKDjWjUgJEixKG7Zv+ZTiU7fNDvLGcaIs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by PH0PR12MB5678.namprd12.prod.outlook.com (2603:10b6:510:14e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Sun, 30 Aug
 2026 15:19:07 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%4]) with mapi id 15.21.0360.008; Sun, 30 Aug 2026
 15:19:06 +0000
Message-ID: <d1a21184-8b24-4612-bd4b-6cacf39962cf@amd.com>
Date: Sun, 30 Aug 2026 10:19:05 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] crypto: ccp: Initialize DBC ioctl mutex before
 registering device
To: Runyu Xiao <runyu.xiao@seu.edu.cn>, mario.limonciello@amd.com
Cc: john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, jianhao.xu@seu.edu.cn
References: <20260829133410.1708684-1-runyu.xiao@seu.edu.cn>
 <20260830015104.2040153-1-runyu.xiao@seu.edu.cn>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260830015104.2040153-1-runyu.xiao@seu.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0172.namprd04.prod.outlook.com
 (2603:10b6:806:125::27) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|PH0PR12MB5678:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c7d84d3-62ae-4319-6a66-08df06aa0865
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|10067099003|56012099006|4143699003|6133799003|22082099003|18002099003|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info:
	sXQItIH2LLe3U6F3whX65xwzidoMtBdM+HQFYro2+0SS+14QdKWv95Okv9uVo99dte300hqc1isuvi9+Vg7XlgpF4r78GRArvABvCU0UjL1kpFTpa8uFhtabJfUApuCgEtBDF4owlsrJ6euqjhoHJxhuWDXh009UugPNGmiZDNS5tagOXTKJYHCM3ApvI2TppOFlJElRSPTlJdF6I0OdLtAuWAsV96wyz7Ud2VD+X1b2AquDYvccZWfM2Am0yhsN41EE/ni2mN49WMSQYkQtHeEYumpJhh3pXdC/NHGKqIwmUi/FLZRzBi2Vnz0x0+PbMht3m728WS6wSunuhng5tMHtb1+a5zJVCM9RTDz7K2q5O3aNzkpf85VnD1K/2EEfTkuOVqQOqME+QVlq0pXTp1tTu6pE9VthIfcLdQw9pQmOC2PP4yvNBUkH583H1svd3AExAMrLsZEINKxK2KsysOKMhw0NFQLbmc0xIS/4aJCADYI73KqNaislNKF7ezHR44cXDFLhHa52LxgHVSNSk+p8HaUkrN1F0nfSExT8K098ad8GVM3EQy4WCbGkbigVFt0HqATjpoiyhdow2ACuHCEMmgbQBGXrRcyvkoc/1yA0KD6XbeNl4f5yMApvhbkPB4SqsnqCCzG5VjFEcKvmZnlXiWtPHBX2E74PrlQ74pE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(10067099003)(56012099006)(4143699003)(6133799003)(22082099003)(18002099003)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RTJRZSs1dGdiRFJXYzVSeG54UkhpbExDdDR3VE5ZS1YwcHhWajJqY0h2bHZB?=
 =?utf-8?B?M050ODdNeEJmaW8rTjA1MnRzSmZBQ0hQZmxaajRWRTBnV2F6VGRnTUxYczRF?=
 =?utf-8?B?V2xjczRIbEdNbDhhV2FuNW91RVU0enRrUlZJRFAvMWloaGZWN3ZXZFovK0J6?=
 =?utf-8?B?Z2JkazVWM3hRK3BybFZxQnBkcVhZM1pyKy9BM0ZjalZpZHJ2a2YyVWQrZENo?=
 =?utf-8?B?dkNOMVI2Z0ZCR280TWtEOTlrak4rUVI4dXRkMTNtWmZxajJyazRZbzNQeS9D?=
 =?utf-8?B?dWVRaUhwb1lUUVpoNFRkSm8waVV2ZnF5YkRMcTM5NW5hMWRmOFpzNDhHNG9F?=
 =?utf-8?B?dHBMVVBMdDkyOHlGSTQrSVFjd2lMaXhBUGU4ZS9vd2Q0VXhnUzdGcjgrdXl2?=
 =?utf-8?B?OGVjOTJMWjFDcU1WbEVDK0syZk1hWDFCQzVTRHdYWlNrZE96V2t5ODhJTDlM?=
 =?utf-8?B?bk44WnZaV3prR3B5RTF3TklRNlk5Sy9BVUFxak1nd2xNZmdEZVZ1K0h4VGZX?=
 =?utf-8?B?NllSMjlUUTM1bENTZnRSL2xEalp3Z2tkQldSVWJPRkVnN3p1S0FXeDhDSmZs?=
 =?utf-8?B?N2VPSXlSRTFFUXR4cW0vWmsyeDJSWFNiUEVocDFCV0lEVDJlTSs3NmtSNGY0?=
 =?utf-8?B?cm45N3JTUGtMNXRJbW5VZG5HeXJXenhDa3QyT2VJYlRrYXlZRUhmMTRCdk05?=
 =?utf-8?B?WVV1WTkvK2t6RGllRFVvQ0dnYTZTV1VoYTZGSStaQ2hQRjZnRUtVazBROHBr?=
 =?utf-8?B?SFVlTkMxM2R3c0FuUlIxUzFsMmYrdVhFeVBjSkRBVi94dks3UlhRN01UQ2NW?=
 =?utf-8?B?R1l2OTBiOWtNcjI5REljNTVzZnhTQU9aU0VneGdwYW9mdVJXRE90ZlNubERi?=
 =?utf-8?B?YlNuWGhZR2MySXJ5eXN3eklzSHhoSEpVMWdPK3ZPaEovYUdwUDR6L0oyU0Jn?=
 =?utf-8?B?RlJWN09TeEFYdEFteFE2ZmZ4MDlJaHduZWlzeUl2bURtaGZ5d3dpOXladWhm?=
 =?utf-8?B?dHd2Nm1OZ09xOUpySkNZckM5aU1haXE3SWR1WGt2SC9OLzRnem0vd0hud3Nk?=
 =?utf-8?B?WmRrM1hqSUFGN1lyS2xtKzhnM0t4MlNpUkxlMmlHM29VNWtnZloxY0s4RVoz?=
 =?utf-8?B?eWZLN3FET0U0cFN1WWFaSUFnOE5BanJjR2t0NHErQW00TnFSTTVTbVZONkZ0?=
 =?utf-8?B?UUE5elFtN1d3TlJUdTJSWkR0Z1VJbGEwdnNtaFlTUWg0REhPb3JDUDZaeDVG?=
 =?utf-8?B?OEk2VytzR0F6UXRhRnI4dEVJaUYrSG1QWWZBTWgrNkxISndiQzlyZmdQZjFH?=
 =?utf-8?B?Sm9SeE0wYndLY2NYQVZMbFVlNGJKRG1Sck9wMkVwcjNBNkJ6OXhGZDYyQ0NL?=
 =?utf-8?B?SnIrelRaendiSWFoZ1dLYWQwVVZzK25ESUdrUmp1dHh1bVVMWlZtdUxPTzdO?=
 =?utf-8?B?U1hvbTVjcnBIL1FkZ2xNem9rSFdlMUQya0IyUFJLNG81Zm1MQ2IxZkI1SlRx?=
 =?utf-8?B?d1NTMi9lWXFSWVFjU1VhWUQ5RllnT3lzNERvWDdLZjJQaUxXYm1nZWpTQS9o?=
 =?utf-8?B?SVpaaWtOeXpqRG50WWlZWW9mcDM2TURRdEJFVnhoVTE4Q1BXaWdLNmtxUTJI?=
 =?utf-8?B?dGtJTThra1Bud0w3WVRGaEdPV09IVDU0bTR5cjNlZ0tmOUZ6SndPcmNsRW1W?=
 =?utf-8?B?NTcweHB3YnVzN004WjFhZjl6MUsxT2pITlRCZ2dKVXR5YUpITjd0Zm1vd0wx?=
 =?utf-8?B?cmZkUTdFWXNKb0s3VmdzN25ZRHJpMG9sTjJiTDNSaTJJeVU5bGgxdjBJUFJR?=
 =?utf-8?B?RFQ2cFg5MkNxN0xWTGFGZlNvWkJUVWJZNW1iZWhhaGhjdjFxZThiU0dqTHF4?=
 =?utf-8?B?T3JxcFQ3NjBEMWpxTHFUaSt0a0VMQkVSbDJUbG8yUnlzOEJNV09kRkMrZDRk?=
 =?utf-8?B?RlVtOHpnU2I3cGl1ZEZMOWsvcXlCNUFhaCtQNzMvSDBLRFZNejR1UGxWOG42?=
 =?utf-8?B?S2c4ZS83bEk5cmxEOTZtRWhQTTFuYlNxVFZMVjJwSHlQMnkzYlVBdFdmc1pP?=
 =?utf-8?B?bmw1VDZqdTQzMEgrN3hjNmlRK0dKdnJJcXIyLzJTMGdmcDRXaUFZRGFwM3hu?=
 =?utf-8?B?aXJCUlRKNzNRVzZtSjZHV0RvZndUNU05L0JMZk9yT2cxV1ZaYUk2V1RqYjBE?=
 =?utf-8?B?eGVwYThBYzRtNUwzMWdhZFovSlpqOHZYaWpZSUtwelYwVmxIU2VyV044R2tI?=
 =?utf-8?B?STdqN2xFU2RXK3RkZ2h4ZFAwRS9CTnFZamZzYVFWeGUrakgvam5MT3dTVlJD?=
 =?utf-8?Q?oNOrXmL2vaXSlG6mcx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c7d84d3-62ae-4319-6a66-08df06aa0865
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2026 15:19:06.6315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fXqrSGeJw3AIQV3XQdQ/swtKATTbC5gWY7qDZmQZPBXHXvy79m8J66Kv+hQHd1jVcedhK9pYz9o6AxIQvNV+1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5678

On 8/29/26 20:51, Runyu Xiao wrote:
> dbc_dev_init() registers the DBC misc device before initializing
> ioctl_mutex. Once misc_register() publishes the device, userspace can
> open it and invoke dbc_ioctl() while the mutex is still uninitialized.
> 
> Initialize ioctl_mutex before calling misc_register() so the published
> ioctl callback always sees an initialized mutex.
> 
> Fixes: c04cf9e14f10 ("crypto: ccp - Add support for fetching a nonce for dynamic boost control")
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/all/20260829133410.1708684-1-runyu.xiao@seu.edu.cn/
> Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
> Assisted-by: Codex:GPT-5

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
> v2:
> - Move mutex initialization before setting up the misc device, as suggested
>   by Tom Lendacky.
> 
>  drivers/crypto/ccp/dbc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/dbc.c b/drivers/crypto/ccp/dbc.c
> index 410084a9039c..4db49a14550c 100644
> --- a/drivers/crypto/ccp/dbc.c
> +++ b/drivers/crypto/ccp/dbc.c
> @@ -235,6 +235,8 @@ int dbc_dev_init(struct psp_device *psp)
>  		goto cleanup_mbox;
>  	}
>  
> +	mutex_init(&dbc_dev->ioctl_mutex);
> +
>  	dbc_dev->char_dev.minor = MISC_DYNAMIC_MINOR;
>  	dbc_dev->char_dev.name = "dbc";
>  	dbc_dev->char_dev.fops = &dbc_fops;
> @@ -243,8 +245,6 @@ int dbc_dev_init(struct psp_device *psp)
>  	if (ret)
>  		goto cleanup_mbox;
>  
> -	mutex_init(&dbc_dev->ioctl_mutex);
> -
>  	return 0;
>  
>  cleanup_mbox:

