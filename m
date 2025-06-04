Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2059.outbound.protection.outlook.com [40.107.244.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DA4192598;
	Wed,  4 Jun 2025 15:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749052632; cv=fail; b=jEn4EOuP/1ehMOyeTBgwvH9aeKdkuIgn1dJtx1bVrjzyLkKZWTNdYtaqDQdUlP7Al+3isr97nqxeDtxi+3MRix3+DZHAZPw0iLut37qr+AwE+2EOSNCFn9gA6XsQR0AVzBH+DDTZJgTd9KXnkKRpByDj5F2Y+jNFeg8++D5n3DY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749052632; c=relaxed/simple;
	bh=OHrXWV1rKQM9VvVzFzQHIY9uHpVjpxmYlQysgo+dHGk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IIyLhzVSGfHwWw0ZiltzuZD2Iq4Osw0/+wmdg4iBFhaRJY7o8fFsaU+OtlXgItBtKfYeFySLqSVfSP9J9HbXmWdZr+zFdkOxaVVHjGPYQ4LxqoNaFIJfjFTg2nriZu1PgR/ACVlns+teSXVEXpCVTWP6bw9rftd8BwdaGZgTlYM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bwyWL4LE; arc=fail smtp.client-ip=40.107.244.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bwyWL4LE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sy5jCaOjbC/YEb2gL6p5/XayvoDrGMwuCiYtZEfx6uDU/a1F5XTxDMzBYcy5e+XYbggO/7rprV2IJPpOwt9v67ws51YHTGHsE8onRAH9er6FYunF2yhqmn77t4iUTsNukTF3yVMMo3XRrlh+kUGJalY6aPhlcXJPkOSl2h2uWcvAeVDfXYvdVklP57XYaLQGOn44nW2bu/+UEYka/yimlRM+1zBAfIdlR5mfArE81VgbjOLDJhdxdf2DMm3t6I/qhOBsw5Fxa2ehL9DkUg5XEW/duMUCQreeBseamN4n7rV9bwyv6hwArPb3O9CPshcZJlc0rzi9LeA1KFvpeiTiZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7kc6ITDG6cbMSRaJw80DvIBpIRY2KAqxa56rHDznOfI=;
 b=lGNmY6yEZ3Mkqzz0yTQANAT/NgQ8G0949zmxKqhWrJDD56NPmvUNfknLnk6Kkdk6kgVjSr5Y206L1rqqYp1ojE+b2LRMH9uTCPGRZ1kNA9uds6iT4+SzQ2Kj7FLMKV4jJZhT2ffDYjtpELh7ood0DxfEKKBmI7kh5PRGUDpFsilnd2Le3C6IXIojH5aMYo55fi/QfKhR1hFQeXZISppUp7NXcBi6Ab+TKSyRM/JEUoQF5PEwFDh5FkH1NXTH5sHZt/TH7JNyiaelmz0WJA9c/SUoI7apYLeBbHPTWHubZxImxV1giDCUttzNfcI8pTC9Ah6ui4lSMi7g94OZJx+QHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7kc6ITDG6cbMSRaJw80DvIBpIRY2KAqxa56rHDznOfI=;
 b=bwyWL4LEmNse9uRQFYZyoG5VNFfJkgM6KtvA8LZDOevJkcwHMaaCOz3DvQwalCMcelj8v+CURPd4tVm/JvWe8L9VgLSURY6Le2sYMDrq9ehbsE9xfU6w0Xe6SPzf1ZA1Eyc0lf5cZx4wRDZMlOf4Ytjtty3izUyN1cwFpDJuqoU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH2PR12MB9519.namprd12.prod.outlook.com (2603:10b6:610:27c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.35; Wed, 4 Jun
 2025 15:57:09 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 15:57:08 +0000
Message-ID: <8cd27c20-6439-deec-f09c-e4f6f789761c@amd.com>
Date: Wed, 4 Jun 2025 10:57:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] crypto: ccp: Fix SNP panic notifier unregistration
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, john.allen@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net
Cc: aik@amd.com, dionnaglaze@google.com, michael.roth@amd.com,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250602191017.60936-1-Ashish.Kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250602191017.60936-1-Ashish.Kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN0PR04CA0032.namprd04.prod.outlook.com
 (2603:10b6:408:e8::7) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH2PR12MB9519:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ab15a9b-b07a-4864-275e-08dda38075c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RmszRTZWUGZ2SFQwK2N5ZG5Rc21pUUFsS05mU2tGUHdIZWZobnJkNnNVTXBn?=
 =?utf-8?B?L1VNVGJtOXJnVGRsZHNwTkN3NHNhL3R5N3ZzdzRPMHFoQk1oRUhoWEwwaWJr?=
 =?utf-8?B?c3N2L2Vra3ZMVFJmN3BOWm5SRUw4a0xwbkc3Tjc0NVgwL3NRYjBOL2RnKzBt?=
 =?utf-8?B?RXozQTYyMGpCRC9QbWxYS1ZocW9pY2NVWUprSFcwWXNJMzhKREJ3RkFRRTJT?=
 =?utf-8?B?ODNHby9DYzlwZFpqNXVVVzNhU3daSmFTbDE5bVl2Nnd4cEk1NFdieFRVNm5U?=
 =?utf-8?B?VFI0OWp2VjdSOGd2UU41ei9Xc2Y2WisySlcyeWEwT3pBcGhxbGRtYTNpVVZX?=
 =?utf-8?B?Vmt4WmpJZmtMUi9NcG9vc2w0ZlpBNGloeExCOGdCOGNkK2Jhd2ZZUktWTi8z?=
 =?utf-8?B?aHZybFJOWW1iTnI2bG5jU1d6dmYyN0MwYkVqU204UUhweEM0dkZ6NXJpZ24z?=
 =?utf-8?B?RjVhdDliOGZjOW5GeVZ0MDBLdjM5NEtvYjJTL3pvamNNcXJtVHpzZ2VRVTA3?=
 =?utf-8?B?R3BOVkJZSE1NaUlGWHRJRk5MRXNKTmFMeGZuSXhRcGJXbE5uTkl3UWpoeDBk?=
 =?utf-8?B?cldVVkdCMGdkOWs3aHZTeTFEeG5CMlkwVktOTTdhSW5MRkp2cSs2WWRicDgw?=
 =?utf-8?B?c1BTUjBEZitJMFFrOG9JNGkxZWtVOVhVb0s0aU94NTkxb1QvL0E2M0RFM0FG?=
 =?utf-8?B?aldjUFM4SDN1RWJBT3BtVElVOEtBdVdQT2c5SjVMWmdSY21TdE0zNmwrbURK?=
 =?utf-8?B?MnV5THhOeGlTN2hEc2RITVFkS1lMYzQ0aC9SeE9uUGMvSmZuSzZxUDVqbExF?=
 =?utf-8?B?aEpZc3V6eUZMakJyUGJ6Y3VId3dDVTY0a0oyUDQweWRmcHVqUXVOampkTHRX?=
 =?utf-8?B?VldQNmQrbkdidmRkUGNGN2xZaWQxMW13VFNOYWx2V282OU1JV2F6SjlhR3Mx?=
 =?utf-8?B?TXFhSFBRdmNYWVplNjdFZlNUMjdDNmhkTjhVekNhUFdkS1hGaFRLdndjK3NG?=
 =?utf-8?B?YWlwUU1YZFNtYnNsa1BwVTc5RnpNVUN6ZVRHa1M3OUFuY2tQczRrR3Q0WGVY?=
 =?utf-8?B?b2dwUUdGdGxUU3pQYW8wUUtCcTJ1c3pSb1lHVGc0K3o3MExOOXFSdXEyemM3?=
 =?utf-8?B?b3pvMXphd3JPR29rTHAwRjVGM0RhblY0WWlRZFBrcnNIOWMreDJJbms3QlJ0?=
 =?utf-8?B?UHYwd2VZZFpLL2gvUnhuMzNnSEw5dVFQS29QS29LSFA4OWJEcWFtL0c5MnA4?=
 =?utf-8?B?WjJKQzBQR1dMVmtoeE9Od0M5VU5ydzJhNng3M0JJck5UQXN6VURLS3JRaDJU?=
 =?utf-8?B?STJEL0JCR0dPTUVQc0g4T2FZRnoxd0xHZHFCSGd5V1lTNzgrOVM1TWxVUTJN?=
 =?utf-8?B?RkFwSk9jY0RaTElJSUFRd0RpR3BISnhwNVJyRnAzcDhXWDhuNG9Db0FLQnZJ?=
 =?utf-8?B?WjV3QTFESW5Id1FWQXhIb0YybXRpbXpsY2VraWRwb1R6bjhBNExEeFRFZ2lQ?=
 =?utf-8?B?RnAzK2ppdXI3SjZ0WnYyRXJua1dndFk1ZE1zTkdzVjYyN2l1cEZvL1doQktz?=
 =?utf-8?B?dC84R0RjWWpObnBQS3V4cVFidTMwVENvalREU3IwUndYRTM2ZXlTekg5NGY2?=
 =?utf-8?B?RmQ1T3VxZy9lbjhKZWdkQWx1TVhQZW9CSURNRkIwUWgxS01qclBjaE5lWEZB?=
 =?utf-8?B?bnpPK1pFOU11QVR0bmFCWkJIRnVlUHBHZ21YV1Z2SEkzU0FZaTltUTF6clo0?=
 =?utf-8?B?SGR4WWxPTVlBNGtYOHFNdW53cUNDaXZqTEZocW5NMjB0dmNjeVNrTEtHTTBC?=
 =?utf-8?B?cFdLQnQwVTZ0cnpCTW9GR0lyOWRjbzExcENWSWlDNElXUVhETkh0dmdHUzVi?=
 =?utf-8?B?Mno1em9uVU9nNk5lYWhsM2xPN0xZMDNCMGN4SjdNSzU5YXo0a0tTbUJXVWda?=
 =?utf-8?Q?fO6pTNDxaoc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c0ZlcXYrQ1JuVjVsTUdpaS9LMlIzSU5zWVdhdUozczVoSFh6dzlTazBzYnRP?=
 =?utf-8?B?WWQzTHRvL1g1Sm1LN1o4WFAvcXlCLzdTaHNRWnNNeXVOTlpjYnRJWVAxWGcr?=
 =?utf-8?B?cWJFTUlSeVVhTndQd1ZhZm9HYlpGVjMyU2daY3M0YzhaNk1oRW9EbVdKak5V?=
 =?utf-8?B?NE8yeFNyMnpLQytxcS8xb3l2L0tQT1luNVVJRndUVGNEbnlyK3p1R3FzdUps?=
 =?utf-8?B?d01zQnR1dGExUzBqKy9iNlFzY2x1L1FLMTU3UldhLytucCtqS3pXeVh1aW05?=
 =?utf-8?B?dnp2ejFoTjZvQ2tEYnpUVHlVUzRxTDFEUTJad0lvOWJKdmYyaVBqVXZ5YVBP?=
 =?utf-8?B?UzQ0TXhJQW9sZ3JSTk94VGNkMmVyTy9FUk9YcjhLTGR5VDZPSHU2c04wOTFl?=
 =?utf-8?B?T1gyd3kxZUhSbForRnlUSGJJam5VMjlWS2F4b3Z2em5va1F2bitkNDFlTDZQ?=
 =?utf-8?B?SWhZOFdQdll5SU02VXJYSWlkR3lnRDdGZWpkUWEwSGR1elZYM0VHQ2RkODRh?=
 =?utf-8?B?U001MTR0NDAxMWtHcmlMMlkvNkttTVA2bThOVW5jZDRFRmIzVU1wNFZPZlhN?=
 =?utf-8?B?OU9XZjR6NFM5Z0NVTWtucG1rQ0RzZ082cklVYnBMVnFNN0Fhby9yalhiWm5o?=
 =?utf-8?B?VU5sY1lDQzJCZ2xvajUzL2FaM1hrUWdobmpKWXRDbDRpWEQydlhrWHlGamZ4?=
 =?utf-8?B?SWxERUc0bXpuUjhQeHliTE51c1JuS1FNRlg1eE0wek40SE83ZmtXckZWM2xa?=
 =?utf-8?B?dzQzZGhtdEdZT3JVK1FpdlI3YTk1MnVZSzh0MnJKRWhhaklHZ2xPT2ZmUk95?=
 =?utf-8?B?Ym5PVWozV2E0YURRTGtPOHlqQTlORjBkMU9NZXRocXZWMkRDVEE2aVJqSkc3?=
 =?utf-8?B?cUdXZmZZN1hBT05MYWU5VVQydTFSZWdYUnFQTmdTdlYxVi9jZVhFZjdwNWhp?=
 =?utf-8?B?TzI0QjFkNzZCMmJFSUJJUlF0SHNOczNkMDViSDFENVRZdGFiZG4ySyszU2Zl?=
 =?utf-8?B?OEVlckV2QmR4VHJvcG5EM2xnVTFaaVdEZHNSTUlrMDZxQlR1VmtxNHZJMjIz?=
 =?utf-8?B?V0VpT3VNaU40c1dCWWtQOC8ram9sUEx1RHV5SFFCaytKVEU3UVlKYlZ5aThl?=
 =?utf-8?B?aEdTSzVhRjErd010ZnVxNzJqVGNZMmFTVFpyaXRQQnZIaWF6UGdIOUxPMzRa?=
 =?utf-8?B?dHlkZ3JhZHo1Y3JDMmYweVQ5dTl5dEtuTGI3RHhVajRIdmh3NHBKeUpjclRM?=
 =?utf-8?B?aWc3aEJUTHVmSkRhZ1djSnZiekdPMnBNbmh2SHdGSTY2bk5CL1VZM0tlcmR0?=
 =?utf-8?B?Ti81K3ZrU3ZIU0FIbUR1R2JWcDJqUlZ5d3VKNWthTHVJRUI0bVloWWh2YVNC?=
 =?utf-8?B?RU1HUGlZR1c1dWZueDZBVnNMeVQ1VThscENMOHU2amxRMHAzZ2w5SUh4TlRv?=
 =?utf-8?B?bGRyTkJqQTNGQVdqS1VVbW9GTWErdVJHeTRzL1BYZ1d6ZDdJYmp6UmhhbTdT?=
 =?utf-8?B?VUsxTUJFTHF5WDR1RFl3ZnZCdWg2Sy8wQkx0b09BV3IvTGtZeWtveHdFSnNM?=
 =?utf-8?B?RHZ0TzVhUWxOK3lqVWM5ekZzV1J4Q2pIc1NhdXBvTVM3YTlvMklVRmRoSmRN?=
 =?utf-8?B?UlVzdWM2L1ZoVTFJSXhSU3g3M2JnT0tYSGRCVE56ck0waFAwbHo4RmtoRWhC?=
 =?utf-8?B?TTQwT2ptejRCRzF3WmROOUFIWE9xd3ZaVjcxSVdwOWNFUUdza3hnVVM4L3hs?=
 =?utf-8?B?TnI3dVp5ZCtTdkJFclM1Ym5oVzVnTGNscU5IU1ZTdXA4VzdTclZCY3ZNWllE?=
 =?utf-8?B?MlI1NEFwb0dXZXIwRUJGYnB1S1JiVmoyQk1QVStpWllZQ2V6TFJoTTYzRmRC?=
 =?utf-8?B?cnZYWXMvM0hWdkN3elpXWkhLa1NDL0tTUkx5cGxWMDFUalJMbjBpMW05RkRX?=
 =?utf-8?B?TEdTblJWRlRLVHRPOHZ0ZWF3czVDZ1ZuRXEwa1FTUVBOdlo1SlFwQUwxTnEw?=
 =?utf-8?B?Njk4Y3lCRDBKcWtRZzZiTnhsZ1dJc1pxV3R3MDF4YzhSK1pLNzF4YVRtYlVh?=
 =?utf-8?B?eUFBbnlKUVp5R1ZrU2ozRkc3M2g5SDJNT0ROdCtzdU80NDNPOURNczk0cXcy?=
 =?utf-8?Q?vMyTpF5qXjnNg1OPBOTzpZMuq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ab15a9b-b07a-4864-275e-08dda38075c3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 15:57:08.5129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h9wtCwrnkAYkl8lYNO7g9L2kL0tg1cZ1PY0IDVENb6vy6mUSq8rxtFqA9yzw/6nOvDaT5TybMgJf02qDFx+SqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9519

On 6/2/25 14:10, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Panic notifiers are invoked with RCU read lock held and when the
> SNP panic notifier tries to unregister itself from the panic
> notifier callback itself it causes a deadlock as notifier
> unregistration does RCU synchronization.

You mean that during a panic, __sev_snp_shutdown_locked() is trying to
unregister the notifier?

Wouldn't it be better to check if a panic is in progress and not try to
perform the unregister?

Or, is snp_panic_notifier() resilient enough to just always have it
registered / unregistered on module load/unload?

Also, wouldn't a better check be snp_panic_notifier.next != NULL during
sev_pci_exit()?

Thanks,
Tom

> 
> Fix SNP panic notifier to unregister itself during module unload
> if SNP is initialized.
> 
> Fixes: 19860c3274fb ("crypto: ccp - Register SNP panic notifier only if SNP is enabled")
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 8fb94c5f006a..942d93da1136 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1787,9 +1787,6 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
>  	sev->snp_initialized = false;
>  	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
>  
> -	atomic_notifier_chain_unregister(&panic_notifier_list,
> -					 &snp_panic_notifier);
> -
>  	/* Reset TMR size back to default */
>  	sev_es_tmr_size = SEV_TMR_SIZE;
>  
> @@ -2562,4 +2559,8 @@ void sev_pci_exit(void)
>  		return;
>  
>  	sev_firmware_shutdown(sev);
> +
> +	if (sev->snp_initialized)
> +		atomic_notifier_chain_unregister(&panic_notifier_list,
> +						 &snp_panic_notifier);
>  }
