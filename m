Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4674028E8
	for <linux-crypto@vger.kernel.org>; Thu, 24 Sep 2026 21:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790285860; cv=none; b=q4HwOY1HMT0uMvL1Tl+Ysyi6jOizDbo4L5DT8UbZljJ5hiZ/c94hyAlB7LIv3YPDQNRtWos6cdwP+h40LO+KtakQNzb8la83+nC/p6PJVwxb2uyXEJRLS3l2RO7WcUCSsqkeITDQ8IcIcY1iCY6pfCx3Ey5BMBud61mXRHEi35g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790285860; c=relaxed/simple;
	bh=y+jcYIXcNsMdpsEczg5evFFk2pa5hyrYLQD0cpV5aTs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MFH80nKngyNrA+gpuYbVWNmCNMLt+i3PJVuom7/HCuJhC/dRb7F4f0tvms95FA1iUmAWGObhjAYgPhx0Uk/fnIzzLJWfsDZ8hGZvDQfhZKLr1/EadMUP8hdJP76XqgJuD+uGSV/aJPmte3Alz7hxE8pFixbv4yWqDNJPm779pdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--shansinha.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rigL3T+7; arc=none smtp.client-ip=209.85.210.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--shansinha.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rigL3T+7"
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-869b8d63e28so318429b3a.0
        for <linux-crypto@vger.kernel.org>; Thu, 24 Sep 2026 14:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790285859; x=1790890659; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GHqS1F7t3y1uUdOnmT2Sp37qwPIXFrLRYfJOnwkiOhI=;
        b=rigL3T+70Bl5MJr1z8tBic3bUWPRhLZUy1sH1AD3iW4LAvSh2Vt0x0IObI1FTW/4aX
         YPfakgVFsN9ICpJycPD9fhpzHIiblnyTKQKnhyEPVcvGHMaF+j9S5kRRCLuO2sQHSRPB
         aY9APiLsf1jBRrhZ17JbWR5HhbqJ7K3PjJTmRqzIxDCrejMqXHy22sbqOMNgIYPFbAJr
         acwS4vSmGK0kIqh9VBt38Hi0lwR2w7xcCl9VzmvzRaVAaXZXX+PndcF8auC9Or6R3Nb6
         3jBm/LiCCFdAcBVv7xKD4NHGo5P0gaUG79FIN666jZhKeoJMKOfk0x3iR65/xxKDrTng
         C/5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790285859; x=1790890659;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GHqS1F7t3y1uUdOnmT2Sp37qwPIXFrLRYfJOnwkiOhI=;
        b=LK9qMpSqQjGGKajqxWtb8KiR6cbmHvZU9pfBRWP5TgRsJBy7n6Fbmui1gs0uJcwBDh
         0VWeim5zM252+fxXe+9I/jkKr9zTHn0djyNZOrwB1QLRXFY+f1TRWmC5eA3yuLOBLFHR
         j+3jeYrPTNwLIkvra44E0eYl70jauLCVC3Ktf+og7C4rxaXX080wWhMLtXvb7Pi+czAK
         vDyglbq1cDYk9EzKMxebtQMZHawUrAD1nb0dpVHdmOHxvceDctXbhelD+hFW8HN3deGD
         9ewir2bMpt4owy839AQhACjbDH0OnGgUemQsVuF7I0vhmsUOSmUohPjgz4R+LsYUv+K6
         oYNg==
X-Forwarded-Encrypted: i=1; AKwUvBy1jz6CVh4oyWJGT2aa0OjF9WZ7FlrRIUF6jrm3A2rIV90isLKpQOfHF2KrDEITY1pDPQxgpEwEgubhy4A=@vger.kernel.org
X-Gm-Message-State: AFuF++kqXPHPoLkTOHGD1aCv1XYQTD2Pvwqx0BwZ2bJ8XvFIti9bbJZB
	xzUWeF8sZNfIC0G3UUVVXcdy35jw/wNAUKjgdQZ2vkdWCFSb3fx5g4eWjChlb4mArMo+p9Gg8K3
	awfRfAgku6qkzxHQ5sw==
