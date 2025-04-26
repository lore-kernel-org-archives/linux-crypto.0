Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360573C0C
	for <linux-crypto@vger.kernel.org>; Sat, 26 Apr 2025 00:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745625613; cv=none; b=R44cdVeQyZh3CK26v0gI5IEyjKbj7srUvq8t4jJ6ERvG+SZihMT5tYAX3AchG5tITcuv0PrdqdU496RtKn+A32P0yXO5EzywXw1u2sDSozEzPS6kvKrzhXHRCFrLjMPjgmVdm52hKnaIkmpMhwyysyB6fcg22VkEjvcCAfOEMTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745625613; c=relaxed/simple;
	bh=H4uJxKCF8X2YSXybFoa0pezBDVH59awZSGnN4OANeXA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EqvlIJMIEf2B3+ZGE8wjnj9HNjY4QC/cxd+gAJ/b2W4LoJwxw1Gg7I70S7+83U98UKY7JR6KKRVMKtMaK68OOCUvarQI2nASH7jJZy1J2EXlIRDawI1eSmJxk+V93Xas6bpslsAJWlPBb8oBa2xee52P0rcpNHmYmJZaRg0/4X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tXSGxQ5f; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tXSGxQ5f"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b078af4b07dso1570379a12.3
        for <linux-crypto@vger.kernel.org>; Fri, 25 Apr 2025 17:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745625611; x=1746230411; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4GFetroiVqwabK1sZJi7Gssm6Y2r4VSG5IcyflglpQ4=;
        b=tXSGxQ5f0DpFbNe5BgRC7VYcidi1J+gQTMQNc55S/R8Crf2pZ9cuRmqAJjDQ8uJM8y
         cclJXDTIwpMJUVUq15Fxx2fJLoSUSbMfAUw8fU8Jh0jJQzXhvqJ2w4L200PZNpc8KMir
         TWImCmZXe5Rkk8iALhoDl6pw4COMJkKuIdT7S4cdHtoHZogtDDQQ75jlCbLK7M2Frlb8
         4lpuDJIuxL7kUhoH7tLP5So295K6m9c6yeuNRtFlTA1Gnqp5SzWSbx0dbvYIRGa7SNLv
         pcJPpjy1VFcW1itBBYCkjwLWUzC8K71q6d8Cgz/ME1wg0IwFUd9RLES09+nhmZ1c9OUK
         2OMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745625611; x=1746230411;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4GFetroiVqwabK1sZJi7Gssm6Y2r4VSG5IcyflglpQ4=;
        b=TlOVOVhTutKKgl14KJr41lf+WG8CBk5/j7pJNUtwzH5vWKR9T+aE0aiYXXDMeutGQb
         tPBZdGhs2MnerxIHksSBA64zbjXPGuO/xfQS6nta1A27yoT0GcYaNQ2czk4arVjDne4Q
         KMVF0oR0dVdsRtcKSQVPpRH/SEffSVuPrkQLnlHZrjQ5WepQ39K6dDA1dYcRr2jQ/Ti1
         pLywPNRBF5SwHvco+JVB2o1U3ZfiJGQ3Wx46ZOLj4aCJISoo/VyueeWxj6pSE3SO4mKL
         VMFXbb2VWWCfvpksDmpmToF8cHsmA8j83nF2O81rK+YlptNUqgR6LRUX2URDwjKCtOV/
         uWuw==
X-Forwarded-Encrypted: i=1; AJvYcCWa+nnG08Wwvcdsswt2UAFpTSEX+ZYIe2eXSxu37v6FoKr0JpAjNP5ScTzL67FJj/VF3SQZ3NHYeMWZ04k=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywaw9TNmzWqK33H5AfpUSBdARYE0XqXb97nLFKa09hQsZGJtcBP
	Ex98xPShZQZ+J4FB1XaDLIh9lnX1u9m0jSmPvusGWo6M0lBjgeQDNgX6vFo65s1p7pFUidaJ8/u
	lvQ==
X-Google-Smtp-Source: AGHT+IFkMqUvzxmIb5DQHMQAnE51nLU+gQzqYa24MNOiSl84Fum6ZnRW7j2yLz/4lpczDu9ZcESx8vr5f2E=
X-Received: from pjgg7.prod.google.com ([2002:a17:90b:57c7:b0:2fc:13d6:b4cb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c8b:b0:2f9:9ddd:689b
 with SMTP id 98e67ed59e1d1-30a01398779mr1331415a91.22.1745625611465; Fri, 25
 Apr 2025 17:00:11 -0700 (PDT)
Date: Fri, 25 Apr 2025 17:00:09 -0700
In-Reply-To: <ff8408bb-b110-4930-b914-98afe605c112@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1745279916.git.ashish.kalra@amd.com> <b64d61cc81611addb88ca410c9374e10fe5c293a.1745279916.git.ashish.kalra@amd.com>
 <aAlYV-4q6ndhJAVe@google.com> <ff8408bb-b110-4930-b914-98afe605c112@amd.com>
Message-ID: <aAwiCTNoQoV2nDfP@google.com>
Subject: Re: [PATCH v3 4/4] KVM: SVM: Add SEV-SNP CipherTextHiding support
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <ashish.kalra@amd.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au, 
	x86@kernel.org, john.allen@amd.com, davem@davemloft.net, 
	thomas.lendacky@amd.com, michael.roth@amd.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 25, 2025, Ashish Kalra wrote:
> On 4/23/2025 4:15 PM, Sean Christopherson wrote:
> 
> > 
> > 	if (boot_cpu_has(X86_FEATURE_SEV_ES)) {
> > 		if (snp_max_snp_asid >= (min_sev_asid - 1))
> > 			sev_es_supported = false;
> 
> SEV-ES is disabled if SNP is using all ASIDs upto min_sev_asid - 1.
> 
> > 		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
> > 			str_enabled_disabled(sev_es_supported),
> > 			min_sev_asid > 1 ? snp_max_snp_asid ? snp_max_snp_asid + 1 : 1 :
> > 							      0, min_sev_asid - 1);
> > 	}
> > 
> > A non-zero snp_max_snp_asid shouldn't break SEV-ES if CipherTextHiding isn't supported.
> 
> I don't see above where SEV-ES is broken if snp_max_snp_asid is non-zero and
> CTH is enabled ?

Please read what I wrote.  I did not say it's broken if CTH is enabled.  I said
it's broken if CTH isn't supported, i.e. is disabled.

snp_max_snp_asid isn't sanitized if CTH is unsupported or disabled by userspace,
and so KVM will compute the wrong min_sev_asid if snp_max_snp_asid is non-zero,
even though snp_max_snp_asid has no bearing on reality.

> >> +	 */
> >> +	if (snp_cipher_text_hiding && sev->es_active) {
> >> +		if (vm_type == KVM_X86_SNP_VM)
> >> +			max_asid = snp_max_snp_asid;
> >> +		else
> >> +			min_asid = snp_max_snp_asid + 1;
> >> +	}
> > 
> > Irrespective of the module params, I would much prefer to have a max_snp_asid
> > param that is kept up-to-date regardless of whether or not CipherTextHiding is
> > enabled. 
> 
> param ?

Sorry, s/param/variable.  Doesn't need to be user visible.
