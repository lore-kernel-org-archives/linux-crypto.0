Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8204F387362;
	Fri, 22 May 2026 12:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779452994; cv=none; b=Au2n5sMSSoRes09dpVREihRCm0tgLUUW+zgmBsGNLViDo5+brvbaaBm9h1VnnPDm4aMYJiBD4Ick7gxFjnQcAVc1CHln2RBzUHE0YVrC8MZjy6KCF1mp79hm3Lr9J4F8ahlw8B+JkFdxS8A7uf9T/0qYSeTksWsmUqLmwNqpRmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779452994; c=relaxed/simple;
	bh=z2PXmEG907aqqgH8G+P5OKHzraN/Olgf39CggU6920E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OmJZVzYA/s2CEKYmRj697gJloWTpVtni5ZLs5r/70UkZT88jXZAEUvXmO8p+EvF0T2tWRW7tVCHwG5QMHZyD1c88EF6zr7AmPxeVMFAMnh6jkHzok1uMpksMHIJvX7Broo6GWOa/GsjYAY5IRdvP1/N6LCJJEL2S7l6vXBxxk4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=sRcxJxv4; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="sRcxJxv4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=JMNIwSjcR5BSsge2JvlhpcmOwo4duhPrSW6GSGJgda4=; 
	b=sRcxJxv4JMa4ezFJHJ4wi0/Z9VszBgqesm9MHpPkSvn9fpxdonVdW/4hJ8VytA4Yc9zzsj8/jC0
	HtgR9J92d7yySxk2FPfOl6hmRZ2EXgBTUL3q+O0R8/XW1+WNricilMHo7Lv2mhQ/cx7K3E3CzKfBB
	W6linjJ6HIs3BbQ/yVfEIMexWDB5YDuLK5miVgumK+/DEEaduXdXvSEHpYV3jqmozbSPS0764qp3g
	K5rbOdyMb/mf7JAnSRjEwaxttov/TQxfUjKkEwpAIuj7DhH6qbmhurHmx8s4m9q8v+OabzmyIT1tj
	VXIWLOl7cJR3sSaRpNn3r9OlvLwQ1PZKXRUA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wQP0e-00GSMp-2y;
	Fri, 22 May 2026 20:29:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 May 2026 20:29:48 +0800
Date: Fri, 22 May 2026 20:29:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	stable@vger.kernel.org, Ahsan Atta <ahsan.atta@intel.com>
Subject: Re: [PATCH v2] crypto: qat - fix VF2PF work teardown race in
 adf_disable_sriov()
Message-ID: <ahBMPFq4z_rMstv_@gondor.apana.org.au>
References: <20260513144940.8635-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513144940.8635-1-giovanni.cabiddu@intel.com>

On Wed, May 13, 2026 at 03:47:32PM +0100, Giovanni Cabiddu wrote:
> The VF2PF interrupt handler queues PF-side response work that stores a
> raw pointer to per-VF state (struct adf_accel_vf_info). Currently,
> adf_disable_sriov() destroys per-VF mutexes and frees vf_info without
> stopping new VF2PF work or waiting for in-flight workers to complete. A
> concurrently scheduled or already queued worker can then dereference
> freed memory.
> 
> This manifests as a use-after-free when KASAN is enabled:
> 
>   BUG: KASAN: null-ptr-deref in mutex_lock+0x76/0xe0
>   Write of size 8 at addr 0000000000000260 by task kworker/24:2/...
>   Workqueue: qat_pf2vf_resp_wq adf_iov_send_resp [intel_qat]
>   Call Trace:
>     kasan_report+0x119/0x140
>     mutex_lock+0x76/0xe0
>     adf_gen4_pfvf_send+0xd4/0x1f0 [intel_qat]
>     adf_recv_and_handle_vf2pf_msg+0x290/0x360 [intel_qat]
>     adf_iov_send_resp+0x8c/0xe0 [intel_qat]
>     process_one_work+0x6ac/0xfd0
>     worker_thread+0x4dd/0xd30
>     kthread+0x326/0x410
>     ret_from_fork+0x33b/0x670
> 
> Add a PF-local flag, vf2pf_disabled, that gates work queueing, worker
> processing, and interrupt re-enabling during teardown. Set this flag
> atomically with the hardware interrupt mask inside
> adf_disable_all_vf2pf_interrupts(). After masking, synchronize the AE
> cluster MSI-X interrupt and flush the PF response workqueue before
> tearing down per-VF locks and state so all in-flight work completes
> before vf_info is destroyed.
> 
> Introduce adf_enable_all_vf2pf_interrupts() to clear the flag and
> unmask all VF2PF interrupts under the same lock when SR-IOV is
> re-enabled. This ensures the software flag and hardware state transition
> atomically on both the enable and disable paths.
> 
> Cc: stable@vger.kernel.org
> Fixes: ed8ccaef52fa ("crypto: qat - Add support for SRIOV")
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
> ---
> Changes since v1:
> - Reworked the bail-out check in adf_enable_all_vf2pf_interrupts() to
>   compute vf_mask first and check it instead of num_vfs.
> - Removed the unreachable kfree() fallback in adf_schedule_vf2pf_handler().
>   Since pf2vf_resp is freshly allocated and initialized via INIT_WORK(),
>   queue_work() is guaranteed to return true for a work_struct that has
>   never been queued.
> - Replaced '>= 0' with '>0' after pci_irq_vector() to allow only for
>   strictly positive IRQ vectors.
> 
>  .../intel/qat/qat_common/adf_accel_devices.h  |  2 +
>  .../intel/qat/qat_common/adf_common_drv.h     |  2 +
>  drivers/crypto/intel/qat/qat_common/adf_isr.c | 39 +++++++++++++++++++
>  .../crypto/intel/qat/qat_common/adf_sriov.c   | 20 +++++++++-
>  4 files changed, 61 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
