Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012019.outbound.protection.outlook.com [52.101.48.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF8233BBC5;
	Tue, 10 Mar 2026 22:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773181126; cv=fail; b=nkTSAzMUX5nQoLJxmnL7AcngZkvWT7lwIRSG0ocfgGjG1mgQLcy1mxcdSETaIJ0eZbMGSnmdZyHNnsArcwQzKa2Ls6fh5Xsvre/qPHJKejFrqi9jlPQMBNCXlUaRZon9Thv3mNRcxcp4J2qq+nZmbjHIpMvlVBSRJpqJDAyr29Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773181126; c=relaxed/simple;
	bh=ytlrYfRiv15BGUc8ftLxoQAJEWoXpRMUgnFg3DTdvwg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ip5A/JGzInU3d+D2quCeafR2H8+NlVt6/g0wLvnVSIQpIRGoswSaLvG1Aj3S5y11QvxF6NON3KLRKGfR9r6nciNCccQoPV+xWgFjU0Y4XeYfkywN17OOAOB5fF9S5dfkRYXtBwlqZSdO6H8ojCO15JifAYMEvkGIOgn8a9OGkA4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IIZDKqXo; arc=fail smtp.client-ip=52.101.48.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IIZDKqXo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VaZPMr7re0ANd1TEu8eiRix8HjWBYo6MvFGw6C1FJfkBpzbwsAhJFV58uPzper9yNSbrri4Ngoug51cThdHFfhCSfvH9n6H+aPHPnFX0YqHZcGYigs5R5CqSMZL6lpT/ds36SK0qTEsiF23prn0XJpj2EBPmhumyPdOVu0lla5J2IW7qnJuUUauTJ5Ivxmp+FxKFKZRQYV83kdp1m/h+6dDWDueVbOB03AdGF+rBPCj52yI0X4AfB4kEhZ9HHnrKPieedTC7E6IISyp8IfMuT6hlJZvm239/cdCKlcPMYgMLm8CzXcFDcTT+1GBbR+PUHMu91RhWa35zR8+lWKHCpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kXntyiSo4hatxgQgaH6Br217pddQ8+tKuqjk6DgHI8w=;
 b=WPDGm2nIPz0hDDrVK8aZq8RSgVo2lFXKNQsTZsOLNGA8pXVUA3vjbEUFoHNZAI4Qg7Uzq7cjXzJDMoT7k/4QZ19r5In93pjqOuVCpyyxCMl5B4EFJRDtMEDqd2H7njRUnWMywynIbag5JRPysmrhirMSoavpqHUjXp3XSMf7zPB0UrVsH645qxkwHsaXkXsIibDSu2iK27x3iP7EdrAuWgz+UHLziW+fhEcdkNv56iPtAUPKhDwCNaLQ4BtwgegIywx8gHCnPi1ws6O2dnJ5HxhsEOb/5HlWdH73vSNzOOUz2f9kGT1wQoSUNfP+Q1i8WdvMcta9X+WJK1x003XEAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kXntyiSo4hatxgQgaH6Br217pddQ8+tKuqjk6DgHI8w=;
 b=IIZDKqXoVGTtFyi7Nek93cNQjQmIoTlkJ+rlWc5ozNdNYvXOpKy+RfoVWtMf8eaS9QdvimNi3tr7SKd/ybGLKLCDh0InuT7/Y9DrvqsE22kxOWcZ7FOEAu+G3xgzP8Y1Yo8XJP7t0O5gmUx2+NRYIxm+dlZBxSVCjVnpAQqjKPw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by SN7PR12MB8769.namprd12.prod.outlook.com (2603:10b6:806:34b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Tue, 10 Mar
 2026 22:18:41 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%5]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 22:18:40 +0000
Message-ID: <98313534-af6a-4c00-a016-9d9010f145da@amd.com>
Date: Tue, 10 Mar 2026 17:18:36 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/7] KVM: guest_memfd: Add cleanup interface for guest
 teardown
