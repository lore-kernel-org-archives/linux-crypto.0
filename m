Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2068.outbound.protection.outlook.com [40.107.237.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4263B6FBF;
	Sat,  8 Feb 2025 00:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738975016; cv=fail; b=knrt3SnRNKRjwYUSkoy+wDl1ntK4G/yA5eyfIERjBXflKGWlHakkJWC4zrOoTT00jjt69mGeZnUVgwgf7bJo6/Sp9RcmKdljf0Aj6U2jODjWdY4dmlmzy+zi9JZSHLNEqwOQi3aEp1oiAdUbt3prd+4ZwI6xrxnsj3jTBa/DWcM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738975016; c=relaxed/simple;
	bh=3+WeZBlXgPfGVWiTbPjacRsUg83w28sTp2puXU/6X8Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ejsq40CddzOD1OuijpQG6ROdyojxuj10xi7mHJqdAkGFQQ9E3IqC7rinqueW0jfBKVjlZFlCZ7lZn5XjKP4phnQqoX1a9gqo65dwbfqSJBDKnEqOKfbvLGVgmW/Sitb3IJve0n2c69oM0wfuIeOpK+ppKm4+mZXFqRJyhZy6Zto=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=N+ZPrkHr; arc=fail smtp.client-ip=40.107.237.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="N+ZPrkHr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j7BamWX+cHIiLL2yu/BqD4f30doI/ebvo606HWsxs52Ff7cIcA6CrRo7/Ai2zQ+lOxhR36VKxCYYpaZYdPntvD9+4+7wORAkzifbQ11Z2IifiHXvITcN9HDE6Fhwhf3lnNSEvqdcP8gUZAaPjCjousErV8aMQ51VYzaSFUXGQDEi8j6832CGDrrzrl5ZI4zS7gDeX0A57PHvVb5nPhR/iFUvcbckW6kTcSpIMLxlOOM5kCHTf3MwmnnF1oVEmGeCbtaKpzsf6FSt/Ky0CEBi493hqFMNKB85j/SzTMZPfVkLVE5vmZtXof6l14qFUf0cU4F4fqeZXrujgQzUMzsjEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ds6dbP1S2ohvik/+g95HUNDDjALIIHVDjcRnsuINfNc=;
 b=E5/M9cdDI5kGY9VnuHB1BElakN6zxZ4oEnFjWf/y3BoAWw+glfl+WYTEWGKaF60RZsWd3Pf+1Og+iKduoHC3FeQAwVSgY/01IiPJEc2aB/5dcUzsr+WL2Dzi/Plt5C8EmdYeo9xtzlYdcO/z6OKjvczg06GoEzm2PbPmHfdZZUlRss/r78b1WPX0+IAi7wieOZrtRsPGs3Q7HXErfbIK7Hddj4M+mUQoUfySkysmtynGml7lBSVfOIsnnM9L28qD0fjvTcMtmmpOL3dbOzZIiBUL8jTS70eMESL3JiN0XNwiQvsNvcP+ejgkZ5GwxvptHloWRvEkWI3Zusi1ZxpgmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ds6dbP1S2ohvik/+g95HUNDDjALIIHVDjcRnsuINfNc=;
 b=N+ZPrkHrk/Ao2OwgnUqIPAlTukV7K4oaWWW493ZGJSgWuKo2r6WvfZ9pU3o3lOqMiSnlMeOiHUFcMFwjxkLD2DgL/gm2RZ8hmFplteCKn0M2yK8XxKVRHzUWQlzslC6bKwu58suxOr2iRsK0tpAhV+PjymHUrXcSWyHE+1PcgUw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by PH7PR12MB8038.namprd12.prod.outlook.com (2603:10b6:510:27c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.11; Sat, 8 Feb
 2025 00:36:52 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::37ee:a763:6d04:81ca]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::37ee:a763:6d04:81ca%4]) with mapi id 15.20.8422.010; Sat, 8 Feb 2025
 00:36:51 +0000
Message-ID: <78f4d7ab-a4ff-47b3-ba27-00b583ffb6fc@amd.com>
Date: Fri, 7 Feb 2025 18:36:48 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ccp - Add support for PCI device 0x1134
To: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
 Tom Lendacky <Thomas.Lendacky@amd.com>, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Thomas Rijo-john <Rijo-john.Thomas@amd.com>,
 Rajib Mahapatra <Rajib.Mahapatra@amd.com>,
 Nimesh Easow <Nimesh.Easow@amd.com>
