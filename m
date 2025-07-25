Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2081.outbound.protection.outlook.com [40.107.94.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE868635C;
	Fri, 25 Jul 2025 15:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753456624; cv=fail; b=RfYYGMOIqH2w9B1htB127phRiTNr7CykDHJfK+C7rk52aPj88IfSRey7zy+mGghcuW99M3/IIjb9CWppL4HXhXGgKX/DWaUUJl3hjuJfMccy86wNvby7oinkEEKqr81jNgQw8U/RosrabwQO2PHTlcQNTCRqE7Josjsl6nDsfQo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753456624; c=relaxed/simple;
	bh=NSP9GJey5v1ZGofuO+xZerkOzmFXSIH4ayeGlsm+PdE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Yxffu61kqRVNdU2trW6Ou4QqeROhO9JKZ6WmTjgh4BbW7fRUiHWcf+3YvpkpNsT2wm83eciI+s9NsE3au/WW24EhdHLrEnXybyfHLnkKlQN+kHqsg6UQA5NiQHgoAU54TO8KvYRR1tYgunDZK8Mld60jzEK0v93LarVdP1jy6bc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pBHMpKY+; arc=fail smtp.client-ip=40.107.94.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pBHMpKY+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R3orMDsNG1oXdt0GcIkSGwiSn9oe6fH6xOYG2PI+h9RWd6Xs9NaVgZ9yFeoKHP9/Oov/mCHisvMtfxv5T0si65HabfvvoBCurfGDc4DPLOe6lIM4vg4+p8kq8JFDJPGfvcv0+goOkJmFrjwx9Y8iU0SIj8jsCi8I62Y0hgjtzeCS6eHvKfR0lVH0CUIBfZ8khyyUywHFjk4KpQAmHmLtKgCjyNGGHmQ7kPO63L+lO2hEIt/XkwYUIi0WPh6kVka5jzv9q0vujh6SF8Fnt441SAdVrlYeOxsniU6IK7vX6LqqPNs8LXrHU7QXc4lUG5f3l6dD9o7gCn4xu86CxoCjnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pwrki9tpTzbQWJff0zcmLVtEj2hBaG94rtZezlCQqS8=;
 b=LvWcTJfvnknhm0tIXC0SGKP5pJCLELa784j16VeSoJKXXT1WgBOLCcqOcvzG50lvbPknK4v80MxbvXp8nMwD8aMA6IWAKbMYnb9NcAwNRobh/Kq7USZHWEBMahvaKseSlYPEg63dx8XUFC8M1b7DiCgXBxkiithqwUZ98ahF6Wzeq1ShEOPALxN/kE5nPbAPQlZigFpqnoYD+FiIkncCGPpgD9LvF8rpXGRF9rMFddsEf4P4syKgNsPXEjpN+BhHS86qNpBayVr/Ztrvxh4O4MkPe5KoIol9s+RAamVeVr9mNJ9iDXnFcEZOp2bjNR4vmOEYPAAT4piH7pylPyDtDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pwrki9tpTzbQWJff0zcmLVtEj2hBaG94rtZezlCQqS8=;
 b=pBHMpKY+h3rVrwD8/Ys3qvhWukZc/To6FH03h4n67WJeirg65TLwqjx1u93RVAw1zZ7IfTWDTcYAz/VADxaX83wDkjG3oSQ2bTQr4T8kTe5UicHhGw27ncsycLGh/nixtxV/ZFzWM2xHmOJjKbQsPgwjSOQnAmW6HVktY/0LOZQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DS5PPF482CFEB7D.namprd12.prod.outlook.com (2603:10b6:f:fc00::64a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.29; Fri, 25 Jul
 2025 15:17:00 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.20.8943.029; Fri, 25 Jul 2025
 15:17:00 +0000
Message-ID: <ed5b4ee0-3827-4d9c-81eb-99f3ea219c93@amd.com>
Date: Fri, 25 Jul 2025 10:16:57 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] crypto: ccp - Add new API for extending HV_Fixed
 Pages
To: Tom Lendacky <thomas.lendacky@amd.com>, john.allen@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net
Cc: seanjc@google.com, pbonzini@redhat.com, michael.roth@amd.com,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1753389962.git.ashish.kalra@amd.com>
 <a5dfa1b5e73286c2d7a2d38422577aff9de48226.1753389962.git.ashish.kalra@amd.com>
 <ff83d1e4-5fbd-360a-22ea-10efd71ff2d9@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <ff83d1e4-5fbd-360a-22ea-10efd71ff2d9@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0082.namprd04.prod.outlook.com
 (2603:10b6:806:121::27) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DS5PPF482CFEB7D:EE_
X-MS-Office365-Filtering-Correlation-Id: f1478cb8-84ff-42c3-beb7-08ddcb8e4d70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U0J4ZjErSTZRdjBkN1BnV3libDhpd2dtTHZGMXZxc1FjcEVNMjlzVm9laWZK?=
 =?utf-8?B?TlBoRExBRGs2c1hmYXdoMm9TNE9RaEZpOWdSc3prNmF2QUk3aHlxbTF6cUh3?=
 =?utf-8?B?b25rY2JBQnBSSXFFM3ljeGRseVl5bXNoOG9hV0RQaVZ3Zmo2OUJpbG5RZ2E4?=
 =?utf-8?B?K3NoZnpUUVVFQmtMdW5rci9uVTY1OXBCank3d1lEaDBpNkczM0hLVEZlS2lw?=
 =?utf-8?B?c0p4SU9rbVVodjN3VTNITDdObkpXY3F5RFlPajBodElLYkRoS2Uwc3QzNnpp?=
 =?utf-8?B?ZlFOeW9iRkdVNTh1S2xOcnIwdTZiempVd0xkMWRTSmEweUZIL0FRNmYxUlhC?=
 =?utf-8?B?cldPbWJ6Y2tqeVo4Y0VlWHJ2MFl3UEhuWGRGQnljZFpOZ2liOXZlV0U3aFRi?=
 =?utf-8?B?cHlGVmlEVjgvZUlHMG5oRDRVaFo5TGhUUTJCTUZzQmlHQW1WOTlDaFU3ZENv?=
 =?utf-8?B?bHhPeUJnMFJSMHhvb3FVYWZobE9XL0hKdzI1NDBLb2VHbnlUWTFtRjJXS3hx?=
 =?utf-8?B?VzdSQkE3cmtpL0V4clFUZ0Q0MzZIREdZcEtXVXlzaGxZZ2k5RTQvL0pNdy9m?=
 =?utf-8?B?NUVZVmk1UmhwVWFIWXlrOVMwcXRGTnNtclozZ1JSQUhVTUhrdmlUTzYyYTBG?=
 =?utf-8?B?Y1BHNWp1dENoMnBINHZtd2ZPY2xqWGovSEZZM052K1NmcXVneTlUdG5RZWVV?=
 =?utf-8?B?aG9kZ1pNNUZyN1VKTWRSYjF5akVvTy96ZFN1MVlMMHdUaUdsQk5QYUt5MGVv?=
 =?utf-8?B?ZTE0dUlIaGZvRWd5dTNIZ3JyYkNGRkVUUUNEbHcrYXZTbkZFRXNCWFRKVlh1?=
 =?utf-8?B?bXRDdVV1ekZYTEpKL2I0T085Q01XTURLMDdCK29nZnpTUjVmK0VDbFN1d1ha?=
 =?utf-8?B?ZTBkU050ckZXdGtCNXMvcUpGNkVDNkRpcDNRVldQS2tseVNtdS8zei84cDg3?=
 =?utf-8?B?cUhJNVZCaEZWd0Z0eGlkRXV2K2NTaC94RER0REY5eFBPMGhlb1oyWXYwcU5O?=
 =?utf-8?B?NEkyWlpiUHhXTEZSSEVrbjJZZjlKZ1JvTGcrdUFHYUE4UGxPWXhMY0VWU0Iy?=
 =?utf-8?B?MGc3dVgxQTEyTHNjYklXU3AxRGVEVlpnUUR3bGwxc2ZCRk5GQllBRytvWGdX?=
 =?utf-8?B?SVF0a1BpbGJ1dlhIaFFPdDhKTGJXM1l0NkVBRXlpNDJNRGFCalZVRisvUkE0?=
 =?utf-8?B?Q25vMWxsdDhUWEgxT1pKS3lFZmFHVmRteDgrV2FlRzdIZDRyZ2dIUDkvbHF5?=
 =?utf-8?B?S2JZcXd1T05wV1daTkpjVGRWMUI5NEUvQXpQS1VXVVMySkMvcWhwTGhEaWR4?=
 =?utf-8?B?bENSeWZXTW9LZmNrcVJsajZmZXBqRlV1eTdYZ01EWktXbG5sNVRTM3Nnd0c2?=
 =?utf-8?B?Mm42MmlSZzlPb1lPaEMva0NUWE9Cenh3UFhwSzlURXR2Qzd6WnZIbHdSekF3?=
 =?utf-8?B?b2d6NFRUbTJGdjlhQ0tDRVI1YmxRQmY5QzZWdzIxT2UvQ0pGZ0tTUlpuL0dF?=
 =?utf-8?B?NFVIN1krZDZXeElCTXVqbnhMODE0QW5xb2pTTUUwSW1FejMvUzh3Rk1iRTJO?=
 =?utf-8?B?Qm9GWmN0TFhHd3F3bVdIWEo2Q1VXREpRZVF0bWNNbWRneWhvKzRCVDd6YVJv?=
 =?utf-8?B?RjFKSDF2cXVGc3oyK0U5M21TVlIycG9hb0MvQTIvZWpEV1ZTbTNqTDRsVmV6?=
 =?utf-8?B?Y0ErR2U3cStBTllIejFXamJ6QWJrRVdMRFVvYWFpNTVnQzZRUHZYbVhIYVpz?=
 =?utf-8?B?aExPN2Y1YzhLTENpUDFnNlZlYjR3dU85RDloRTNnNzZFZkRwYXh0WFJhbE5R?=
 =?utf-8?B?QzJHQldNcDlwYlRhTDZmVUNvMXp0RGZVZWJmdVMzbDlJMnZhN1Y5RHc0RWhx?=
 =?utf-8?B?MUp3VVZ3N0JsQXdEMEpOTC9zQTc3bkxrb240TFo2emNXOElubms5c0kxRUZs?=
 =?utf-8?Q?iFBhqCQndSA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dlRBMTNQRm45eXFUeFByZFh0QlRGN2dYb2prUmJHYVh6WUhabmRzc3Ird3lB?=
 =?utf-8?B?d0wxR0hXN1h6akZrUjhDZ1l4TTlYMXV1Tnk2KytlS2hSc0I2U0NkKzh6Skg3?=
 =?utf-8?B?Y0tKY2VUdXZMRHJNNzFRNm1sVWpPbHFDNHF6ekZwcDUyQWIyQm9ISVVKN2ZU?=
 =?utf-8?B?VWR2QlZHcWVKUTRvT05uZ245LzdjZnV4WU5PNCtRdHBpM2FXemd6ejZFVWUw?=
 =?utf-8?B?MEEzUmw5MmpoUTJlNXZGbUFleDRCQjJPTWo3RWF1eGViZjNiSDlOdE1uNzRH?=
 =?utf-8?B?YWt4MGMwZTVpSUNUdTc3OFRSUWF5YVd0N0hndkJNbDhKTGVGSUl2Z0dJajcy?=
 =?utf-8?B?TTc2Mk5wNnV5S1BwbHRkeHRxeGdZVkQ4RE02RTBRK1daVWZjQ2Z2ZFplZHRx?=
 =?utf-8?B?c2o5R3RqRkNXeTJpU0hCRnlyR3NjbGRTOVNNTFdtcmdUQUZVYTJNYnRQV3hz?=
 =?utf-8?B?cEp3NDZRRCtZQWpEVGMxT2xpWkZ4em80dVdJempReE9xQnNBaTdpWVp4YnRv?=
 =?utf-8?B?YzNKeHFudGxYMzNvR2N5K3RueVhRTk9wZ0d6VmdIUWI4ZEtKeTVPZFkvU290?=
 =?utf-8?B?Q1JUanA1Mm5kajlPWHkrUEE3MDZUYjBmcXVnRnpXcnJlakI4NWlhUzh1dFI1?=
 =?utf-8?B?NkZBLzlPQnFHdEZsVFNZVHg1MDNueCtnR05MN04ycWxqdDl0Y3BVS1VHVTV0?=
 =?utf-8?B?L1d5R1lPcGhHdlZRVlltZm1lTHZqYTY0SVFLNTYySlE4Sm0xRXlVQ3ZXVmxt?=
 =?utf-8?B?MEhqaUo4TSszeEtneENmT3VRb3hFVVJYOWVGczlYRFVDdXQzYzJEMUIrVGpQ?=
 =?utf-8?B?cjB6WWFCcmI1QjFTNnM4U0ZsdUNDaEhSR0s2YnVlSzBQVWt5MzlHNVNCdjc1?=
 =?utf-8?B?bUVUTUNIU1BRbk1sYTBLajlxRVY2NU93Q2hOU2dUcEc1R0Rwc0lxN2srQm1L?=
 =?utf-8?B?OEgzVWRiY2hTLzRXb2FSQkpiVUJ4V0dvWHhlczkwT0twcjFqejkrUloxMGJE?=
 =?utf-8?B?WXQ3M01aWFRJRi80TkRrUEpTV2tROEloMUpUTUJiMGNrSDljd1lZZ1NHbUkx?=
 =?utf-8?B?WlpUZmRSV3Y0dmZKb20zUUVVUmsrMXRSSExvMUsyOGJjMUV4RzlSYXpsSkg1?=
 =?utf-8?B?eWR0MDNQU0FUMTFlVjVjK1c0bTFVVDVVWEJzSWxHeEdpSENqY2JQV2VsM3Yz?=
 =?utf-8?B?KzFRdk5YaU5XNmIxdDduYnpWTVNUdGRFZEsvd1dSNXJjaXRENDd6aDdKRk5p?=
 =?utf-8?B?OFVXTllkSU8rOXd0WTkvN1lDZWl1N05hS3BLL0VpYVdCNkQ3STRFRk01WGpU?=
 =?utf-8?B?ekJxbkpUYWpWSVFTcHA4YnNqenl0bmlVUjFSeEF6dSt2TkViN3M3R1BRMjFj?=
 =?utf-8?B?eHVJVHMzYnZNNGlFMk1pd0lwbmttek01ZzZ0WjVJRk1KYy9aK2xxUy90N2RU?=
 =?utf-8?B?N1ljcm1uMWwyRE9UMnp1VDJLc3Iya2hIbjBteld5TTBkWVM4clV0eDFRSWoz?=
 =?utf-8?B?Zm5wS2xnWTNXWkdnMkJRY1FTZlU0NFZJYytRUStGSi9ZWmY4Yy94ZVhuWVpj?=
 =?utf-8?B?VDZlcmJnTjhCQmxqdTQ4bkNadTJ6QkdxeXpXY1VpYWcyM1hlQjcyUEo3eUxI?=
 =?utf-8?B?ME9iUnpXc3JyOVJSZkJwcW5uWnhjUU1tcE1OSk53U2tJZnEyb1QwT3ZJRmln?=
 =?utf-8?B?Ly92czlFM3dlZXBNaUFvRk53ZnhNOWpVWnJHaEkxK2JnRjVlemVuTE1yNVNU?=
 =?utf-8?B?L2dod09yS3I2V0VGbkxjUXpuWkRtSEpDa2NoaW9RSVI2dStyV29nSGVxN2Y4?=
 =?utf-8?B?UDdCakVjbnBIZUQ2NjIrNUJObjNqZlhYVy8xMXk2OU5IS29oYThjSStVYjBD?=
 =?utf-8?B?L3UrY2lEVmtkRVJvc09qYlF5czNWMTluSVhiOTFBOFk3RDU1ZzdwMGl5czhw?=
 =?utf-8?B?UzVtWjdxOUJ3TUhuMytZQmZBay9QeDdWSUtqVDR4UXZaY3NlOVdGUytRTTR1?=
 =?utf-8?B?UVQ1b0lEbFVQSG0xdUVoV3FKWlZkVzM2KzdVTHJBQ2ZLOTJ3a28xb3VLaHhh?=
 =?utf-8?B?dVFwTVdUVzRvb2dRZXhiUWdqWW5PUzhybGlyWGNvN3pnSnRlRUxybFBkSlVI?=
 =?utf-8?Q?yuf86Zi4az2YYNJs2ZsTowf4b?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1478cb8-84ff-42c3-beb7-08ddcb8e4d70
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 15:17:00.3601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0rYJnetQKd0/mmkrtaXeWL2lPBYni0oluDup5uHNsJ9oQTFaHL/C9onqFUuSl0TXGVS345ztRQqYumfE4J6azg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF482CFEB7D

Hello Tom,

On 7/25/2025 9:28 AM, Tom Lendacky wrote:
> On 7/24/25 16:14, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> Implement new API to add support for extending the HV_Fixed pages list
>> passed to SNP_INIT_EX.
>>
>> Adds a simple list based interface to extend the HV_Fixed pages list
>> for PSP sub-devices such as the SFS driver.
>>
>> Suggested-by: Thomas.Lendacky@amd.com <Thomas.Lendacky@amd.com>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>  drivers/crypto/ccp/sev-dev.c | 88 ++++++++++++++++++++++++++++++++++++
>>  drivers/crypto/ccp/sev-dev.h |  3 ++
>>  2 files changed, 91 insertions(+)
>>
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index e058ba027792..c3ff40cd7a96 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -82,6 +82,14 @@ MODULE_FIRMWARE("amd/amd_sev_fam19h_model1xh.sbin"); /* 4th gen EPYC */
>>  static bool psp_dead;
>>  static int psp_timeout;
>>  
>> +struct snp_hv_fixed_pages_entry {
>> +	u64 base;
>> +	int npages;
>> +	struct list_head list;
>> +};
>> +static LIST_HEAD(snp_hv_fixed_pages);
>> +static DEFINE_SPINLOCK(snp_hv_fixed_pages_lock);
>> +
>>  /* Trusted Memory Region (TMR):
>>   *   The TMR is a 1MB area that must be 1MB aligned.  Use the page allocator
>>   *   to allocate the memory, which will return aligned memory for the specified
>> @@ -1073,6 +1081,76 @@ static void snp_set_hsave_pa(void *arg)
>>  	wrmsrq(MSR_VM_HSAVE_PA, 0);
>>  }
>>  
>> +int snp_insert_hypervisor_fixed_pages_list(u64 paddr, int npages)
>> +{
>> +	struct snp_hv_fixed_pages_entry *entry;
>> +
>> +	spin_lock(&snp_hv_fixed_pages_lock);
> 
> Please use guard() so that you don't have to issue spin_unlock() anywhere.
> 
>> +
>> +	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
>> +	if (!entry) {
>> +		spin_unlock(&snp_hv_fixed_pages_lock);
>> +		return -ENOMEM;
>> +	}
>> +	entry->base = paddr;
>> +	entry->npages = npages;
>> +	list_add_tail(&entry->list, &snp_hv_fixed_pages);
> 
> You're creating this API that can now be called at any time. Either
> restrict it to when SNP is not initialized or add support to issue
> SNP_PAGE_SET_STATE.
> 
> I would suggest that you return an error for now if SNP is initialized.
> 

Ok.

>> +
>> +	spin_unlock(&snp_hv_fixed_pages_lock);
>> +
>> +	return 0;
>> +}
>> +
>> +void snp_delete_hypervisor_fixed_pages_list(u64 paddr)
>> +{
> 
> Not sure you can have this...  Once a page is marked HV_FIXED it can't be
> changed unless SNP (SNPEn bit in SYS_CFG MSR) is disabled, which doesn't
> happen until reboot.
> 
> So users of this interface will have to leak pages since they can't be
> released back to the general allocation pool for chance they get used for
> an SNP guest.
> 
> So this API should probably be deleted.
> 
> Or you change this to a driver HV_FIXED allocation/free setup where this
> performs the allocation and adds the memory to the list and the free API
> leaks the page.
>

Again, as you mentioned above this API interface is restricted to use till SNP is initialized,
so i think we can still have this (to handle cases where a sub-device init failure path
needs to remove it's HV_Fixed page from the list). So probably i can have this with a
check for SNP being already initialized and returning an error if it is, allowing the
user to leak the page ? 
 
>> +	struct snp_hv_fixed_pages_entry *entry, *nentry;
>> +
>> +	spin_lock(&snp_hv_fixed_pages_lock);
>> +	list_for_each_entry_safe(entry, nentry, &snp_hv_fixed_pages, list) {
>> +		if (entry->base == paddr) {
>> +			list_del(&entry->list);
>> +			kfree(entry);
>> +			break;
>> +		}
>> +	}
>> +	spin_unlock(&snp_hv_fixed_pages_lock);
>> +}
>> +
>> +static int snp_extend_hypervisor_fixed_pages(struct sev_data_range_list *range_list)
>> +{
>> +	struct sev_data_range *range = &range_list->ranges[range_list->num_elements];
>> +	struct snp_hv_fixed_pages_entry *entry;
>> +	int new_element_count, ret = 0;
>> +
>> +	spin_lock(&snp_hv_fixed_pages_lock);
> 
> guard()
> 
>> +	if (list_empty(&snp_hv_fixed_pages))
>> +		goto out;
>> +
>> +	new_element_count = list_count_nodes(&snp_hv_fixed_pages) +
>> +			    range_list->num_elements;
>> +
>> +	/*
>> +	 * Ensure the list of HV_FIXED pages that will be passed to firmware
>> +	 * do not exceed the page-sized argument buffer.
>> +	 */
>> +	if (new_element_count * sizeof(struct sev_data_range) +
>> +	    sizeof(struct sev_data_range_list) > PAGE_SIZE) {
>> +		ret = -E2BIG;
>> +		goto out;
>> +	}
>> +
>> +	list_for_each_entry(entry, &snp_hv_fixed_pages, list) {
>> +		range->base = entry->base;
>> +		range->page_count = entry->npages;
> 
> Will there be an issue if the size is not 2MB aligned? I think a PSMASH
> will be done, but something to test if you are going to allow any page
> alignment and page count.
> 

I believe that SNP_INIT_EX can add HV_Fixed pages which are not 2MB size aligned.

Here is a sub list of HV_Fixed pages being passed to SNP_INIT_EX: 

[   25.940837] base 0x0, count 1
[   25.940838] base 0xa0000, count 96
[   25.940839] base 0x75b60000, count 75
[   25.940839] base 0x75c60000, count 928
[   25.940840] base 0x88965000, count 83
[   25.940841] base 0x8a40c000, count 1
[   25.940841] base 0x8e14d000, count 48187
[   25.940842] base 0x99d88000, count 235
[   25.940842] base 0x99e73000, count 1153
[   25.940843] base 0x9a2f4000, count 12043
[   25.940844] base 0x9fffa000, count 5
[   25.940844] base 0xa0000000, count 65536
[   25.940845] base 0xb4000000, count 1
[   25.940845] base 0xb5080000, count 1
[   25.940846] base 0xbe100000, count 1
[   25.940847] base 0xbf000000, count 1
[   25.940847] base 0xd0080000, count 1
[   25.940848] base 0xd1100000, count 1
[   25.940848] base 0xec400000, count 1
...
...

>> +		range++;
>> +	}
>> +	range_list->num_elements = new_element_count;
>> +out:
>> +	spin_unlock(&snp_hv_fixed_pages_lock);
>> +
>> +	return ret;
>> +}
>> +
>>  static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>>  {
>>  	struct sev_data_range_list *range_list = arg;
>> @@ -1163,6 +1241,16 @@ static int __sev_snp_init_locked(int *error)
>>  			return rc;
>>  		}
>>  
>> +		/*
>> +		 * Extend the HV_Fixed pages list with HV_Fixed pages added from other
>> +		 * PSP sub-devices such as SFS. Warn if the list can't be extended
>> +		 * but continue with SNP_INIT_EX.
>> +		 */
>> +		rc = snp_extend_hypervisor_fixed_pages(snp_range_list);
>> +		if (rc)
>> +			dev_warn(sev->dev,
>> +				 "SEV: SNP_INIT_EX extend HV_Fixed pages failed rc = %d\n", rc);
> 
> If you aren't going to do anything with the error other than print a
> warning, this should be moved to the snp_extend_hypervisor_fixed_pages()
> function and have it be a void function.
>
Ok.
 
> I would assume we'll see a failure in the SFS component if this fails, though.

Yes, SFS or any other sub-device component will fail in this case, but i don't want to abort
SNP_INIT_EX in this case.

Thanks,
Ashish

> 
> Thanks,
> Tom
> 
>> +
>>  		memset(&data, 0, sizeof(data));
>>  		data.init_rmp = 1;
>>  		data.list_paddr_en = 1;
>> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
>> index 3e4e5574e88a..444d7fffd801 100644
>> --- a/drivers/crypto/ccp/sev-dev.h
>> +++ b/drivers/crypto/ccp/sev-dev.h
>> @@ -65,4 +65,7 @@ void sev_dev_destroy(struct psp_device *psp);
>>  void sev_pci_init(void);
>>  void sev_pci_exit(void);
>>  
>> +int snp_insert_hypervisor_fixed_pages_list(u64 paddr, int npages);
>> +void snp_delete_hypervisor_fixed_pages_list(u64 paddr);
>> +
>>  #endif /* __SEV_DEV_H */