X-Received: from pfbfy11.prod.google.com ([2002:a05:6a00:828b:b0:878:3658:23d3])
 (user=shansinha job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:a583:b0:878:34d7:6a26 with SMTP id d2e1a72fcca58-87e9ba90e5emr3074583b3a.40.1790285858279;
 Thu, 24 Sep 2026 14:37:38 -0700 (PDT)
Date: Thu, 24 Sep 2026 21:37:37 +0000
In-Reply-To: <3463e8ce7b925d8cade35cf9d98b96bc3fc619b4.1789749016.git.prsampat@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1789749016.git.prsampat@amd.com> <3463e8ce7b925d8cade35cf9d98b96bc3fc619b4.1789749016.git.prsampat@amd.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260924213737.3833625-1-shansinha@google.com>
Subject: Re: [Patch v2 7/7] crypto/ccp: Implement SNP Download Firmware EX
From: Shantanu Sinha <shansinha@google.com>
To: prsampat@amd.com
Cc: aik@amd.com, ashish.kalra@amd.com, chao.gao@intel.com, dakr@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, mcgrof@kernel.org, 
	michael.roth@amd.com, nikunj@amd.com, rafael@kernel.org, 
	russ.weight@linux.dev, shansinha@google.com, thomas.lendacky@amd.com, 
	tycho@kernel.org
Content-Type: text/plain; charset="UTF-8"

> +static enum fw_upload_err sev_fw_upload_handle_err(struct sev_device *sev,
> +						   int rc, int psp_ret)
> +{
> +	enum fw_upload_err ret = FW_UPLOAD_ERR_FW_INVALID;
> +
> +	if (!rc)
> +		return FW_UPLOAD_ERR_NONE;
> +
> +	switch (psp_ret) {
[...]
> +	case SEV_RET_UPDATE_FAILED:
> +		ret = FW_UPLOAD_ERR_HW_ERROR;
> +		dev_err(sev->dev, "DLFW_EX: Upgrade failed, automatically reverted\n");
> +		break;
> +	case SEV_RET_RESTORE_REQUIRED:
> +		dev_err(sev->dev, "DLFW_EX: live upgrade failed, please roll back\n");
> +		/*
> +		 * Firmware requested a roll-back. Declare the PSP dead so
> +		 * nothing else tries to use it, and let the next upload through
> +		 * so the admin can restore the previous image.
> +		 */
> +		sev->fwl_rollback_required = true;
> +		psp_dead = true;
> +		ret = FW_UPLOAD_ERR_HW_ERROR;
> +		break;
> +	case SEV_RET_HWSEV_RET_UNSAFE:
> +		dev_err(sev->dev, "DLFW_EX: SEV firmware no longer safe. Reboot recommended\n");
> +		/*
> +		 * Following a return of HARDWARE_UNSAFE, operation of the SEV
> +		 * firmware is indeterminate and the recommendation is to reboot
> +		 * the platform. Declare the PSP dead so the driver stops
> +		 * issuing commands to it while the reboot is pending.
> +		 */
> +		psp_dead = true;
> +		ret = FW_UPLOAD_ERR_HW_ERROR;
> +		break;
> +	case SEV_RET_NO_FW_CALL:
> +		/* The command never reached the firmware. */
> +		dev_err(sev->dev, "DLFW_EX: driver error %d\n", rc);
> +		ret = FW_UPLOAD_ERR_HW_ERROR;
> +		break;
> +	default:
> +		dev_err(sev->dev, "Unknown SEV firmware err 0x%x\n", psp_ret);
> +		ret = FW_UPLOAD_ERR_HW_ERROR;
> +		break;
> +	}
> +
> +	return ret;
> +}

I've been trying to work this patch into our current workflow and
running into a slight issue. My goal is to cleanly distinguish 
between the following failure outcomes and their associated actions:

1. Rollback to the old (committed) firmware: SEV_RET_RESTORE_REQUIRED
   (0x25), where the PSP did not auto-revert (psp_dead == true &&
   fwl_rollback_required == true) and will only accept a
   DOWNLOAD_FIRMWARE_EX upload of the CommittedVersion binary to recover
   the host without a reboot.
2. Retry the update: device busy / legacy SEV guest active
   (SEV_STATE_WORKING), driver-side -ENOMEM (SEV_RET_NO_FW_CALL), or
   SEV_RET_UPDATE_FAILED (0x24), where the PSP either auto-reverted or
   was never modified (psp_dead == false) and remains healthy on the
   previous firmware.
3. Abandon the update due to a fundamental image or precondition error:
   bad signature, malformed image, version/SVN check failure, or
   SHUTDOWN_REQUIRED, where the PSP rejected the command up front and
   neither retrying nor rebooting will help.
4. Reboot the host: SEV_RET_HWSEV_RET_UNSAFE (0x14) where the PSP is
   permanently disabled until a system reset.

Right now, the same user-facing error in /sys/class/firmware/sev/error
(FW_UPLOAD_ERR_HW_ERROR / "transferring:hw-error") is returned across
states 1, 2, and 4 above (SEV_RET_RESTORE_REQUIRED,
SEV_RET_UPDATE_FAILED, -ENOMEM, and SEV_RET_HWSEV_RET_UNSAFE). Because
psp_ret is only logged via dev_dbg() in __sev_do_cmd_locked(), userspace
tooling only sees "transferring:hw-error" in sysfs and has no clean way
to tell whether to roll back to the committed image, retry, or reboot
the machine without scraping English strings out of dmesg, which has
been finicky.

Could we do a closer review of the error reporting here and potentially
include (rc, psp_ret) (matching the "failed %d, error %#x" format
already used in sev_fw_upload_shutdown_platform() and
sev_fw_upload_reinit_platform() below) in every dev_err() output so the
exact driver return code and PSP status code are always visible in
dmesg?

Alternatively (or alongside that), we could also separate the enum
fw_upload_err buckets so those four outcomes map to distinct sysfs
errors:

- Keep FW_UPLOAD_ERR_HW_ERROR for fatal states where the PSP is dead
  until a host reboot (SEV_RET_HWSEV_RET_UNSAFE, or when psp_dead is
  already latched).
- Use FW_UPLOAD_ERR_RW_ERROR for SEV_RET_RESTORE_REQUIRED (where writing
  the committed firmware image recovers the PSP without a reboot).
- Use FW_UPLOAD_ERR_BUSY for retryable states where the PSP is still
  running the previous firmware (SEV_RET_UPDATE_FAILED and -ENOMEM,
  alongside SEV_STATE_WORKING).
- Keep FW_UPLOAD_ERR_FW_INVALID (and FW_UPLOAD_ERR_INVALID_SIZE) for
  permanent image/version rejections where the update should be
  abandoned, and add case SEV_RET_BAD_SVN: alongside
  SEV_RET_INVALID_CONFIG so an SVN check failure returns
  FW_UPLOAD_ERR_FW_INVALID instead of falling into default
  (FW_UPLOAD_ERR_HW_ERROR).

As a side note, I think -ETIMEDOUT is not handled properly. When a
command times out in __sev_do_cmd_locked(), it zeroes *psp_ret = 0, sets
psp_dead = true, and returns -ETIMEDOUT. Because
sev_fw_upload_handle_err() only checks !rc before switch (psp_ret), a
timeout falls into the default case, prints "Unknown SEV firmware err
0x0", and returns FW_UPLOAD_ERR_HW_ERROR instead of
FW_UPLOAD_ERR_TIMEOUT.