References: <8e2b6da988e7cb922010847bb07b5e9cf84bb563.1738879803.git.Devaraj.Rangasamy@amd.com>
Content-Language: en-US
From: Mario Limonciello <mario.limonciello@amd.com>
In-Reply-To: <8e2b6da988e7cb922010847bb07b5e9cf84bb563.1738879803.git.Devaraj.Rangasamy@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0117.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c5::23) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|PH7PR12MB8038:EE_
X-MS-Office365-Filtering-Correlation-Id: 783983a3-83ef-45ec-3446-08dd47d8adfb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MXRYVk00bVZsVlNIeTFXakFjMVRubkZpQVRTRWZ3b20xQytoeWdDRW9sNFZI?=
 =?utf-8?B?OWVLa0NGYldtWWFaek14eUVtNEQ5SXNMWjRUNkhXMERZczNUa1dJTE8wZ0xY?=
 =?utf-8?B?WU5MNGo3N3VNQzF6VFpxNGdIcVdVNFBHcDErUjZISGM5SXFPbm9SakQxbG1S?=
 =?utf-8?B?d2swSThBUzhzM1VmNXIxV2F0ZE9KZ2FRcllveStaZVFkd0s4VXZLaW8vc1M0?=
 =?utf-8?B?WTBuZ1hGS29YLzNVajFGOEQ1RGd0ekZ5UmF2TC9wV0M0cGR1ekVoVXdLK1J1?=
 =?utf-8?B?RDVMdFR6QmZwMDhWWkxJK0FCOHVYSWk3SEIyUUVncDJDUng3N2x1cXZ2YWY2?=
 =?utf-8?B?Z2t5Z1hsSVR1bGhHY3hwSWp2emtnZjNXNk0xUXJYWHZxTGJQenllcGVKV2RN?=
 =?utf-8?B?dHF3UzBjUklGSDJ6YmJTSFl0ZGxWZDhTNkh3bFhaaFFONVlLRU9HOWZ6TG9X?=
 =?utf-8?B?SjQ4aFBKNUF1L0F5MVd5NTA1RHVSK3dBdnh0cXZyRzNZMXNNWkZ3Y3pLUGxR?=
 =?utf-8?B?YnJPMjlEU08yQStqczBwM3loRjRWdU1aMTY1U1FDa3EyTkFKVFhNaFN4OFlo?=
 =?utf-8?B?dHc4UzBMNGl5VU9TaGRSRWxncUt3bjhLYjk3S2ozNld5WkU5amJLeW1VUXhp?=
 =?utf-8?B?dDl2VjRYclQ4RTg5cXVaeGt1aVg3MlZvVVlnVzl6cTNsNXZTcmE2Tk5oYUI2?=
 =?utf-8?B?aDJVYzd0WGZKWlVkMjNscGJjK2crYUVHakJIOU9uR2EwVmhDTlRybU94NFFX?=
 =?utf-8?B?RE9JTHo3OG03RVFSZkdSZ05mSnc3UVh4eFJvd3ZvdHljU0x2cjZpTHRydk9M?=
 =?utf-8?B?YUlkeXBpZ3h3bEFXQlBmTjJia2NCcm5vMUJWamdOSHZmQ2M0N2s3ZXFQd1dh?=
 =?utf-8?B?dTJBcklwdGFmRGQ3Wk9zcTNPdzd1eGE3Y0Q0SDZnZHc0bCtZbXA4NEM2VVRx?=
 =?utf-8?B?SzJBYTgzTTRubzB6M09LMjlFU1F2Yk1nTCsvQ1hMRDZCNkpBQ2VHNXM0LzBZ?=
 =?utf-8?B?OTFScVd3UStMcUNEQTFuaFFRZlJlU2EzUC9YWmFhcDBob3lBYUVLUEViNU9Q?=
 =?utf-8?B?OWxEaUFzYk5ZUkJOYnA2S3BmMzZLVEF6UmUxMWFBT095eUt3ci90bFIwK01h?=
 =?utf-8?B?V0RSZ2Rub21DdnNxNTV0U2Y1bUp4Ky8ramFSVjFHSmY5cCtxZUtYSDBFZjJa?=
 =?utf-8?B?WmVUc3JJUTVCbFpmNmJpQ1JKVi9SYUhoSElzVmdmSWJ3U1hqdHJxTGkyLy92?=
 =?utf-8?B?Snd6cWVNZEVndnlEaG9iNjJ0enptUVI5QVV0YUd5QlBzQ2dzeXVCUlNVeGhh?=
 =?utf-8?B?dHpZZXNiZExzSXAvbzRlVE1QejdpZUZpTWxhZXA4bjNKOEdoRGpRSWFpVnFZ?=
 =?utf-8?B?ODJoZEMrZ0Z5UTE5RlYySDAyR2ZObDNOQkZGdnNzN1JSdzhUcmpRWGpIRWJ6?=
 =?utf-8?B?dlJFNGFqNm1IU0FSR2lzdlFpZnljaEtzVE96c1kvRy8yUVJpRXVIbngwZFZI?=
 =?utf-8?B?VHc3VHY4NzNjRkY5bEVGM0pkQjRHTXBWZEFJQ2tJYmNwVlpHOFducFRuZm5h?=
 =?utf-8?B?ZjhjY1cwSU9kNlJvRzA5c3BjRDl5ZGF6WnlUSy8zVzE0amhwYmppN2JaZUt5?=
 =?utf-8?B?S2N6RmJZanNxbWRmdXB4VGplMHl2M00yWGE1UE9TMzZMTzhtNURGdDhGNUFV?=
 =?utf-8?B?aStoSnhjMTBjcHlML0xCckg3OG1MQUloVHEyOXlyTkthVUFNOWNYVGtPd3BE?=
 =?utf-8?B?eTNFN3F4K1psZmNPbGlzUHM0eWxuYzZaV0xQZEk4dDZqMWo3VnIySVBWbmZq?=
 =?utf-8?B?UXJSUmp0ZXRNdWltekFveHV5RXNudUttd2lRNUZ0S0dwVEdLOXh0cktJZCtu?=
 =?utf-8?Q?w8MfHZX+TFCca?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MmsvSXZUNWwySm5NOG9tWlUzdDFZM2lmTGZzeVdVTEZUTFF6a3A5cXc0ZXFU?=
 =?utf-8?B?M2JwYlA2dm9LZU1XNDJsbXBubUV0dFdLWnArMjRiNkwrU3dtelBOMmxYV0da?=
 =?utf-8?B?K2V0STc4SFB6NDY0ZysvWFg2aUZoWUYyYWYzS1djTVNqTEN0aTJZc0ZHTlMw?=
 =?utf-8?B?RzNla0NKQTVQYWNuZ3NTUjhtTzZxVjlmZkJKQVd0WmFWdFJPeEZlcUU0OUFV?=
 =?utf-8?B?Q3VRRVFkWW1RUnl2S0tGV1lpdVFkU09rVVIvSEpoT1R6ektDVFd4c0Z2M2p5?=
 =?utf-8?B?dEdxcXlRNmdiRU01b3pIZVZZNkY4MmVoWWxYWWp2YlVRSmlSQUtFYU5hUlFN?=
 =?utf-8?B?UnR5YVFxajM4WEd5VGRrc0VEeS9jdGZGbEt0Z1dhRTlPR0oxTC9PbkM1RUpj?=
 =?utf-8?B?L2RVR2tJbGY5NG1QUUpXNXQ4YjAwM014d0lOM2lMOEVyd3A5bjYrbmRvbE9W?=
 =?utf-8?B?Q0pMOStEcVl0LzVtU3o4MllNSEZmT21kNUQ5QXd0ZENVb1huOENncHZHQWQ5?=
 =?utf-8?B?cHdZZmVrNERjVG0wQ0VRdnZqZmlPR3VmQmFZeXpPRTI0bEYzbG9uV2pmckdq?=
 =?utf-8?B?eU05dkNUTkhVMEtCMU5oQmQra0JaYmdjcXVIYWkxUVppNHVvNG5jbDlaSW50?=
 =?utf-8?B?M3VqSVBRZXE1ejhFdmg2N2RNdnpBMWtuT3hUR0tRbkprMzd5VmYzQWp0N0k2?=
 =?utf-8?B?V1FMRlRJYzlTeVdzNGIrdW5QbzFRLzFKV0lNdUpzZElDVk1MNHRDNmJuNVdx?=
 =?utf-8?B?RVhPdjJWb3l3aTM4UURHTUpSQnVRdGJJWElBOUN6RkVJUUhOUzRuTVRiaHhW?=
 =?utf-8?B?a0IrSFU4cmxQd2FRYUVSeTh1c1FteGgxNlVuWGxpb0EyZWU1cmIycTJ6K29S?=
 =?utf-8?B?bUhVVERDS2R5dVgvQzRJWlhWOUlyY0srcVhmSDBGeEw2TC9OSTcvYUJKdXR4?=
 =?utf-8?B?L0t4TExrclJseEJId255R3BlZkkyZmZTVmZHN2JZZXIvNGJRdWpmbzhoSld4?=
 =?utf-8?B?K0xEWkJnOXlZUWJVdVBQMjl6bWUvdnNRR1B3UU9DaTJFdkFVd0VzRmVmc2lM?=
 =?utf-8?B?WXpTOGxqVzdpZTNLcVh5L0hGZ0ZadHV2YUZQVVROWlJ6dUdIM0N3eHoxeHIr?=
 =?utf-8?B?dVBlMXZIN3d1UDdRa2d1YjNMWVBuNHdDNE8xa0NWcEwzSU1aL0RIS3RuVHZz?=
 =?utf-8?B?ZS9MWXFuWkVTL2tKWTlWcnk5MWF3MGhUUzluWmNiWGc4MzRMaUl0R3JrNE9H?=
 =?utf-8?B?U0FGZDRxWnRPWHM5Qms5dkJ3SWk2RWc1UWNETzdjSXp6cWZ2Z1laM01kc3VZ?=
 =?utf-8?B?NVBlc3NjbjFYMjFEeG9kSWlhckNlM01mV25mZG1wSnZPNVZlT015QzYrL2lx?=
 =?utf-8?B?YzBEWExXZlhBUENMUHQvaFdpdDR5MXd4MHI5UGZkbVJCVnc2eU1DOWpQTmFP?=
 =?utf-8?B?Z2VIM2llN2xzUDF2b0RVbzB5VmduTW1Rd3c4SnFjOG95VFNEQ1Z4RC96ZUxz?=
 =?utf-8?B?aW1jUlBVa2dOTVd5cmNLMVl2b2RsVkNNR1VmSEVmMTRQUDg3RFdWQ3FpWVhU?=
 =?utf-8?B?bXFvTHRBcU4vcENOR2RibklSdUthTk5nVjg2U0ZZQWd0bVEvaU9PRFNPYzQ1?=
 =?utf-8?B?SmJ0Q1dVV1QzQTUxbFQwYmVZV2JCZFMrNEVCT0djM1R0T0VWeUQ5QXFldEpV?=
 =?utf-8?B?VnZWM2JzY0UrdkhtUzM0c1VTRTFLcWpicy9LRnBKcktWSWswRFQwQWRDTVBu?=
 =?utf-8?B?TVJkNmxac3lFR2hIbEZORkRJVEZ3em5OYjRQNWRDRGVlZ2VhVTNzemx3b0xD?=
 =?utf-8?B?RllHZEd3YlZMWGROWWs1R2NVemVWVGQzNHZlQzdMeHJxazV3UlhxemZ4Mlo4?=
 =?utf-8?B?dlRNWWRLMWc2MU1kN0dBdjlsR21PRTFNTXpkeEcvRFZCUk9MNzJtbVVUbFJh?=
 =?utf-8?B?VFhBelNMOFNieVZ4TXhZNUJ6UGxqVEI3QklFY3N6b2prbmVZOWhvV0pCc1NC?=
 =?utf-8?B?cGN4V2QwZW5tditEcnp1OGJ5WGhtYW82dldjb0IvZXZRcVp3NUU3elhZbU1C?=
 =?utf-8?B?SzhwMEt0K3BjZE5uUk5LWC9qVjlPcW9HeUREN0FIWjFmdGk0djJhclNoeFg1?=
 =?utf-8?Q?KsV66qk+mi2leolo8lV9pEyg0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 783983a3-83ef-45ec-3446-08dd47d8adfb
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2025 00:36:51.5919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PugnV3CmzSot3g15Iwg5EA6tXK2Tv8ILg6SdiS9mSJTm1E8vFdZfUV403ocQg9usJr4FJb1m5lwyeEEVkX1O0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8038

