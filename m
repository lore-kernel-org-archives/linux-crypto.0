Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011010.outbound.protection.outlook.com [52.101.62.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6161EF0B9;
	Tue,  2 Dec 2025 02:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764641089; cv=fail; b=klZCSB/qEx/Dlmo3lzhGk6kz+JVX5g65XfFCmTGeVJljZzNGyMksI+7JPHnhESLTKVkN4GpR8fK4dNsiBTE3ta0K2IcVmWLjCF/EfmMIDX9agebfK53U1BenRw6i500WLciT4Ll5zjNex7YP6dLM/kMxonuOjvHnY/im2eFf8ec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764641089; c=relaxed/simple;
	bh=34kY064LV452XU/fXNco1PeX5gL4lEr1mnLr9a2L8YA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Pewe19/KsJWMxlXWHHM2r5QKl699ArxPHzj3bCrRfkOSzJMVKAFxYtW8yj8p4c+WtovzlKPKbx5srE2edQ86PdD2v90lLzg8OKWX9USY+oWm75ghn3tLueVgWHCzqcf3MpAsSV1LslRgqEqn9gkGMr5vZHVIxp/uACVr0/8/bU4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OyWEUx8m; arc=fail smtp.client-ip=52.101.62.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OyWEUx8m"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j1zhE9Gr8FVc0eZg1r7eaPLorJCa++MKCt8KONZNdLObA4gICJvfG2BgYsauvmm5i1ahIs+E2ZkoT8uRx2kwzBZuZs4PlMNxjoI9xxi2LxWoMleDUYYecl7SmrpX3SjsEvLpG6atZGQFs9gH69rYjmC261E1x3upYJ0nDagutggSjYsNO5wTjCnoC4MwnCRq6V+BgMHVEALX8/xvcEZ98nuOBMqium2/s7mLIaiFm1M02jVtK/LSWPNa5/0embrIu/MNCbXli5XOd+X608KcE5K7+cM3PnRK++nett4KVGmP1UjUIPaa9RKkTM81mtAT5VMODEZM1JUo6UEsLst9bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9OHJbCs2e1Z4St54JAEF790186IKZhzj41u7ufkiXMw=;
 b=qxpd83LmNMGZnHItkEz+mr8EhNFiKxy48HDqiZui+CymVb+pxeJC6sjyBWU5o0s4eEPnkWylEwRM0BJZSBjoc+eCijDn4sYqRfh45o4TWX5srUfGjpGj8bXryyypGTE1Fpv3VJp3d1qaxiaRuiuuZhzepDIlmYaYUA2g1y8cYGzbxIThOcXPsotHMQHe/ltHiSHePgsXnKpmCGfYEYlDSesyhTjqva/ldQVvHqXcap2ha25OecuvbJmsOsYXlszG2HW6IMavrU1aXFsCCyELkEEC8xKLiJAO4IWZl4PggwC2/YPed8TpHjImXMiPJNsZI6ujTy8oVMl7mTTt+EhXsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9OHJbCs2e1Z4St54JAEF790186IKZhzj41u7ufkiXMw=;
 b=OyWEUx8m/TD9s/AyKXHa/QUPKl+JJGylZboGd3iWdRI+YPKLvDmjyXuVTBRdi97oXrHO0cN3rZraCry01+gFbMqSaFupGswnvCJebQtNoWcQ9MZY96ay30OmNqC9vdu4G8OoLnpqEYCXHhDL8n6dEbJyCcVG+zAG8G7Sdx5x24w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by SJ2PR12MB9162.namprd12.prod.outlook.com (2603:10b6:a03:555::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 02:04:44 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%4]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 02:04:43 +0000
Message-ID: <de801efa-61fe-4540-8749-c3483e0f793e@amd.com>
Date: Tue, 2 Dec 2025 13:04:24 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH kernel v2 5/5] crypto/ccp: Implement SEV-TIO PCIe IDE
 (phase1)
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Ashish Kalra
 <ashish.kalra@amd.com>, Joerg Roedel <joro@8bytes.org>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 "Borislav Petkov (AMD)" <bp@alien8.de>, Kim Phillips <kim.phillips@amd.com>,
 Jerry Snitselaar <jsnitsel@redhat.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Gao Shiyuan <gaoshiyuan@baidu.com>,
 Sean Christopherson <seanjc@google.com>, Nikunj A Dadhania <nikunj@amd.com>,
 Michael Roth <michael.roth@amd.com>, Amit Shah <amit.shah@amd.com>,
 Peter Gonda <pgonda@google.com>, iommu@lists.linux.dev
References: <20251121080629.444992-1-aik@amd.com>
 <20251121080629.444992-6-aik@amd.com>
 <fd5bdddc-fd22-4373-a8ff-3933c63cbacc@amd.com>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <fd5bdddc-fd22-4373-a8ff-3933c63cbacc@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY4P282CA0010.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:a0::20) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|SJ2PR12MB9162:EE_
