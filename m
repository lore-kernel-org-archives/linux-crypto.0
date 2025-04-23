Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393D92F2E
	for <linux-crypto@vger.kernel.org>; Wed, 23 Apr 2025 21:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745442906; cv=none; b=OiDf0AMNLAGadKX7zd9KWhIa75sRVWCx3LgIokavh+dff19LW9AK57WgFlZZ38yCqbw/co/AXLmWvf7nrMsTvkRS6h3yuHmSJ32jR9YDQQlYYbKQcF9FHP9uZfJvsG12Cbb71u6dQLnVEz2wVhoEGI7+oDeo7aLIbHP+z8pHLuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745442906; c=relaxed/simple;
	bh=Qhyle64nj5FEVZr/spLuAISvfxmqODk5SmnW5z0y0jc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FClqsYGW+MIXmb/ULGqPWWRwWiJsxkX8ZXGdIOj7D2OCyY4puQiKFJ0bnZTHdEE+86xizjuoJUA1eumcF+CfNcjiX0Ah/SukLrSXut0eEe/YRAbTil4cYRJ56C9tT3OcHhvNSjRQITfWFElGRtils9lj+jIMmTQ11oYri66wKLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=esOrgarj; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="esOrgarj"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-af5310c1ac1so114291a12.2
        for <linux-crypto@vger.kernel.org>; Wed, 23 Apr 2025 14:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745442904; x=1746047704; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QNCezoC2norzND4zfx/aDz75UEkYOmyGNrrBgzBFjYo=;
        b=esOrgarjrZrpxJQrC+klWKtwmfTV/ZSnze7h4reaFbypsJnq7fgkM/rkD6cO2c/8aM
         7stSq6oQngGv1L07HsX4Y4HqoTbesmNFcD7/dHZ8+Gwl5TWIHra4JqenQrT4wsHryQie
         jC5KDSpDz7gzTfQClv5iDDPaFg1YhhTyl2CUxWH6LEZYSyPGnEcheVU3ZrmCxNg1TPfi
         FdWJ5r2DHBpO6I5uBnT1qHFEvPCA77RrPF3D06anPM4GYwWbdGQmdepDCgvFwkB1/uld
         +UUdjxNaUb8vKGOnruA14Sgv6/PgtVi3LuFtQmOTJo3ZYT3pUILi2T1dgeYir9K9QL8H
         0bTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745442904; x=1746047704;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QNCezoC2norzND4zfx/aDz75UEkYOmyGNrrBgzBFjYo=;
        b=iw7chL2bbyAi88jPruHc7TVvR6aZyCMBjA64NL7TcV06/P7LS0jVifzNb2njywGvVY
         qpiDObz/vxA2SOYZPKUnYnN6AZCGWEDvcRHccOfbNmf20Tac/2GGaGQhBgwimXP8dojm
         0QBclGguVTyni6UXwxlIqDooRZH4fgd3P4oos3e5nReJW7eVpc+Of44uAKBmF8BrGooc
         9pDTsknJPVDvuURhSjM61dh7F7zab60ZkGUqENULG1g8mKJJcp69+rbwAcslc4XEG+3a
         wi3rDhiU38aHyB+/kL8vq2eeman4T2diYKrfbDfbnKuknbhHGQL9d2ejmRFYKPgnovhr
         CasA==
X-Forwarded-Encrypted: i=1; AJvYcCUJdb6u/pQQtKxctsKEcVEY4Lx/CNLkqkJ7nSpZGRKiaksw/42sTgfNRh6YCA7do5lqPX4E/U85A+XgyAw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCT1AqjqW3hVep5fsu/FRwbsbwY0P1RSWGZmUHFBnyrOo8kaHv
	bt+KGqayIRoqamKeaGfd0Py9IwtgX6ZEtiL+aF//6DR5PtGAAoFpimo1llnxMW7r0Q7IJX3L4kq
	fcQ==
