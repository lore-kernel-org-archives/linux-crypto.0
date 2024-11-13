Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF8B137C35
	for <linux-crypto@vger.kernel.org>; Wed, 13 Nov 2024 15:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731513497; cv=none; b=gY6EUF560b/aY7XQ+EpcMd22PNWLbOYNm+C2b8+d2iL4rmTpDeUXIdLM2AtSnSCRpDphoUvbAwg836xnLj2KEjeIPYoVa7TSazKGGOTFxcbxzTJc27n7O0rWbcNgF2yM1S3NvtIhvQ1SiRazsm/TNPri6LxmFKl90NSh94PAtMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731513497; c=relaxed/simple;
	bh=IZNKL5dKTunqOnlhlqbELW9B4+RdNR6QwIYEmChpV5c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gVemwTFPEhV2BVrtYPcYwTzPjH4nqfeiGRlV+IpKp6rs1LiLubHI2Y1G0pongqAHJ7m4fdpaxaLLlt8aO16pHxXdt8T9MOQUPxSMdbnNLrdKCj5ok0m1aNkELvPQBUoZJ1/rsJvK3bArta8dndAEyDfed+FlhKyr5Vt8msCDOPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0cdk/8xd; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0cdk/8xd"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6ea86f1df79so128411757b3.1
        for <linux-crypto@vger.kernel.org>; Wed, 13 Nov 2024 07:58:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731513494; x=1732118294; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kF/MfTQ5/fcEXQi4LYfLZfwZ71SBi7osE385WhqsuTc=;
        b=0cdk/8xdpEhg/zSuncy9dvr/2/cM2LvCeCkjsVa4x7a+DCyk7NSn3NUdlQjFgT1AC1
         IRtOyUexm3N2p41o2K2jNqhcCkvqDs+ZH9SCoMECnFjJoe5821cL+T4+HJQHx2rlDigM
         aRkcGK4UbcHzPqKLUJsgaGB6pAocUpHXlHyyVsEc09H705OCI111mpXsACkgi6n7vayC
         wHZ/Zt6XtN56bgXZxgm3OiiybsZYipRNHlvpdEIMSOqEIMvvLYbL7j5GpW4Wh4+AGmCF
         BZEFTzHuJHitAVdUOWFSgQ98sXkpRg3IzwimakaIBB5FgA8SLkrkO5nZhJdcTsobWSLl
         ebJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731513494; x=1732118294;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kF/MfTQ5/fcEXQi4LYfLZfwZ71SBi7osE385WhqsuTc=;
        b=V7QLW/6nJNjQKFuZ4t85KOWWrnNJqCZz8jb16JH8oI22AGOOVBdbpZwl6fqmNcNSge
         v/joTIgIKAglusHSEnzkgkq32GP+e3ixLVuuDogYiFyJ/ozLUH1wV63Fy9M24bGW42V5
         8viepS5HGOQrxReXqPvnPLM1gbBVH/vfbQUtwfG59t2F60UtaKUKuRNmT/bO+oRAst0v
         ac1x/B8k2F622KsHuQTAPONLEOn0bsxdkDOyrJzgoJbu+vSE8gC9u7RFE4oHBoLq5cjz
         3MLQehmJb8KYBPKgHoJb9IG6HJbBDEUbspelrTBaTovW+eLjI2dk8XqagDDy5c1Cztki
         xZ0w==
X-Forwarded-Encrypted: i=1; AJvYcCWSAlyiCsMto/a3mb0AvcxvX5elzTSWyEXWaoZvyvIWcWAhlAjZSD70llR2y30VvlN5OX/OtA1+S59ZCho=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7RD5HDtq+7uVHUf0y0S4RhNmMg5JKPAk2m2PDbp9h5CcCmpD9
	+qAOx0GXuPTQklqYXvDegrWBA70WBl1x2iVrQ1VFml9W3oXypAujYE30n2ZYSXmCcNkGTqpn49Q
	MEw==
X-Google-Smtp-Source: AGHT+IHuQ95n+Y8jejyNGBOGXye70VLPfyNGzX3R/E/mHwLTbyQVpbG8tfrNstJjL7AVlymwbNM8htd7/LM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a81:b510:0:b0:6e2:ad08:4924 with SMTP id
 00721157ae682-6eaddf71dcfmr1920297b3.4.1731513494525; Wed, 13 Nov 2024
 07:58:14 -0800 (PST)
Date: Wed, 13 Nov 2024 07:58:13 -0800
In-Reply-To: <20241112232253.3379178-6-dionnaglaze@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241112232253.3379178-1-dionnaglaze@google.com> <20241112232253.3379178-6-dionnaglaze@google.com>
Message-ID: <ZzTMlcoU4uOijVxt@google.com>
Subject: Re: [PATCH v6 5/8] crypto: ccp: Add GCTX API to track ASID assignment
From: Sean Christopherson <seanjc@google.com>
To: Dionna Glaze <dionnaglaze@google.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, linux-coco@lists.linux.dev, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Michael Roth <michael.roth@amd.com>, Luis Chamberlain <mcgrof@kernel.org>, 
	Russ Weight <russ.weight@linux.dev>, Danilo Krummrich <dakr@redhat.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Tianfei zhang <tianfei.zhang@intel.com>, Alexey Kardashevskiy <aik@amd.com>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 12, 2024, Dionna Glaze wrote:
> @@ -109,6 +110,10 @@ static void *sev_init_ex_buffer;
>   */
>  static struct sev_data_range_list *snp_range_list;
>  
> +/* SEV ASID data tracks resources associated with an ASID to safely manage operations. */
> +struct sev_asid_data *sev_asid_data;
> +u32 nr_asids, sev_min_asid, sev_es_max_asid;
> +
>  static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
> @@ -1093,6 +1098,109 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>  	return 0;
>  }
>  
> +static bool sev_check_external_user(int fd);
> +void *sev_snp_create_context(int fd, int asid, int *psp_ret)
> +{
> +	struct sev_data_snp_addr data = {};
> +	void *context;
> +	int rc, error;
> +
> +	if (!sev_check_external_user(fd))
> +		return ERR_PTR(-EBADF);
> +
> +	if (!sev_asid_data)
> +		return ERR_PTR(-ENODEV);
> +
> +	if (asid < 0 || asid >= nr_asids)
> +		return ERR_PTR(-EINVAL);
> +
> +	/* Can't create a context for a used ASID. */
> +	if (WARN_ON_ONCE(sev_asid_data[asid].snp_context))
> +		return ERR_PTR(-EBUSY);

Tracking contexts in an array that's indexed per ASID is unsafe and unnecessarily
splits ASID management across KVM and the PSP driver.  There is zero reason the
PSP driver needs to care about ASIDs.  Attempting to police KVM is futile, and
leads to bloated, convoluted code.

AFAICT, there is nothing to guard against a use-after-free in 
snp_update_guest_contexts().  The need to handle SEV_RET_INVALID_GUEST is a pretty
big clue that there are races between KVM and firmware updates.

		if (!sev_asid_data[i].snp_context)
			continue;

		status_data.gctx_paddr = __psp_pa(sev_asid_data[i].snp_context);
		status_data.address = __psp_pa(snp_guest_status);
		rc = sev_do_cmd(SEV_CMD_SNP_GUEST_STATUS, &status_data, &error);
		if (!rc)
			continue;

		/*
		 * Handle race with SNP VM being destroyed/decommissoned,
		 * if guest context page invalid error is returned,
		 * assume guest has been destroyed.
		 */
		if (error == SEV_RET_INVALID_GUEST)
			continue;

Using an array is also inefficient, as it requires iterating over all possible
ASIDs, many of which may be unused.

Furthermore, handling this in the PSP driver (correctly) leads to unnecessary
locking.  KVM already protects SNP ASID allocations with sev_deactivate_lock, I
see zero reason to complicate things with another lock.

The "rollback" mechanism is also broken.  If SEV_CMD_SNP_GUEST_STATUS fails,
synthetic_restore_required is set and never cleared, and impacts *all* SEV PSP
commands.  I.e. failure to update one guest context comletely cripples the entire
system.  Not to mention synthetic_restore_required also lacks any form of SMP
synchronication.

I also don't see how a rollback is possible if an error occurs after one or more
guest contexts have been updated.  Presumably trying to rollback in that state
will leave the updated guests in a bad state.  Of course, I don't see any rollback
code as nothing ever clears synthetic_restore_required, so what's intented to
happen is entirely unclear.

I also don't see anything in this series that explains why a SEV_CMD_SNP_GUEST_STATUS
failure shouldn't be treated as a fatal error.  Of the error codes listed in the
SNP ABI, everything except UPDATE_FAILED is clearly a software bug.  And I can't
find anything that explains when UPDATE_FAILED will be returned.

  Table 80. Status Codes for SNP_GUEST_STATUS
  Status                          Condition
  SUCCESS                         Successful completion.
  INVALID_PLATFORM_STATE          The platform is not in the INIT state.
  INVALID_ADDRESS                 The address is invalid for use by the firmware.
  INVALID_PARAM                   MBZ fields are not zero.
  INVALID_GUEST                   The guest context page was invalid.
  INVALID_PAGE_STATE              The guest status page was not in the correct state.
  INVALID_PAGE_SIZE               The guest status page was not the correct size.
  UPDATE_FAILED                   Update of the firmware internal state or a guest context page has failed.

Somewhat off the cuff, I think the only sane way to approach this is to call into
KVM when doing a firmware update, and let KVM react accordingly.   E.g. let KVM
walk its list of VMs in order to update SNP VMs, taking kvm_lock and the somewhat
misnamed sev_deactivate_lock() as needed.  Then if updating a guest context fails,
terminate _that_ VM, and move on to the next VM.

Side topic, I don't see any code that ensures no SEV or SEV-ES VMs are running.
Is the idea to let userspace throw noodles at the PSP and see what sticks?

+        Provide support for AMD Platform Security Processor firmware.
+        The PSP firmware can be updated while no SEV or SEV-ES VMs are active.
                                                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+        Users of this feature should be aware of the error modes that indicate
+        required manual rollback or reset due to instablity.