To: Ackerley Tng <ackerleytng@google.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
 darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1772486459.git.ashish.kalra@amd.com>
 <ce99dc548000b5a1f4486cdd3efe510b3874684b.1772486459.git.ashish.kalra@amd.com>
 <CAEvNRgFCTNr=LUR_RM7+A4z+qHCWBZOYKe_Cbokwx0UsCtzaVw@mail.gmail.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <CAEvNRgFCTNr=LUR_RM7+A4z+qHCWBZOYKe_Cbokwx0UsCtzaVw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0091.namprd12.prod.outlook.com
 (2603:10b6:802:21::26) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|SN7PR12MB8769:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a0a053a-ded9-475a-225c-08de7ef2fbd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	omRfpo6EoibGnzYg7a94sAl2ecWSIhEcVksbra/UbPDtchPFQabxGS+SBOA+TiUAakcF5TsDNTwREq+FlbcnAlbMbwaTWa5wE7D/1s3X/5AeT4UYQWuxxYeR1qGzvdqZR1zlMlyBy5GPWoNCZ5cX83MOic50GwKT8WGSRuAsjQvZWcsqo/omnl9uSvG24n27yGJn0a+bZEkfWR0ktG7Lo/PIC39MD2sda5FSIgGNAOWcT5Hq0CDk7oP/P6QSD7Dv3jXaPjPQhCwku89Mi4gaQfnWHqGLGUg54/gxz1aqK1zcYCqoAs2neNMNifpjqW6j2XdOCmzzKp1jOH2OQOjL6S3dSZI8etGdlFNsUCoXC5RRMC8bOUNsS7679ykp4YB9yIiYPMDcPIiv5y18kX59iW2AOC3Cg625LjyQhBxvLNCr5Uaw9ySo3EtxSdkdfVFoLukJxxgxjx8O2oWmUie3+bZkzPO6a3RG37iQ40DI6z0+rOaTJRa8Auy3dBXfAKzlL4oSfTcHDU4fdpKD/Uo63HodxmaHFGRZ4u9K8eafSy4YFocsFennxIKBBqNmzP1TwZlpyiYAkYbD6zx0M1kypR8gawP01LCAgfPL1QJY1ipyaI0E96LpmCkblDVAwFFwAxQpHrQVgYM1EX/6Hy+Xv3LwwJeD8ee20LGsOEU7ukoT3PeuUoBX8AV+Cdki4WpweHbjHS133EXgNWO47t6DJC6IhpWVSSNZceaFlJENePjqHqMGDLshFlN1aEdqG2+v/RccH0ndADbcpkXpR5OoPg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Yml0alQ4a1V2V1d2ZzFka2hXRFVTZ3AyQStjK1QwYUtDQ2RvdFV5emdOSHdL?=
 =?utf-8?B?YkMzclRZL2NaVkZZVlpyZTZBVllIWW9TOWxwaEpwSVNKdy9jSUVaRDFrOHB5?=
 =?utf-8?B?OVlWWE5Vb1RtMDl5K2FpQmdxdE1HTlprZnlhTWtVSzFkZzJEaWZ3SVVwTnZI?=
 =?utf-8?B?V1I3aDF2N0ZlaURqUndQMkhhNG1tT0d2ZlRweWVWZjNSbkZ0SEFXUFVTZkJ0?=
 =?utf-8?B?YWlrU2JvR1UxS2xOVHJCTFI3Vys4UUs5QjlwM1NaSnNWL0h5dFpGRUd0TS9B?=
 =?utf-8?B?SHlBYm9jTnIrV2pRWTlVYi9tcTVYWnFnTmtYc1pxS0tqcE1hM0hGdHgyZVY0?=
 =?utf-8?B?ZEc4Z3M3bk8yNXc3SW5INXVLSk9adTdueitMNGhCKzdhbFJZeDZXYkRqTWVx?=
 =?utf-8?B?YkwrWDFXNHlnb0h5ZzkvZUZvZUxVeEx5RWpCTGc2US9xQ0RWb0I3R1oza25H?=
 =?utf-8?B?K0VHWEVPeEllV2ZWSVozNTlZb3JvTWJQc0hZMmtkNXIzZzBhUkZlT1pvaXlK?=
 =?utf-8?B?L0svVkRnTFlUdm5nbjlIMVRzRkNzZ1ZaRURsc0YzOUprVkhzYzNYcVNxaHVL?=
 =?utf-8?B?WVFkb21EaVZ3VEM2RVM1THZnZnBHM0lJK0JDM1NxK0YrVFQvNWlaQVZCQVZx?=
 =?utf-8?B?cTdWYjJUUTdXc1Z5Z1hVSlc2N3loQ3YvblZ2YVJQSnB1cGtDa0NxcHZOTHRD?=
 =?utf-8?B?UHhaekxtYWRZVitjK2M4UkxhWGt6bXlmQWU0amhmdEJpQjZqNXF4Wm9MSHFs?=
 =?utf-8?B?STZqRllPRHREQnRXTmlKQzYzdU80bnpmZThWYktMSGFsSTY4cVhwU0tTdCtv?=
 =?utf-8?B?ZmhGNkVGcVNmYzVmdDVvRS9NRm1xSFZCR2ttZGJlYWtLNXRMTkh2YThxUklO?=
 =?utf-8?B?NVNvK3M3eTRDVHQvL0JCcTd3cW1lOUZCUEpDTytpcXBvOHd6RGd4V2g2RDJY?=
 =?utf-8?B?QnVrY2NyeDloZ2k0VzRkWldSRTAxM3N3ajJONzE2S1FrOEZVR2s2ZmFFV1gr?=
 =?utf-8?B?aVd6T1k5WWlKQkFtQVc3QmpLZnY4bzdpMmdScVdLSHl3VzZnVVBFL0wzUEFY?=
 =?utf-8?B?UnRHMFZVYTNuaFBmVXpjbURtTHZFdkF4bkpNdzgxWFJuKzVqdSs0bGJERFJw?=
 =?utf-8?B?cGR4UFJlNW9VRHg5RTJsbVdoZEpGU0RXMGZIMVJRVmZUV3B3VEpSSU9OWTJO?=
 =?utf-8?B?T1hpMGRUTEFjbmx1OWs0bXA2M0k3ampBNjROeDVWa0dCVUc1Q1Bid2t2NkFP?=
 =?utf-8?B?ekkyMTVKb21VVjhhcTVwQVJra1B3eEdjakYrL2RFVm9iVW5zM1R0ZHhJMzFy?=
 =?utf-8?B?ZlVad1p4Z3h1T1U2VGtwWk9RakN4UG5uWG85WnV0dlVCemFKdG5lN2xiSlY1?=
 =?utf-8?B?MzN0UnZqWHkzaDhIYlZ1SUZpWWZ2bE5rM3YyRWRQR0FqOGVMQXdJcXVPS212?=
 =?utf-8?B?MWs4amdkTGllMVhuS1Mrb0J1UjNabnc1Ym5NNEhQMjRRZXlkRHUzM2RlNTJ3?=
 =?utf-8?B?UThCYkM4V0lyZ3FwQWtuZmJEZkpUZ3JQKzdwMDMzczVpMjhWbDlCekhpRUl0?=
 =?utf-8?B?SWcrVkVJQi83SlpaY1ZhVWZkMUpuU3pzRDNZUjIzbzR2Tk5sWnMxWlBmVkl5?=
 =?utf-8?B?Wk5yeHVDSVZMMnMwNUE1bTdqRmRRL1NqYjFCTjVNUGIrVjdXRWNRQ2Q3bm5x?=
 =?utf-8?B?bjYxNG9QcklGV1RwVTFwRXpoMlZKdVFtUXErRXhKYkQrVHVQU2ZUUGU2Ynl2?=
 =?utf-8?B?REs4bFhFVEw5QVhrZzNSQU91Q0N3K2ZXNFU0aHdrQmdSQmtnTWxTL0VsZkt0?=
 =?utf-8?B?Z2FsSkxjM2ozZy9SK09KK2szQXFjRWsyZkMrSGlZWk1kNzkrMTBxTThObllm?=
 =?utf-8?B?ckpIQ3prWWpvaXV6djU1dzF6ZlNEMFZuMk9zbFNYWVBGNmFVSzg3SEJPd3Zi?=
 =?utf-8?B?U3JoK1JKZjZrUDVYeDU2WWIwU3RNQXdQOTVkeFA1RXJnZ05FQUFKcVJsQW9S?=
 =?utf-8?B?WnMrcklDS1BEZkpwdHExSzhmdHdOZHpIMENUU29XTFhaZkhqTThPalV1RlRP?=
 =?utf-8?B?SzQzWHFHekJmdWdjOE1RRGV1SThLQU9sTlJ5aXB1RTJhb3pOODJYTW9NWjFu?=
 =?utf-8?B?ODdyTUFMZE1vL3RrbHBhd3BpblFvQWFVb1NwUndqNTBwTnlrVStqUVBzcTVp?=
 =?utf-8?B?OVRjbFdINi9Rb2VqMzhNaXJzeHFLSWtxMk5wekR0a0l6Nlg1TmhTZDhDbTJR?=
 =?utf-8?B?REFkclE1aU5STVJUWm55VmE5dmc0KzRtcXlhN1JPcXhVejhqaFRGNlp5MTJP?=
 =?utf-8?Q?K3hA2G5uh/MWj7lHbg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a0a053a-ded9-475a-225c-08de7ef2fbd9
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 22:18:40.8176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JIteioJ/nhXB08epGstQOuDbVf4tnkx4sOhKPUIjRctB6JURbgbWy5GaRB1j5YT70Bt2M07DglDNrF9H+EZhtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8769

