Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012003.outbound.protection.outlook.com [40.107.200.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD5F1DA60D;
	Tue,  2 Jun 2026 14:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780411137; cv=fail; b=TmdfHLI20Ed+m1kRzBbcjbl2G9crxEyUwpv2fMsDj48jaxzfphQsiwwZeCJus7PRf3xDOZrZoHno3PuNFQErhQKIvltH5sPsn2iXELWkNLsyBsGOFVDziy9aJl17l66S2bvt6ngiMNa51LA4a2DPCb9qyc+278sFIJPX0RBXmyo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780411137; c=relaxed/simple;
	bh=ao6ArbXd+1vaIzSkaSbbmLPA8jDop9VSvtKFBXdIMTs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=msTPybaypkGnJR2U5eTZAxg54QamwnFH36LH6OxiwS08DSNCKA8bXb3OhPwQcIriTbxwaosVVQnEdUTxMpXxD1zEV40GD/6pKlPkSLJdwRN3sgl5XF/xZicBNtkvfuBDtBErTpowL+lrfH0UOP375hz+cr0RbhwlSDe5y+vhMHE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1ii2OPqB; arc=fail smtp.client-ip=40.107.200.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1ii2OPqB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D+7NSrkzXTFdJ2Dmc75fXpB2ZkrwNlxNG1HZ+0TAbRZvaJC7Uxo1iUCEx4FHrOxvnzWx08LJB8/Fos8z/WtLjlcMfgD0SoKZu+fLcLQmy6sZsuu1d1srmgPMqgyA+oWbhGdSXdQoWgp3BFMTeGW0VXF3QW4Gxvr3uAqLb/6Ywk08veW8pOZoUU/MCR2iyaDMP1JniApR2yVVS7Pqijty/cPE7vLGOBJ0DlmvMh1JH3U8Sj5Cz5I+MM8qseavTxD5rSv+TCIg7ob/3kbSUGR5ID4+ibD4yG8Fn+E41rKRYcQbYvQ0xLR/bnzgwh3dYWnpkhlX/sJyLnitt7l06X9v+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X1/aikaF/FwIKjsWbcJryCGnSf4aNseo3mMzcdv+I/4=;
 b=L3VZduyKgeb/zH2WwHsqm8Gpyz9QffUvE4QExt2YYt72ekhaRLfSRRVBS5naMS+4Ae6DbGoNpNMj/IXG9+Q47Dj/nMOiAgAaIE/D4uobhwKaNUsofn8vuO99GGyfpukj0C2HehHThHgzf+57AMVAuabw8B99fSKliyJuRbE6BqfK7pAooK/RCw13vG/FILYnmVaKLGOaWqKuDgOsiG/dpp++EOXQ3VHdlIi+JLTMaBoKo8TfA4en0ZKVeL/Qaf6jvZr8uQmAMeHoZo2ffJJhNgHfrJqoEJ+Q+CogxxVJmAWJy/BmbVLkVpUxNta5NC0Q0veVZKu0Vgt+PmAFofgbQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X1/aikaF/FwIKjsWbcJryCGnSf4aNseo3mMzcdv+I/4=;
 b=1ii2OPqBT8Np3Nhhi73fstd8JqXCsdAnE4YVW6oaW8RU9SFotn1dbGnHda3bsGOyz+qD0xdlQYdeB1ZRwA13fl/fXeUfD4R5pq6DXHt2QRwHP/vwfR/VMtI/qEY2oXUG8qCZ8KYirSOyYUHnk+mUavCp/tbYC0Q3VMyChB0+n9A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH3PR12MB8545.namprd12.prod.outlook.com (2603:10b6:610:163::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Tue, 2 Jun 2026
 14:38:49 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%6]) with mapi id 15.21.0092.006; Tue, 2 Jun 2026
 14:38:49 +0000
Message-ID: <ec31f685-e766-42e0-8239-eb6202cabdde@amd.com>
Date: Tue, 2 Jun 2026 09:38:45 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] KVM: SEV: Do not allow intra-host
 migration/mirroring of SNP VMs
