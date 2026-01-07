Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011010.outbound.protection.outlook.com [40.93.194.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C59335975;
	Wed,  7 Jan 2026 08:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767772811; cv=fail; b=mLei1/OHmO0oZ4SZqiPjO2r6odwcwHw5+5r2chE6h4xKpVGaLBDjPgr+zKZV6H5ea+dNYOKq6sVd4iQXrK6RBc5jKc7cc3RPbzALgNqsxCNXLxFg/6P+37Hrc4G91wYKkY8DHMtlWv8GGQNvztPFAyJb+fyfMh13sOrSwL69VVM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767772811; c=relaxed/simple;
	bh=vtsvXa0z4GYZAwyo0/Q1CfLq164ebqJ3PL/6BrXc0DQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=A+tmnxo/8rBVnt0nwyJcRwGU+kTAbArBgquHRviKBEnLcGeDKMNtXa499+kZlD5qvk4KVKklBDfw9DEHTHyKqTzhrts/mgpgOsYhg6hsH/C2mwTpKh+WPpwoz5pZO/9bubZ6YsxGpCObvyHSKFpPLPizl2+1nxUou0Yv7LprLzY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DhHjKB07; arc=fail smtp.client-ip=40.93.194.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DhHjKB07"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v3c/HvREHq8JcjihI7DOK00ly8N5iD/ofk/1uKThiY75xbcKQp8oIHBcLieEH6QAI0XH8rhWWGjDDhlosPuizvJI7YrAd/wQzFsTEJt9c2Ykqto6Z+lSfKT9Zwb8Pf/Pu+gmZAJdsb79ysGNEbFj1tKplus67/Je3VA3HwMsN3kPxnA2h+NuDs4j/nxW+kAdgb016svzOgm81r4WclJdsq+qXsDZvWGo131wycdypCbofnxZYMo1eL3kmoMgtjePap62/fsOR5BknYTgs1Ca7N8uGZInRJvQWN32LoH70a9w8kGQl2dZYlmkA5XMSBHmpEHcYbzIuGSLD+dAphoS0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kd/rprhVEb3+pj4Eta8haju57iod9BB8TbNSKSm/fiU=;
 b=nNut/6B2gpyBqP4ysDEV8fEIHu6scyyae1lr+0keO5cPcRpMgkBPaA/XN6dtp2QzKNmJYnrd3YeYUi/lyVfB1+TbOZU8JnTDbCCUZbmKO1Hjce9Bin76YJNBaQdOn1vAm/EK3u8ffS3dXXwzZFSHCngNLmitwdfvGgB9Ir/0oTf3hQKRoVj8DBkhem6Du07X2RU4ulll6IrQYwU/1lwI2SArb0qpMppDPi2uw1ivXTTDUxipAFu2k1wkYBjcL0RIq7oGUZ6IroEhCQJGU66OGqRXDb0ERmSbNGhY15YAgKTy80HHEpJ8Lc/1kFdrkpIOzsaHDEN0A6b2QSZBrR9bZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kd/rprhVEb3+pj4Eta8haju57iod9BB8TbNSKSm/fiU=;
 b=DhHjKB07lUocCp5XWhSNswzC9ETll6viXqJI4bhq5Zdu5iosUI/qTYblqEVuHPmXBYoa8PshmupHzOd9pN9iCl36rGk6JuqZcV1u943Y0joXORfgid9fdUM0V1KdzNQO5lbP8QCG+ER8NCdW89YUpKiXtcQqrCQJO97IuErFmm8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5176.namprd12.prod.outlook.com (2603:10b6:208:311::19)
 by IA1PR12MB8310.namprd12.prod.outlook.com (2603:10b6:208:3ff::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 08:00:06 +0000
Received: from BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::91cb:8f10:c6d2:d683]) by BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::91cb:8f10:c6d2:d683%5]) with mapi id 15.20.9478.004; Wed, 7 Jan 2026
 08:00:06 +0000
