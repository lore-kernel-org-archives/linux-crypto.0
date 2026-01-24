Received: from mail.thorondor.fr (unknown [82.66.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA441B4F2C;
	Sat, 24 Jan 2026 14:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.66.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769265652; cv=none; b=dHK1G7cPMmK8LHaZvtScPozk6bvQgIsA0WbMu6LGb9sEjTOUQNkzOY0wgGT/dy268E3pN7PAAHq2V13LkWNtBICTK/Go46DxRPTnJ1CTfMrzVi4EM+KahRVlcREpkssaLZ3v2PMI5OZHxAo+xXkljNh6Nedlzdu29o6+XUgFpVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769265652; c=relaxed/simple;
	bh=cS0mBluvzJW0KPbiT4PvyGUJVfzqblDmb8zlJD8r8dk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZdOGTKbzsxqUzngmdYm7VmbKc8HA7Yz6NDGuECMTRIU1a4g1Zr6We6XHWwMBBZycUhXgpNJFrdD9gDohAVoIAKj9LArPEfgf9omPKrbrZEeacSKn0RxAO5z2R1qjsvpThBnz+uZdspn1bk8lP9mUzEIUAR4AmyW5pQ/FKKrXSEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=thorondor.fr; spf=pass smtp.mailfrom=thorondor.fr; dkim=pass (2048-bit key) header.d=thorondor.fr header.i=@thorondor.fr header.b=YbNfLH9z; arc=none smtp.client-ip=82.66.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=thorondor.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thorondor.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thorondor.fr header.i=@thorondor.fr header.b="YbNfLH9z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=thorondor.fr; s=mail;
	t=1769265642; bh=cS0mBluvzJW0KPbiT4PvyGUJVfzqblDmb8zlJD8r8dk=;
	h=Subject:To:Cc:References:From:In-Reply-To;
	b=YbNfLH9zCXG2IZT6ag27gaMBYO7VLogsYOXFlz0VfQCfsYHALgM0rZVQLSzjuDagE
	 1rHOBQ74wLuQuOjQxPGSNjdVPIK6zdkjnD+J+4ENQ1ZVOf2knddPj31nJB3as72W32
	 YxTgKi26x7jvyi+RJEkvagbHgQLCD57CB/PuyfJcwEJ44MD6/7dAtX+vIS7Wu4EWo7
	 7IxmeIUEHAYw8TpsK1gz5KangpQJuSG+vOiNqtzHTwBHL7BYP68Tps9xPrQHdz5MG8
	 6dddWEI/FOtiVSg30gd6i2hI5OdRNFdPr9AwemWPo1ovqr8XAGnOT2+Rp/v3xQc9XM
	 CGTXLCPMOqCqw==
Message-ID: <879f354c-822f-4902-8cc3-6cf9557db969@thorondor.fr>
Date: Sat, 24 Jan 2026 15:40:41 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3] KVM: SEV: Add KVM_SEV_SNP_HV_REPORT_REQ command
To: Tom Lendacky <thomas.lendacky@amd.com>, ashish.kalra@amd.com,
 corbet@lwn.net, herbert@gondor.apana.org.au, john.allen@amd.com,
 nikunj@amd.com, pbonzini@redhat.com, seanjc@google.com
Cc: kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org
References: <20251215141417.2821412-1-thomas.courrege@vates.tech>
 <254d7d53-b523-452d-8c6f-d611ab08a9ff@amd.com>
Content-Language: en-US
From: Thomas Courrege <thomas.courrege@thorondor.fr>
In-Reply-To: <254d7d53-b523-452d-8c6f-d611ab08a9ff@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Sorry, i didn't saw the response, i changed the email i use.

On 21-01-2026 00:45, Tom Lendacky wrote:
> On 12/15/25 08:14, Thomas Courrege wrote:
>
>> +	size_t rsp_size = sizeof(*report_rsp);
>> +	int ret;
> The declarations above should be in reverse fir tree order.
    
Like that ?
    struct sev_data_snp_msg_report_rsp *report_rsp;
    struct sev_data_snp_hv_report_req data;
    struct kvm_sev_snp_hv_report_req params;
    struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
    size_t rsp_size = sizeof(*report_rsp);
    void __user *u_report;
    void __user *u_params;
    int ret;
>> +	if (ret)
>> +		goto e_free_rsp;
>> +
>> +	if (!report_rsp->status)
>> +		rsp_size += report_rsp->report_size;
>> +
>> +	if (params.report_len < rsp_size) {
>> +		rsp_size = sizeof(*report_rsp);
>> +		ret = -ENOSPC;
>> +	}
> This can be contained within the if above it, right?
>
> if (!report_rsp->status) {
> 	if (params.report_len < (rsp_size + report_rsp->report_size))
> 		ret = -ENOSPC;
> 	else
> 		rsp_size += report_rsp->report_size;
> }

This leads to an error in case the user wants to query the report size.


Using params.report_len = 32, the nested if is true and thus the user get

back the default rsp_size (= 32), not increased with report_size (= 1184).

>> +
>> +	if (copy_to_user(u_report, report_rsp, rsp_size))
>> +		ret = -EFAULT;
>> +
>> +	params.report_len = sizeof(*report_rsp) + report_rsp->report_size;
> I'm not sure if we can rely on report_rsp->report_size being valid if
> resport_rsp->status is not zero. So maybe just set this to rsp_size.
>
> Thanks,
> Tom
maybe something like this ? to avoid copying on ENOSPC, where this issue come from

    if (!report_rsp->status)
        rsp_size += report_rsp->report_size;

    if (params.report_len < rsp_size) {
        ret = -ENOSPC;
    } else {
        if (copy_to_user(u_report, report_rsp, rsp_size))
            ret = -EFAULT;
    }

    params.report_len = rsp_size;


To test this specific case : 
    https://github.com/Th0rOnDoR/test-length-sev/blob/main/sev_test.c

Thanks, 
Thomas
