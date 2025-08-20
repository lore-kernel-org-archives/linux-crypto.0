Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9C231CA5C
	for <linux-crypto@vger.kernel.org>; Wed, 20 Aug 2025 15:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755702177; cv=none; b=snSrfB5luxwkYKm1eox9euRfa+86pcT5VLhMzYflZFRc6b579sGH51CVG9h1HRs+0oXKACBTvv+/LQ8R9Z9ZE5ejHfnJqFR92mEOjzWDSNlx5l+sZMhHxoIrHGA2HG+9tgXIMNO1I+WR3HaMoM3kUneS+1RDenvs4nyUgMz4Cwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755702177; c=relaxed/simple;
	bh=35pKN6C+VNX7xaXkGsNYx4qte9faL+6BBB0MhsJsU0k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JGM0TbWTUtjQ916d+gu43KJQgam+rOG6M2zpDyO/0FZbNwrYJ9Qodgy0HsmYQ7cQG2jKs3fXaXynTXaJWfKlGpZJz5RqRE7HMYP6EimlPT2VVy1n1pLZrgrcqiZByGVfNtfYO1o/SgCSidtCmKaUSCrOKMDf7HVg1lRvq64pPS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fIU0xb0A; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fIU0xb0A"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b474d5ff588so2364029a12.2
        for <linux-crypto@vger.kernel.org>; Wed, 20 Aug 2025 08:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755702175; x=1756306975; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=py9R9+QApeJXx5I1V91Kk0iD24/wK+S35BROPAqD64s=;
        b=fIU0xb0Atg0GNx2MoY2JAFMsnAJ7hm+LCZlZ0Zb7sHVIWxiTQtC53fn9UfiX7AJWic
         K4zT+XvTgu139DU+ugnD6aOtYJmOUuVUHwxw/l9/DaToElUWt0qyYqT8eoLx+tQocbEh
         j4PwsDQYbiPOUlxYl0naw8ZtO+ldeqKbjXo5IfJ5cZae+bUpw5uzAL0F1nJ7lromFXdc
         HScV5bhfXFRhr63dd79F/oD20awkik3j94VwU0eGPqd7u0pU6OAGlC0gtw511K9g+uRG
         7lnegCP6xuFlZnOJ0FmPiqHOCcA/qXDGqPbEkWGfAY6oiiL8z55EEbFUBLHy5gJ+Unop
         XOyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755702175; x=1756306975;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=py9R9+QApeJXx5I1V91Kk0iD24/wK+S35BROPAqD64s=;
        b=E+PB1Q4EujGsTDfkV+XGo1RbLsCi2Hb96uPkqQYaoKikt1GCK4+ivYHK43yCvBiSkY
         zDZ6oiY0kWxSMxBPukPgQfPfAGR9WvfcPRCjtvkly/i6IZuHbrrmCnvdv/KlC3L6rz1+
         snYJMq2wXUBb+R0MZyYpEUpPtRn+qNUvTahL07qj5iwFwAI9AAqYIZGIqS0uqMaTyvxb
         g7XvW0JXstpDR84iZVyujlSdfs/EF/kWN7SCx2KVlIYsfHFwEVdyEJwUpSCGomNK07+f
         j8ww0bwxq63RTCnIStbRG5NlaPZvvfL3aJLQwnNGyFQZOa8G/XlJnl3/+kezzIpmFhsF
         Of1w==
X-Forwarded-Encrypted: i=1; AJvYcCXCGya8zyOLAbcdbxWB03yoO/7lHbIAmatgKACf5GIJzr3qHchoF+4/sVl1Lt0WWW9DBaDaYrMhEFsfHoo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHmaR3iMXnW5qLdOQRXTewiGamgHb0uaID/ECwypCWnCprPaVv
	k3mIBJAM+eFnaHQirYI7sc0UfsXtCCyUABwFuDEWeLaULmGAdU1kk/95Gj9axijk7+NRKTRmDgu
	EFtBWXg==
