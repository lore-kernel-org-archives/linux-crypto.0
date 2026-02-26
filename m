Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2214835DCE3;
	Thu, 26 Feb 2026 14:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772115193; cv=none; b=YxJLuUHRBgrIiUOBbNVsYQ2wn5CbzLM8VgSqfUHfmTJ7MthF439I62u2vy+2B14mXyDepzkw9ajg3m8P3UIcisd08DgqHpJw325Riu8JckRcqOv/S+t0xj6h7vM3DCm5Br/P9ZNTTpdhNLenCjhKBna3sw0coXlSHOcZJKhT5+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772115193; c=relaxed/simple;
	bh=N5/QKsWZbsr4w598jQ56Ld6v9RY+C417xqu4x5xdLQM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bJKSmJ4Kb50oq5RfJYF6ZuVIxdyeQfGlupEzzmqqNNDNpgUByZwUO/qSYlEyQPbZVpsinfSVQC8tM4I5ARFj1yjanSgvX9XptnR42mRx3/MwuGhtE9GwSP5cww4YottaJeQK/DVXPpKDUpiyxRj7p+QlcQhr6dQyHkNFRBpxQQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uKW60KEq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uKW60KEq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7572EC116C6;
	Thu, 26 Feb 2026 14:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772115192;
	bh=N5/QKsWZbsr4w598jQ56Ld6v9RY+C417xqu4x5xdLQM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uKW60KEqNhiHAIq10IXrgV0I3CoYcb87PeEF4BKvZhL1FtMmsGmyBLVi+EAopz9Fu
	 H5vHpj6/Sy09tpigOKvOhqDsKo+8jxmPnMUs7WCzbK5wCUvCy5YSl1bRK6FtmcFNjg
	 l61NVb7zB7ziL8QDcBivHoqVw3vsuLki2z55HT4zjbLOEpyyWrvOSRXCujBbc9bVQV
	 uma2uNoMZzWRsRgBXL4OZQqF+aHn8xx7zV2oMEkFLzFNRslRx9xQr5gT9u/8wAOQqb
	 zwpu5nxMPqnIp8f+XtwJGQNrKMMmsbHM1gm4TL3kngeH+oQ92h0jrqOEqwc4pFcbXk
	 +/aSvXgbFe0+Q==
Date: Thu, 26 Feb 2026 14:13:04 +0000
From: Lee Jones <lee@kernel.org>
To: Yousef El Bouzidi <elbouzidyyousef@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
	rafael@kernel.org, dakr@kernel.org, tglx@kernel.org,
	herbert@gondor.apana.org.au, davem@davemloft.net, hansg@kernel.org,
	ilpo.jarvinen@linux.intel.com, ansuelsmth@gmail.com,
	atenart@kernel.org, wens@kernel.org, hauke@hauke-m.de,
	andrew+netdev@lunn.ch, kuba@kernel.org, david.e.box@linux.intel.com,
	akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
	hca@linux.ibm.com, driver-core@lists.linux.dev,
	linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH] treewide: fix duplicated word "the" in comments
Message-ID: <20260226141304.GE8023@google.com>
References: <20260224065300.454633-1-elbouzidyyousef@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260224065300.454633-1-elbouzidyyousef@gmail.com>

On Tue, 24 Feb 2026, Yousef El Bouzidi wrote:

> Remove duplicated word "the" from comments across various subsystems.
> All instances are clear typos where "the" appeared twice in
> succession, often merged with the following word (e.g. "the they",
> "the there", "the these", "the them").
> 
> Files fixed:
>   - drivers/base/platform.c
>   - drivers/crypto/inside-secure/eip93/eip93-hash.c
>   - drivers/mfd/axp20x.c
>   - drivers/net/ethernet/lantiq_xrx200.c
>   - drivers/platform/x86/intel/chtwc_int33fe.c
>   - drivers/platform/x86/intel/pmt/class.c
>   - drivers/s390/crypto/vfio_ap_ops.c
>   - kernel/irq/migration.c
> 
> Signed-off-by: Yousef El Bouzidi <elbouzidyyousef@gmail.com>
> ---
>  drivers/base/platform.c                         | 2 +-
>  drivers/crypto/inside-secure/eip93/eip93-hash.c | 2 +-

>  drivers/mfd/axp20x.c                            | 2 +-

Acked-by: Lee Jones <lee@kernel.org>

