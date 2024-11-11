Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2088.outbound.protection.outlook.com [40.107.237.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A51156678;
	Mon, 11 Nov 2024 14:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731335308; cv=fail; b=srHh7S9h8h/HhSi60UHwvlwc/33mwHZiqwGpfO0LLmcqARGRY2E18At8dzeFpnPjMnui1rUixcAG5o7ATPOJhmDrniS6cW9oxNM2hi+GtA3od6ISFxvBcYG9uY4bIHPkuH5c0E2WLGU2Fxq/KGvOgtc3x+YP/ZDX2tbQ6Q1StlQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731335308; c=relaxed/simple;
	bh=Pamo2N1Ar+GtUwvcmV5vbBSOgl40Qr+jmM912dCMdMY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HFoabGo4SL0wWFHmiCgY7blLBwOXBfUUOhs4SQJn1Zrjj3+TOEi+2l4FiiEajrKpmUNdGIeH2GNsGQMmxs8Y7llba1u+IjgrIbf2MACCqiL54p/RcvPKRRnFHLKCXaBrxafU9ta0R3mGa31qxMlBXtYyNmn5Yk07W+uMBY4lQKw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ux6XS0U6; arc=fail smtp.client-ip=40.107.237.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ux6XS0U6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fMw3YmXCbeS7kA1FfJVs4vJwz5P8RXj1LTszQG2zrsmdPbnhVYdfn9Y+zJKf4bz3qgoFP6Y9OP6C4+oe/jQnhtKFj5JT+eYAlpH3hT6ptjIeJR/SA8KI0/EzZjJf0YWBQABVo20HCc1qKKN0iy00ccVzk/zZ4zqjeYbloCvpDM8D6mVXqhhiZO07dPVTJgTwm2jN23VvmbonDK+DKzQUQlgXUgdhk+D4wlc6kwY7K6r07JvqwjrktwwOk7eIg5AbFs1pGXxaHaDSQRsQqE9F7qtQjrVYLf7M7XY0LXxqViaZWs9jGu2dCSAd/yHWOxP3zq6tJuWKclSOp5tGgu5SvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=drdtu2tStZSidcM6wzcgFmPEji8m4uw/cXgqdRcZ/3k=;
 b=rBKaqT9q2M85gKeUCd31Oo6ZZzN2uJav96TFr56HLgyh94sGagBiDpSg2LfCyG7NYBfUJ7qB213/NLdfTauQywNGNq6CrwCLf7FWhGTnZenHxpBUjxLLxTZlJ9z5J8hTxou8Ix008cFlYv9aXtVMDuaSEBq2F8p6ej2zQZ2LMxqcRu2erR1Eq5IE6otvMvsk7Nla+NXCtkYi4wsrovFjh4+NZWGWUILnESfYXRzoE2EOaWfS3Op25vzyc/yGttV5pF68wKHIbuhJm7+mFBNoo/fUW1cUrhlcVisaf9KqNyxpnMPkgOT3IuUcuSFeM85NcuFhbhEiE7tZQuoHI3o8Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=drdtu2tStZSidcM6wzcgFmPEji8m4uw/cXgqdRcZ/3k=;
 b=ux6XS0U6CGar9ErFZZJlJufdJSTwJwr7OgjKZ805yn9T/W58nKIm7p2Rr7wcCOFQ7OHteWA7E3+6X1DN5lk2p9u4wt3CIRkJZoubivMpjfQfNOUc75vN8pbz6oA8HXt+8PVYXVdkS6GGJmEKcJlh8YDnR3XdQlK4DGMrwx+FNR8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SJ0PR12MB6710.namprd12.prod.outlook.com (2603:10b6:a03:44c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.27; Mon, 11 Nov
 2024 14:28:20 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8137.027; Mon, 11 Nov 2024
 14:28:20 +0000
Message-ID: <e2102da1-3418-01d9-06ff-0e7bbb427e38@amd.com>
Date: Mon, 11 Nov 2024 08:28:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] crypto: ccp: Use scoped guard for mutex
Content-Language: en-US
To: Mario Limonciello <superm1@kernel.org>, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Mario Limonciello <mario.limonciello@amd.com>
References: <20241109020054.3877377-1-superm1@kernel.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20241109020054.3877377-1-superm1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0058.namprd11.prod.outlook.com
 (2603:10b6:806:d0::33) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SJ0PR12MB6710:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ab34971-8d3d-4bb2-7998-08dd025d174c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bEJhTFA5ajJyaTZwQXNDekRmL25haVg2dzhkZjhXZzQya1IvVUV2S2xiT05p?=
 =?utf-8?B?QkwwY3M0MVF4dGUrdHJqTEk4WFNOR2tiNTRjY096OXJPNjZ6aTNkOGIyb256?=
 =?utf-8?B?TUtsRGg4UmpncFdZdzBJMUExRkNlT1VjSGhRWERNTllEWnJvZENrN0VKZUR2?=
 =?utf-8?B?b1VQT1NpN3VDaHRMSVluRHRJdlZMdkhudFlGd0ZlZUtqMzRCU3FvdTRrb2hr?=
 =?utf-8?B?eVcwMlk4dm9vWVdqM3Ficm5nczBUWDVtSDh6VXlpUHZyM1NOT3NhR0NFb2Nh?=
 =?utf-8?B?Qm9ya2xOdDJITUs0ODV5c2NDNEdaK2RJN3NORnNzU0ZVc2M2QjJTV1hyUmtX?=
 =?utf-8?B?eitoc2RtVlJJdUVXYi80ZEt1UXRmSmJ6R0NLcW9wSnBqSmxEVXRRdFdZRTg1?=
 =?utf-8?B?aEtLekVIa1J3ck1NZWgxYzhaZXRXdlJSTDc4Mll2aDdaaGRnNlgwS0oxTzh5?=
 =?utf-8?B?N083cVlENkdKcEZLckIwNitLVTNWamViaWFXK1Z3WkxFcnlMclRnc3NMb1g5?=
 =?utf-8?B?NWxrZW5seEk3NXJheEtwU2lCNGNXekFueVI3TDIycHJFOTJjTHNUMU82bWdv?=
 =?utf-8?B?eWNDM2lvQS9aZnJkZW5VMlZCYy8renU3T1RvZ3YzeGNZd3ovNVpUVklpMU1I?=
 =?utf-8?B?SUk4OUVuMFVrd1pNVkJma0JqVFJsMjh5NGhoM0lSdmdoYnZjVWxkenZrd2VN?=
 =?utf-8?B?KzNQNkpkeWhrN0JZNnBLTDZDcmNjd2I2T3FyVUVRbzV3MFl4SDJrOEs2RFpZ?=
 =?utf-8?B?Qy9ka3puaFcyZ3RUYk04aVdvYXFDYzZ3YW5pNEkyRFVXVVVGY245WTUzSktL?=
 =?utf-8?B?Wk1hRUVVNzN5eDBkVTc0ZXpsaGN5eDlYOWlHM0NTcjhqVlNTTUJpc2dralZu?=
 =?utf-8?B?d3M0bmlEb2RWZGRyVy9wQXg0Ym1vUDFlNDhLdVVVYVVYL0VnT3NDMGJ5OHpm?=
 =?utf-8?B?SlVjRXc0NnJOemRXSkNlTWxvNXpNM0Q0bFYwVm9yMC9wemlqYkJJYW41TER4?=
 =?utf-8?B?bTJuMXEyVWxTQVZzeHFodlZuS2tVYlJQQTBhb0toL3cvdSt2REpmajdxTk5W?=
 =?utf-8?B?ejVpazlzMkQ4RVpWTmVqUGhGYnF1VE9BZ0p4UncyWUUxUEVUQldzbGEzOERH?=
 =?utf-8?B?c0d5OGxNMVZyVWFzcHRvQUlXVEE3bm8ySCt6UGNzbjZIWVc2ci9SWmdQSU14?=
 =?utf-8?B?cHREbms3ZkdmR3VvZ2tuSm1mNXpXMXo3Z0JzeWZxVkNTblp5UnF6eUdzeUFr?=
 =?utf-8?B?dW5vQjU2Ry91WkxuZHVTYW4vWGlrYTFzaXlRdzNMeWV6Z3lWVnJkSmQ2dUpU?=
 =?utf-8?B?eHdhZDk5SnJvSlB5ODAxNGdOdW9LMmhQVU1lU2VwZWVGR21JQUFPVVg5anZS?=
 =?utf-8?B?MEtYWnQ3NFkveit5bks1am9wUlRXcWpqWTRna1lSMGR2N0VnT3BhUjBRckE2?=
 =?utf-8?B?STUvRlJpS2gzRmMyaGhhSC9Qa04zd0NiYUg5Mzl0THViNW9oZW1kSldUWUF2?=
 =?utf-8?B?WEFKOWVldjhrdW4wdzhTbmwzUUNOSWtWVDI4dGZWd2plMkxZUTNkN2hrMW5p?=
 =?utf-8?B?c1RyN1VyWkN0SFMyazJYTXZjcnlNSm9BNDRQdUY0dGl4cmQvVmZtTkFrYzM4?=
 =?utf-8?B?QWN0ZjNKR2NBaTVWUGllR1pyT05QcmNCOHp4Qkd3RGFQa0I4QktEOHA3NGJk?=
 =?utf-8?B?bjVBNTV2ZnNIek9zQVdQanpROWplKzArdW5zVmxpUm5qYlBpcVlkMG55aHhn?=
 =?utf-8?Q?NF0ax1V8b6okdKMIiEBz8RRUxuZHsNJ8u4HQMzL?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b25BMml5bnM2dmVXRzhDcUlDTXM5T2k5cXB5TkZyY1QvU2ZCTzJ1TTVMd3NH?=
 =?utf-8?B?WENmdUp4WjFWOUs1SnpWYklBVHArZWpBVitNaVAzL2ZpZXBLSmcrYkNPbDAz?=
 =?utf-8?B?am5Xa3NwOENCKytxRVpVTzVjcEd2TEFqcERMdjljTUJsbTNEcVY1RXBiYytP?=
 =?utf-8?B?bW9PbFgvMXBDTnVKa2pZMFZHdkZXRkVjZVFYaDhycVVDNzBMRHRHbncvTHlt?=
 =?utf-8?B?L0pIZ2NNZ3MrMngwWmFJd0xsQ01sY0VURUQ1YWsyTmtTR0grSUJQd2kyOUhv?=
 =?utf-8?B?cWRLVDFkQkRwVzlsMHNueHh0bE1NTml1ZFE2TVhNTTgzMlRiMXFaVmdETU1s?=
 =?utf-8?B?aWhmNDFVTGVQbkZUNDBRcGM0dGlRZkFWY3lWblBWMis5d1hFeDhoRzBvOXVK?=
 =?utf-8?B?YXM0aThVY0lXa1pocVBwM2t2NjI0MTF4VDFrTEFRbXAxektyRk5SL25wUXkr?=
 =?utf-8?B?ZEcxenF1OGlPbFl3bFZRYUZMRUo1NmZhMUw2cFU2UDNSREFNRXlnY3NSK2xR?=
 =?utf-8?B?MUpkeU9UdUJ4UE5IZmpPenNDS01FdXpZWnZuc3JzRHBYYUcyWExoSWcxa2ZS?=
 =?utf-8?B?RTNkWi85Qy9sVWpSNVY2bGwydDV4MnZweFJYRXk2ZUZ4UCtUQTNSMVN3ZWt0?=
 =?utf-8?B?ZW92dFRlaDE5cGxyUm9TMEpZTmxMMytaekhsNm5WOThqRlZlM3poaWJHdzJt?=
 =?utf-8?B?NVpJelo5b1pRbWFaZmF0WDR5c0pSRW0wZVlNOVFtK1VpTkhKd2hQZVlMWFhp?=
 =?utf-8?B?cVBHMXYvazBWU1lkeXQvWW9qRkRtUXpmalpKeEFhMW5yQU1zOUhudjVGNHJx?=
 =?utf-8?B?UVdtYldJT1BzYnZ5aUVjc0ZBYVh3TUVzVkhZOU1CVVcwS0EzVjFUemxHZEZS?=
 =?utf-8?B?ZTJ3NkhZK0RnQWdMVjBJY3hsM2pLQm1SUG9uSlprbC96WlRVNEM0c0x6UHZw?=
 =?utf-8?B?VXBaZkI5UmlpU2o3V1ZLdWpKZVBzRHE4VEtjcFlmMTRRSXhGRE9nV0VndHUr?=
 =?utf-8?B?SU5mZlpUWWNsTllHbmlMVmdmODZ3ZHFWUVgrUXZuMG5jMW4zM05RdE12aWRm?=
 =?utf-8?B?bXFUa21CbmNmUHloRU5EQU9rSTZyaXZ1SDdqRitxRnQ2bHBJZjJvd1BsUERI?=
 =?utf-8?B?YmhKSjBkd1RPNkp0TmZGS29abUcxU0pZVUZFbUVqUDN1bjZuNHBBZkgwM1A1?=
 =?utf-8?B?S21QYXJkS0YwdjhYVysvS1B3dmVaUStaLzkwdXQ3Q3VVZ3NkYm1IcWFZS1VW?=
 =?utf-8?B?WGR6bXRtVzV3MWNBZXpQWTMwNFc5eGZ2MUR2SkJkZkpqYXdGMmwxR3k4QU55?=
 =?utf-8?B?UU55dUU1eVEyOE5zSUtmaWxESEJWaDBKeDh2c01IUWEvRVJmTXMxUGp3azAz?=
 =?utf-8?B?RU5YVFh2Vlc2TDBGWXkzcHFTMzhBWjBaL2ZmYmhYdDdDRGc2a3h4WDN1eUFv?=
 =?utf-8?B?V2VCckF6RUFLUUx6enNHK1B3RWQ5VEZFMUdsakxxM09LeW5aVEdkc3QwbGJY?=
 =?utf-8?B?WDd4UGM2WE4yT3pCdUdwTytLbnZySzJ5UXZTSm9lc0NWY0dKZm1CYVl6MUNm?=
 =?utf-8?B?ZGljZ1dtcVRSbmVnSlFnNGVnaERTZ3piaDRIWkw0b2NKY3hUbmtlc2JkZW9U?=
 =?utf-8?B?dEFRczJvWGVNNGZabGhmN0J6Ykt3OGd0QjhtRE8xYUY3RmU3b3poNXVoZWxX?=
 =?utf-8?B?R3ZIemdKMDluQ0JzM2lHNFU0Nnd6QzFTZFV1aXhaNk94UW1pdkhIam9WRUFU?=
 =?utf-8?B?M2g0Vm9NNWprdzFjbmlzZXp1b3FSVmZpSVdiZU1KVmp5dStPQlpXMVp1a3NM?=
 =?utf-8?B?UEdYRmFQSVFIVnAzWnI0bllqUndjWUNuTnBoR0Z4VVRNdlNabFVyR1dVenRw?=
 =?utf-8?B?NkdNZldTMlduSVhEU0lVTmlmVk5LVVBPWjNTSXY4M0NNcFVNNS9DaVBRV3lY?=
 =?utf-8?B?WXZkejhScWJYNHFGMFFGeGRkZ05uc3A0V3IwVVlrQmJhdW9RMmpXenFqbnJm?=
 =?utf-8?B?NFZaNG1VWC9LSmRvMXRTdDF4ckpGNFJmeWJNbkJkVXV2ejFuSHhJZ3JzYkdn?=
 =?utf-8?B?aXJSUlIrWEpQVWs1QnVVSVVBNHAwdmlaZWxzVjNCZzhLK0kwYWpxdjhqUVNr?=
 =?utf-8?Q?qUuOcDfjUwI/yoRtfesSXxzZE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ab34971-8d3d-4bb2-7998-08dd025d174c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 14:28:20.4549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pd5+iytW5B8oWlCZKbZloj1Q5iV8YoXjmrzSgd2cqnLUcmirXHQ/G2OY5WyibR97WTdb0qmplfzhxQLCxzudtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6710

On 11/8/24 20:00, Mario Limonciello wrote:
> From: Mario Limonciello <mario.limonciello@amd.com>
> 
> Using a scoped guard simplifies the cleanup handling.
> 
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
>  drivers/crypto/ccp/dbc.c | 48 +++++++++++++++-------------------------
>  1 file changed, 18 insertions(+), 30 deletions(-)
> 

>  	default:
>  		ret = -EINVAL;

Might as well make this a return -EINVAL and get rid of the return ret
at the end of the function, too.

Thanks,
Tom

>  
>  	}
> -unlock:
> -	mutex_unlock(&dbc_dev->ioctl_mutex);
>  
>  	return ret;
>  }