Hello Ackerley,

On 3/9/2026 4:01 AM, Ackerley Tng wrote:
> Ashish Kalra <Ashish.Kalra@amd.com> writes:
> 
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> Introduce kvm_arch_gmem_cleanup() to perform architecture-specific
>> cleanups when the last file descriptor for the guest_memfd inode is
>> closed. This typically occurs during guest shutdown and termination
>> and allows for final resource release.
>>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>
>> [...snip...]
>>
>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> index 017d84a7adf3..2724dd1099f2 100644
>> --- a/virt/kvm/guest_memfd.c
>> +++ b/virt/kvm/guest_memfd.c
>> @@ -955,6 +955,14 @@ static void kvm_gmem_destroy_inode(struct inode *inode)
>>
>>  static void kvm_gmem_free_inode(struct inode *inode)
>>  {
>> +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CLEANUP
>> +	/*
>> +	 * Finalize cleanup for the inode once the last guest_memfd
>> +	 * reference is released. This usually occurs after guest
>> +	 * termination.
>> +	 */
>> +	kvm_arch_gmem_cleanup();
>> +#endif
> 
> Folks have already talked about the performance implications of doing
> the scan and rmpopt, I just want to call out that one VM could have more
> than one associated guest_memfd too.

Yes, i have observed that kvm_gmem_free_inode() gets invoked multiple times
at SNP guest shutdown.

And the same is true for kvm_gmem_destroy_inode() too.

> 
> I think the cleanup function should be thought of as cleanup for the
> inode (even if it doesn't take an inode pointer since it's not (yet)
> required).
> 
> So, the gmem cleanup function should not handle deduplicating cleanup
> requests, but the arch function should, if the cleanup needs
> deduplicating.

I agree, the arch function will have to handle deduplicating,  and for that
the arch function will probably need to be passed the inode pointer,
to have a parameter to assist with deduplicating.

> 
> Also, .free_inode() is called through RCU, so it could be called after
> some delay. Could it be possible that .free_inode() ends up being called
> way after the associated VM gets torn down, or after KVM the module gets
> unloaded?  Does rmpopt still work fine if KVM the module got unloaded?

Yes, .free_inode() can probably get called after the associated VM has
been torn down and which should be fine for issuing RMPOPT to do
RMP re-optimizations.

As far as about KVM module getting unloaded, then as part of the forthcoming patch-series,
during KVM module unload, X86_SNP_SHUTDOWN would be issued which means SNP would get
disabled and therefore, RMP checks are also disabled.

And as CC_ATTR_HOST_SEV_SNP would then be cleared, therefore, snp_perform_rmp_optimization()
will simply return.

Another option is to add a new guest_memfd superblock operation, and then do the
final guest_memfd cleanup using the .evict_inode() callback. This will then ensure
that the cleanup is not called through RCU and avoids any kind of delays, as following: 

+static void kvm_gmem_evict_inode(struct inode *inode)
+{
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CLEANUP
+        kvm_arch_gmem_cleanup();
+#endif
+       truncate_inode_pages_final(&inode->i_data);
+       clear_inode(inode);
+}
+

@@ -971,6 +979,7 @@ static const struct super_operations kvm_gmem_super_operations = {
        .alloc_inode    = kvm_gmem_alloc_inode,
        .destroy_inode  = kvm_gmem_destroy_inode,
        .free_inode     = kvm_gmem_free_inode,
+       .evict_inode    = kvm_gmem_evict_inode,
 };


Thanks,
Ashish

> 
> IIUC the current kmem_cache_free(kvm_gmem_inode_cachep, GMEM_I(inode));
> is fine because in kvm_gmem_exit(), there is a rcu_barrier() before
> kmem_cache_destroy(kvm_gmem_inode_cachep);.
> 
>>  	kmem_cache_free(kvm_gmem_inode_cachep, GMEM_I(inode));
>>  }
>>
>> --
>> 2.43.0