Message-ID: <3d97082c-60d0-4ba6-b5d6-6bdf582c2307@amd.com>
Date: Wed, 7 Jan 2026 13:29:58 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/5] crypto: ccp - Add an S4 restore flow
To: "Mario Limonciello (AMD)" <superm1@kernel.org>,
 "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 "Thomas, Rijo-john" <Rijo-john.Thomas@amd.com>
Cc: "Allen, John" <John.Allen@amd.com>, "David S . Miller"
 <davem@davemloft.net>, Hans de Goede <hansg@kernel.org>,
 "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER"
 <linux-crypto@vger.kernel.org>,
 "open list:AMD PMF DRIVER" <platform-driver-x86@vger.kernel.org>,
 Lars Francke <lars.francke@gmail.com>, Yijun Shen <Yijun.Shen@dell.com>
References: <20260106045423.55190-1-superm1@kernel.org>
 <20260106045423.55190-4-superm1@kernel.org>
Content-Language: en-US
From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
In-Reply-To: <20260106045423.55190-4-superm1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0190.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:be::19) To BL1PR12MB5176.namprd12.prod.outlook.com
 (2603:10b6:208:311::19)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5176:EE_|IA1PR12MB8310:EE_
X-MS-Office365-Filtering-Correlation-Id: 86fbd85c-dfda-4319-96ef-08de4dc2c511
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NWRtL3Q1cHAwdEVLSGZSeGl5QVoyU0RGNS81WWNRZDVHQzRRaW9VTHN3aXlO?=
 =?utf-8?B?b2tVemdPMDloRnFSV3dUZlY5TjdjOEEva2haRkJLVW1XeE1Edmk4NURPY3Q4?=
 =?utf-8?B?QnlLbXhoVTRhZlNBa09WWkR4N3M4bm90OS9JMDNnUFNZYjZ5Q2pzSFM5YnVt?=
 =?utf-8?B?cnUvQjcydjV6Y0FPV0dQaHdlbm1qYTgvVnFuVXRtUGZ3Rnl4V0crNitUWlp1?=
 =?utf-8?B?TVJ6bkV5SzlWdE82cWlvK3o2OE9RR1p5YTdrYnpkMlJyYUI1OEY3bzBBckRH?=
 =?utf-8?B?elduWjM3bllYS2ZqRU40cEJGbjNPamk1dmphTzR5TVQ1S2ZWc0s4aWdueUN1?=
 =?utf-8?B?UlFIMkhBSDJYVkYxL2hQUlhLRlp6NjNnN3hYMzNublhzamwvcksxMW9wUlVw?=
 =?utf-8?B?ZFR1WXVYVWdXcXY2TDk2a0xYSHJqUkl1NHk3WHZIYjVJeUlESzd6OEFpcnFm?=
 =?utf-8?B?SnRoUXZzZTJ1N09oQ1EydXo1T3FPNm11czFlY25MaktoTXFqbVVVdTR4R0ls?=
 =?utf-8?B?Mm9iZDBvUm1EOFJLYm1MaUFsQzloS0lSaS8yK0tZOW1icDQ2NnNoLzcxWjlX?=
 =?utf-8?B?R0Exbzlmb2NvYVNrRWpMRnJjSXluNmR3aExVVEtRMlpZdEp4UmdERklnZGIy?=
 =?utf-8?B?WUt4Q3lUZEk5cFhaWmRFQUZJSkxVZDBMR2lkdGZmWHhMN2NEL1lGVmtKOTh3?=
 =?utf-8?B?T2QrcmEyaFRzRnBwSW1tMmcrdjNpWldHRzRZSlFtTlZBcWRQYzEwWHBqTCtX?=
 =?utf-8?B?NlBBTXh4ZlV0b1QvWGw5Mm1WYUFsSXFUUWtOR1FrUHBrcE52OG45U29rTGNr?=
 =?utf-8?B?TkJIaGR2TDF5RjhlS1BLWExiUFJycGVHQTRLSHp1MkFjSkNXTHNic0NheUJQ?=
 =?utf-8?B?UWZvRGprVnpIZE4xci9vWmlXaWJvY2hLbnBnNUZIaC9nTFBXR2JpdU9qdS9h?=
 =?utf-8?B?UjBhdHpobjFYM2w2dmk4cjFRNHVTN1JsNTd2djlXSlhYTklKMEhsaTZBNXIy?=
 =?utf-8?B?WFhYdzNzZTRqN1cwSHAzdzNSdERDSVFyVFBIQ1F1eXY3OU1iOGNkS0x5WVBt?=
 =?utf-8?B?cGRTeVV5Qm92NjBwZExHU3ZXQ1M1UkJoSXdBcitzTEpJNm91ZnhVQnpxT1lO?=
 =?utf-8?B?cUt4NG5jakpIWThVOGNIckNCbE5HZk5zUHQ5bU1qTnJyRnJVZmVuY0dGeTFU?=
 =?utf-8?B?dERrMENnY1VOUStyLytRaW9zWStJbHhQaEphWktKRHlrYUNveE5idnZEUzFj?=
 =?utf-8?B?cTltbnZURVNRb3hrNmM2QXpBZzhXVWsxanVzVE0xbC9XRmVtNjdWd2hRZGF3?=
 =?utf-8?B?WTRtbllHTFg1dmhTUWNyelRsNVhwWGtBNjBUZjkrQitQRUlVV3o2djh3alFU?=
 =?utf-8?B?NXlpSFBBOHlWQzRZMXZUeitubEJUQmpsNEYzQ3pUdEdoQloxTFVkSHVOT2Qw?=
 =?utf-8?B?bmJvZ0NmaGtEQUI1bFQwUkVId1ZYSDFoTWoxTSthSUpkRTdmc2tObzdqZWQz?=
 =?utf-8?B?cnFlYVRiNnN1RE1LWjFMd3FLcnp4ekNWNlNqT1pDYnBYMW9GNzJpT3hDUTJp?=
 =?utf-8?B?cW1ibyt4bk1WNklxV2dhUlNXTmhMYW9SYlR6U3I2U211VVExMnc3QnUxUC9n?=
 =?utf-8?B?c3BNdm5XNkhmb3JCdm9BRTZnandXVmtaMnBVL251TVFyYUtHT1QwOG5rK0E4?=
 =?utf-8?B?UW1EZ2ZYYmJzWS9ya0l4enlNc3ZYbitDZG5BMEkzcjRuNllqMkM1cmQwcWwv?=
 =?utf-8?B?UFp1YW9UcklEeWZMZmZ3RGU0MktQbTZXYnpHbGprei84bFc3UnovUkVCSDAw?=
 =?utf-8?B?V3Y1WFNhZDd3bEZwTmowaFlZTFNGN0E2NGllMENsZDhORDU0NmduSEFOM280?=
 =?utf-8?B?WVg3eFpaNDNIUFBMcC94TVFhK3BXT29rczRBMmVIWXlkcUxoRVhpQnZsdVJD?=
 =?utf-8?B?L1RCcWtMVkJjVkJqTm1tNllTV2VkZklHRHcza3E1OC9Yd0RPMDRuK2dieGw0?=
 =?utf-8?B?SjAyTURVdkF3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RDJ1OTA3aGdwUTQ3akN3dHNkUHNycFBib2JjVXVEeExJaUlxTDVKTlFvRVdM?=
 =?utf-8?B?MjlqOE0zWkVYYlFlSzN3akJFWU1EUzcwSGdVQ3RVZzhxOHlOa1A4ZlJTU0RS?=
 =?utf-8?B?dHNYbVg5MlFReFRidmJNWkk1elVUVEQyRmZLYjI5Qlo3cnRLWjZFbWFrMmwz?=
 =?utf-8?B?bUNvYmFueTRzdjJ5eXo4YjZRa1cySXdNVkRoMXVudjV0NjVMUHRiNXkxTWMz?=
 =?utf-8?B?Uk4yU3FDTGREWG9TRDBYZExpemhWYmhXRFlWYWhRbGFqa29pRzNFN3NHM2xt?=
 =?utf-8?B?MFhoTkNKQzJ3bGliV01kcllGVzMvU3RQRUJyRU1lbXBHUHBVVTZDcVIwYTRI?=
 =?utf-8?B?NUUvU3RRNE9HMTBzMURvN1kxaEtDakJ5c1lldUo0Wldha1VPcmNFODBrRXNP?=
 =?utf-8?B?NUJ1UkZqNkNSN3hLeW83U0F6cjR3aklGU3dSVzVEYTJYUW5kSm1GQnA5MmNh?=
 =?utf-8?B?cmdWQkJJdXZ4dEs2a1VuV1pSMGlNemFWUzRxSzd6cTdHanNYbXQ2YnZ1Zm0r?=
 =?utf-8?B?TS9aZzZLNGo2Y1dwRjRFYk9CVDR5R1ZmTC9KdEdEVTV3d3RtQ0VwL0VJakdQ?=
 =?utf-8?B?dndRN0twZ29BTnBKKzJYRUpUM3hzV3B0UWNVeEpveUZwVGVLTUNpTjVpN1Ay?=
 =?utf-8?B?QVlqOE1kdUhuUTEwM1V6aGNGQ1R0WE9HRURyeW56K3VVamh2Y0t2YmZUTHlU?=
 =?utf-8?B?cS8zbEwvbUJscGR0dTR2WG5TaURxK1JWdENpdEJzRWxnYnYxVjFLaGVYSGxo?=
 =?utf-8?B?eHBrR21HWkxMdEkzOW40dWF3RmZOd0cxQXJpSGREeUZ1YTVHdUFXRGIwbGRs?=
 =?utf-8?B?Slp4WDFkSWw0VGpmYWlwSmdyM1RVUGJvTmJoZjI4VXRPK2V4UmRXVGNWNFBm?=
 =?utf-8?B?YWNmd0RCZHBiTVlRNHVPdlVJZWt0WEVrb0xGNFE5VW1scnNZQi9RRzZMUDdV?=
 =?utf-8?B?OXp6R21EcllDaHhRQzROQ0Jib0pWZDVSSzlMNGtIOHFmVW9HQys0QU1BRXdC?=
 =?utf-8?B?VS8ycytKRTdkaTVndG0vMzJEekU0MHlNMWZLSFFvenlQRnQxd3ZkU2hXSk5M?=
 =?utf-8?B?T2JaTWg2V1dFRlV6NDlic2xlUHJuRDBxeHdEL1RSRi9TMG1jOGt6MUc0Ykxo?=
 =?utf-8?B?TVVzZ3VZb1ppNkg4eTFBdVFVUGM4SkhxY1RSRC85RUNhUXhqaUswUzYzZ0t2?=
 =?utf-8?B?TUF6eEQrNGFNRXR5OGNkS3pRRng5MW44emFmTGhmR2dGLzdGRTFVdkJ5RU5U?=
 =?utf-8?B?YXJnNk85TzBSU2F3czZrNHBpTWR3Vmx5L3Z4ZHlzOHVveGxKT1p4WDFXaEhw?=
 =?utf-8?B?UnNEMXR5Y1RmSU1sTmpuYzZZV2FoK0ZpMUJHYUptNTNhWUZwWjVHaFp1Nk9I?=
 =?utf-8?B?emduSEJLcmYwTURzdi9hWmR1ZXlKOGM1VEFkT0RSd1ZiV0JPYzdBaXM5WUlH?=
 =?utf-8?B?YUNIdUJkQ2hVWDM1UXo4d2FaNUZraVFkLzdJZGYxMnNaVXkyMG03QjhhOVVI?=
 =?utf-8?B?bUtyS0Z2TEM3VmRtK1lXdFA5WEtzT3ZKWEozb3Q2aE9rWFFSWnlxeDdtaUJn?=
 =?utf-8?B?R1kvUTZEakR2MnJmMW1FL1V2R2laa1ZTSHl6dzBBdjVnVi9KcitvbHhwb3pW?=
 =?utf-8?B?V2FqVGJyVWs4a3BWQ1NQRnFBVEFuR0ZQMHloc2tuMkFnTEFVV3d2elY0QXFk?=
 =?utf-8?B?NkFpVkhoZThEeFhzVlMxcDlZL2xKTFo3ZndDZ0U0cXhWYlMraHhJZTBaRSt2?=
 =?utf-8?B?MWxpbXE4T1BrZURIY3hMSkxZQ1E0U0hmNU5QTC9FdTFmNUVTZTRJSmJRaHJJ?=
 =?utf-8?B?ZVU5YlVpQ2NleXV2ZXdpYVpURzd0K0VDQ3JkZVcyZlNlNmgvTzNoSG9qVTZK?=
 =?utf-8?B?V3k2aTNJNnpwWHpFYjRtWUUrRXYwNXc2QjE3Yk1taWF1TDkzbGlwNXpyblFu?=
 =?utf-8?B?SXJDWXpGeWNDYXlzY0pvZTJvelo1SWY0dlhYeEpHcWlVQW9NZmdPdHI3OVZS?=
 =?utf-8?B?azY0TlhkaFd4MnRKRCswcUFMbU41MExxTFFsMERGdG5vbW1oQ3BqUDJMWDBm?=
 =?utf-8?B?UGt6bUlndFFnZUdNVHBRcHJsQ0lZVVBWaGJSaUx0bFM2R1h1dHFaSEJUTkFh?=
 =?utf-8?B?bGlaUEE1a2RUeHJsMDJoTDVrRnJ6VFZxUnhJYXhHVlljcGZObWMyMlVTQ1lZ?=
 =?utf-8?B?SDN1WEFzWmJpNWhtWEtRdzI0bTNIUDgvUWRTV2tmS1I4RE1VakZIdVFaK08y?=
 =?utf-8?B?YlNhUEdQa2kyVzBrMnZ6VE1EcFNIdGM5ZEppSFZXaEY2V3dMUExsN3Y4WXp1?=
 =?utf-8?B?UTd3K1EwRmhqY3JTY3ltU2djUjA4V1NNem1pdW5zU3EzNE1FbENtUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86fbd85c-dfda-4319-96ef-08de4dc2c511
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 08:00:06.0522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LgsbcGrB+h/4Bqlb2KnjFOME8gjHbq65ycFXqOfCEMKZu6HJIVR92E4XE5TymQD4lrtOs0USs5hYk6JusZxdNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8310



