Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB4839A7FE;
	Wed, 25 Mar 2026 15:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774452310; cv=none; b=NS9wRMfTVkZHzKDs/Q11YPSt4XZloYCGfBLyMww5vqLYGFjGdUfAGsJfcFYyfLV3uQCI2CejAZD4IrAIXIFMaA2pQuHFD6tT6ixr+GexiztYQ+aL1I0bD1OMqBoYgK530IFLIqD6RBE9V660ydWrEHtMOUPsc0q+dZvZrmptso4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774452310; c=relaxed/simple;
	bh=sI6cjAIO1yZ54Gqe2yyUZeshtZbWqpAlSGw4L5lRmzk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GW9ldIb9fsQggkygD51oGBay06GZz3uyF8Py4Af+3TxIV2Ev0f3923I4BC//uOENWgdrkjRSc+syP2R9Ld3k81LNGhHic8CwJqwsOcxeNSJcYfWiUd4zRfo+e2Pyed8YSu+wE1wthi01AvPuhPHB7MIrR9pYsLbLs4kDv5Qwg/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dEelH2eT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dEelH2eT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C57FC116C6;
	Wed, 25 Mar 2026 15:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774452310;
	bh=sI6cjAIO1yZ54Gqe2yyUZeshtZbWqpAlSGw4L5lRmzk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dEelH2eT5mI+c6A7F+qjo0dLLdE+xa197XUVe60Mhv0mnAGmz3EUpb0SMesUh77FN
	 rJsqcC7DSPfuv6KCfeUqXTHkQTtVBvwgKOVqoIajkpjdR4PupLRDeu85R9dUUB8JXK
	 gio07OmXnBtRgIE6r6GGuzVjX8MkhW6fldH2JsWPQXzENPAbOlur1Swt9Tpi8UVk36
	 iddHFWastQZqwC0neCEzxzrApvImZSjirzsgS3oj/kVfoHuamMKMTJXpBE5V/hK7k/
	 C3kv90fsQkBskE2P5ihN1/sqU/mYqqNpnW9jNhx95rHbNDN0Bg0nqEe39jWQuLOnGT
	 VlbjGuqrBJETA==
Date: Wed, 25 Mar 2026 09:25:05 -0600
From: Tycho Andersen <tycho@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Kishon Vijay Abraham I <kvijayab@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kim Phillips <kim.phillips@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v4 0/7] Move SNP initialization to the CCP driver
Message-ID: <acP-UdjBy06MnBgY@tycho.pizza>
References: <20260324161301.1353976-1-tycho@kernel.org>
 <6A6AA56D-6B4C-4C32-A639-18C14BC0C358@alien8.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6A6AA56D-6B4C-4C32-A639-18C14BC0C358@alien8.de>

On Wed, Mar 25, 2026 at 09:07:42AM +0000, Borislav Petkov wrote:
> Sachiko has some questions:
> 
> https://sashiko.dev/#/patchset/20260324161301.1353976-1-tycho%40kernel.org

Interesting, review-prompts directly didn't complain about these,

> Could this lead to a NULL pointer dereference in clear_rmp() if
> setup_rmptable() fails during early boot?
>
> If setup_rmptable() returns false (for example, if the BIOS did not
> reserve memory for the RMP table), it exits without allocating
> rmp_bookkeeping or rmp_segment_table, but leaves the CC_ATTR_HOST_SEV_SNP
> platform attribute active.

If setup_rmptable() fails, snp_rmptable_init() returns -ENOSYS and
iommu_snp_enable() clears CC_ATTR_HOST_SEV_SNP.
__sev_snp_init_locked() checks CC_ATTR_HOST_SEV_SNP before doing
anything else, so I think this is not possible.

You did complain about this call chain before off-list though, maybe
we should clear CC_ATTR_HOST_SEV_SNP in more places directly vs.
returning an errno to make it more obvious?

> Is there a race condition with CPU hotplug here?
>
> Since snp_prepare() lacks cpus_read_lock() protection, a CPU could
> come online exactly between the two passes, missing the mfd_enable step
> but receiving snp_enable.

I think it makes sense to do the operations on the same set of CPUs
even if we don't support hotplug. I will resend with
cpus_read_lock().

> Additionally, without a CPU hotplug state callback (such as
> cpuhp_setup_state()), any CPUs brought online after snp_prepare()
> completes will miss these MSR configurations completely. If an SNP
> guest is later scheduled on one of these uninitialized CPUs, will it cause
> hardware exceptions?

Yes, WONTFIX.

> Can deferring this call cause a NULL pointer dereference? Previously,
> snp_prepare() was called only after setup_rmptable() succeeded. By
> moving it to the CCP driver, it may be called unconditionally as long
> as CC_ATTR_HOST_SEV_SNP is true, even if setup_rmptable() was skipped
> or failed. Does clear_rmp() inside snp_prepare() safely handle the
> uninitialized rmp_bookkeeping pointer?