To: Atish Patra <atish.patra@linux.dev>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Peter Gonda <pgonda@google.com>,
 Brijesh Singh <brijesh.singh@amd.com>, Youngjae Lee <youngjaelee@meta.com>,
 Ashish Kalra <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>
Cc: clm@meta.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, stable@vger.kernel.org,
 Atish Patra <atishp@meta.com>, Sashiko <sashiko-bot@kernel.org>
References: <20260601-sev_snp_fixes-v2-0-611891b28a86@meta.com>
 <20260601-sev_snp_fixes-v2-1-611891b28a86@meta.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260601-sev_snp_fixes-v2-1-611891b28a86@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR14CA0003.namprd14.prod.outlook.com
 (2603:10b6:610:60::13) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH3PR12MB8545:EE_
X-MS-Office365-Filtering-Correlation-Id: e53b167b-4a59-4a7f-fff6-08dec0b4a8b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|7416014|921020|6133799003|18002099003|22082099003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	MpT5T2WfhaYuozJetaf+18K16bn3oVhROVyBjFrIAFWqj87R4OtMD6HQO8VpAKdxQOFqORVru6ka9tfYVkNnUt/bZidktvc+62nX4p7uKeSCOfkFzQOf2jKdQgW7HKL2U+zyoqpo6VIiRNYPjEQ53bbvkn71zrWGefD3mB7a92ZqzbO1u4CHcUtOEZwD1r6QG6dwUPDaIeb8Ar94QYklAYxuf/FZ7g2fcfgd648drl8jMs1ZmXu7eQgpnCKrwYrLUQc2VxHaNbjI5GQXBLT4qR0O1ZQCjYSEduZ/EnHm/xUW6bgRwwFyzkL3LB38e/mPrhHoyT/0Qxb7RqXK4UX3gpAO2vzmfNc/BBg5d1F0RHTZ3LgOt7bMUCp96HUJtcVNM72Gh+B4twTNLmdOLiKl4NNyraC18T9gWok9sbKEJyOtzhFxviA4KXOI/zo2BNoJOzlomRm1+bBWSTlXyqTMYN3ihv7q1eaBWHsknLoXqiLzX9cqX9fx6RdmppleSvgy64bITtzeDQe9XshPqZrT/ZI7q/fHZRJPu1oJ4AxFEdkJVmPTFtof1hYK5iaxN1ZandzUcHajGQVwfNbYKpv64eKA0fhHGt+Y9bModHeu2SlXWa2bzpIHcCZDvvHtK+NpbW/N3C9XbE3muOcrD+rkpOjfWrdPbiMgzie4bOJHX9ND/nVoggsSI01WZYv+0Xb12oyn5gRup1caGz6GKoZDqMlmAKlT4D0DaZPwo19AaKY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(921020)(6133799003)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OGNBTC9JQ09Cc3pUZVNabVRHOSsvL1BkNzBhd1puYWRxK2hibDcyZ2lRbTlM?=
 =?utf-8?B?NHlQOUVwalV3NXZnZnovTmF5czVZeXA3M2lxWmNVYi9IUmJ3bjBoVVgxbnor?=
 =?utf-8?B?TjA5K2kxRlpoS0ZWaG9RM3haZHZQQXFlaGwxQk5mM1h6T0xCdzQvdXhXdmNZ?=
 =?utf-8?B?RW8xeEdGUVI3bjRmdTVWNU9DcVp6QUk1M3JWdVBueWdnazFvZDlEZ1p5K2d0?=
 =?utf-8?B?Q2lzSU5EQUdIR0ZnRGFESWV3ZGhwZEpYU3Q2bUhlQVRuOUVlTGcxelM5c3h3?=
 =?utf-8?B?V2FoMVlkUkcrOFYzVS82UERwdUdmRXFtMmpMYlo4ZC9tMTR2YmxHZ1FCWDFa?=
 =?utf-8?B?RTZMVkRqcTlUK3M1cjd6SHE2L0FpZVRQMzU3NUF6TVUzYjlEeEVyRXRYbDRu?=
 =?utf-8?B?L3BLWXRJOTZCbXJESkhoSWFsV3RCSXAwVE50Q1Y2NHM3R1lOUC9vWTVhQjE2?=
 =?utf-8?B?bklRTEtXRHJhOEtXdEgxWk13ckVGU1RENmF3UTZ5ZC90K0lvOEc2V0VOeGI3?=
 =?utf-8?B?czBvL3JXK0NSZEFrVENBV3ZpWjhJSWpXTnJmY0ZXR1Jvc0hjUXg1c2huVzZq?=
 =?utf-8?B?UjlKRzAvTmdTWi8rMVNqNkpURzhCMklweTlPeG9NbmtkNE9FSUg0SU5sTlRP?=
 =?utf-8?B?ZFpLa1Z6bFl0UFF6Zno4bi8xQjNDZ2I3cHN4Q3dBRFFlU2h1NWtkQ0dtRlVi?=
 =?utf-8?B?UUJUZkJHN1VJbURqVjdCTFZiQXV0Tm82UmVuUHVZd2ltTHZOZ2Q4WnpqRDVw?=
 =?utf-8?B?WkFRb1NJVlJFS3dlTWEreUVjVnhGVE9GWjZOUlgyYWNieTRLOHdNdlZsMU5T?=
 =?utf-8?B?Q1Z5eHVOOXg5NmNpeFptWHdPYVdTMFZnaUVPbld6dlhqeHdvU1VnSHRMaXNE?=
 =?utf-8?B?cVF0SXdtT3JMZWxwcHJSS3VMSW5EbzVnRHNFQUlQaEQ3c0tROE1XeVo2cnR3?=
 =?utf-8?B?eGlyYUUzQUplMk1VSnIzZnlKQ2dHTFltMmZQcWVWYkREUTAwaHltZ0dFdmdZ?=
 =?utf-8?B?eHNVZi9WV09EM0hjVllpTno3VjRjWFVwbXFqbDRObC82Q2pDdURDeDQyMEdV?=
 =?utf-8?B?Y1hod1dzKzdpWlVvc3ZCYitSL2xTZ2d2NVhGMzNPZTQ2RUFxQkpNY3NmNk9R?=
 =?utf-8?B?eTlTeTFlTVN2TE1wV0NxM3dWdDBYcm5hRzQzWE9KK0RGYW9oZzRMcjQ4TzVX?=
 =?utf-8?B?YjJiWFRiVU5NMUV6aEEybGJDUC9tUlVuOUdmcFc1ODJDbTlxQi9SWm1ZQ24r?=
 =?utf-8?B?S1pEaW1OQmNMRzdMM0NVOVdUNTdPZFlpUi9IdUpQQ2JTTUdOTlNqbkJnbmRs?=
 =?utf-8?B?akJSbG1YNlM4aWphRGdIT3RELzBiU1c5cEVPb2Q4aWQydTZGdjdLYWxpaTh6?=
 =?utf-8?B?SUllY2licGVPZVBoRkN0UkVxV0MySUxTL2ExSWZOTkRkeGhmRiticHp1NGZ5?=
 =?utf-8?B?NFZGM1I3Y1dPc2MxTlFYcXBKNzR6RkwzV3dqcWRUZnlzSGx1RlRFSys4TWdG?=
 =?utf-8?B?aXZzNlAyd3pxZ3lzUUV6VCtDc2MySW9temZXbzMzRERGa2R5RklxVHpYOEpX?=
 =?utf-8?B?Vms4c0VoUy9IbWp0bHJHbVBJSGNVdkZDalNxeHozQ0E0SUVrTlZ6cllXRkVl?=
 =?utf-8?B?T0tXY2t6Z3FSc2FDTVJzdWsxWCswdGhmZmhzMXJ0MGtLT0tlN3VONXM0Z2pa?=
 =?utf-8?B?aEZ1aiswR2lCaTNSZTJVNlYrSmVPWExUZnFrWVNFUUJhM1NYSVZqOEtWVlBp?=
 =?utf-8?B?dFJKZUhRbnpFdHNsZmpiZUZkVUF2THhKeDZ4V0NYYk83aWRsNmUrN1ZJNzZ1?=
 =?utf-8?B?blMvbkkydzhFZGhsV2d1L0VsejZEUEYxQk56RWw4K3pvVnUwbllqOVdhdDds?=
 =?utf-8?B?V2tFZTJNTG80U3o3dXRneXlRWnhpVEowNTM4SDNVOXNsaFlObTVnVmRreHFy?=
 =?utf-8?B?SjdCdmxTOEowNEVaK0luKzY2NFBqRExYVER4YUtURjl2OHhXMWNmaEg3ZXRm?=
 =?utf-8?B?LzFHMzQ2Y3AzcTliM2RUaHVBWFZXd2p1dnR3a1VBMkc0aU5tQUR3YjdTSEVm?=
 =?utf-8?B?QjBUWmIydHBLWmNkS1d3QUMySlVPdDZ2WTVDUkFwSm45TXRtakhSTzlxTTB4?=
 =?utf-8?B?Ymc2VDd0bkJETjFyejVKckFpTllQcTU1OXlIT216MUVzUFlFbFNvVGw0ZkdR?=
 =?utf-8?B?dGR2Q1ZNRUxWOFlFc2ZndmlLVFgvN01ZS1k2elVMMW5JRllsdFRRbElHaEZT?=
 =?utf-8?B?aXNYSW9DMUdISHBIUVZ0WVhqTEkzaXhLME15N093Q1MxQ2IwU3l0UDRoZ1F1?=
 =?utf-8?Q?ck8Ry/D5GvQoNnpIK5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e53b167b-4a59-4a7f-fff6-08dec0b4a8b0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 14:38:49.2373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WXF3KfG64LMI6NsJ08qgOoUeQK8FqjT9iOYcoeEVjINJBKjNcsCIaMZBaySVNIjmr+L0WN6mrAEgL3242OTOdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8545