On 1/6/2026 10:24, Mario Limonciello (AMD) wrote:
> The system will have lost power during S4.  The ring used for TEE
> communications needs to be initialized before use.
> 
> Fixes: f892a21f51162 ("crypto: ccp - use generic power management")
> Reported-by: Lars Francke <lars.francke@gmail.com>
> Closes: https://lore.kernel.org/platform-driver-x86/CAD-Ua_gfJnQSo8ucS_7ZwzuhoBRJ14zXP7s8b-zX3ZcxcyWePw@mail.gmail.com/
> Tested-by: Yijun Shen <Yijun.Shen@Dell.com>
> Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
> ---
> v4:
>  * Add tag (Yijun)
>  * Remove blank line (Ilpo)
>  * Adjust whitespace in psp_restore() (Ilpo)
> ---
>  drivers/crypto/ccp/psp-dev.c | 11 +++++++++++
>  drivers/crypto/ccp/sp-dev.h  |  2 ++
>  drivers/crypto/ccp/sp-pci.c  | 24 +++++++++++++++++++++++-
>  drivers/crypto/ccp/tee-dev.c |  5 +++++
>  drivers/crypto/ccp/tee-dev.h |  1 +
>  5 files changed, 42 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index 9e21da0e298ad..46072ff84f716 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -351,6 +351,17 @@ struct psp_device *psp_get_master_device(void)
>  	return sp ? sp->psp_data : NULL;
>  }
>  
> +int psp_restore(struct sp_device *sp)
> +{
> +	struct psp_device *psp = sp->psp_data;
> +	int ret = 0;
> +
> +	if (psp->tee_data)
> +		ret = tee_restore(psp);
> +
> +	return 0;

you meant to have 'return ret' instead of returning 0 :-)

