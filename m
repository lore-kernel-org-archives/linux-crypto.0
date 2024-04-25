Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA98631
	for <linux-crypto@vger.kernel.org>; Thu, 25 Apr 2024 00:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714004240; cv=none; b=Apf5miADm7sdUTgLwJKpf/QWPJwkupbinwbvkiVar+wrfpA41DGCOCm/iZkIaw+EWb+zBL8pL/wrx3xu1M/hX2at2fM+DfuZWBkdHtWbgZA1PHpC02H6lgxz+oC1gC0p7M8kMw4Cl2p7xSZNjM15CN2a2tLpqbiBs5yjEamcTGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714004240; c=relaxed/simple;
	bh=y194H3ql9IsOPzk1sZAi+84lwfCHJUjSzRUSPix0sVE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dQqD7PU17sfP0e7mic3zTxGdcEYej0T8G+B0QqXGT2ZReSgbufFVE56TKxfcxthnQSdjlkW835RkDjrpq1SZ/p7cihgQF5K7hZYHj8QNE9m24EHGFOndTJfXvnkK0Fdz0JWG5gVQ7+fGdgfw+EYCcgWdIXLpsDWAXjE/qAERB20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=erMtAQ93; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="erMtAQ93"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de54be7066bso846990276.0
        for <linux-crypto@vger.kernel.org>; Wed, 24 Apr 2024 17:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714004238; x=1714609038; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JTJ1EUj9mJco0oYfbV1dH143iLNodHjs8SX3c6d486Q=;
        b=erMtAQ93E0dJqYzZxiS0RXz2BlaZLWaylQbNU+VUK4EKYqL2NkP0/yT+IELWTzs8+D
         ooQH63XYyZCDSt+6QXndiQnDHDmkf+h7ChKCfN2Abm7ztDQfn0VIMYnWasZ98Aqp3nox
         QOV2/Lrn1dEeV8+zxyYSjE8jXmcWPq1FciUVp1d85sSV9+ButzY17+pI+/hAgbqffv7S
         Og8RM0AWQ8OCFwVvxApZepXu5ufNZwWvD6RGJPaE5JJhJ4HJvTT2NfIYM+OK0O2NCkYu
         aoqpmJBLayiGA9YATbNP4Q8CuEPmvYh6K4YHluk2JuDTmHhzfVFMO8H3UiyBiK5EBj37
         P0aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714004238; x=1714609038;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JTJ1EUj9mJco0oYfbV1dH143iLNodHjs8SX3c6d486Q=;
        b=VtIbjYfYodkZV5RLBWT54WRfE2puAMGPz/21QwZgXBjlDqopuAFDBy6ketVbXHI6sg
         WavzjM71+nR4TRUpI+7Y8wnUzT+lFkA6guaS2sykw5DKkMDAqhMvvJkt8MVOfnBsDK2h
         f97/ALbsAg0jqEuFR4WU6jmNJpQK1pRWeWiT+eQqaX70rdmdbjkASptdl4VkhHzY/BAk
         jdHubamnhRL8oyMUx/QH0WJ80uMDTP1zWPm05aXyc7ZJDx7NixATV+qBEvtpGfYTBG34
         278ivAvRLDNVVeoJQbbsa3o5neTIwKsfPFSf5I7wAtkktFqvH77gOkzFJKaZ2NJeoT7t
         R76g==
X-Forwarded-Encrypted: i=1; AJvYcCXljSOVDgu7Aub2e9MAxduOErnh3f4/FqEON2cWozah5rCKytLJ+ZaAVM1JclpREqifRQpKOiqUZUnpY66wZnc9pelSERl+cIt82oxt
X-Gm-Message-State: AOJu0YyzAw5SHQ7ZSkQjHdqglyeBTgYor5oO7xxUdmdpcjI5OuBFICDg
	cfCwNoXQ3BxYjXnyYMw1AlfsSW/rKGQBzeGNRDxr2P+pupMY2DhwjMupX1YF3zG1sJj1X35DupR
	GXQ==
X-Google-Smtp-Source: AGHT+IF06EpTOwvZeQGKlqPQtXFzYGfZPqUfmBFZuyaYdLAzcsdi+7awfJdAqckqz+IcAQhBBvcZ3k/AgAM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1205:b0:de5:2325:72ac with SMTP id
 s5-20020a056902120500b00de5232572acmr1331874ybu.6.1714004238029; Wed, 24 Apr
 2024 17:17:18 -0700 (PDT)
Date: Wed, 24 Apr 2024 17:17:16 -0700
In-Reply-To: <20240421180122.1650812-18-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240421180122.1650812-1-michael.roth@amd.com> <20240421180122.1650812-18-michael.roth@amd.com>
Message-ID: <ZimhDMwAif-KIxNs@google.com>
Subject: Re: [PATCH v14 17/22] KVM: SEV: Avoid WBINVD for HVA-based MMU
 notifications for SNP
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, 
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, pbonzini@redhat.com, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com
Content-Type: text/plain; charset="us-ascii"

On Sun, Apr 21, 2024, Michael Roth wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> With SNP/guest_memfd, private/encrypted memory should not be mappable,
> and MMU notifications for HVA-mapped memory will only be relevant to
> unencrypted guest memory. Therefore, the rationale behind issuing a
> wbinvd_on_all_cpus() in sev_guest_memory_reclaimed() should not apply
> for SNP guests and can be ignored.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> [mdr: Add some clarifications in commit]
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 243369e302f4..cf00a811aca5 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3042,7 +3042,14 @@ static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
>  
>  void sev_guest_memory_reclaimed(struct kvm *kvm)
>  {
> -	if (!sev_guest(kvm))
> +	/*
> +	 * With SNP+gmem, private/encrypted memory should be

Not should, *is*.

> +	 * unreachable via the hva-based mmu notifiers. Additionally,
> +	 * for shared->private translations, H/W coherency will ensure
> +	 * first guest access to the page would clear out any existing
> +	 * dirty copies of that cacheline.

I don't see how this second part is relevant.

> +	 */
> +	if (!sev_guest(kvm) || sev_snp_guest(kvm))
>  		return;
>  
>  	wbinvd_on_all_cpus();
> -- 
> 2.25.1
> 
