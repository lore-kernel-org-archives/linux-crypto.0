Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B805581E8;
	Thu, 15 Oct 2026 19:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792093089; cv=none; b=aZirQG2KR99qO2Vf6RcYTbdSAyL4zZidIGIsJ/pbC7UaLnWzZioMRKFtSLYIEJub7colg81IgOVid/lIooFW7cDERfvBk5B2Wx8NjGmDdkCcJcSU2uzloS8D/VtWqbbLyRffg96RLj3QzLISmVHOpxHNAkVEwC6FQAXYS95k21U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792093089; c=relaxed/simple;
	bh=c5h3wczMNCh936y2iGbQJ6+ioFXXwrnvB0nc/8VJQh8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sCWY7GBDZ9XXkD8lyE/A5J3JBl9/+6T0eFyTshyEEkhCOxrgn/YO82jmwyl/A5lMg2D7vSi8jUwqExyuZ/Hsw1E4uYbRQQX4HuksTfdxHv45ahNY4BYV9G/5Ri5PIHBUTzqo9DOZ+gFWAqBt3jPKmFtlaxF5iC8oRP8IR9+CqQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HTsQh0xs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HTsQh0xs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60CF1F000C4;
	Thu, 15 Oct 2026 19:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792093087;
	bh=ktHamms1PZ3sH7AhbC9zmSU27z/kVmWRHXgIXRPL5/0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HTsQh0xs4AeBk/FICm+aCABoHspVLMidcXogEDA+TCFRDMqPCCnpPHtwJwcdLkz4u
	 QyNqW7d1l8HjyzhG6K+jDCIt2iHwu6G2dt1lAZmLBK8BhYZeGWf/Ay5kC9V48shjB7
	 o3aHpyGPv5XuGcSmP7o8BS9OvA5GzolCl3XWqzLYYHUvuq5vFmV7IS2MifTtrjeqv4
	 aunLqSjqAjOwQ035Fgrd6N0uy+SqR6hOhiTwNaZGgwsfZgew5P5Fz5/g2J5m1kgOgT
	 MIIeWUfDpTMAAxddQ5Krts77OTMqZuQkj51/1IFmmTGjO128yEP9hmWfgwYn8RqTKs
	 06lxb6FRQT3FQ==
Date: Thu, 15 Oct 2026 13:38:04 -0600
From: Tycho Andersen <tycho@kernel.org>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: mcgrof@kernel.org, russ.weight@linux.dev, dakr@kernel.org, 
	ashish.kalra@amd.com, thomas.lendacky@amd.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	gregkh@linuxfoundation.org, rafael@kernel.org, chao.gao@intel.com, aik@amd.com, 
	nikunj@amd.com, michael.roth@amd.com, shansinha@google.com
Subject: Re: [Patch v4 7/7] crypto/ccp: Implement SNP Download Firmware EX
Message-ID: <atElnAcDQFTnmdVr@tycho.pizza>
References: <cover.1792014060.git.prsampat@amd.com>
 <55c189e9130a7d22c0b756440f10a056415404e5.1792014060.git.prsampat@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55c189e9130a7d22c0b756440f10a056415404e5.1792014060.git.prsampat@amd.com>

Hi Pratik,

Two small comments if you happen to respin this one, no worries if
not.

On Thu, Oct 15, 2026 at 02:14:09AM +0000, Pratik R. Sampat wrote:
> +static int sev_download_firmware_ex(const u8 *data, u32 size, int *psp_ret)
> +{
> +	struct sev_data_download_firmware_ex sev_data = {0};
> +	int ret, order;
> +	struct page *p;
> +	void *fw_blob;
> +
> +	order = get_order(size);
> +	p = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
> +	if (!p)
> +		return -ENOMEM;
> +
> +	fw_blob = page_address(p);
> +	memcpy(fw_blob, data, size);
> +
> +	sev_data.len = sizeof(sev_data);
> +	sev_data.fw_paddr = __psp_pa(fw_blob);
> +	sev_data.fw_len = size;
> +	/*
> +	 * Don't commit the new firmware, an explicit SNP_COMMIT is required
> +	 * after update.
> +	 */
> +	sev_data.commit = 0;
> +
> +	ret = __sev_do_cmd_locked(SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX, &sev_data, psp_ret);

I guess this function could use a lockdep_assert_held(&sev_cmd_mutex),
but maybe we should not do that and instead put it in
__sev_do_cmd_locked()...

> +static enum fw_upload_err sev_fw_upload_update(struct sev_device *sev,
> +					       const u8 *data, u32 size,
> +					       u32 *written)
> +{
> +	int cmd_ret, psp_ret = SEV_RET_NO_FW_CALL;
> +	enum fw_upload_err fwl_ret;
> +
> +	guard(mutex)(&sev_cmd_mutex);
> +
> +	/*
> +	 * SEV firmware will only successfully execute the DLFW_EX command if a
> +	 * firmware rollback is required. Other commands may be processed, but
> +	 * may not execute properly. Use the psp_dead boolean to restrict
> +	 * execution to this path.
> +	 */
> +	if (psp_dead && !sev->fwl_rollback_required) {
> +		dev_err_ratelimited(sev->dev, "DLFW_EX: PSP is not responding\n");
> +		return FW_UPLOAD_ERR_HW_ERROR;
> +	}
> +
> +	/*
> +	 * If the last firmware update returned RESTORE_REQUIRED, retry DLFW_EX.
> +	 * Being in this state means that the legacy firmware has previously
> +	 * been shut down, so no need to do it again.
> +	 */
> +	if (sev->fwl_rollback_required) {
> +		psp_dead = false;
> +	} else {
> +		cmd_ret = sev_fw_upload_shutdown_platform(sev);
> +		if (cmd_ret)
> +			return psp_dead ? FW_UPLOAD_ERR_HW_ERROR : FW_UPLOAD_ERR_BUSY;
> +	}
> +
> +	cmd_ret = sev_download_firmware_ex(data, size, &psp_ret);
> +	fwl_ret = sev_fw_upload_handle_err(sev, cmd_ret, psp_ret);
> +	if (fwl_ret == FW_UPLOAD_ERR_NONE) {
> +		*written = size;
> +		sev->fwl_rollback_required = false;
> +	}
> +
> +	/*
> +	 * Firmware either just requested a rollback or a rollback attempt
> +	 * failed. Keep the PSP dead for all other commands, only another
> +	 * DLFW_EX attempt is allowed through.
> +	 */
> +	if (sev->fwl_rollback_required) {
> +		psp_dead = true;
> +		if (fwl_ret != FW_UPLOAD_ERR_HW_ERROR)
> +			fwl_ret = FW_UPLOAD_ERR_RW_ERROR;

I think this error switcharoo could use a comment (or maybe just be
dropped?). e.g. if the user does something to set
->fwl_rollback_required and then tries another firmware upload that is
the wrong size, ERR_INVALID_SIZE -> ERR_RW_ERROR, which seems
misleading to me.

I saw some discussion about all this:
https://lore.kernel.org/lkml/20260924213737.3833625-1-shansinha@google.com/

but it's not clear to me why you need to reset the error code here.

Thanks,

Tycho