>  drivers/net/ethernet/lantiq_xrx200.c            | 2 +-
>  drivers/platform/x86/intel/chtwc_int33fe.c      | 2 +-
>  drivers/platform/x86/intel/pmt/class.c          | 2 +-
>  drivers/s390/crypto/vfio_ap_ops.c               | 2 +-
>  kernel/irq/migration.c                          | 2 +-
>  8 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index b45d41b018ca..3e3b6fcfa194 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -565,7 +565,7 @@ struct platform_object {
>  };
>  
>  /*
> - * Set up default DMA mask for platform devices if the they weren't
> + * Set up default DMA mask for platform devices if they weren't
>   * previously set by the architecture / DT.
>   */
>  static void setup_pdev_dma_masks(struct platform_device *pdev)
> diff --git a/drivers/crypto/inside-secure/eip93/eip93-hash.c b/drivers/crypto/inside-secure/eip93/eip93-hash.c
> index 2705855475b2..d91a1ac152f0 100644
> --- a/drivers/crypto/inside-secure/eip93/eip93-hash.c
> +++ b/drivers/crypto/inside-secure/eip93/eip93-hash.c
> @@ -432,7 +432,7 @@ static int eip93_hash_update(struct ahash_request *req)
>  
>  /*
>   * With map_data true, we map the sa_record and sa_state. This is needed
> - * for finup() as the they are mapped before calling update()
> + * for finup() as they are mapped before calling update()
>   */
>  static int __eip93_hash_final(struct ahash_request *req, bool map_dma)
>  {
> diff --git a/drivers/mfd/axp20x.c b/drivers/mfd/axp20x.c
> index 679364189ea5..0c6e93eb3955 100644
> --- a/drivers/mfd/axp20x.c
> +++ b/drivers/mfd/axp20x.c
> @@ -1417,7 +1417,7 @@ int axp20x_device_probe(struct axp20x_dev *axp20x)
>  	 * 1 bit customizable at the factory, and 1 bit depending on the
>  	 * state of an external pin. The latter is writable. The device
>  	 * will only respond to operations to its other registers when
> -	 * the these device addressing bits (in the upper 4 bits of the
> +	 * these device addressing bits (in the upper 4 bits of the
>  	 * registers) match.
>  	 *
>  	 * By default we support an AXP806 chained to an AXP809 in slave
> diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
> index b8766fb7a844..dde651d901c8 100644
> --- a/drivers/net/ethernet/lantiq_xrx200.c
> +++ b/drivers/net/ethernet/lantiq_xrx200.c
> @@ -157,7 +157,7 @@ static int xrx200_open(struct net_device *net_dev)
>  	/* The boot loader does not always deactivate the receiving of frames
>  	 * on the ports and then some packets queue up in the PPE buffers.
>  	 * They already passed the PMAC so they do not have the tags
> -	 * configured here. Read the these packets here and drop them.
> +	 * configured here. Read these packets here and drop them.
>  	 * The HW should have written them into memory after 10us
>  	 */
>  	usleep_range(20, 40);
> diff --git a/drivers/platform/x86/intel/chtwc_int33fe.c b/drivers/platform/x86/intel/chtwc_int33fe.c
> index d183aa53c318..1fca9fdd8f5b 100644
> --- a/drivers/platform/x86/intel/chtwc_int33fe.c
> +++ b/drivers/platform/x86/intel/chtwc_int33fe.c
> @@ -14,7 +14,7 @@
>   *
>   * So this driver is a stub / pseudo driver whose only purpose is to
>   * instantiate I²C clients for chips 2 - 4, so that standard I²C drivers
> - * for these chips can bind to the them.
> + * for these chips can bind to them.
>   */
>  
>  #include <linux/dmi.h>
> diff --git a/drivers/platform/x86/intel/pmt/class.c b/drivers/platform/x86/intel/pmt/class.c
> index be3c8d9e4fff..99bf7e0afdf1 100644
> --- a/drivers/platform/x86/intel/pmt/class.c
> +++ b/drivers/platform/x86/intel/pmt/class.c
> @@ -239,7 +239,7 @@ static int intel_pmt_populate_entry(struct intel_pmt_entry *entry,
>  
>  		/*
>  		 * Some hardware use a different calculation for the base address
> -		 * when access_type == ACCESS_LOCAL. On the these systems
> +		 * when access_type == ACCESS_LOCAL. On these systems
>  		 * ACCESS_LOCAL refers to an address in the same BAR as the
>  		 * header but at a fixed offset. But as the header address was
>  		 * supplied to the driver, we don't know which BAR it was in.
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 44b3a1dcc1b3..334aaa2d97b2 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -610,7 +610,7 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
>  	matrix_mdev = container_of(vcpu->kvm->arch.crypto.pqap_hook,
>  				   struct ap_matrix_mdev, pqap_hook);
>  
> -	/* If the there is no guest using the mdev, there is nothing to do */
> +	/* If there is no guest using the mdev, there is nothing to do */
>  	if (!matrix_mdev->kvm) {
>  		vfio_ap_le_guid_to_be_uuid(&matrix_mdev->mdev->uuid, uuid);
>  		VFIO_AP_DBF_WARN("%s: mdev %08lx-%04lx-%04lx-%04lx-%04lx%08lx not in use: apqn=0x%04x\n",
> diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
> index f2b2929986ff..b29d13baee55 100644
> --- a/kernel/irq/migration.c
> +++ b/kernel/irq/migration.c
> @@ -89,7 +89,7 @@ void irq_move_masked_irq(struct irq_data *idata)
>  
>  		ret = irq_do_set_affinity(data, desc->pending_mask, false);
>  		/*
> -		 * If the there is a cleanup pending in the underlying
> +		 * If there is a cleanup pending in the underlying
>  		 * vector management, reschedule the move for the next
>  		 * interrupt. Leave desc->pending_mask intact.
>  		 */
> -- 
> 2.43.0
> 

-- 
Lee Jones [李琼斯]
