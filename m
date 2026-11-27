Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795756109;
	b=pDAS9tuSJfyD2B7CKZVvuSyNALXpS0Ey7frr/w+s/gE2G+S541bRZEMv5GnWbJ8cX4ou
	 9mWLhrjjGvffMrubHamMwp7A82mnhcX+xSjoGcOezZZ9ZfIwlgjjyItCr7eiVy6KE4xz/
	 jiQSuovyhxd8JMI4dsd66KbXZts4wqGXFJs24bowUPW/Lcyh2oNAyECKBLn6rTdfnlBAe
	 mfvjwck250uBAz2baSeWIzZ41H6fP/6d6BvhBUblfc8SR4u1+GEfQEHqxlPvB0MC2Qsod
	 eZTbfr5c89lFeN5X8Zji+kRRQjRm0kuWEwsggpfcnhYB+XTGZkoUdAu9ByH7f6m/aEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795756109;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=UKR5FaDeokUtzqpD6yvK+6cnIUfybqlAH/9fh9CVSIs=;
	b=xiR09YrXFSyJY7iZ0oqoQfCIMFy6SzWRlihxs21SdXEBl6/T2cWOMUV/LzqBWyDhYSJW
	 31gzWTLDnrN+cGIjiLhPI+601mFeJgtqIhVIsW6BzfW2sMP70Oa4I7ln2uGBLg9vCR7n3
	 9uwkjKnBZzeaF/768SRn7/1qd3n13HeNgL8xUtNVJoNLyvvwwae0Fdd1b+s/KsASSYpAK
	 GHhXJRb3zzauvwfCxuQpMIDKS5yU0xZ/CQaoOtninMGHNKuDRMYrSSMCFjNO3v2eh6hQg
	 dbogSV15wzAwyY08QxUvQ4vGuNpcwY+IunL9s80OxZCGruvhgbmOwrd8EeZN2L4xJvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=cveQXNjG;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A14B606A31C;
	Fri, 27 Nov 2026 05:08:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A14B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=cveQXNjG
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=UKR5FaDeokUtzqpD6yvK+6cnIUfybqlAH/9fh9CVSIs=; 
	b=cveQXNjGlW9sKbl8G/O1LrJFlFqXbrpgZFAXhpZPO2DeabLdiVyXKjlBXLlpfdIMlqFargGxRW/
	nzCDoc7P/gPELWKyPIKKbBjjq/iHEDyZNCMQoJCyvIRveTC8O13YnJu1dKPayXppyQMmclAFvZhrT
	tMyI7l2OyHsFaH+n9ojhu9Ub/El8hrUze4IKReOLNL3mSikPmIJqKMJo7MKIl+M/YY1XwieT4+Ht5
	qSPCmAjwvPOklOfWzxfJA0mSeVhNSiKnULuOVe2H+KIsq7/18xvk/L0O4Q1fFZkernvB+/64xNWAv
	fgL+SbesWn1w0f9Y8SxpcEBfRP+eD/NOjXYw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xWoC6-00000002VRj-14yk;
	Fri, 27 Nov 2026 13:08:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Nov 2026 13:08:22 +0800
Date: Fri, 27 Nov 2026 13:08:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: mcgrof@kernel.org, russ.weight@linux.dev, dakr@kernel.org,
	ashish.kalra@amd.com, thomas.lendacky@amd.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	gregkh@linuxfoundation.org, rafael@kernel.org, chao.gao@intel.com,
	aik@amd.com, tycho@kernel.org, nikunj@amd.com, michael.roth@amd.com,
	shansinha@google.com
Subject: Re: [Patch v6 0/7] Implement SNP live firmware update support
Message-ID: <awkQRptZv79Gsurn@gondor.apana.org.au>
References: <cover.1794531772.git.prsampat@amd.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1794531772.git.prsampat@amd.com>