On 2/6/2025 16:11, Devaraj Rangasamy wrote:
> PCI device 0x1134 shares same register features as PCI device 0x17E0.
> Hence reuse same data for the new PCI device ID 0x1134.
> 
> Signed-off-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
>   drivers/crypto/ccp/sp-pci.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
> index 248d98fd8c48..5357c4308da0 100644
> --- a/drivers/crypto/ccp/sp-pci.c
> +++ b/drivers/crypto/ccp/sp-pci.c
> @@ -529,6 +529,7 @@ static const struct pci_device_id sp_pci_table[] = {
>   	{ PCI_VDEVICE(AMD, 0x14CA), (kernel_ulong_t)&dev_vdata[5] },
>   	{ PCI_VDEVICE(AMD, 0x15C7), (kernel_ulong_t)&dev_vdata[6] },
>   	{ PCI_VDEVICE(AMD, 0x1649), (kernel_ulong_t)&dev_vdata[6] },
> +	{ PCI_VDEVICE(AMD, 0x1134), (kernel_ulong_t)&dev_vdata[7] },
>   	{ PCI_VDEVICE(AMD, 0x17E0), (kernel_ulong_t)&dev_vdata[7] },
>   	{ PCI_VDEVICE(AMD, 0x156E), (kernel_ulong_t)&dev_vdata[8] },
>   	/* Last entry must be zero */
> --
> 2.25.1
> 