X-Google-Smtp-Source: AGHT+IGSotSuoVezUkY9oBo/u8SA5fDagRbvCMKpPl6WJrksgFvi4sZibjd8bBwt+jGPv4gcxxrQo6KIUGc=
X-Received: from pjbpx10.prod.google.com ([2002:a17:90b:270a:b0:31c:2fe4:33bd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:431f:b0:240:af8:176d
 with SMTP id adf61e73a8af0-2431b7ddc06mr5696035637.24.1755702174789; Wed, 20
 Aug 2025 08:02:54 -0700 (PDT)
Date: Wed, 20 Aug 2025 08:02:53 -0700
In-Reply-To: <e1740fa2-f26c-4c3b-b139-b31dd654bea6@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1752869333.git.ashish.kalra@amd.com> <20250811203025.25121-1-Ashish.Kalra@amd.com>
 <aKBDyHxaaUYnzwBz@gondor.apana.org.au> <f2fc55bb-3fc4-4c45-8f0a-4995e8bf5890@amd.com>
 <51f0c677-1f9f-4059-9166-82fb2ed0ecbb@amd.com> <20250819075919.GAaKQu135vlUGjqe80@fat_crate.local>
 <aKURLcxv6uLnNxI2@google.com> <e1740fa2-f26c-4c3b-b139-b31dd654bea6@amd.com>
Message-ID: <aKXjnbZcmrtRwIXS@google.com>
Subject: Re: [PATCH v7 0/7] Add SEV-SNP CipherTextHiding feature support
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <ashish.kalra@amd.com>
Cc: Borislav Petkov <bp@alien8.de>, Kim Phillips <kim.phillips@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Neeraj.Upadhyay@amd.com, aik@amd.com, 
	akpm@linux-foundation.org, ardb@kernel.org, arnd@arndb.de, corbet@lwn.net, 
	dave.hansen@linux.intel.com, davem@davemloft.net, hpa@zytor.com, 
	john.allen@amd.com, kvm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, michael.roth@amd.com, 
	mingo@redhat.com, nikunj@amd.com, paulmck@kernel.org, pbonzini@redhat.com, 
	rostedt@goodmis.org, tglx@linutronix.de, thomas.lendacky@amd.com, 
	x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 19, 2025, Ashish Kalra wrote:
> Hello Sean,
> 
> On 8/19/2025 7:05 PM, Sean Christopherson wrote:
> > On Tue, Aug 19, 2025, Borislav Petkov wrote:
> >> On Mon, Aug 18, 2025 at 02:38:38PM -0500, Kim Phillips wrote:
> >>> I have pending comments on patch 7:
> >>
> >> If you're so hell-bent on doing your improvements on-top or aside of them, you
> >> take his patch, add your stuff ontop or rewrite it, test it and then you send
> >> it out and say why yours is better.
> >>
> >> Then the maintainer decides.
> >>
> >> There's no need to debate ad absurdum - you simply offer your idea and the
> >> maintainer decides which one is better. As it has always been done.
> > 
> > Or, the maintainer says "huh!?" and goes with option C.
> > 
> > Why take a string in the first place?  Just use '-1' as "max/auto".
> 
> It's just that there was general feedback to use a string like "max".

From who?  There's definitely value in providing/using human-friendly names for
things like this, but that needs to be weighed against the cost and complexity
in the kernel.  And the cost+complexity is quite high:

> +static bool check_and_enable_sev_snp_ciphertext_hiding(void)
> +{
> +	unsigned int ciphertext_hiding_asid_nr = 0;
> +
> +	if (!ciphertext_hiding_asids[0])
> +		return false;
> +
> +	if (!sev_is_snp_ciphertext_hiding_supported()) {
> +		pr_warn("Module parameter ciphertext_hiding_asids specified but ciphertext hiding not supported\n");

This will print a spurious message if the admin explicitly loading KVM with
ciphertext_hiding_asids=0.

> +		return false;
> +	}
> +
> +	if (isdigit(ciphertext_hiding_asids[0])) {
> +		if (kstrtoint(ciphertext_hiding_asids, 10, &ciphertext_hiding_asid_nr))
> +			goto invalid_parameter;
> +
> +		/* Do sanity check on user-defined ciphertext_hiding_asids */
> +		if (ciphertext_hiding_asid_nr >= min_sev_asid) {
> +			pr_warn("Module parameter ciphertext_hiding_asids (%u) exceeds or equals minimum SEV ASID (%u)\n",
> +				ciphertext_hiding_asid_nr, min_sev_asid);
> +			return false;

This is unfortunate and probably unexpected behavior, because if the admin
provided a super large value, odds are good they would make SEV-ES unusable than
disable ciphertext hiding.

> +		}
> +	} else if (!strcmp(ciphertext_hiding_asids, "max")) {
> +		ciphertext_hiding_asid_nr = min_sev_asid - 1;

The actual resolved value isn't captured in the module param.  

> +	}
> +
> +	if (ciphertext_hiding_asid_nr) {
> +		max_snp_asid = ciphertext_hiding_asid_nr;
> +		min_sev_es_asid = max_snp_asid + 1;
> +		pr_info("SEV-SNP ciphertext hiding enabled\n");
> +
> +		return true;
> +	}

This will fallthrough on ciphertext_hiding_asids=0 as well and yell about '0'
being invalid.

> +
> +invalid_parameter:
> +	pr_warn("Module parameter ciphertext_hiding_asids (%s) invalid\n",
> +		ciphertext_hiding_asids);
> +	return false;
> +}

> But as a maintainer if you are suggesting to use '-1' as "max/auto", i can do
> that.

Looking at this again, I don't see any reason to special case -1.  Just make the
param a uint and cap it at that maximum possible value.  As above, disabling
ciphertext hiding if the number of request SNP ASIDs is higher than what hardware
supports is probably not want the admin wants.

Compile tested only.

--
From: Ashish Kalra <ashish.kalra@amd.com>
Date: Mon, 21 Jul 2025 14:14:34 +0000
Subject: [PATCH] KVM: SEV: Add SEV-SNP CipherTextHiding support

Ciphertext hiding prevents host accesses from reading the ciphertext of
SNP guest private memory. Instead of reading ciphertext, the host reads
will see constant default values (0xff).

The SEV ASID space is split into SEV and SEV-ES/SEV-SNP ASID ranges.
Enabling ciphertext hiding further splits the SEV-ES/SEV-SNP ASID space
into separate ASID ranges for SEV-ES and SEV-SNP guests.

Add a new off-by-default kvm-amd module parameter enable ciphertext
hiding and allow the admin to configure the SEV-ES and SEV-SNP ASID
ranges.  Simply cap the maximum SEV-SNP ASID as appropriate, i.e. don't
reject loading KVM or disable ciphertest hiding for a too-big value, as
KVM's general approach for module params is to sanitize inputs based on
hardware/kernel support, not burn the world down.  This also allows the
admin to use -1u to assign all SEV-ES/SNP ASIDs to SNP without needing
dedicated handling in KVM.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../admin-guide/kernel-parameters.txt         | 19 +++++++++++
 arch/x86/kvm/svm/sev.c                        | 32 ++++++++++++++++++-
 2 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 747a55abf494..f4735931661e 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2957,6 +2957,25 @@
 			(enabled). Disable by KVM if hardware lacks support
 			for NPT.
 
+	kvm-amd.ciphertext_hiding_asids=
+			[KVM,AMD] Ciphertext hiding prevents disallowed accesses
+			to SNP private memory from reading ciphertext.  Instead,
+			reads will see constant default values (0xff).
+
+			If ciphertext hiding is enabled, the joint SEV-ES+SEV-SNP
+			ASID space is paritioned separate SEV-ES and SEV-SNP ASID
+			ranges, with the SEV-SNP ASID range starting at 1.  For
+			SEV-ES/SEV-SNP guests the maximum ASID is MIN_SEV_ASID-1,
+			where MIN_SEV_ASID value is discovered by CPUID
+			Fn8000_001F[EDX].
+
+			A non-zero value enables SEV-SNP ciphertext hiding and
+			adjusts the ASID ranges for SEV-ES and SEV-SNP guests.
+			KVM caps the number of SEV-SNP ASIDs at the maximum
+			possible value, e.g. specifying -1u will assign all
+			join SEV-ES+SEV-SNP ASIDs to SEV-SNP and make SEV-ES
+			unusable.
+
 	kvm-arm.mode=
 			[KVM,ARM,EARLY] Select one of KVM/arm64's modes of
 			operation.
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index cd9ce100627e..52efd43c333a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -59,6 +59,9 @@ static bool sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
 static u64 sev_supported_vmsa_features;
 
+static unsigned int nr_ciphertext_hiding_asids;
+module_param_named(ciphertext_hiding_asids, nr_ciphertext_hiding_asids, uint, 0444);
+
 #define AP_RESET_HOLD_NONE		0
 #define AP_RESET_HOLD_NAE_EVENT		1
 #define AP_RESET_HOLD_MSR_PROTO		2
@@ -201,6 +204,9 @@ static int sev_asid_new(struct kvm_sev_info *sev, unsigned long vm_type)
 	/*
 	 * The min ASID can end up larger than the max if basic SEV support is
 	 * effectively disabled by disallowing use of ASIDs for SEV guests.
+	 * Similarly for SEV-ES guests the min ASID can end up larger than the
+	 * max when ciphertext hiding is enabled, effectively disabling SEV-ES
+	 * support.
 	 */
 	if (min_asid > max_asid)
 		return -ENOTTY;
@@ -3064,10 +3070,32 @@ void __init sev_hardware_setup(void)
 out:
 	if (sev_enabled) {
 		init_args.probe = true;
+
+		if (sev_is_snp_ciphertext_hiding_supported())
+			init_args.max_snp_asid = min(nr_ciphertext_hiding_asids,
+						     min_sev_asid - 1);
+
 		if (sev_platform_init(&init_args))
 			sev_supported = sev_es_supported = sev_snp_supported = false;
 		else if (sev_snp_supported)
 			sev_snp_supported = is_sev_snp_initialized();
+
+		if (sev_snp_supported)
+			nr_ciphertext_hiding_asids = init_args.max_snp_asid;
+
+		/*
+		 * If ciphertext hiding is enabled, the joint SEV-ES/SEV-SNP
+		 * ASID range is partitioned into separate SEV-ES and SEV-SNP
+		 * ASID ranges, with the SEV-SNP range being [1..max_snp_asid]
+		 * and the SEV-ES range being (max_snp_asid..max_sev_es_asid].
+		 * Note, SEV-ES may effectively be disabled if all ASIDs from
+		 * the joint range are assigned to SEV-SNP.
+		 */
+		if (nr_ciphertext_hiding_asids) {
+			max_snp_asid = nr_ciphertext_hiding_asids;
+			min_sev_es_asid = max_snp_asid + 1;
+			pr_info("SEV-SNP ciphertext hiding enabled\n");
+		}
 	}
 
 	if (boot_cpu_has(X86_FEATURE_SEV))
@@ -3078,7 +3106,9 @@ void __init sev_hardware_setup(void)
 			min_sev_asid, max_sev_asid);
 	if (boot_cpu_has(X86_FEATURE_SEV_ES))
 		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
-			str_enabled_disabled(sev_es_supported),
+			sev_es_supported ? min_sev_es_asid <= max_sev_es_asid ? "enabled" :
+										"unusable" :
+										"disabled",
 			min_sev_es_asid, max_sev_es_asid);
 	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
 		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",

base-commit: fba22ac9ea05ee5e15318823333114104045be2d
--