Thanks,
Shyam

> +}
> +
>  void psp_pci_init(void)
>  {
>  	psp_master = psp_get_master_device();
> diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
> index 1335a83fe052e..0deea1a399e47 100644
> --- a/drivers/crypto/ccp/sp-dev.h
> +++ b/drivers/crypto/ccp/sp-dev.h
> @@ -174,6 +174,7 @@ int psp_dev_init(struct sp_device *sp);
>  void psp_pci_init(void);
>  void psp_dev_destroy(struct sp_device *sp);
>  void psp_pci_exit(void);
> +int psp_restore(struct sp_device *sp);
>  
>  #else /* !CONFIG_CRYPTO_DEV_SP_PSP */
>  
> @@ -181,6 +182,7 @@ static inline int psp_dev_init(struct sp_device *sp) { return 0; }
>  static inline void psp_pci_init(void) { }
>  static inline void psp_dev_destroy(struct sp_device *sp) { }
>  static inline void psp_pci_exit(void) { }
> +static inline int psp_restore(struct sp_device *sp) { return 0; }
>  
>  #endif /* CONFIG_CRYPTO_DEV_SP_PSP */
>  
> diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
> index 8891ceee1d7d0..931ec6bf2cec6 100644
> --- a/drivers/crypto/ccp/sp-pci.c
> +++ b/drivers/crypto/ccp/sp-pci.c
> @@ -353,6 +353,21 @@ static int __maybe_unused sp_pci_resume(struct device *dev)
>  	return sp_resume(sp);
>  }
>  
> +static int __maybe_unused sp_pci_restore(struct device *dev)
> +{
> +	struct sp_device *sp = dev_get_drvdata(dev);
> +
> +#ifdef CONFIG_CRYPTO_DEV_SP_PSP
> +	if (sp->psp_data) {
> +		int ret = psp_restore(sp);
> +
> +		if (ret)
> +			return ret;
> +	}
> +#endif
> +	return sp_resume(sp);
> +}
> +
>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>  static const struct sev_vdata sevv1 = {
>  	.cmdresp_reg		= 0x10580,	/* C2PMSG_32 */
> @@ -563,7 +578,14 @@ static const struct pci_device_id sp_pci_table[] = {
>  };
>  MODULE_DEVICE_TABLE(pci, sp_pci_table);
>  
> -static SIMPLE_DEV_PM_OPS(sp_pci_pm_ops, sp_pci_suspend, sp_pci_resume);
> +static const struct dev_pm_ops sp_pci_pm_ops = {
> +	.suspend = pm_sleep_ptr(sp_pci_suspend),
> +	.resume = pm_sleep_ptr(sp_pci_resume),
> +	.freeze = pm_sleep_ptr(sp_pci_suspend),
> +	.thaw = pm_sleep_ptr(sp_pci_resume),
> +	.poweroff = pm_sleep_ptr(sp_pci_suspend),
> +	.restore_early = pm_sleep_ptr(sp_pci_restore),
> +};
>  
>  static struct pci_driver sp_pci_driver = {
>  	.name = "ccp",
> diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
> index af881daa5855b..11c4b05e2f3a2 100644
> --- a/drivers/crypto/ccp/tee-dev.c
> +++ b/drivers/crypto/ccp/tee-dev.c
> @@ -366,3 +366,8 @@ int psp_check_tee_status(void)
>  	return 0;
>  }
>  EXPORT_SYMBOL(psp_check_tee_status);
> +
> +int tee_restore(struct psp_device *psp)
> +{
> +	return tee_init_ring(psp->tee_data);
> +}
> diff --git a/drivers/crypto/ccp/tee-dev.h b/drivers/crypto/ccp/tee-dev.h
> index ea9a2b7c05f57..c23416cb7bb37 100644
> --- a/drivers/crypto/ccp/tee-dev.h
> +++ b/drivers/crypto/ccp/tee-dev.h
> @@ -111,5 +111,6 @@ struct tee_ring_cmd {
>  
>  int tee_dev_init(struct psp_device *psp);
>  void tee_dev_destroy(struct psp_device *psp);
> +int tee_restore(struct psp_device *psp);
>  
>  #endif /* __TEE_DEV_H__ */