On Fri, Nov 13, 2026 at 05:31:53PM +0000, Pratik R. Sampat wrote:
> Introducing support for live update on AMD SEV-SNP platforms via
> DOWNLOAD_FIRMWARE_EX.
> 
> This patchset is an extension of the RFC patchset from Tycho
> Andersen.
> 
> This series also fronts firmware_loader patches from Dan Williams[1]
> which majorly cleans up refcount issues so that registering the upload
> interface no longer pins the module. Without which having live firmware
> update will cause failure to reload the ccp module as well as break
> kexec.
> 
> Patches based on cryptodev-2.6
> 
> v6:
> * Since "crypto: ccp - Make usage of sev_cmd_mutex more granular" is
>   merged, __sev_do_snp_platform_status() takes sev_cmd_mutex itself, so
>   calling it from snp_get_platform_data() with the mutex held would
>   deadlock. Instead, stage the SNP_PLATFORM_STATUS output through a page
>   from __snp_alloc_firmware_pages() and issue the command directly, the
>   same way as SNP_FEATURE_INFO.
> * Refresh the cached platform data before re-initializing the legacy
>   platform, under the same hold of sev_cmd_mutex as the update
>   itself - Sashiko
>   This ensures that:
>     * __sev_platform_init_locked() logs the new firmware version rather
>       than the stale pre-update one.
>     * There is no unlocked window in which concurrent callers can see
>       stale platform data, or in which a legacy guest launch can move
>       the platform to WORKING before the refresh caches that state,
>       which would make every later legacy SEV INIT fail.
> 
> v5: https://lore.kernel.org/linux-crypto/cover.1792599491.git.prsampat@amd.com/
> * Collected reviewed-by tags
> * Keep the original firmware error when rollback fails - Tycho, Shantanu
> 
> Responding to Sashiko comments:
> * Does __snp_alloc_firmware_pages leak the allocated page on error?
>    - This isn't a transient firmware error. rmp_mark_pages_firmware()
>      issues RMPUPDATE, and a failure there indicates an inconsistent
>      RMP. Any pages already converted are reclaimed or placed on the
>      SNP leaked pages list, so not freeing is the conservative choice
>      and used by all the other callers.
> 
> * Can reading *feat_info here trigger a host crash?:
>   - No.  Reclaim is only needed before the page is written by the host or
>   returned to the allocator, which __snp_free_firmware_pages() takes care
>   of after the read. tio_status page reading does the same
> 
> v4: https://lore.kernel.org/linux-crypto/cover.1792014060.git.prsampat@amd.com/
> * Collected reviewed-by tags
> * Cleanup snp_alloc_firmware_pages() error handing - Tom
> * Cleanups to comments and code formatting - Tom
> * Change dev prints to ratelimited - Tom
> * Add comment about releasing sev_release_firmware_buffers() - Tom
> * Add FW_UPLOAD and FW_LOADER to CRYPTO_DEV_SP_PSP config and clean
>   up #ifdef-erry - Shantanu
> * On failure of sev_get_api_version() return an error only if PSP
>   failed in all other cases DLFW_EX succeeded - Shantanu
> * Free TMR if we were already in UNINIT too - Local Sashiko instance
> 
> Responding to Sashiko review:
> * Possible RMP violation when live fireware update races with
>   snp_get_platform_data()
>   - Both the dlfw_ex and snp_get_platform_data() are called within a
>     mutex guard so feat_info can only be accessed once it is no longer
>     in the firmware owned state and the mutex is dropped.
> * Register-unregister failure
>   - The ccp PCI driver probes synchronously, so psp_master is set
>     before sev_pci_init() runs. The uploader follows the same lifecycle
>     as the rest of the SEV/SNP initialization, including the TSM and
>     verify-mitigation interfaces. The unregister in sev_dev_destroy()
>     is needed so the upload device doesn't outlive sev.
> 
> v3: https://lore.kernel.org/linux-crypto/cover.1791212077.git.prsampat@amd.com/
> * Print psp return codes along with driver returns for easier
>   parsing - Shantanu
> * Clean up error codes to map the right firmware/driver error condition
>   to the firmware error codes. - Shantanu
> * Report -ETIMEOUT case by checking for psp_dead after DLFW_EX command
>   is called instead of reporting unknown error - Shantanu
> * __sev_do_snp_platform_status() call can race and incorrect cached platform
>   states may be supplied. Guard the call under a mutex - Sashiko
> * firmware unregister can race when called from sev_dev_destroy() or
>   sev_pci_exit(). Guard the call under a mutex - Sashiko
> 
> v2: https://lore.kernel.org/lkml/cover.1789749016.git.prsampat@amd.com/
> * In snp_get_platform_data() use snp_[alloc|free]_firmware_page() to
>   transition pages to and from firmware-owned state, instead of
>   open-coding rmp_mark_pages_firmware()/snp_reclaim_pages() around the
>   SNP_FEATURE_INFO command - Tom, Sashiko
> * Claim sev->fwl atomically with xchg() in unregister_sev_fw_uploader()
>   so a concurrent module removal and sysfs unbind cannot both reach
>   firmware_upload_unregister() - Sashiko
> 
> Responding to other Sashiko comments:
> * __sev_release_firmware_buffers() called with panic=true can cause
>   deadlock as another stopped CPU might currently hold zone->lock or
>   other page allocator locks.
>         - I think having a panic param within __snp_free_firmware_pages
>           which checks and returns before __free_pages() should resolve
>           this issue. Since this is a pre-existing issue not relevant
>           to this patchset, plan to send this as a seperate patch
> * The sev_download_firmware_ex() function is called with the lock held
>   and performs a GFP_KERNEL allocation.  Since GFP_KERNEL can trigger
>   direct memory reclaim, could this invoke SEV page reclaim operations
>   that attempt to acquire the already-held sev_cmd_mutex, resulting in
>   a deadlocked state?
>         - GFP_KERNEL may perform direct MM reclaim, but SNP page
>           reclamation is not registered as an MM shrinker or normal
>           page-reclaim callback. snp_reclaim_pages() acquires
>           sev_cmd_mutex only when explicitly called with locked=false
> * "If snp_reclaim_cmd_buf() fails and returns early, the code skips
>   resetting sev->cmd_buf_active and sev->cmd_buf_backup_active.
>   Will this permanently leak the bounce buffer slots and result in
>   future -EBUSY failures?"
>         - Since the command buffer may still be firmware owned, I think
>           declaring psp_dead = true is the way to ensure we do not make
>           it available for reuse after a failed reclaim. Pre-existing
>           issue, plan to send this as a seperate patch
> 
> v1: https://lore.kernel.org/linux-crypto/cover.1789059391.git.prsampat@amd.com/
>  * firmware-loader patches are rebased as-is and only incorporates
>    fixes for minor build issues
>  * Dropped crypto/ccp: Hoist kernel part of SNP_PLATFORM_STATUS as that
>    patch has been merged since
>  * Dropped crypto/ccp: Reclaim command buffer when the PSP dies and
>    subsequent handling since firmware quirk is now resolved and need not be
>    handled in the OS
>  * Use guard(mutex) for the locked region, which the split makes
>    possible since sev_get_api_version() acquires sev_cmd_mutex - Maxwell
>  * Added a patch factoring out the TMR and INIT_EX teardown, so the update
>    path and __sev_firmware_shutdown() share it - Shantanu
>  * Skip the re-init when the PSP is dead, not just when a rollback is
>    outstanding - Shantanu
>  * Re-initialize the platform before refreshing the cached status -
>    Shantanu
>  * Split the monolithic .write into a locked update helper, an error
>    translation helper, and a thin .write that refreshes the cached status
>    once the lock is dropped and clean up various allocations
>  * Convert rollback required and reinit required globals to reside in
>    sev_dev struct to avoid carrying over states if manually reloaded
> 
> RFC: https://lore.kernel.org/all/20260430160716.1120553-1-tycho@kernel.org/
> 
> [1]: https://lore.kernel.org/lkml/20260331214726.903274-2-dan.j.williams@intel.com/
> 
> Dan Williams (3):
>   firmware_loader: Stop pinning modules on registration
>   firmware_loader: Stop pinning parent device per workqueue invocation
>   treewide: firmware_loader: Drop the unused @module argument
> 
> Pratik R. Sampat (4):
>   crypto: ccp - Factor out the release of the SEV firmware buffers
>   crypto: ccp - Allow SNP platform data to be queried after SNP INIT
>   crypto: ccp - Register with fw_uploader and always fail
>   crypto: ccp - Implement SNP Download Firmware EX
> 
>  .../driver-api/firmware/fw_upload.rst         |   2 +-
>  drivers/base/firmware_loader/sysfs_upload.c   |  50 +-
>  drivers/base/firmware_loader/sysfs_upload.h   |   1 -
>  drivers/crypto/ccp/Kconfig                    |   2 +
>  drivers/crypto/ccp/sev-dev.c                  | 454 ++++++++++++++++--
>  drivers/crypto/ccp/sev-dev.h                  |   4 +
>  drivers/cxl/core/memdev.c                     |   4 +-
>  drivers/firmware/microchip/mpfs-auto-update.c |   2 +-
>  drivers/fpga/intel-m10-bmc-sec-update.c       |   4 +-
>  drivers/greybus/gb-beagleplay.c               |   2 +-
>  drivers/iio/frequency/ad9910.c                |   2 +-
>  drivers/media/i2c/thp7312.c                   |   2 +-
>  drivers/net/pse-pd/pd692x0.c                  |   4 +-
>  drivers/virt/coco/tdx-host/tdx-host.c         |   4 +-
>  include/linux/firmware.h                      |  15 +-
>  include/linux/psp-sev.h                       |  19 +
>  lib/test_firmware.c                           |   3 +-
>  17 files changed, 482 insertions(+), 92 deletions(-)
> 
> -- 
> 2.43.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