X-MS-Office365-Filtering-Correlation-Id: 294cb75a-9226-4237-a334-08de314728f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?anlod252K084ZGtOOFN3QWdvT3FCNGU3QU9LRkc2QkFIeUdBYVo1WTBzZGNa?=
 =?utf-8?B?REF0TmtJcTJ0WFFOaEFPRktKVVFDcTB4RUt4TlRQVzVqMHhQRTcwWDRzNm54?=
 =?utf-8?B?TVR4QStLdzM5NXloRk9kVzhEK05BVjAxS2U3MzM4SGtESlJ6TG91MityRW0w?=
 =?utf-8?B?WEtEQzE0USs0RFVmNzJhSjYvcWE4TEJXM2xsMlNVWHp1ZzJQQ2JFV21aa3J1?=
 =?utf-8?B?bU1ibWgwbDJnUjRCZ3loNWJTL3dxWnZzL3RaWEVCRUoxSUZrZDRkVWQyTnR5?=
 =?utf-8?B?dm9nb0t1Z3FoeDZuRXRmT2JmYTNhUGZ4eVJmeTdCM3FpT1c4OEJwbHg1WUpq?=
 =?utf-8?B?TWhGSkVVUDhBQmZPNHdIZDF0Ly9OdU9EdHkweEc1c1JMQnFzaEh3c2g2V290?=
 =?utf-8?B?dlVKNmIrYlVHQ1JwQTZHSmpaM2R0dURRNFBUL2lGNHBYbHh0QjJTTVJMV2M2?=
 =?utf-8?B?RmY2V0FBOTNIM1lvdVJJVmRrQUZhaklhYTByalVpQmJYL2FkQko4cnF2VFVI?=
 =?utf-8?B?czYzZ2VzTDYrL3krTXUwdEFjN1gxaWU0QVVmUjdOeDJoTVZhMFZ6bll2WDYy?=
 =?utf-8?B?NG9vOWhyM2h3QTM1VmJQeVV5UmZ1dG9qOS8vWGdzQ2VTWEpSb3lCVlk4MHVq?=
 =?utf-8?B?clh0N0h4aERQb2N5NGNET1o2aktiOUVZcmVVRVVsSk9oMXVnVzdiOURTeHlO?=
 =?utf-8?B?T0kwcnlNNVFaNHJVVFQ2eUtoTHNGY1NmdG9uVXVjQlZvbEhOWTRPUDZyck1l?=
 =?utf-8?B?YTY0R1duMWhmUHpLalpSeUxqREpyaTJpSk1sUDhIY3lBZXlYTDQzTXdVc05x?=
 =?utf-8?B?QkhaVVRMOE1PTU5MWHBZQmtoa2VRd2Z0QlZkbE1HdzNKOTlLZ3ZpM2J3dUN4?=
 =?utf-8?B?eVVPZEozdktWRG5ITlByQzgveW9kcDhBYmpoY2dvMzRFZWM2cDhjckV4YmN2?=
 =?utf-8?B?SmI4dkxhUFFJRHYrUStPakdmWVNYb0J4S3d0VGsrZ2ljdWZVYTZYZHNHdHF0?=
 =?utf-8?B?T01Pd3IyVjU3a0NUSjVXVGNsajEyNGRvQ3J1czdTMGJ6SCt1bU5sOURYdVFm?=
 =?utf-8?B?ODBkY0VESzJxMzkwdlg4cmRDNW5IV2kzNHdGWkVWVW1JMkVTOHZjN2d5Rkg4?=
 =?utf-8?B?bUFNc3NSN2ZjMW1QSlpGNE5sZnRkaXN2ZTVFVjhzUk9uZ0VTandDK0Zsb2lB?=
 =?utf-8?B?V292WTRTWTR2MjRTb1pkOW12WFJrYXlMajkrN3RVTjhLa1pUKzlTSDhXU3hL?=
 =?utf-8?B?OGIwY1paVnNuK3k3R0RJYkcwRkZPNXJXblFjVWF5ZHdPOGJyZUxGNHFmbEZ0?=
 =?utf-8?B?OHkzdCtRL2dSOW9talNERDJqWGFyd0txUytyL3pJZ1lRcHIxQnlNdnRlQ0p3?=
 =?utf-8?B?cGJTQUl4WGJSZXZJT1RMRjhyeUs3aFFoYlZkZnllOWgzdHArdC9qZ0dtNUVR?=
 =?utf-8?B?OHJlNlVWc2RGaGJFczhtNm43R0IwRWpwZnRvWmdSWkRmVUE1N0xjbG8yVVU1?=
 =?utf-8?B?eWtFd0pNTHVwYk54NEtUVUx0TndzckRJdzh6c1dmWXJ5Q2QwbEFNRXFnQUFC?=
 =?utf-8?B?T3Z3MkZldXAwamRra3ZtZEFPMU1WRE4yc0RtclZSRkdLOXhITnBxYjFxYjJX?=
 =?utf-8?B?ZDBpZ29DcHZFTVZES1k2dEF1U2RVWWlCNVQxYTBlNHB1a3phMllQVVhFNThu?=
 =?utf-8?B?dzN5aS95S2pDRkMyaWlGaytKcGZIYTM3d1NvS0h3MUxHMnkxQmJobktFS3RC?=
 =?utf-8?B?Z0xwUkVjdVRoOFRpREkwUFFINis4S1B0Q2NLbFV2RWtzS1BhN25QYWlVTURX?=
 =?utf-8?B?MGVaTUNJS1Q2eWhNNEZiZzZqdGUyTG51V29aZmpYQnExMHMxaXUweG05cGd0?=
 =?utf-8?B?MGVPbnZKdFlrN2YySFJzM2E4LzVnbkp1RWYxL3BNOFVEencydUdsdjNnakVq?=
 =?utf-8?Q?JMwuF1up32HPr2jLqx89ZLLXt7PjfFfx?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UXZtci9kWTRkUGUycFVYNFlUZ3FUbFRla3RVdEtsVjlmVkxkcW5xSm0xTEEw?=
 =?utf-8?B?eHRKR2pvOHhhcDhPTmJnTDFuejRSL0lqWldXQ1h1aGFOODk3OGdnRGlpMjVq?=
 =?utf-8?B?VlBuUnAvQUdaaERsMjJOakk5VENhbHhENVd6cHNJZ3YwS2JUK0FKT1Uvd0dN?=
 =?utf-8?B?N0tuMEF4b2VSOS9KdXBvZ1FZRUJDNFVDMitPTHZDZDUvSGRudjJkK2x2ajhY?=
 =?utf-8?B?QTBCcFpoYk9YWExpSjk3UThZVFd3V2xOY05BRmF0QSt0eFR4cGliV3A3dWdr?=
 =?utf-8?B?WVBSRDBycCs3S3JqRk5pU1UwRmtYeG5KZ2MwRi9XaVUyZjh5eDBRNEI0R1Qv?=
 =?utf-8?B?bEd3ald2Ym4zRkJrV3p3Z1VVQ2pWWFB3RHFDa3gxUlZmektlTUkvYW9VcUVk?=
 =?utf-8?B?U2VzMXhxQUVxWlNsSlhtZ0trOVRmd3dFRjJES1FYZG56d3dPam83dE1WTkdv?=
 =?utf-8?B?WWNSRVhrbTBDNTdOUU1rYnNwZWhxYnBVQXpOQlowL0h2ZldZMTYvODVTWklL?=
 =?utf-8?B?YVNOYXB1bjRMN0N0Zm4reGpkQXcyOFhMQ01NS1VMeXFwQ2RHWUJHWXZsSzZv?=
 =?utf-8?B?ZzUzR3FWTEtaQ3RNeUJEbWhXUk9Eamp6dENWYThCdnB3R2I4QTB1dENlYzZG?=
 =?utf-8?B?TWs3eVlIV0luQ0xNVFU3NHhIWG1WZHk3citjdEdSTEpNYlJJVDlRSFdEdE02?=
 =?utf-8?B?WVk5UUxnQ0YrclVtaVdNQ2QrRnNoaUdPUGpwbUI4Tm8yVHA4STJxVWxqb2dO?=
 =?utf-8?B?Zyt4ZHRlYjJlMHRRV212ajNRcWFhTHFYMjRuUXRkQ0VvMVM0YXYvSGlVN25U?=
 =?utf-8?B?UTYzcVA2Mk92aUFxVXJSaXlWajg5QVZBT1hER3JHRlNsc2o3bjdSSUxrWHl0?=
 =?utf-8?B?Y05Xek10VFFUN25FNThFc1ZrdW9uS1NBVHg2a1U4WXFjNHFqYWhjYnFlK0x5?=
 =?utf-8?B?azJ5RkhPYVF5VFlBQjVzcHpnQTgvQkZ3aWRVaW5SSk53QlcvRE1vVk1ubU5B?=
 =?utf-8?B?TzBIa3hUVStHazV3cnRxYXVDWkF2bDhlRmxXMEZDNWpZTndFSVErWlRtclFR?=
 =?utf-8?B?VExjOGdjVWZqRmtwZkhoS0k0SE8wcXBzM3JIT3VjZ2xLSlNnK0psUGIwOG82?=
 =?utf-8?B?eTFibU5ydW1iVVJ1UmlDSjhhWnYyOUVCNklYNXQyZ2NrZTZCdTBtY0pCRG9D?=
 =?utf-8?B?RlpxRXNqUHRXb2dBeUg3bEdvVWoxaUNkT0Z3QUVKdXJ5ODhIQmE3ajJQRkNO?=
 =?utf-8?B?MmdibktobGdzeHdiMnZLSEJzRytYNlBrdHdDV0xnUnZhbkF5MisxK3EzT1A2?=
 =?utf-8?B?RVZGdWdjWjczS0hXZ1c5dEJQSG1YTWgyVHFRY282ZDdHRnBGYS9zcDE3V1M3?=
 =?utf-8?B?UTZxNDRaby9kb3Y3K0RLYjl5T0VKc0ZEanRJTDVIQS9pYjJCRVJaQTBzWmZo?=
 =?utf-8?B?QWVacC93bDQrRGI0ZWx0NHdXVndQNk02Wk5lSU5FS0c4S1I4Wk5xdnF2WWtm?=
 =?utf-8?B?UmMvMVJoUFRUOE9rNFRQdWZmRXVuNUxhT1I3ZGZiZzFoQ3plRkVnZ1FyV3Rw?=
 =?utf-8?B?QWsrSUNBaGZKNG53T0xlZkdNL1I3c1loY0V3L1JsS3ZHd09Za2dsK2VsZW9S?=
 =?utf-8?B?aGI3RCtFbkNHdjV2NnNvZW1icjFUWVgwZFU1NXF5TFZXY29IZ3VzRVI4RTNC?=
 =?utf-8?B?MmZQN1kvajVkc1VHMml6WmMxeUhxbEljOCtpZFAzK25hM0VNRE42aGpvc1F3?=
 =?utf-8?B?SmYyZ2s2c1VlRE9NcGdyZTFIT1FsKzJLd1h4V3RvOGpaNWhvNk05dnk3ME5m?=
 =?utf-8?B?MkllQUFpaXVyN0dxSFRZbkYraEI4enpSdnZSa2g4dXdWZ1VGWWF1YUx6UFFU?=
 =?utf-8?B?SlZOTUMrNUU5T3drNnR5RzNZeFNIRnRRN1BSd3Z4ZlZydlFqMUxCTGlQZ0R6?=
 =?utf-8?B?WmNlblhZb0hiOWZIaVlYcW03YlgxZGpiNFVVQlg4OEFFck13U3RNUldWSUtD?=
 =?utf-8?B?aXhJS2VuTW1OaHdXSFR1V0lRWDNjQ2JYSEw5TTJYZ0lsU0o3RTFCaTJZamN6?=
 =?utf-8?B?bHp3MjlMNVFTYUs5b2xjNjVCblNBcE41Y2FHRklaK0pSTnJCUDlnNGpqbGZh?=
 =?utf-8?Q?0kEt8W5yjUAowJsMXOAxdc5Zy?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 294cb75a-9226-4237-a334-08de314728f1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 02:04:43.6384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xMjaGLDOjAg1ak/vhuNGmABddEYBBPShKdw4Cmh1wS8ePPsPa/nYwv1oFdGI0xxxJvA7mk/N72yX+LZ7TJnoFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9162



