Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010010.outbound.protection.outlook.com [40.93.198.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFEAF3B775E;
	Fri,  3 Apr 2026 13:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775223245; cv=fail; b=ch+2+mbo9Mw3Y4kn2yHpL3gBYPuA2bci/rwfBeV+wLNlOpnz9PoATasX4NCfPcAfpXUXy04Ihf5ZAjTDjq1FwWN3EuVKzXNR1Jx+kxkfsqk6hiEAVH/6tEI2RKdxZRckqO0i+/SVQglIEGWbt+mSGH+Uzq/qiRvWOrvEEqvkAbA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775223245; c=relaxed/simple;
	bh=oX83JGmYS9J05EB7UL6jQIMiwD0+75alhoiTh1U49BI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Hg2gS1H5Eo7ZhYEyzJ8uX9hBIyA3ng2X0G+apoSqlKIyBQxpHIxDyI7rkcWzELuYXa8Nc/CL5zVSlB+Yxs+dJtxEkNlrgrCKsINyPkx77Ox4C7f4WRZB75dOubpwbwpna77kYZ/Q4zW2SEHe8Yeqw0MWQ2O0sVNUNTDcwl78muU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YAcd+VMa; arc=fail smtp.client-ip=40.93.198.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YAcd+VMa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WyQIFiHEzYbwBmntfkRq0aomdi6B+WbXgRV54ggLkB6+7OqY7TdkaZSvAKnlirmrrt7e1aTNPmVBvPqsRE1WpaZgCspOx4dHl3eBnejSOBadi7/+0LX9w7a00GMIrV9UBmmayDyYQyN11HNwaSLIvx0dw2CU+nPfpemTt4niLPH7sV2D6fsDTZuJgjqVIDPZjEieVXs6Qifrjz/oLDwNInh2sAdkrjBBg0C+dwnk/fKM6tcF82L4g5FAqWmvfVHtwFi3Wp6uq5PC/ewP81Hlj0Sg6J1os2A/ZrGVuSS/zS+6ppROgrhRcb6zN3O+rqJxXsuROWjfg7iBMjgxvhFctg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=teFpS6mcK9nqh+YMKAFfkkWBYs0MkaJPaWf4rC1qTXE=;
 b=tueJUSmRCEhIv+Qmwxtxrn2N/YDbuZ06TK91GNKXW1SoFR+gV3FTmLJ1htgbUcMXxCmNWY8krClg8m2Jq9HKXV4Gjc1ioyGkkr1wGB4DhIo444KkkO4km4jns8rMEzemE/oy2a789ebBtkiOU08haFeAjcfGrQvMwbNRF6oOgwDcph5x9NrVSDpgANXGniHU/a+JlAYttE2OD3IWzUjwBkpIgbUjspfZNScpYmUlaslQvt7fUmU2W5cVJH0cgnIcgFDOWMt/WG5ES46kp/RF1QCX3lvIMhUC7RQpe6puAokafleyazJhZ/X0KwxSpHK0Ldl6AgvmmCzYgta0rnCL5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=teFpS6mcK9nqh+YMKAFfkkWBYs0MkaJPaWf4rC1qTXE=;
 b=YAcd+VMaZBJ0HakJ4okF5YSQ/7ARYRM6HZGegU3M+0Rn54Q0kw/AqE/EpamM0nwpfKZmioeoxgU0m3TJIfVFECsYLowGOJkMgdQUYatAYokWvSol6FpAaSZuq9RRDwuZiyniI/pPES0nmJU8na4MFav7zYmrOnQRoDKnYSKd/gs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by MN0PR12MB5882.namprd12.prod.outlook.com (2603:10b6:208:37a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Fri, 3 Apr
 2026 13:33:59 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9769.020; Fri, 3 Apr 2026
 13:33:59 +0000
Message-ID: <fd1efca2-ef3b-48c9-8910-f89dd55c11bf@amd.com>
Date: Fri, 3 Apr 2026 08:33:55 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] crypto/ccp: skip SNP_INIT if preparation fails
To: Tycho Andersen <tycho@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Ard Biesheuvel <ardb@kernel.org>,
 Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
 Kishon Vijay Abraham I <kvijayab@amd.com>, Alexey Kardashevskiy
 <aik@amd.com>, Nikunj A Dadhania <nikunj@amd.com>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>,
 Kim Phillips <kim.phillips@amd.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20260401143552.3038979-1-tycho@kernel.org>
 <20260401143552.3038979-2-tycho@kernel.org>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260401143552.3038979-2-tycho@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0019.namprd13.prod.outlook.com
 (2603:10b6:806:21::24) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|MN0PR12MB5882:EE_
X-MS-Office365-Filtering-Correlation-Id: a1568b7d-257a-47cc-6037-08de9185a91c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|22082099003|18002099003|56012099003|921020;
X-Microsoft-Antispam-Message-Info:
	bUi4RCxedvEGYix+hM22LB8sgumKbDbSjvGXTk/r8B2bOo/VMBxQhPtn5vffSQQxRsCQHf4bAJJwoa8zie7tZDCfFqsUtTHQX0t0+7k08rS3AUSmYk5JFReZG3UtHzqwaUN0DQQh4oQjOzIuvy3+ZvLslD0BGbEPaVqraBqUSqU/vu9vEA3jZ6Mr8L+teV7MGDqCuTM/STBPiwKpq6SlPxhJtY6TxJ/4fuu4H5Z8lTUd5DBxkH+KBgOvdkFNWJjN7ABcuZ2MYmZ3wG+rFxEITdvIP8dlsXJM0GH0/ZKeTBuVc7YZQs1ThulNaGaiE/+LHXSYyZncx8oLe00v0yCy7YUX+hbNy8gzR1EZZWIJRrTrJVfol1rras3tQz48DNYTO6Nw3MD5O0Risi4UeWnJ1Pj/5EQBIMYCTbTrrcstcbikw2padeRipMAelFoBN9RrawYxw22lnDxBe0XOGV61YsCXJ5DOJgbrI14261cmxYryKNeiLey2Yh5sHQDOlmvUKgPngMi+DrZxeK00bPtMLnwG3Ve93P5fEJUS/HywNq/cqJV5HkDNVSlggSnrpnvHrYJQ3C4cicDJdnXe2IOKNPwDGBM+hYPKBw3ZMnneKINcoMp6J7vhFnjwlRjoaZuHhpGQZpLyurd21bcJqX+Bavj9f9n3psCgRRZxLO1Nsj/wdUgqYEM0yxiw2G61J3eKqI1O8HBKrrUuEXSRkjwJTZNDW8lePYJBwfGAE1TLKcnvx4RSsxS60LOmzNHpXFdfrNF97dLo7iK0EEFoMOuTTw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(22082099003)(18002099003)(56012099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SC8rbFpWMWxhcmNqSDFGZHRYaTVTMEkvbjdGMUh4T2JqTDZaWFpIQjZiaVZy?=
 =?utf-8?B?UTR1WHpBaU5OZzFuWkJQb0JaRFY4VFVIMHZHSC9pbjdheUI3VFFVK1Rud3FL?=
 =?utf-8?B?QUpGQkREbUNqSVpsdUVQUlQ5SEIrWHJoOXJCL3E0ME4wMmhIYVdvVmtBNzRY?=
 =?utf-8?B?UHRmV3NoQmdFZ0dTWHM5MXlmSnpodVllQ0d2QmRMNjV4cGN0cHdwejhIdXB3?=
 =?utf-8?B?cDcrRGUrcU51QnYySjBkeHBLVXN4RGV2aUEvYThGNEVhNDBRbVBveGxlQndV?=
 =?utf-8?B?RFhVN3dpYm1zWWZDeENuY0FmUEtlR3lWQzdHNlZXb3BwMlA2OWRkRUE0WllB?=
 =?utf-8?B?TVhXU2xyZU9GYWpVdFk2YVkyT1I3QnlkSXI5bW9qaktlaWs2cTQ3SnIrbDhG?=
 =?utf-8?B?MFlIMTdVM0xpcmxZOC8va05QSHlGeXNVV3FUbmxkVHRzeUZhdVJkRkZwV29W?=
 =?utf-8?B?dHNIM0ZKelZnQVJoT2xCOWxJZDVtbVRNQ3gyUHI5QUlYQmNxekxCMXJ2UjVK?=
 =?utf-8?B?b2I0bUlSSUkzazdZQkVKb0lPcXlURFpwN0lPWmdOcnFxaEp5WUY1Kzh3ZTMx?=
 =?utf-8?B?NFRlZHcvMmRsemo5a1RtQUNYTUNxaVJOZUhUQUVXZnFhYVN3QWM1RklXWWkx?=
 =?utf-8?B?TmN6dUN6dGRRR2xNK1doZVVuSlQ1eHZ2a0F4NjdnWkh5SXRKTjB2SnZoTDNZ?=
 =?utf-8?B?WUJNM1IrTTNGaGNwbnkrMExBdXBUR2xzMXpuYm5nSDRoY2liZ2QrbVEvMG90?=
 =?utf-8?B?amwvelpzL2RQbmtVNCtuL2dWRDM4RGh6emFUOHc0T3h1bUFDRlc1WUZpTWdj?=
 =?utf-8?B?YWNaT1pqSXRadzFHYmduTDloc3JybGpHMWxOVTBWUWUvZUlkaEZhK09SNGo4?=
 =?utf-8?B?eUllRldRL3RqZGRsZklnRSt1Y3B2cjFQQlhWSXhMaVdPQWhCU0l6OUdpMDhr?=
 =?utf-8?B?SXQrcWpsOHVCd0VUdWlPMGQ2M0JnbWRuQUZoamlJRVdrQkhxWkdldFA5K2Uy?=
 =?utf-8?B?cFJYelhlNnZLMTZsbE9TNUZBV215OGVwbEpJQ21TaFpDTHkyaWNPdkl5M3Y3?=
 =?utf-8?B?amdyZ1pzYTFVMmwzTnZmVmNEVzhOU2JGVkNZeDBFL3RidGwzSHROUWRubEIy?=
 =?utf-8?B?UnQxcndybVcrdW96NTVETlNhcjYvUkFkclhrazZVelNJQklhT2JoS01RZFpG?=
 =?utf-8?B?ckxRanUxNFhRWndmY09yWXlZN1RQblBjU3Q4L1pSRHQzYXJnYzhJeW1FdE5h?=
 =?utf-8?B?Q2JMN0laeWdUaUxNZ3E5dVdpWUZJWUhGa1BRc3IvWkx4UDNyVnAzWkxRSmVC?=
 =?utf-8?B?VGoyQ1EzQWx6L09hL1Q4UnpSME15c1RGOVM5M3VlQUNUVTlYVm5xaWJEMDdY?=
 =?utf-8?B?WE5iNjA1QzdKMUZtSFJvY05aMDV1amRsdjY4bHV2M29sdFFzRWRWdDUzQUdG?=
 =?utf-8?B?eWlzV3JjNEJLMFplY0t0TkdoWVpzcTVMRFV3a1B4b0tPd1NKUmdjdUkxRG54?=
 =?utf-8?B?ZUFaN0xGSXd0V3V1SlRDS1hmL1E0bHgwRTdQS3VvcXRYY0RsckthZ2xVZFhH?=
 =?utf-8?B?SUQvN2ZlT2Y4UjIweVBvUzQySjNIaDRrQlNicG90aEZVeTQyVlJYZjZ0TmtM?=
 =?utf-8?B?Tm5Ic3BRR2xHMUE4NTN6NkhoUXh3Z0EvbE1IbnVsZzhBdFFJOEFHUCs4OVY2?=
 =?utf-8?B?OU5FY3ZBbjhtTEJ6YnVsR2RVQ0YraWVBZ0pLc0Q4RHZ2RmYreWZwNWdRWXJ3?=
 =?utf-8?B?MWo2bk9DTGx5N0xPOFhvaEdkak9NZjBtR25BUGFkektIUzhUdXhKdnZWbndo?=
 =?utf-8?B?MzNrNnJmWXhGTXFzOFFLR3p5a0tVdWVwWjNtblFFdkErUE95Wm9RTjlCZit0?=
 =?utf-8?B?K2s3dXQrcVEwRHdOYmc0aWsyTGFkYkFzRnUxa1c3ZzB5T3VLZ1h2SzU4cXpR?=
 =?utf-8?B?N2pUSTl3a09rQVV5ek0rUTJsMlVmVE96OEhGUy90ZFBBTjRkUUthNmluZXlG?=
 =?utf-8?B?ZzJyVFRmUENuNXFJSGpsUjFHWGNqN0lZRUplcGJ1WlFtTDVHb09ETGRGWGY2?=
 =?utf-8?B?bUlNNytTWElpVjZ6YVlCVVh2UU9CbUE2ZkFpOFYydEREdjRFYnVTNEViR3lO?=
 =?utf-8?B?alk2VHFxeWc3TWhTOUdyZ3N4S1EzUlpQQ3djcXkzaHdlV2FZUnJLNkIwcHdh?=
 =?utf-8?B?MDhGU3hUU0xjaitXVlBOczAzV0R0RGxiQktBNzdSa2tQcjlwb1RwakxuNnE0?=
 =?utf-8?B?azB1RUpxN2pzUUJ2NGFXNzUrWFk2TWYwT1V4M0EwOS9QT2ZKSHdJOWFXNGF1?=
 =?utf-8?Q?iVRu9rp4lqtZr7wyAu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1568b7d-257a-47cc-6037-08de9185a91c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2026 13:33:58.9197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JLsTjPdK2EB/UKLDRttE+wTusw1Ob6lAFzL7ShIYpDf9frs/dC4veTyy9AZxOn3z/cMBgqAobKApjhXkR/tHQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5882

On 4/1/26 09:35, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> During SNP_INIT, the firmware checks to see that the SNP enable bit is set
> on all CPUs. If snp_prepare() failed because not all CPUs were online,
> SNP_INIT will fail, so skip it.
> 
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> ---
>  drivers/crypto/ccp/sev-dev.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 939fa8aa155c..1fc7ee432e28 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1374,7 +1374,10 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>  		return -EOPNOTSUPP;
>  	}
>  
> -	snp_prepare();
> +	if (snp_prepare() < 0) {
> +		dev_dbg(sev->dev, "SNP preparation failed, are all CPUs online?\n");
> +		return -EOPNOTSUPP;
> +	}

Shouldn't this propagate the snp_prepare() return code:

	rc = snp_prepare();
	if (rc) {
		dev_dbg(...)
		return ret;
	}

Thanks,
Tom

>  
>  	/*
>  	 * Starting in SNP firmware v1.52, the SNP_INIT_EX command takes a list