X-Google-Smtp-Source: AGHT+IH6n+39jdeR5xkLFRtMmFnqk2ZJ/vL++6lDOWKWu84lSXlK/x1TOJfVE4Bcya7a1ouuhEvg45IXz8g=
X-Received: from pfud20.prod.google.com ([2002:a05:6a00:10d4:b0:73c:26bd:133c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:428e:b0:736:57cb:f2aa
 with SMTP id d2e1a72fcca58-73e24635235mr301470b3a.13.1745442904504; Wed, 23
 Apr 2025 14:15:04 -0700 (PDT)
Date: Wed, 23 Apr 2025 14:15:03 -0700
In-Reply-To: <b64d61cc81611addb88ca410c9374e10fe5c293a.1745279916.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1745279916.git.ashish.kalra@amd.com> <b64d61cc81611addb88ca410c9374e10fe5c293a.1745279916.git.ashish.kalra@amd.com>
Message-ID: <aAlYV-4q6ndhJAVe@google.com>
Subject: Re: [PATCH v3 4/4] KVM: SVM: Add SEV-SNP CipherTextHiding support
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au, 
	x86@kernel.org, john.allen@amd.com, davem@davemloft.net, 
	thomas.lendacky@amd.com, michael.roth@amd.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 22, 2025, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Ciphertext hiding prevents host accesses from reading the ciphertext of
> SNP guest private memory. Instead of reading ciphertext, the host reads
> will see constant default values (0xff).
> 
> Ciphertext hiding separates the ASID space into SNP guest ASIDs and host
> ASIDs.

Uh, no.  The only "host" ASID is '0'.

> All SNP active guests must have an ASID less than or equal to MAX_SNP_ASID
> provided to the SNP_INIT_EX command. All SEV-legacy guests (SEV and SEV-ES)
> must be greater than MAX_SNP_ASID.

This is misleading, arguably wrong.  The ASID space is already split into legacy+SEV and
SEV-ES+.  CTH further splits the SEV-ES+ space into SEV-ES and SEV-SNP+.
> 
> This patch-set adds two new module parameters to the KVM module, first

No "This patch".

> to enable CipherTextHiding support and a user configurable MAX_SNP_ASID
> to define the system-wide maximum SNP ASID value. If this value is not set,
> then the ASID space is equally divided between SEV-SNP and SEV-ES guests.

This quite, and I suspect completely useless for every production use case.  I
also *really* dislike max_snp_asid.  More below.

> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 50 +++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 45 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 7a156ba07d1f..a905f755312a 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -58,6 +58,14 @@ static bool sev_es_debug_swap_enabled = true;
>  module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
>  static u64 sev_supported_vmsa_features;
>  
> +static bool cipher_text_hiding;
> +module_param(cipher_text_hiding, bool, 0444);
> +MODULE_PARM_DESC(cipher_text_hiding, "  if true, the PSP will enable Cipher Text Hiding");
> +
> +static int max_snp_asid;
> +module_param(max_snp_asid, int, 0444);
> +MODULE_PARM_DESC(max_snp_asid, "  override MAX_SNP_ASID for Cipher Text Hiding");

I'd much, much prefer proper document in Documentation/admin-guide/kernel-parameters.txt.
The basic gist of the params is self-explanatory, but how all of this works is not.

And max_snp_asid is extremely misleading.  Pretty much any reader is going to expect
it to do what it says: set the max SNP ASID.  But unless cipher_text_hiding is
enabled, which it's not by default, the param does absolutely nothing.

To address both problems, can we somehow figure out a way to use a single param?
The hardest part is probably coming up with a name.  E.g.

  static int ciphertext_hiding_nr_asids;
  module_param(ciphertext_hiding_nr_asids, int, 0444);

Then a non-zero value means "enable CipherTexthiding", and effects the ASID carve-out.
If we wanted to support the 50/50 split, we would use '-1' as an "auto" flag,
i.e. enable CipherTexthiding and split the SEV-ES+ ASIDs.  Though to be honest,
I'd prefer to avoid that unless it's actually useful.

Ha!  And I'm doubling down on that suggestion, because this code is wrong:

	if (boot_cpu_has(X86_FEATURE_SEV_ES)) {
		if (snp_max_snp_asid >= (min_sev_asid - 1))
			sev_es_supported = false;
		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
			str_enabled_disabled(sev_es_supported),
			min_sev_asid > 1 ? snp_max_snp_asid ? snp_max_snp_asid + 1 : 1 :
							      0, min_sev_asid - 1);
	}

A non-zero snp_max_snp_asid shouldn't break SEV-ES if CipherTextHiding isn't supported.

>  #define AP_RESET_HOLD_NONE		0
>  #define AP_RESET_HOLD_NAE_EVENT		1
>  #define AP_RESET_HOLD_MSR_PROTO		2
> @@ -85,6 +93,8 @@ static DEFINE_MUTEX(sev_bitmap_lock);
>  unsigned int max_sev_asid;
>  static unsigned int min_sev_asid;
>  static unsigned long sev_me_mask;
> +static unsigned int snp_max_snp_asid;
> +static bool snp_cipher_text_hiding;
>  static unsigned int nr_asids;
>  static unsigned long *sev_asid_bitmap;
>  static unsigned long *sev_reclaim_asid_bitmap;
> @@ -171,7 +181,7 @@ static void sev_misc_cg_uncharge(struct kvm_sev_info *sev)
>  	misc_cg_uncharge(type, sev->misc_cg, 1);
>  }
>  
> -static int sev_asid_new(struct kvm_sev_info *sev)
> +static int sev_asid_new(struct kvm_sev_info *sev, unsigned long vm_type)
>  {
>  	/*
>  	 * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
> @@ -199,6 +209,18 @@ static int sev_asid_new(struct kvm_sev_info *sev)
>  
>  	mutex_lock(&sev_bitmap_lock);
>  
> +	/*
> +	 * When CipherTextHiding is enabled, all SNP guests must have an
> +	 * ASID less than or equal to MAX_SNP_ASID provided on the

Wrap at ~80, not

> +	 * SNP_INIT_EX command and all the SEV-ES guests must have
> +	 * an ASID greater than MAX_SNP_ASID.

Please don't referense MAX_SNP_ASID.  The reader doesn't need to know what the
PSP calls its parameter.  What matters is the concept, and to a lesser extent
KVM's param.

> +	 */
> +	if (snp_cipher_text_hiding && sev->es_active) {
> +		if (vm_type == KVM_X86_SNP_VM)
> +			max_asid = snp_max_snp_asid;
> +		else
> +			min_asid = snp_max_snp_asid + 1;
> +	}

Irrespective of the module params, I would much prefer to have a max_snp_asid
param that is kept up-to-date regardless of whether or not CipherTextHiding is
enabled.   Then you don't need a comment here, only a big fat comment in the code
that configures the min/max ASIDs, which is going to be a gnarly comment no matter
what we do.  Oh, and this should be done before the

	if (min_asid > max_asid)
		return -ENOTTY;

sanity check.

And then drop the mix of ternary operators and if statements, and just do:

	unsigned int min_asid, max_asid, asid;
	bool retry = true;
	int ret;

	if (vm_type == KVM_X86_SNP_VM) {
		min_asid = min_snp_asid;
		max_asid = max_snp_asid;
	} else if (sev->es_active) {
		min_asid = min_sev_es_asid;
		max_asid = max_sev_es_asid;
	} else {
		min_asid = min_sev_asid;
		max_asid = max_sev_asid;
	}

	/*
	 * The min ASID can end up larger than the max if basic SEV support is
	 * effectively disabled by disallowing use of ASIDs for SEV guests.
	 * Ditto for SEV-ES guests when CipherTextHiding is enabled.
	 */
	if (min_asid > max_asid)
		return -ENOTTY;

> @@ -3040,14 +3074,18 @@ void __init sev_hardware_setup(void)
>  								       "unusable" :
>  								       "disabled",
>  			min_sev_asid, max_sev_asid);
> -	if (boot_cpu_has(X86_FEATURE_SEV_ES))
> +	if (boot_cpu_has(X86_FEATURE_SEV_ES)) {
> +		if (snp_max_snp_asid >= (min_sev_asid - 1))
> +			sev_es_supported = false;
>  		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
>  			str_enabled_disabled(sev_es_supported),
> -			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
> +			min_sev_asid > 1 ? snp_max_snp_asid ? snp_max_snp_asid + 1 : 1 :
> +							      0, min_sev_asid - 1);
> +	}
>  	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
>  		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
>  			str_enabled_disabled(sev_snp_supported),
> -			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
> +			min_sev_asid > 1 ? 1 : 0, snp_max_snp_asid ? : min_sev_asid - 1);

Mixing in snp_max_snp_asid pretty much makes this is unreadable.  Please rework
this code to generate {min,max}_{sev,sev_es,snp,}_asid (add prep patches if
necessary).  I don't care terribly if ternary operators are used, but please
don't chain them.

>  
>  	sev_enabled = sev_supported;
>  	sev_es_enabled = sev_es_supported;
> @@ -3068,6 +3106,8 @@ void __init sev_hardware_setup(void)
>  	 * Do both SNP and SEV initialization at KVM module load.
>  	 */
>  	init_args.probe = true;
> +	init_args.cipher_text_hiding_en = snp_cipher_text_hiding;
> +	init_args.snp_max_snp_asid = snp_max_snp_asid;
>  	sev_platform_init(&init_args);
>  }
>  
> -- 
> 2.34.1
> 