Same as above, CC_ATTR_HOST_SEV_SNP should perhaps be cleared in more
places.

> Also, moving snp_prepare() out of early boot might expand the window for
> CPU hotplug events. Does this create an asymmetry where newly onlined
> CPUs miss the MSR_AMD64_SYSCFG_SNP_EN configuration applied by
> on_each_cpu(snp_enable, NULL, 1) because the SEV subsystem lacks a CPU
> hotplug callback? Could this cause host crashes when KVM schedules VMs
> on these uninitialized CPUs?

Same as above, WONTFIX.

> Additionally, does deferring SNP enablement in the hardware coordinate
> with the IOMMU feature degradation? The AMD IOMMU driver evaluates
> amd_iommu_snp_en at early boot and permanently disables identity mapping
> domains and IOMMUv2. Will the system suffer this permanent penalty even
> if the CCP driver is never loaded?

This is about the bios setting:

        amd_iommu_snp_en = check_feature(FEATURE_SNP);
        if (!amd_iommu_snp_en) {
                pr_warn("SNP: IOMMU SNP feature not enabled, SNP cannot be supported.\n");
                goto disable_snp;
        }

so I don't think the question really makes sense.

> Could placing snp_prepare() here cause prolonged blocking of all SEV
> operations? Since __sev_snp_init_locked() holds sev_cmd_mutex, the long
> execution time of clear_rmp() (which zeroes the entire RMP table and scales
> with system RAM) might block SEV firmware ioctls and VM lifecycle operations
> globally for several seconds.

Yes, it does :). Actually the firmware call is the expensive part, not
the rmp zeroing, but it definitely blocks for a while.

> This isn't a bug introduced by this commit, but if SEV initialization
> fails and KVM is actively running normal VMs, could a userspace process
> trigger this code path via /dev/sev ioctls (e.g., SEV_PDH_GEN) and zero out
> MSR_VM_HSAVE_PA globally? Would the next VMRUN execution for an active VM
> trigger a general protection fault and crash the host?

Oof, yes. I wonder if we shouldn't set psp_dead = true if
sev_platform_init() sees an error. After this series, if
the error is e.g. init_ex_path failure, you can unload, fix the
failure, and try again.

>  	if (sev_version_greater_or_equal(SNP_MIN_API_MAJOR, 52)) {
[ ... ]
>  		memset(&data, 0, sizeof(data));
[ ... ]
>  		data.tio_en = tio_supp && sev_tio_enabled && amd_iommu_sev_tio_supported();
[ ... ]
>  	} else {
>  		cmd = SEV_CMD_SNP_INIT;
>  		arg = NULL;
>  	}
> This isn't a bug introduced by this commit, but is the stack variable
> data left uninitialized when taking the else branch? Since data.tio_en is
> later evaluated unconditionally, could stack garbage cause it to evaluate
> to true, leading to erroneous attempts to allocate pages and initialize
> SEV-TIO on unsupported hardware?

No, arg is the actual pointer passed, and it is set to NULL. non-EX
init doesn't support TIO anyway...

> Also, regarding the bounds check in snp_filter_reserved_mem_regions()
> called via walk_iomem_res_desc(): does the check
> if ((range_list->num_elements * 16 + 8) > PAGE_SIZE)
> allow an off-by-one heap buffer overflow?
>
> If range_list->num_elements is 255, 255 * 16 + 8 = 4088, which is <= 4096.
> Writing range->base (8 bytes) fills 4088-4095, but writing range->page_count
> (4 bytes) would write to 4096-4099, overflowing the kzalloc-allocated
> PAGE_SIZE buffer.

Yes, this also looks real, and needs:

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 939fa8aa155c..3642226c0fc0 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1328,10 +1328,11 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
 	size_t size;
 
 	/*
-	 * Ensure the list of HV_FIXED pages that will be passed to firmware
-	 * do not exceed the page-sized argument buffer.
+	 * Ensure the list of HV_FIXED pages including the one we are about to
+	 * use that will be passed to firmware do not exceed the page-sized
+	 * argument buffer.
 	 */
-	if ((range_list->num_elements * sizeof(struct sev_data_range) +
+	if (((range_list->num_elements + 1) * sizeof(struct sev_data_range) +
 	     sizeof(struct sev_data_range_list)) > PAGE_SIZE)
 		return -E2BIG;

I have another bug that review-prompts found unrelated to this series.
I can put the two fixes above with that or include them here, let me
know what you prefer. Either way I'll resend one more with
cpus_read_lock().

Thanks,

Tycho
