Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918F17E107
	for <linux-crypto@vger.kernel.org>; Wed, 12 Feb 2025 01:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739325496; cv=none; b=d59uDg3QPKPi57TCsT/2BakQRmTQTIIyS2K6ZWkZJj2RXVMRJLCpe7G5IW/rfyQjgJH2/SBGQLZDYqUn6oy5ZBDiTUd9eQJon+h3hpABJvK5WiV0jH9vE+blcGoekQ/WHoGl1yc9o4tEyy7g/xiMQIBgrTljpQzZFEKSH5XEMgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739325496; c=relaxed/simple;
	bh=XIMgkskMxn1nn+KR+UHsoIEJpOMWNgBuJYgmSHFKAZE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=deXngBWwWxY+/cFAO0B4CjXSIY6UwSXtZuY2WwtLi9z+8LzjD+XH/C32m+jxDD3EDo2U1bA+u3dmszKxzIv5lt5rL+BVquN/9Byxsf+Y00vK/l82QHkzL5MwRMoMKe0zFgRMSBTpP7e672tnPqDtQhc3/XsH7YrRj1c3FMczXFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ARZ3Bj9j; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ARZ3Bj9j"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fa440e16ddso8231560a91.0
        for <linux-crypto@vger.kernel.org>; Tue, 11 Feb 2025 17:58:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739325494; x=1739930294; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JBmexDJauWUVMueSQTYcfoS5XgO5mBN+j+WiBcxqz+0=;
        b=ARZ3Bj9jl8OJMYGMS/FPbwXsuvkeWZCEBkmkkQPAuzEX0G8LLGHWejhHH91mOuIVmp
         iKCdZ5CpvKM/rTywAtOLVVAfSorMPO5fdt5KsGv7jvO5IGnr0DOxQ7ry7AGiKT/rvfEp
         vbe9avvOFcFkew9HcMm63VUF2T1lwehR35KRC/kgEUyOX91hh5Kk8EuEBSd2tkTuksHW
         gDt6R7R8dZYSndtUuU+z8vkgY4hULZMe6aZOvcvSLq92dsjkVF49uyUAq/TYME2vChY7
         f0HUqz/LSEUAOUe1qN1GMe+/pYoGoJKbqRKfkCIYXtmqvMmOWdp7g32DL6sv2+oXPLOR
         Dd3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739325494; x=1739930294;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JBmexDJauWUVMueSQTYcfoS5XgO5mBN+j+WiBcxqz+0=;
        b=BWqiFH6F5nrbZUljggsbRNe4BIfUsguA/NU4OkJAGoIwF7Ou/FFu1vwlHzw8EElWzg
         7mIk8We93/lS2VRzp5dhbeOQGTwRtMDdDO2nx6PowViAhyxsLf5Za8RdudCq6wEkuWBM
         mGb1Hi0+nMv5z5qaKxaJFyCEpPki/ZkRDm2TfuGpxFtUx+mofZJGCpf5NckNNgezv2I/
         NtEsWp48NpxDLoaRqT+Q6afh98c9MyIlQJYnqjxuLIXPeXroG/PQevzVHeWy+aV/PQ/Q
         gTTP2DORc0fjtj8yn9kTwTYTeymU1A4aCNT3aeOh6E0b0ivnSlcPzbDHIPMbujQrqQXQ
         k+LA==
X-Forwarded-Encrypted: i=1; AJvYcCW80n/4EkEQdQZugyQ33LrnThLUuEJOk3JlL288HV879emH41izsEsTApYeF6BGGqA3Dgzn7/NDA/TOX98=@vger.kernel.org
X-Gm-Message-State: AOJu0YzipvK1Bcd9pmSDJMfDfJMMhjNNymszOB82YdcAAd/twDB9zG8X
	nBNkErsyCP3rNrakwI1UbZQLwzanWciZohfOdRFzqjbKRlXMDW0HRSs+zDSo51cQuYQtVrOTFp3
	SYg==
X-Google-Smtp-Source: AGHT+IG8gNhDei/WwBHZVkG78nqd1F8fT+XYoWcLtzAPMmJRfa8+UGmH6QlGzlgYGpwOFsPEKl6pyd8osao=
X-Received: from pji8.prod.google.com ([2002:a17:90b:3fc8:b0:2fa:1fac:269c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2712:b0:2ee:741c:e9f4
 with SMTP id 98e67ed59e1d1-2fbf5be0da2mr2064880a91.11.1739325493702; Tue, 11
 Feb 2025 17:58:13 -0800 (PST)
Date: Tue, 11 Feb 2025 17:58:12 -0800
In-Reply-To: <20250203223205.36121-3-prsampat@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250203223205.36121-1-prsampat@amd.com> <20250203223205.36121-3-prsampat@amd.com>
Message-ID: <Z6wANGkZb7_HK8ay@google.com>
Subject: Re: [PATCH v6 2/9] KVM: SEV: Disable SEV on platform init failure
From: Sean Christopherson <seanjc@google.com>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	pbonzini@redhat.com, thomas.lendacky@amd.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, shuah@kernel.org, 
	pgonda@google.com, ashish.kalra@amd.com, nikunj@amd.com, pankaj.gupta@amd.com, 
	michael.roth@amd.com, sraithal@amd.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 03, 2025, Pratik R. Sampat wrote:
> If the platform initialization sev_platform_init() fails, SEV cannot be
> set up and a secure VM cannot be spawned. Therefore, in this case,
> ensure that KVM does not set up, nor advertise support for SEV, SEV-ES,
> and SEV-SNP.
> 
> Suggested-by: Nikunj A Dadhania <nikunj@amd.com>
> Tested-by: Srikanth Aithal <sraithal@amd.com>
> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
> ---
> v5..v6:
> 
> * Rename is_sev_platform_init to sev_fw_initialized (Nikunj)
> * Collected tags from Srikanth.
> ---
>  arch/x86/kvm/svm/sev.c       |  2 +-
>  drivers/crypto/ccp/sev-dev.c | 10 ++++++++++
>  include/linux/psp-sev.h      |  3 +++
>  3 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index b709c2f0945c..42d1309f8a54 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2957,7 +2957,7 @@ void __init sev_hardware_setup(void)
>  	bool sev_es_supported = false;
>  	bool sev_supported = false;
>  
> -	if (!sev_enabled || !npt_enabled || !nrips)
> +	if (!sev_fw_initialized() || !sev_enabled || !npt_enabled || !nrips)
>  		goto out;

Me thinks this wasn't tested with KVM_AMD built-in[1].  I'm pretty sure Ashish's
fix[2] solves all of this?

[1] https://lore.kernel.org/all/d6d08c6b-9602-4f3d-92c2-8db6d50a1b92@amd.com
[2] https://lore.kernel.org/all/f78ddb64087df27e7bcb1ae0ab53f55aa0804fab.1739226950.git.ashish.kalra@amd.com