On 2/12/25 02:23, Tom Lendacky wrote:
> On 11/21/25 02:06, Alexey Kardashevskiy wrote:
>> Implement the SEV-TIO (Trusted I/O) firmware interface for PCIe TDISP
>> (Trust Domain In-Socket Protocol). This enables secure communication
>> between trusted domains and PCIe devices through the PSP (Platform
>> Security Processor).
>>
>> The implementation includes:
>> - Device Security Manager (DSM) operations for establishing secure links
>> - SPDM (Security Protocol and Data Model) over DOE (Data Object Exchange)
>> - IDE (Integrity Data Encryption) stream management for secure PCIe
>>
>> This module bridges the SEV firmware stack with the generic PCIe TSM
>> framework.
>>
>> This is phase1 as described in Documentation/driver-api/pci/tsm.rst.
>>
>> On AMD SEV, the AMD PSP firmware acts as TSM (manages the security/trust).
>> The CCP driver provides the interface to it and registers in the TSM
>> subsystem.
>>
>> Implement SEV TIO PSP command wrappers in sev-dev-tio.c and store
>> the data in the SEV-TIO-specific structs.
>>
>> Implement TSM hooks and IDE setup in sev-dev-tsm.c.
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>> ---
>> Changes:
>> v2:
>> * address bunch of comments from v1 (almost all)
>> ---
>>   drivers/crypto/ccp/Kconfig       |   1 +
>>   drivers/crypto/ccp/Makefile      |   8 +
>>   drivers/crypto/ccp/sev-dev-tio.h | 142 ++++
>>   drivers/crypto/ccp/sev-dev.h     |   7 +
>>   include/linux/psp-sev.h          |   7 +
>>   drivers/crypto/ccp/sev-dev-tio.c | 863 ++++++++++++++++++++
>>   drivers/crypto/ccp/sev-dev-tsm.c | 405 +++++++++
>>   drivers/crypto/ccp/sev-dev.c     |  48 +-
>>   8 files changed, 1480 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
>> index f394e45e11ab..3e737d3e21c8 100644
>> --- a/drivers/crypto/ccp/Kconfig
>> +++ b/drivers/crypto/ccp/Kconfig
>> @@ -25,6 +25,7 @@ config CRYPTO_DEV_CCP_CRYPTO
>>   	default m
>>   	depends on CRYPTO_DEV_CCP_DD
>>   	depends on CRYPTO_DEV_SP_CCP
>> +	select PCI_TSM
> 
> This shouldn't be here. This is CCP related, not SEV related. This
> should be moved under CRYPTO_DEV_SP_PSP.
> 
>>   	select CRYPTO_HASH
>>   	select CRYPTO_SKCIPHER
>>   	select CRYPTO_AUTHENC
>> diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
>> index a9626b30044a..839df68b70ff 100644
>> --- a/drivers/crypto/ccp/Makefile
>> +++ b/drivers/crypto/ccp/Makefile
>> @@ -16,6 +16,14 @@ ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) += psp-dev.o \
>>                                      hsti.o \
>>                                      sfs.o
>>   
>> +ifeq ($(CONFIG_CRYPTO_DEV_SP_PSP)$(CONFIG_PCI_TSM),yy)
>> +ccp-y += sev-dev-tsm.o sev-dev-tio.o
>> +endif
>> +
>> +ifeq ($(CONFIG_CRYPTO_DEV_SP_PSP)$(CONFIG_PCI_TSM),my)
>> +ccp-m += sev-dev-tsm.o sev-dev-tio.o
>> +endif
>> +
> 
> Would it be clearer / cleaner to do:
> 
> ifeq ($(CONFIG_PCI_TSM),y)
> ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) += sev-dev-tsm.o sev-dev-tio.o
> endif
> 
>>   obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) += ccp-crypto.o
>>   ccp-crypto-objs := ccp-crypto-main.o \
>>   		   ccp-crypto-aes.o \
>> diff --git a/drivers/crypto/ccp/sev-dev-tio.h b/drivers/crypto/ccp/sev-dev-tio.h
>> new file mode 100644
>> index 000000000000..7c42351210ef
>> --- /dev/null
>> +++ b/drivers/crypto/ccp/sev-dev-tio.h
>> @@ -0,0 +1,142 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +#ifndef __PSP_SEV_TIO_H__
>> +#define __PSP_SEV_TIO_H__
>> +
>> +#include <linux/pci-tsm.h>
>> +#include <linux/tsm.h>
>> +#include <linux/pci-ide.h>
>> +#include <uapi/linux/psp-sev.h>
>> +
>> +#if defined(CONFIG_CRYPTO_DEV_SP_PSP)
> 
> Since the TSM related files are included based on CONFIG_PCI_TSM,
> shouldn't this use CONFIG_PCI_TSM?> +
>> +struct sla_addr_t {
>> +	union {
>> +		u64 sla;
>> +		struct {
>> +			u64 page_type:1;
>> +			u64 page_size:1;
>> +			u64 reserved1:10;
>> +			u64 pfn:40;
>> +			u64 reserved2:12;
> 
> 	u64 page_type	:1,
> 	    page_size	:1,
> 	    reserved1	:10,
> 	    pfn		:40,
> 	    reserved2	:12;

okay for formatting but...

> 
> This makes it easier to understand. Please do this everywhere you define
> bitfields.

...I really want to keep the union here (do not care in other places though) for easier comparison of a whole structure.


> 
>> +		};
>> +	};
>> +} __packed;
>> +
>> +#define SEV_TIO_MAX_COMMAND_LENGTH	128
>> +
>> +/* SPDM control structure for DOE */
>> +struct tsm_spdm {
>> +	unsigned long req_len;
>> +	void *req;
>> +	unsigned long rsp_len;
>> +	void *rsp;
>> +};
>> +
>> +/* Describes TIO device */
>> +struct tsm_dsm_tio {
>> +	u8 cert_slot;
>> +	struct sla_addr_t dev_ctx;
>> +	struct sla_addr_t req;
>> +	struct sla_addr_t resp;
>> +	struct sla_addr_t scratch;
>> +	struct sla_addr_t output;
>> +	size_t output_len;
>> +	size_t scratch_len;
>> +	struct tsm_spdm spdm;
>> +	struct sla_buffer_hdr *reqbuf; /* vmap'ed @req for DOE */
>> +	struct sla_buffer_hdr *respbuf; /* vmap'ed @resp for DOE */
>> +
>> +	int cmd;
>> +	int psp_ret;
>> +	u8 cmd_data[SEV_TIO_MAX_COMMAND_LENGTH];
>> +	void *data_pg; /* Data page for DEV_STATUS/TDI_STATUS/TDI_INFO/ASID_FENCE */
>> +
>> +#define TIO_IDE_MAX_TC	8
>> +	struct pci_ide *ide[TIO_IDE_MAX_TC];
>> +};
>> +
>> +/* Describes TSM structure for PF0 pointed by pci_dev->tsm */
>> +struct tio_dsm {
>> +	struct pci_tsm_pf0 tsm;
>> +	struct tsm_dsm_tio data;
>> +	struct sev_device *sev;
>> +};
>> +
>> +/* Data object IDs */
>> +#define SPDM_DOBJ_ID_NONE		0
>> +#define SPDM_DOBJ_ID_REQ		1
>> +#define SPDM_DOBJ_ID_RESP		2
>> +
>> +struct spdm_dobj_hdr {
>> +	u32 id;     /* Data object type identifier */
>> +	u32 length; /* Length of the data object, INCLUDING THIS HEADER */
>> +	union {
>> +		u16 ver; /* Version of the data object structure */
>> +		struct {
>> +			u8 minor;
>> +			u8 major;
>> +		} version;
>> +	};
>> +} __packed;
>> +
>> +/**
>> + * struct sev_tio_status - TIO_STATUS command's info_paddr buffer
>> + *
>> + * @length: Length of this structure in bytes
>> + * @tio_en: Indicates that SNP_INIT_EX initialized the RMP for SEV-TIO
>> + * @tio_init_done: Indicates TIO_INIT has been invoked
>> + * @spdm_req_size_min: Minimum SPDM request buffer size in bytes
>> + * @spdm_req_size_max: Maximum SPDM request buffer size in bytes
>> + * @spdm_scratch_size_min: Minimum SPDM scratch buffer size in bytes
>> + * @spdm_scratch_size_max: Maximum SPDM scratch buffer size in bytes
>> + * @spdm_out_size_min: Minimum SPDM output buffer size in bytes
>> + * @spdm_out_size_max: Maximum for the SPDM output buffer size in bytes
>> + * @spdm_rsp_size_min: Minimum SPDM response buffer size in bytes
>> + * @spdm_rsp_size_max: Maximum SPDM response buffer size in bytes
>> + * @devctx_size: Size of a device context buffer in bytes
>> + * @tdictx_size: Size of a TDI context buffer in bytes
>> + * @tio_crypto_alg: TIO crypto algorithms supported
>> + */
>> +struct sev_tio_status {
>> +	u32 length;
>> +	union {
>> +		u32 flags;
>> +		struct {
>> +			u32 tio_en:1;
>> +			u32 tio_init_done:1;
>> +		};
>> +	};
>> +	u32 spdm_req_size_min;
>> +	u32 spdm_req_size_max;
>> +	u32 spdm_scratch_size_min;
>> +	u32 spdm_scratch_size_max;
>> +	u32 spdm_out_size_min;
>> +	u32 spdm_out_size_max;
>> +	u32 spdm_rsp_size_min;
>> +	u32 spdm_rsp_size_max;
>> +	u32 devctx_size;
>> +	u32 tdictx_size;
>> +	u32 tio_crypto_alg;
>> +	u8 reserved[12];
>> +} __packed;
>> +
>> +int sev_tio_init_locked(void *tio_status_page);
>> +int sev_tio_continue(struct tsm_dsm_tio *dev_data);
>> +
>> +int sev_tio_dev_create(struct tsm_dsm_tio *dev_data, u16 device_id, u16 root_port_id,
>> +		       u8 segment_id);
>> +int sev_tio_dev_connect(struct tsm_dsm_tio *dev_data, u8 tc_mask, u8 ids[8], u8 cert_slot);
>> +int sev_tio_dev_disconnect(struct tsm_dsm_tio *dev_data, bool force);
>> +int sev_tio_dev_reclaim(struct tsm_dsm_tio *dev_data);
>> +
>> +#endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
>> +
>> +#if defined(CONFIG_PCI_TSM)
>> +void sev_tsm_init_locked(struct sev_device *sev, void *tio_status_page);
>> +void sev_tsm_uninit(struct sev_device *sev);
>> +int sev_tio_cmd_buffer_len(int cmd);
>> +#else
>> +static inline int sev_tio_cmd_buffer_len(int cmd) { return 0; }
>> +#endif
>> +
>> +#endif	/* __PSP_SEV_TIO_H__ */
>> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
>> index b9029506383f..dced4a8e9f01 100644
>> --- a/drivers/crypto/ccp/sev-dev.h
>> +++ b/drivers/crypto/ccp/sev-dev.h
>> @@ -34,6 +34,8 @@ struct sev_misc_dev {
>>   	struct miscdevice misc;
>>   };
>>   
>> +struct sev_tio_status;
>> +
>>   struct sev_device {
>>   	struct device *dev;
>>   	struct psp_device *psp;
>> @@ -61,6 +63,11 @@ struct sev_device {
>>   
>>   	struct sev_user_data_snp_status snp_plat_status;
>>   	struct snp_feature_info snp_feat_info_0;
>> +
>> +#if defined(CONFIG_PCI_TSM)
>> +	struct tsm_dev *tsmdev;
>> +	struct sev_tio_status *tio_status;
>> +#endif
> 
> Do you need the #if here? Can this just be part of the sev_device struct
> and just always NULL if CONFIG_PCI_TSM isn't set?
> 
> Is "struct tsm_dev" not defined if CONFIG_PCI_TSM isn't 'y'? I would
> think it would be simpler for all to have that defined no matter what.
>>   };
>>   
>>   int sev_dev_init(struct psp_device *psp);
>> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
>> index c0c817ca3615..cce864dbf281 100644
>> --- a/include/linux/psp-sev.h
>> +++ b/include/linux/psp-sev.h
>> @@ -109,6 +109,13 @@ enum sev_cmd {
>>   	SEV_CMD_SNP_VLEK_LOAD		= 0x0CD,
>>   	SEV_CMD_SNP_FEATURE_INFO	= 0x0CE,
>>   
>> +	/* SEV-TIO commands */
>> +	SEV_CMD_TIO_STATUS		= 0x0D0,
>> +	SEV_CMD_TIO_INIT		= 0x0D1,
>> +	SEV_CMD_TIO_DEV_CREATE		= 0x0D2,
>> +	SEV_CMD_TIO_DEV_RECLAIM		= 0x0D3,
>> +	SEV_CMD_TIO_DEV_CONNECT		= 0x0D4,
>> +	SEV_CMD_TIO_DEV_DISCONNECT	= 0x0D5,
>>   	SEV_CMD_MAX,
>>   };
>>   
>> diff --git a/drivers/crypto/ccp/sev-dev-tio.c b/drivers/crypto/ccp/sev-dev-tio.c
>> new file mode 100644
>> index 000000000000..f7b2a515aae7
>> --- /dev/null
>> +++ b/drivers/crypto/ccp/sev-dev-tio.c
> 
> ...
> 
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index 2f1c9614d359..365867f381e9 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -38,6 +38,7 @@
>>   
>>   #include "psp-dev.h"
>>   #include "sev-dev.h"
>> +#include "sev-dev-tio.h"
>>   
>>   #define DEVICE_NAME		"sev"
>>   #define SEV_FW_FILE		"amd/sev.fw"
>> @@ -75,6 +76,12 @@ static bool psp_init_on_probe = true;
>>   module_param(psp_init_on_probe, bool, 0444);
>>   MODULE_PARM_DESC(psp_init_on_probe, "  if true, the PSP will be initialized on module init. Else the PSP will be initialized on the first command requiring it");
>>   
>> +#if defined(CONFIG_PCI_TSM)
> 
> Not sure the module parameter should be hidden in this case. But if you

The module parameter won't do anything, why keep it exposed, only because of ifdefs?


> do want it hidden, why not move the #if down one line so that
> sev_tio_enabled is always defined. And then...
> 
>> +static bool sev_tio_enabled = true;
> 
> static bool sev_tio_enabled = IS_ENABLED(CONFIG_PCI_TSM)
> 
> will give the proper default.
>> +module_param_named(tio, sev_tio_enabled, bool, 0444);
>> +MODULE_PARM_DESC(tio, "Enables TIO in SNP_INIT_EX");
>> +#endif
>> +
>>   MODULE_FIRMWARE("amd/amd_sev_fam17h_model0xh.sbin"); /* 1st gen EPYC */
>>   MODULE_FIRMWARE("amd/amd_sev_fam17h_model3xh.sbin"); /* 2nd gen EPYC */
>>   MODULE_FIRMWARE("amd/amd_sev_fam19h_model0xh.sbin"); /* 3rd gen EPYC */
>> @@ -251,7 +258,7 @@ static int sev_cmd_buffer_len(int cmd)
>>   	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
>>   	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_data_snp_feature_info);
>>   	case SEV_CMD_SNP_VLEK_LOAD:		return sizeof(struct sev_user_data_snp_vlek_load);
>> -	default:				return 0;
>> +	default:				return sev_tio_cmd_buffer_len(cmd);
>>   	}
>>   
>>   	return 0;
>> @@ -1439,8 +1446,14 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>>   		data.init_rmp = 1;
>>   		data.list_paddr_en = 1;
>>   		data.list_paddr = __psp_pa(snp_range_list);
>> +
>> +#if defined(CONFIG_PCI_TSM)
>>   		data.tio_en = sev_tio_present(sev) &&
>> +			sev_tio_enabled && psp_init_on_probe &&
> 
> Why add the psp_init_on_probe check here? Why is it not compatible?
> psp_init_on_probe is for SEV and SEV-ES, not SNP.

