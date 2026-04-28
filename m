Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011056.outbound.protection.outlook.com [52.101.52.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156874A07;
	Tue, 28 Apr 2026 21:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777413404; cv=fail; b=dedTxBvYA8g8z25pm538Ho/HaeVlojJRasPTU84nOSGsssJfxwppFaO7K/A7/WcipII1TzW9ZxcvDDyQsuAFXK8b6GaQAH5ph1SgiORfVfsxxVfLL2pWxsqk+TNStlNt1R7bku0ZoOtsiOQjWELO6f/d+sJHkjRBJcXpZZ+TWr8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777413404; c=relaxed/simple;
	bh=4Q/1Tupoi6fbcdi5DXN07Sy2K9KNjxjplZLTtbDbvjI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BwCnKmx9Q5wffgpVhk/jGrvJz/S00HZpv84ojIkP3v49jRDA52jXQpgg88TfAzCrHKtbKHz5y1/lodIfcQxLwF/ayKWDtxMhJfEAl67lZHuLpVdjMafzX1omcs1KiTLaV57dl0hePZEnEF2W8WbYSNBDkRU6Osn4lXAXgshbF5A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RELY1lVI; arc=fail smtp.client-ip=52.101.52.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RELY1lVI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Km4fqJPBKf/XDkKF1R2vNjp+F7t+8ESJzU9hVSiI3296Gjqc3C7gUESqqUOTPBpmu8c7XVx/yFfaZT0X2T6SpjAxt8QHJUHvr64uBjVOXtshloPS/dBs4tCw9Iz4ijsaK6phik7lUIJb6DtuyNrMHHLLTnVnpC7GLSnC6flAzOegL1pX+6ItMFxY6KofulU9P89gf142JGrYil3W3B8Eh6dpj817GY3jMoZoHwzkC2QfK4DrZQJiWWbzOiE8E2QBv/OcFsqMw8SOyo9r6awniXyufZA/DKI+t79gqLsJj94xj8m1c5CJogNpCXCamGGazCpI6pHmEw6l/yHtDm0tEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=stZmZ4Ub26m04ikGtQ8AOqJIXl3uts4t5nD3BmHZTAQ=;
 b=G8JjFT/m/9ZbyUA5zZ2L5Bd7aLFJBnJwXfP7kK2hzb9zbOs/XOBLz/fyltniAzf5dR1m9kdgArhCk6Iju6FtdmNftMFtTnr2VMmqzktSk38tcP2Lcp9dJKUVAjTfKZIMPUg2kyzgmIdCE85GgUpDXvAZ27Pz8zvX2lPewz+J/DtlExqDK/ByIf92CP/NPcm3y6zBczUo0cOobQvY8nLO77QVhkTtP+O1yyEaftU+RsQvFuDukwga+K4aJK1UpNEvdQBl7tfg6zNI9lwND2kiycDC5+duQi4ylz2bUttxPXJ8enqQatPX3mR2NyupEfiQCsasHNBX8I/v8O77tciDDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=stZmZ4Ub26m04ikGtQ8AOqJIXl3uts4t5nD3BmHZTAQ=;
 b=RELY1lVIRsyQ4ksK1k2hncWq1wvw/Y2KPKqsaLIJi8ZakvcpEBXC+SlBNbLgg7pEzdsjEFrNXUv3KfyJO6gPT1bX+emDx8+lgXtTsTwYRU0cK6M2S877b96sYERUtib4ObMCKrvab7mZw1e8zNa4M7ISTq1HVCYr11yS+4bxctg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SA3PR12MB9178.namprd12.prod.outlook.com (2603:10b6:806:396::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.16; Tue, 28 Apr
 2026 21:56:39 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9870.013; Tue, 28 Apr 2026
 21:56:39 +0000
Message-ID: <26259583-bf58-439b-980b-76460e8ebece@amd.com>
Date: Tue, 28 Apr 2026 16:56:36 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/4] crypto/ccp: Do not initialize SNP for SEV ioctls
To: Tycho Andersen <tycho@kernel.org>, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Borislav Petkov <bp@alien8.de>
References: <20260427161507.32686-1-tycho@kernel.org>
 <20260427161507.32686-2-tycho@kernel.org>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260427161507.32686-2-tycho@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR18CA0022.namprd18.prod.outlook.com
 (2603:10b6:806:f3::21) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SA3PR12MB9178:EE_
X-MS-Office365-Filtering-Correlation-Id: 540f659c-f220-4f42-bfa8-08dea5710634
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	qc3C+ox/TQPIXI6eOCFLJ2vg5byj6v9eJvr1BYAnAee4b8sX3FzOR87Eu5u3lSpal8a0k2A0BAIFT/Vi2vr1IjN3UHI5qPQjr6ay6s0+jVpnWJNT4DXKjV9cWN9MzGQNKkhhsuUi0HMVpWXj0HvcEftmQx6NmbVbTThd+AAkQu8zAAVzk9a1no+koTbwIzvb32v+iO+vihiBaCzWw0voXHfgzcIjLTeDoH7Q3IqLlF+HKB0cf3W+1qmt8zx4NA66QmNb1gXIl0Z15xl3bydaRePVonVs292ad7UkGvxRnX9kXU32qcBUh9iPEo37sjRJDZ3ZnBIE2UzP0DTXlyz6e+f1cgj7MA/OfwrnmtIjdXQyhQ8QU12fM2nANiHnfFz7YeEP69w+NcpaxvP/+zTU9pweWoO3uGwqRja375ScC8evVcMT94M8KBPKsvfCveFgBe6mafX/qpUTEVvwScjf1Hx8UvqGrYKt5IM8kvIR8fazqQXcXF+NHtYkNYJ1rLHwj3uTl+a1nVvUl8h23pAG2u0QmZi2L0MXtWJX48T1mB6TAPBYzPaDVHJv4uUsxzPFjCSgyr6RbA+NwUGmBz99IEw0d35HGPmUkZFMS25qqpVKKapmrTrfQRiHbjXGZjNkSppoktzUvu5gvQ+AViMPt6DODtcWudD5Wx4+ntaaLgwVUmxiE9rcTHiitqqvnx15
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eUJFbGZGdjJZNWwvY0NHNHNMbkdWSVFtbCs5WnIyZmZaMXpELy82Nms4bHJB?=
 =?utf-8?B?Zlk1bHNrYUdZdTJnQXplNnJUdXhDN1ljUFFSVkxyTFYwSFYwR0ZiOWFYVkw5?=
 =?utf-8?B?WmdtakhzaTAyYmZ2L28yY1V4VkMyYytMbjNFQVVEbVhHSERYRVFkZ25pa3VX?=
 =?utf-8?B?eXg1WnVMdEpmRzRLa0JYWTd3Y0pnbTdwMzlJN3d2K3Z5ak5tZG1LRTYzbFNv?=
 =?utf-8?B?QXV3R05mR0poaUJObmNGbU9UOUw3MmpFdXVjZWRlT1BCM0ZWZXNlOHV0K3gv?=
 =?utf-8?B?L3Q4TnNaRzVsY1F6Y25mci8yS29OY3VPUnNkRjA2WEc2c1dJd2ZWelNuNW9M?=
 =?utf-8?B?RjBqZTZVYTI0VG1xc1FnK0c0blpxclVHendZSGhNWnQ1RVZSLzVKUHBNc3JE?=
 =?utf-8?B?OENCM0tNQUsyNlEva1NnMGIyMEl2WlZxRjBxUmZML3hrR0tJOVk2Sm5Rb1I0?=
 =?utf-8?B?eHY0eGhjUnZIMnNzd0hmOUpUb2M2VjhzVTQ1dnl5WG1rNUFEU2t0SUJNY2d5?=
 =?utf-8?B?cFR4TGV2WVVUSUZ5U3FVOXZQaXJtZ0FhTHNlMUNxMnFSQVBrdHEvYVl5S1NP?=
 =?utf-8?B?YVQyQVM5dVFaTjc3T3JmeGJ2ZlV0RnpIYUUzcWMyRUdCZ2pxcnFweHhUcGo5?=
 =?utf-8?B?RGw3aFFBWjhXK0thREN5bUxqYkl0djgyT3VIdHIwWERsMTl3UXpYSUx0N0tt?=
 =?utf-8?B?YThQZ29QMjZ5RUNITTg1Z0JUU2tpVGxzd0JCZnlvekNPakVTMzhwN25yNUJF?=
 =?utf-8?B?R25OSUtVdjU2ZnZDVEcvcC9xTGljY0xhRWNVMUk4NnJCblYyLzgrcWNKejNa?=
 =?utf-8?B?Z3Y5TU9SSXJVcUYrYy9XcU9YWldVVWV5eFViVG5HaWJNaHNrYzlhMjRVM2NH?=
 =?utf-8?B?U1BISzNMamQ1QlZsOVl5dDJXb09iajR5a3VQemVTV0dBV2hLTXkyVGVYcEcz?=
 =?utf-8?B?WFBFRVNPQkpRd1ZVOW1VRHRUKzM5eTVCbUpCNC9qSEFWVWNUeCtCUnAxQTVU?=
 =?utf-8?B?MkVoNnQrb1BSZkMybFJEL3RKSjlxdkVOd3l2WGNoV1hjY0hOQkFzU3doT3E3?=
 =?utf-8?B?Ums1aklsb1NSNTFsRUxkcUc4bzFINzdCYkUxU2N5RzFRVUsvQ1U3aVhuUzlH?=
 =?utf-8?B?anU1TFliTUVDaGx3TkNWTGFCVVBwUmkyL3V1NEk4WmhPUDlzcitZdUJRYW5U?=
 =?utf-8?B?ZU5QYS9UeVlUQlU3MHV2ZzczUzdMMm9vU0VmQXhic1NHVk9BWHo4dlRqWDd5?=
 =?utf-8?B?bjRnK3Q1RWt4Q2ZTZG9FVmlFanZzeE5aaTV5UWNORHBkVk5XVjRxM0JkcENK?=
 =?utf-8?B?MTdRQ2ZpYjZNRXUwdUt3cm9mRFd0NkZEOC9UaGJWL1FPUU11SEFqblg2TWtC?=
 =?utf-8?B?NWpaaEFhbTM4K3VIblRlOWZ1bis3TXJEMldnTmRmcVVLYVhrdlB4OWRZRnZt?=
 =?utf-8?B?dlhQOHQwWXEwdDJUaSt1MUlnN0F6WlprMm96RE44YndCSWdOcnp2WW81VlVy?=
 =?utf-8?B?cU1aTk1VN3E5b0RJQnVmNFE0UnRZeFlyRTArbFFGQWNZRlRmd1AxS1NqVFZN?=
 =?utf-8?B?TEtuakJvMTM4Qy9SNFFtYzgwdHNtdnI4dWRvaThnNFJNc21EeDM0QURLR2Vt?=
 =?utf-8?B?NnpGVW8rMHpRL05HRndseTBKWU5OallyakFrWmhQc3JjU09kdkd0aUYwZytR?=
 =?utf-8?B?bDgwaXNHRFdmc3E2RHg1MTZmNTVubFYwUWlrUnBRSUhWUzNuTmo4N0N5c1gr?=
 =?utf-8?B?aTlzTWk4Q1RnOEc4WWFoY0lHZDZNbFh4MFlUSVEwQzczdDhsRGozNGRmcHFl?=
 =?utf-8?B?WjIycFNxME4yNWxId21mcDhTaXE5SVV0bVZHYW8zWU9KaGdWNFU0amlwS00w?=
 =?utf-8?B?dC9NM3F3UThYeklOZGpmYlFYVUNtMnExTzlucmN4d0paRXE1QmUwQzJaaVlp?=
 =?utf-8?B?cHUwTWdpL09zRDJyME9Oc0hORnh1TkNnUHY4bEo5TFF4ZDBGL0E2aWRFcXVu?=
 =?utf-8?B?MjExQlREZ3h3dms3WWR2M0xERDJIcWNrdm9UVjRvTGhhS08wejJsdjZUWWlD?=
 =?utf-8?B?UExxcGdhaDZNcUEzOHBodGJSdnZXS25CcCt5VmFkbWoyZ014c1ExVHhkNWY4?=
 =?utf-8?B?ckZHTlF5Sm8yc28yZnZwdGgvWHRvdEtiRkhKRWxZVkdDNS9PMDJBN3NTb1kx?=
 =?utf-8?B?Z1FNWmY3Qzl0elNRNmNoV1ArS0ZuVVJSZkNCTEYyRWlacE1pdTNVTTJkdDhD?=
 =?utf-8?B?Y3g4d1g2SDdXSlZLaE5KY0tLQzVsZTA2VGV1aFBEZnhIRWlES2s0SHdGUXRW?=
 =?utf-8?B?aERYaGltb3NHOERlN01sTklhZVhJdHkweThUTWprcWNybmFPRXFBdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 540f659c-f220-4f42-bfa8-08dea5710634
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 21:56:38.8500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zpXmk9w4UjIObcgywV9vL2Fo63s+/qXo5zSrGxIMYl2C5hRwkKEGws51kBpvs2D6SPt1fdmWbFaVrCZIa8JtBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9178

On 4/27/26 11:15, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> Sashiko notes:
> 
>> if SEV initialization fails and KVM is actively running normal VMs, could a
>> userspace process trigger this code path via /dev/sev ioctls (e.g.,
>> SEV_PDH_GEN) and zero out MSR_VM_HSAVE_PA globally? Would the next VMRUN
>> execution for an active VM trigger a general protection fault and crash the
>> host?
> 
> sev_move_to_init_state() is called for ioctls requiring only SEV firmware:
> SEV_PEK_GEN, SEV_PDH_GEN, SEV_PEK_CSR, SEV_PEK_CERT_IMPORT, and
> SEV_PDH_CERT_EXPORT. After the firmware command, it does SEV_SHUTDOWN on
> the SEV firmware. Since these commands do not require SNP to be
> initialized, skip it by calling __sev_platform_init_locked() which only
> initializes the SEV firmware. This way SNP is not Initialized at all, and
> HSAVE_PA is not cleared.
> 
> The previous code saved any SEV initialization firmware error to
> init_args.error and then threw it away and hardcoded the return value of
> INVALID_PLATFORM_STATE regardless of the real firmware error. This patch
> changes it to surface the underlying error, which is hopefully both more
> useful and doesn't cause any problems.
> 
> Note that it is still safe to call __sev_firmware_shutdown() directly: it
> calls __sev_snp_shutdown_locked(), which skips SNP shutdown if SNP was not
> initialized.
> 
> Fixes: ceac7fb89e8d ("crypto: ccp - Ensure implicit SEV/SNP init and shutdown in ioctls")
> Reported-by: Sashiko
> Assisted-by: Gemini:gemini-3.1-pro-preview
> Link: https://sashiko.dev/#/patchset/20260324161301.1353976-1-tycho%40kernel.org
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>

I have a similar patch that I hadn't gotten out that added an argument to
_sev_platform_init_locked() to skip/prevent SNP initialization. I wonder
if adding something to sev_platform_init_args would be better? This could
then be expanded to prevent SNP initialization if the KVM sev_snp module
parameter was set to false.

But for a fix, this is probably simpler. It does skip some of the checks
that _sev_platform_init_locked() has, but I think all of the checks that
matter are performed for the paths that call sev_move_to_init_state().

Should this go to stable?

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index d1e9e0ac63b6..6891b90bbb88 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1716,14 +1716,11 @@ static int sev_get_platform_state(int *state, int *error)
>  
>  static int sev_move_to_init_state(struct sev_issue_cmd *argp, bool *shutdown_required)
>  {
> -	struct sev_platform_init_args init_args = {0};
>  	int rc;
>  
> -	rc = _sev_platform_init_locked(&init_args);
> -	if (rc) {
> -		argp->error = SEV_RET_INVALID_PLATFORM_STATE;
> +	rc = __sev_platform_init_locked(&argp->error);
> +	if (rc)
>  		return rc;
> -	}
>  
>  	*shutdown_required = true;
>  