On 6/1/26 18:04, Atish Patra wrote:
> From: Atish Patra <atishp@meta.com>
> 
> The intra-host migration/mirroring feature is not fully implemented for
> SEV-SNP VMs. The proper migration requires additional SNP-specific
> state such as guest_req_mutex, guest_req_buf, and guest_resp_buf to be
> transferred or initialized on the destination.
> 
> The SNP VM mirroring requires vmsa features to be copied as well otherwise
> ASID would be bound to SNP range while VM is detected as a SEV VM.
> 
> Reject SNP source VMs in migration/mirroring until proper SNP state
> transfer is implemented.
> 
> Fixes: 0b020f5af092 ("KVM: SEV: Add support for SEV-ES intra host migration")

Probably not the correct Fixes: tag. It should the tag that first
introduces SNP hypervisor support.

And adding a comment above the if statements that indicate additional
support is required for SNP, so don't allow it for now, would be nice.

Otherwise, for the actual code...

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> 
> Reported-by: Chris Mason <clm@meta.com>
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Assisted-by: Claude:claude-opus-4-6
> Signed-off-by: Atish Patra <atishp@meta.com>
> ---
>  arch/x86/kvm/svm/sev.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index c2126b3c3072..e6ad6af128c9 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2142,7 +2142,8 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>  		return ret;
>  
>  	if (kvm->arch.vm_type != source_kvm->arch.vm_type ||
> -	    sev_guest(kvm) || !sev_guest(source_kvm)) {
> +	    sev_guest(kvm) || !sev_guest(source_kvm) ||
> +	    sev_snp_guest(source_kvm)) {
>  		ret = -EINVAL;
>  		goto out_unlock;
>  	}
> @@ -2865,6 +2866,7 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>  	 * created after SEV/SEV-ES initialization, e.g. to init intercepts.
>  	 */
>  	if (sev_guest(kvm) || !sev_guest(source_kvm) ||
> +	    sev_snp_guest(source_kvm) ||
>  	    is_mirroring_enc_context(source_kvm) || kvm->created_vcpus) {
>  		ret = -EINVAL;
>  		goto e_unlock;
> 

