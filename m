Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010002.outbound.protection.outlook.com [52.101.193.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DCE366DBE;
	Mon, 12 Jan 2026 16:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768235649; cv=fail; b=aICzlWUxSqkEJBp9cB3+NRK9T48G4dhnkegl3a6PRucPTdyQT8Am+hJUXpXCYc1Rns3CwP8u+csgo41vAx4qnfWFvzj4w+VKleuvbnJT8O1hGNYbVzecOj/qRlU2kZT3uRzc6Ysu9RybfMep9P8/f8YO6eAIzj2cYv4YS1sgBXw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768235649; c=relaxed/simple;
	bh=A2SYw3HApn6gZ8Lo+n5Q4PHvX5Hhv14i9JBtRj5Ozyk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=goapSfRKIqSKTTCE+LI+5akvpjlIzHXWXJhicUye6RfxV9b1TR6Ln1G6KKjEgqxPvW8COmuUYt5vozsNl1UdX2ZX241nlCSLDD6o69nqyWoZkQrE8p+YfDdZnrWYR2qRIG9e4FTyGI5KfN/iGE2idfLKmMFLU8EU5CcAgt6xdyM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GuPkPKh8; arc=fail smtp.client-ip=52.101.193.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GuPkPKh8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u1hPCZKi3ajAgSD3oQPQgCW9wtk4uqvAvf8PG1JV3nDwrhAt8yU9x829B+LY2JQR1zslGbz0viONuaB2C+8S4NQqd9PO/rb9LQBDfB2e1B1g8jDh1GTHYK0O4ErV4KkPeizNHyZuT7yGSyFLUeoZmcLADclOni8I9sldMFhjebV3Rs1l0yMzqoqMo8p2Cg8CNZKxFzEyX6sD8EwGGC+whK5t+5AvWiXbCrqPhgJXbJhH8HcvF9CvizL9uy5QPBCy+MdIlS/x7OwMef9gsUn8fLEz7nzqdoPk3S8/lhooeHwbJZhnxcQ117EoeaqFwj2M0au9CiDQSEfC/EtcIN9f+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OcuwgVnZ9y0kOyc2mVJG+m/eALEFoGIa0CgpJtR3rRs=;
 b=pQJIg5jo5K55IW5+7SS3cRgGyQDTv+PbtxnesAO4GfyoQJFqj6VWUEZw9gBd7VVkwAUZ4t5BcJb3faQKbdra7Zw91CZbVY5ImUSdrWHmGhGLrIkgvVSXyXpq8Jry34H0g6e67Xt2t4RqgkofY3fyNhmmPUJYmvdQcDHq+VaodRYl0vcXmhYaimY1fnjGgpIr3hYM02tOw1PEs5H2E42NdssUHXGgeeyIV9t2X3RtpJ8n+nRwyZ+bsanfohmQJl4ycvmO93i5QxgEle4ICUXhlCCkQ/pviDqskOq/SsSE2qQ1JuHT/u4El34kf0ocg2/tsMbVK6WCEx7Ni9FBVGAntw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OcuwgVnZ9y0kOyc2mVJG+m/eALEFoGIa0CgpJtR3rRs=;
 b=GuPkPKh8BIHNXwfFBELrG5I67cxPyqWSBr+Xi+uXAdO0BbxREjz6/h9aYztcyZsMLcC+/ivm1bMQ7whcQbgRtHo093sm6eRUC/gpv73lLMHeDs/sKvHs3ilZeL/CyQvqjwvskvLB0YhoYF5rFUC+A4uZ6VspRxMhu8EeahucMvQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH3PR12MB7524.namprd12.prod.outlook.com (2603:10b6:610:146::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 16:34:04 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 16:34:04 +0000
Message-ID: <69f9b4eb-02a7-4a8f-8e77-903dee9e2de5@amd.com>
Date: Mon, 12 Jan 2026 10:33:57 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/5] crypto: ccp - Add an S4 restore flow
To: "Mario Limonciello (AMD)" <superm1@kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Rijo Thomas <Rijo-john.Thomas@amd.com>
Cc: John Allen <john.allen@amd.com>, "David S . Miller"
 <davem@davemloft.net>, Hans de Goede <hansg@kernel.org>,
 "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER"
 <linux-crypto@vger.kernel.org>,
 "open list:AMD PMF DRIVER" <platform-driver-x86@vger.kernel.org>,
 Lars Francke <lars.francke@gmail.com>, Yijun Shen <Yijun.Shen@dell.com>,
 Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
References: <20260112053610.2566943-1-superm1@kernel.org>
 <20260112053610.2566943-4-superm1@kernel.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260112053610.2566943-4-superm1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR05CA0046.namprd05.prod.outlook.com
 (2603:10b6:5:335::15) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH3PR12MB7524:EE_
X-MS-Office365-Filtering-Correlation-Id: dedc0c52-a5b1-49f1-a01a-08de51f8666a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dVJMUnlWbmZCYTNDVStvQlBiWWpwcnM0OGNzUWdXQTVsdnFra1NPQVFoalI0?=
 =?utf-8?B?clJSSkxIWGlFU3hGTnZEZVBiTFlMNXd1d2xVVERiT3RaNVNLWTgyMVUvanU5?=
 =?utf-8?B?Qk1QQWNoRDlyMlZnSnZqbFAwaTJpMUdIaCtVdGc5R1lxM2M0YWMwUXd1NWM2?=
 =?utf-8?B?UVJzY0ZpQ1NneVNQWG1GaDREbE11OE5FYmhMYm9ZU1lNMDJ5OFAvdGlMcTBt?=
 =?utf-8?B?ajV6SlZOR1lodThCOW4xQzI0NWphc3pWN0w1dGdqOGQ3bkVwSkVkYXZ3UDNM?=
 =?utf-8?B?WnljTERqeDIwQnE2QnIrOTFwNkVaaVh0eHVrODFadDErSjRzTmZlL1Z4T0lM?=
 =?utf-8?B?WmhnbU95L25SbWg1aUU2S2c4cEY5Y3p4aGNhZnNXUHB3dGswWDg2aVV5bk1t?=
 =?utf-8?B?MlhHTFFtdWNJcWllS2tYRU9sMG53N0NMeHZNNnpGd25aTkIvUlp2R0hMNTk0?=
 =?utf-8?B?K1NnUXRVZDJZKzN1YlNaZlVZcDhJYXF1NGVvT1JxUCszaGRvWUJIbDNKSEM2?=
 =?utf-8?B?WXlTOUQzRHJJbDZtNXJJclBXWG1yU1dXMHMzVmNaTUZTWE5UZ1Uxak9ZUVJq?=
 =?utf-8?B?U0ExNnczQ1hveHcxbnBhekNJZHhqUHp2NFJ2aEhlUXFxUDFCUUR2UmcwbGVU?=
 =?utf-8?B?MDZnOFNvRmdhNzRicWJMTmo1YzN5VG9OREg2dVc2UmFqWFdJQXVwd1NKbER6?=
 =?utf-8?B?ODFucy9VY203R0JxVloyd3RGZGtMaG9Cajk0cVBjZU54K1p6YlZXVlBHVkhP?=
 =?utf-8?B?Y1VjY3NKTUtOOTY0NFVoZGNsOWQ4UU9tcysvL0NxSm5CZVFYRE1IQzNkRXBa?=
 =?utf-8?B?WCtmRHAybWZpZGtVOEorOE5uMGZzVmVtQ0psRFkxQVdSWEcrRk9iRmRUR1lJ?=
 =?utf-8?B?bElVU1VvNURxM05HTW1mNUpuTm9oQlZPRS9KNlU3M0hja3pKWUw2NmNtSUpS?=
 =?utf-8?B?RlhBUlVlSjNKVGpVSWhTTTJ3WHhQa1Z3b3BTcEt3Q0hCT1RleWtuTG1MWWFz?=
 =?utf-8?B?RTZhTktzQTF1SmxLVXRSZkJ2L0dMei9KNlV5VS9yNXp5ejkvRTc1RjFwSTQ4?=
 =?utf-8?B?UkNvZzhvMStORDNHWStZNjZSS0Z3ajh4R2NtSU83OWk4U2tMM0NLQkFVdjRm?=
 =?utf-8?B?ZHYraDU0ejhtUlVKTDFIeGJHSXhxSTJVRTFrTFk4MHFUMFJXbjhlSkpMZ2dr?=
 =?utf-8?B?V0Fsb2JHVUdJRm9tRVV3QWNkT1F1QjZtbEVjLzNpZHJ2YjBJaHVxSHRTNld3?=
 =?utf-8?B?b3ZJUmlCRVdqQ0VnY0xxR0ZzcFJYeGRYZG9wK3ZLZW42aWZnNDdsNkxhNDhV?=
 =?utf-8?B?Vk0zdVBERGRvclVjd0s1RTZvNHQ1RzF1MkU3MFA1ZmVTNDdNNWFhaHlRYXpy?=
 =?utf-8?B?aldmUjZ0NXppZUZkTG9xdUEzaWNtRjJkZ0tMQnhpY2pHaGNlNEJsZCtkRWwx?=
 =?utf-8?B?bkVpZnVZUDliM0RsL3d5ekg3OCtIRCtQV2ErSlBKTmM4dWtJM0QwSG9EeWZm?=
 =?utf-8?B?V0dFMmdQTGZEdjMxb2hJL0FLMEIzcmphR2dVdzM5MnlmaWNHd25zdXU1aEFj?=
 =?utf-8?B?bEtXQmhKNlJvd2QzUWg5RkxGL3ZLOTluSEwrR1JVS3oxMmp2UEJNaGI4RXM2?=
 =?utf-8?B?cjBjcHlFaG4ybDliZzhzY014MjE0bjljUkF5RTQ2UXo5UW9VeEFtejNHLzR2?=
 =?utf-8?B?dmx1bFRJSFVMTkQwTlVhakdTbHlSQ1N2NzV6U2Y0dG84bG9qQkhhdTRlVUcz?=
 =?utf-8?B?c1R2L3lrK0YzS2RBNnlGVXhaQ3hiUlAwRG1RWkdZLzBydys5OW5kZmpvam90?=
 =?utf-8?B?Vk5jaW5LSCt0bFZoWC9mV3FWR1I3VmxLWjNaZ0pPcERab2dnWUxaT3lBS2VB?=
 =?utf-8?B?MG4xN3BaYmk0UEdJQVdXRzhpOWdzNGUrQUhUMHRwTkljVDBISlBKSG8vMXRH?=
 =?utf-8?B?aWJBUzM0cW5aaE82U1ErTGlZWFhFNnRGbWUrUCt3eEtrRm9HRTJmV1lqOFFk?=
 =?utf-8?B?eWwyam5KUTF3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?alN6T0xkYzJqdThOVmFKT2dNYTh5UlU5Tm9CeXYwTTZzUnpjUWlkSml2c0lQ?=
 =?utf-8?B?TTkyZlY0M2x6TEhjMld6cnlCdW9vczBtNUp3bWIvUTBZZ0s4c1ZVUnM4ZUxp?=
 =?utf-8?B?VkpxWjh1U00rZ1AxNXpCL29uNGljUkZ2bHVSanZaMDlGekRNU05pQVRjRVdT?=
 =?utf-8?B?TGRsNEQvSERTUDNHekxxY3FsWmdMVGRmc1pHWXBJdW54YTdRTDFIS2RPTXJJ?=
 =?utf-8?B?NHQ1VkZHYS9JSFovcFBkY20zZElxQldvdW1lZ3R2cHVUUjh2Zk1yaCttWFdr?=
 =?utf-8?B?TFR4OEtaR3VsL0ZTbHc3Z1hCalBJY3FUUXFTNlJ5MHZ3Z2l2SStWWEFpUFFl?=
 =?utf-8?B?YlRPYWNtRldUNUhEcENXU3g0MWpVbkhKTTUrVUxsRi9tSlVkSXZTaFVmYVBy?=
 =?utf-8?B?Y3dpcUpZQyt5VDJTQnhHY3FndnczMTF3ZzJwc1UzV2ZxRkhlWThHU2RnbFAr?=
 =?utf-8?B?OUhsY2dFZFF6aWJBWTZaazR0VVNTOUVVcjVxT0Q4UC9mb0Q4VzB3MzI4Tzkx?=
 =?utf-8?B?ak1BdUJUVDg1OGNlQlIzckZQeDZGOXIxelhVeFNNWTN5ZzNJeVZ5clFVS3lW?=
 =?utf-8?B?R3FFa0JnYUxrblYzMXdYVjlSU3VtUHNlUWpxVmJ5YWhSNWhISEtCUWxrK2dR?=
 =?utf-8?B?WXo5OGVrdVR4VGRadGZoNTFZenBqdkIwSVo1b0FUL3BNTStzNGpRd3lMVW5r?=
 =?utf-8?B?Nm1yb1hTcFI1ZmJ6UXorK0pudjIxeVNxZkdnak1hblFxU25XVEFRbVI4b3hS?=
 =?utf-8?B?Smd0akZVTTQrZ0J0UHQ2ZncrYUxNeTlXdjRPR2NZMVRDMDM3Z0ljdlNnTi8v?=
 =?utf-8?B?aC9od0pEb3VBR1R3N0lQYm5vZlNOQlVqMDl1WXNZVS9zYTRwWldvRFh1UWJ4?=
 =?utf-8?B?d0J1dVdkSjFmVC8xTDU2QjJ0NjBsbmdsWFh3WG92UFFjVFM3OC9xbjhOc3ZC?=
 =?utf-8?B?MCtmRWJ4RS9OMng5UjAvY1owUEtreTFvdHUxWU5YOVJHd01aMTdGWE4xOWxC?=
 =?utf-8?B?WVltalplekJacDkzcDV6M21MYlkyc2dqd012cEpOTjRCcUdUS2xPWWNOaTNt?=
 =?utf-8?B?cWpIdDhFNXltZ1B2em43aFpZM0xwMVdPUlR3M2NWSzVyL3hUWEpCd0Y5YjVI?=
 =?utf-8?B?NXA3VFU3QURNWm5YQlZVOG1NMFFMV0NGRWFNeWl3dEJQY1BaUjFIZnd2Z0xW?=
 =?utf-8?B?THVzSUQrM3hlMDJqZnpkUmpTOFV5MkpCTFJIaVIwd0NRbGVpQVk3SllnblE5?=
 =?utf-8?B?UUIzbjJPS2hCYTgvN3ZCTnpEanQ3VUVqMGxiZzZQcDh5ZG1pWDdUWXZZQXNs?=
 =?utf-8?B?eStjS2l1N0o4R2phK2FjS3RQVml0QW84N3ZhUlBJMWFDUGZYNld4anQ1WXRK?=
 =?utf-8?B?MkVhc3gvK21IWlY3OTY4R1FCdkRYcmp5akllWjNTcE03cG02MEFWbDhyb2dJ?=
 =?utf-8?B?b1MwRERLcUhBb1NPd29MYnMxaWRuMjd2N2RlU1FyQWFnYnpBT3ZFU0xoZDV3?=
 =?utf-8?B?UVFyMWRzLzlJb0YrZzI2Y29TeFJpYkFoYVZLRU1rZ1JpRFZsSzBwTEwxaFpT?=
 =?utf-8?B?Rzg5V0dDQ1dIeE8yeUh1c1RQeFRPUkZtd2QrcTN1YXNZQWs0U29JMzExblFO?=
 =?utf-8?B?cHNydVBLbnltWXUyc0pPeitNQTROWGo4QWVLMXNQemdwdGdQdVhyU2x3QmlD?=
 =?utf-8?B?ZWs0cEdJWW1BSzVobmh5RDBxT2xnSjRnTUVnTGRmN3AxWEY3TE9vN0FxbTZT?=
 =?utf-8?B?SnJIZWhOdzlyTlFnUVA3bUNpc1NjUjNGNFNNQmJ6K2pCQ3Rob3ZGOWxMTGo1?=
 =?utf-8?B?N3lkZ09ZQWh5My9zY3g1QStZb29vb21DWkRDdjlYTEl3UC9PT0NTeHk3cXlh?=
 =?utf-8?B?U1ZGSzduRGRDMDhYZCtIMnJUaGVIV2V5aWRRRDNHNlVRYWlUNVg4dTBJaHdn?=
 =?utf-8?B?dGxEOVZBUkRYOXkwdUZYT1IxcTlSVGp0SkxKVjZmaUJzV2JMek5FbWdVYVRw?=
 =?utf-8?B?VWpFWFJjbkJiVDJac1U1NG40cFlWb1Fqc0M5dFp6d0tKU2tGTWRRZlB4bENa?=
 =?utf-8?B?TkJyeWZaNmZZK0dOc3F2VUdkSk90cUdvQWFjNS9WeFhEOEd5cm8xeG40dUZO?=
 =?utf-8?B?TGRCSmZHc1YyWDNPb0R6NUZFMkZDaExRUlpQQi90SUtUZTRvNVpDd0dQMmd0?=
 =?utf-8?B?UW9USG8xaWFGdTQ3Sjc3Z2g3VUlFa2pWc0RFYkNWY1pLTys4Q0s1TmZZL2Fa?=
 =?utf-8?B?UHJxWWZBQldIa3E1SHZvSjVEUXF3RDdya2MwZzdmaG1Xb054TmkzQXJQRVpW?=
 =?utf-8?Q?YaBVOPw/z97V5yNsdD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dedc0c52-a5b1-49f1-a01a-08de51f8666a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 16:34:04.7144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2fUbeDI0mbto9W7dtjzray2Jx5GLbUuuUovjWfasIUhyZJmzLNHBj/9kmdibp5g5QmGn+aTzKqLV0F6rfOXk1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7524

On 1/11/26 23:36, Mario Limonciello (AMD) wrote:
> The system will have lost power during S4.  The ring used for TEE
> communications needs to be initialized before use.
> 
> Fixes: f892a21f51162 ("crypto: ccp - use generic power management")
> Reported-by: Lars Francke <lars.francke@gmail.com>
> Closes: https://lore.kernel.org/platform-driver-x86/CAD-Ua_gfJnQSo8ucS_7ZwzuhoBRJ14zXP7s8b-zX3ZcxcyWePw@mail.gmail.com/
> Tested-by: Yijun Shen <Yijun.Shen@Dell.com>
> Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
> ---
> v5:
>  * Fix return for psp_restore() (LKP robot, Shyam)
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
> index 9e21da0e298ad..5c7f7e02a7d8a 100644
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
> +	return ret;
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

This isn't needed since you have the "#else" definition in sp-dev.h.

> +	if (sp->psp_data) {
> +		int ret = psp_restore(sp);
> +

Remove blank line.

> +		if (ret)
> +			return ret;
> +	}
> +#endif

This isn't the way the other functions work. This function should just
be calling to sp_resume() and then sp_resume() should call psp_restore()
(or psp_dev_restore() ?) if the psp_data is present.

And if you need to distinguish between the resume and restore case in
sp_resume(), then it sounds like you need an sp_restore().

Thanks,
Tom

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