If psp_init_on_probe is not set, then systemd (or modprobe?) loads kvm_amd and at that point SEV init is delayed but SNP init is not so SEV-TIO gets enabled.

Then, there is some systemd service in my test Ubuntu which:
1) runs QEMU to discover something, with SEV enabled, that trigger SEV_PDH_CERT_EXPORT
2) the kernel ioctl handler has to initialize SEV
3) sev_move_to_init_state() returns shutdown_required=true (it does not distinguish SEV and SNP)
4) the SEV_PDH_CERT_EXPORT handler shuts down both SEV and SNP (which includes SEV-TIO).

The right thing to do is just not use psp_init_on_probe as it is really a debugging knob. But people are going to use it while DOWNLOAD_EX (which we need this psp_init_on_probe thing for) and SEV-TIO are still in their infancy. It took me half a day to sort this all in my head, hence the check.

I will remove it from the above but leave the warning below and add the comment:

/*
  * When psp_init_on_probe is disabled, the userspace calling SEV ioctl
  * can inadvertently shut down SNP and SEV-TIO during initialization,
  * causing unexpected state loss.
  */


> Instead of the #if, please use IS_ENABLED(CONFIG_PCI_TSM) so that the
> #ifdefs can be eliminated from the code.
> 
> Having all these checks in sev_tio_supported() (comment from earlier
> patch) will simplify things.

I am open coding sev_tio_supported(), and ditching 4/5, seems pointless as hardly anyone will want to enable just TIO in the PSP without the host os support for it, right?


>>   			amd_iommu_sev_tio_supported();
>> +		if (sev_tio_present(sev) && !psp_init_on_probe)
>> +			dev_warn(sev->dev, "SEV-TIO as incompatible with psp_init_on_probe=0\n");
>> +#endif
>>   		cmd = SEV_CMD_SNP_INIT_EX;
>>   	} else {
>>   		cmd = SEV_CMD_SNP_INIT;
>> @@ -1487,6 +1500,24 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>>   	atomic_notifier_chain_register(&panic_notifier_list,
>>   				       &snp_panic_notifier);
>>   
>> +#if defined(CONFIG_PCI_TSM)
> 
> Does this have to be here? If the functions are properly #ifdef'd in the
> header file, then you won't have a compile issue and tio_en would only
> be set if CONFIG_PCI_TSM is y.>>> +	if (data.tio_en) {
>> +		/*
>> +		 * This executes with the sev_cmd_mutex held so down the stack
>> +		 * snp_reclaim_pages(locked=false) might be needed (which is extremely
>> +		 * unlikely) but will cause a deadlock.
>> +		 * Instead of exporting __snp_alloc_firmware_pages(), allocate a page
>> +		 * for this one call here.
>> +		 */
>> +		void *tio_status = page_address(__snp_alloc_firmware_pages(
>> +			GFP_KERNEL_ACCOUNT | __GFP_ZERO, 0, true));
>> +
>> +		if (tio_status) {
>> +			sev_tsm_init_locked(sev, tio_status);
>> +			__snp_free_firmware_pages(virt_to_page(tio_status), 0, true);
>> +		}
>> +	}
>> +#endif
> 
> Add a blank line here.
> 
>>   	sev_es_tmr_size = SNP_TMR_SIZE;
>>   
>>   	return 0;
>> @@ -2766,7 +2797,22 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic)
>>   
>>   static void sev_firmware_shutdown(struct sev_device *sev)
>>   {
>> +#if defined(CONFIG_PCI_TSM)
> 
> Ditto on the #if here. Shouldn't the function be properly ifdef'd in the
> header file which would not require this?>> +	/*
>> +	 * Calling without sev_cmd_mutex held as TSM will likely try disconnecting
>> +	 * IDE and this ends up calling sev_do_cmd() which locks sev_cmd_mutex.
>> +	 */
>> +	if (sev->tio_status)
>> +		sev_tsm_uninit(sev);
> 
> Should this be part of __sev_firmware_shutdown() or
> __sev_snp_shutdown_locked()?

As the comment above explains, the sev_cmd_mutex is a problem. I'd have to have to modes of tsm::disconnect - one triggered by the user and called without sev_cmd_mutex, and the other one coming from here with sev_cmd_mutex.


> 
>> +#endif
>> +
>>   	mutex_lock(&sev_cmd_mutex);
>> +
>> +#if defined(CONFIG_PCI_TSM)
> 
> Ditto here. Without CONFIG_PCI_TSM, sev->tio_status will be NULL
> already, so kfree() will just return.

The ifdef is here because there was one in sev-dev.h, I am dropping it now.

>> +	kfree(sev->tio_status);
>> +	sev->tio_status = NULL;
> 
> Wouldn't it be safer to do this after the call to
> __sev_firmware_shutdown() in case that function some day needs to use
> that structure?

Uff. Right, __sev_firmware_shutdown() shuts down both SNP and SEV, I'll move that down.
> 
> Thanks,

Thanks for the review!


> Tom
> 
>> +#endif
>> +
>>   	__sev_firmware_shutdown(sev, false);
>>   	mutex_unlock(&sev_cmd_mutex);
>>   }
> 

-- 
Alexey

