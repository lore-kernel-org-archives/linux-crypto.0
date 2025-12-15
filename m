Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7905C2EB874;
	Mon, 15 Dec 2025 12:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765800104; cv=none; b=InKCm3LlHhPfZ2bwS3v7WbULIvCN7FOcAzrjsteF4bjey3LFrEHfZuzZqigcb8cy58PrkQRMk3Bp2a0dn0t6At3Ens3OPxSZt2QtvmRiDWz/hfMWFXYBylAFLns7/tA6FD8kNzuSeB7xlvL3s78K5/5G0pHOdPSE7VULccz5eA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765800104; c=relaxed/simple;
	bh=i/835JYJXhRye+7a8HYBCwnieXk/OomT8RgEpq6o5IA=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=hcHIzFVPzizRjrS+V2lD5udtEDykhTUth2+XOU+2srX34Jubys5igScbAeb0/OCka6H6P+dM67l4aN52z4GyMQq9XiR26843FhpQ2Cv512pBJWXOMOw3JsCFvFgyhQ0w+S5a9otyaErzuhY1A0TAIXv6mejw9zZM65HPnpc+3ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NncD+PyN; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NncD+PyN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765800103; x=1797336103;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=i/835JYJXhRye+7a8HYBCwnieXk/OomT8RgEpq6o5IA=;
  b=NncD+PyNIsANLjSeQQJhI/wLcyWMgHe136gBePfRyke2O6rpOOi0vGsf
   v0lGBQ4ZDUiL0NZDUEZsxdCoDN8nSrqBeqjrupKxHa/KAaethfzwZPf7i
   /ZHZrg8utK2DRsAIg/olMX4F63oHocfCsQpuqrEVx6IzdJY+iISxv0QXk
   Xh3vkc3VBj61JL+lJtdIjF2B/VoMq1t8Jezo1We52ur6DDDsrgVXrbPmJ
   +nSffEGfLlArwNZZu9UWQZdcFnl89maqoGS4sRQfEnLsd1YUTn7aYna8T
   SwUTJVBVQPgzwmcF0Ug8OaQUV6+VqoecPv/n6VzfctnTVbz9MJa/Axvls
   w==;
X-CSE-ConnectionGUID: WscdN6UoQwepN3nc1/9nGg==
X-CSE-MsgGUID: vHSHb7AXRYeUVaAilX1/jQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11642"; a="66685875"
X-IronPort-AV: E=Sophos;i="6.21,150,1763452800"; 
   d="scan'208";a="66685875"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2025 04:01:42 -0800
X-CSE-ConnectionGUID: snrdnyquTHiyd+nufD75Qw==
X-CSE-MsgGUID: L9Os29MHQhOGyJ0WCMvgfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,150,1763452800"; 
   d="scan'208";a="197697319"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.115])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2025 04:01:37 -0800
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Mon, 15 Dec 2025 14:01:33 +0200 (EET)
To: "Mario Limonciello (AMD)" <superm1@kernel.org>
cc: Tom Lendacky <thomas.lendacky@amd.com>, 
    Herbert Xu <herbert@gondor.apana.org.au>, 
    Shyam Sundar S K <Shyam-sundar.S-k@amd.com>, 
    Rijo Thomas <Rijo-john.Thomas@amd.com>, John Allen <john.allen@amd.com>, 
    "David S . Miller" <davem@davemloft.net>, Hans de Goede <hansg@kernel.org>, 
    "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER" <linux-crypto@vger.kernel.org>, 
    "open list:AMD PMF DRIVER" <platform-driver-x86@vger.kernel.org>, 
    Lars Francke <lars.francke@gmail.com>, Yijun Shen <Yijun.Shen@dell.com>
Subject: Re: [PATCH v3 5/5] crypto: ccp - Send PSP_CMD_TEE_RING_DESTROY when
 PSP_CMD_TEE_RING_INIT fails
In-Reply-To: <20251214191213.154021-6-superm1@kernel.org>
Message-ID: <53f2736f-39b7-b041-ea02-372618df5de3@linux.intel.com>
References: <20251214191213.154021-1-superm1@kernel.org> <20251214191213.154021-6-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Sun, 14 Dec 2025, Mario Limonciello (AMD) wrote:

> The hibernate resume sequence involves loading a resume kernel that is just
> used for loading the hibernate image before shifting back to the existing
> kernel.
> 
> During that hibernate resume sequence the resume kernel may have loaded
> the ccp driver.  If this happens the resume kernel will also have called
> PSP_CMD_TEE_RING_INIT but it will never have called
> PSP_CMD_TEE_RING_DESTROY.
> 
> This is problematic because the existing kernel needs to re-initialize the
> ring.  One could argue that the existing kernel should call destroy
> as part of restore() but there is no guarantee that the resume kernel did
> or didn't load the ccp driver.  There is also no callback opportunity for
> the resume kernel to destroy before handing back control to the existing
> kernel.
> 
> Similar problems could potentially exist with the use of kdump and
> crash handling. I actually reproduced this issue like this:
> 
> 1) rmmod ccp
> 2) hibernate the system
> 3) resume the system
> 4) modprobe ccp
> 
> The resume kernel will have loaded ccp but never destroyed and then when
> I try to modprobe it fails.
> 
> Because of these possible cases add a flow that checks the error code from
> the PSP_CMD_TEE_RING_INIT call and tries to call PSP_CMD_TEE_RING_DESTROY
> if it failed.  If this succeeds then call PSP_CMD_TEE_RING_INIT again.
> 
> Fixes: f892a21f51162 ("crypto: ccp - use generic power management")
> Reported-by: Lars Francke <lars.francke@gmail.com>
> Closes: https://lore.kernel.org/platform-driver-x86/CAD-Ua_gfJnQSo8ucS_7ZwzuhoBRJ14zXP7s8b-zX3ZcxcyWePw@mail.gmail.com/
> Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
> ---
> v3:
>  * Add a comment (Tom)
>  * Add a define for busy condition (Shyam)
>  * Rename label (Shyam)
>  * Upgrade message to info (Shyam)
>  * Use a helper that validates result for destroy command (Shyam)
> ---
>  drivers/crypto/ccp/tee-dev.c | 12 ++++++++++++
>  include/linux/psp.h          |  2 ++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
> index ef1430f86ad62..9edb220abbc1a 100644
> --- a/drivers/crypto/ccp/tee-dev.c
> +++ b/drivers/crypto/ccp/tee-dev.c
> @@ -113,6 +113,7 @@ static int tee_init_ring(struct psp_tee_device *tee)
>  {
>  	int ring_size = MAX_RING_BUFFER_ENTRIES * sizeof(struct tee_ring_cmd);
>  	struct tee_init_ring_cmd *cmd;
> +	bool retry = false;
>  	unsigned int reg;
>  	int ret;
>  
> @@ -135,6 +136,7 @@ static int tee_init_ring(struct psp_tee_device *tee)
>  	/* Send command buffer details to Trusted OS by writing to
>  	 * CPU-PSP message registers
>  	 */
> +retry_init:
>  	ret = psp_mailbox_command(tee->psp, PSP_CMD_TEE_RING_INIT, cmd,
>  				  TEE_DEFAULT_CMD_TIMEOUT, &reg);
>  	if (ret) {
> @@ -145,6 +147,16 @@ static int tee_init_ring(struct psp_tee_device *tee)
>  	}
>  
>  	if (FIELD_GET(PSP_CMDRESP_STS, reg)) {
> +		/*
> +		 * During the hibernate resume sequence driver may have gotten loaded
> +		 * but the ring not properly destroyed. If the ring doesn't work, try
> +		 * to destroy and re-init once.
> +		 */
> +		if (!retry && FIELD_GET(PSP_CMDRESP_STS, reg) == PSP_TEE_STATUS_RING_BUSY) {
> +			dev_info(tee->dev, "tee: ring init command failed with busy status, retrying\n");
> +			if (tee_send_destroy_cmd(tee))
> +				goto retry_init;
> +		}
>  		dev_err(tee->dev, "tee: ring init command failed (%#010lx)\n",
>  			FIELD_GET(PSP_CMDRESP_STS, reg));
>  		tee_free_ring(tee);
> diff --git a/include/linux/psp.h b/include/linux/psp.h
> index 92e60aeef21e1..a329148e3684b 100644
> --- a/include/linux/psp.h
> +++ b/include/linux/psp.h
> @@ -23,6 +23,8 @@
>  #define PSP_CMDRESP_RECOVERY	BIT(30)
>  #define PSP_CMDRESP_RESP	BIT(31)
>  
> +#define PSP_TEE_STATUS_RING_BUSY 0x0000000d  /* Ring already initialized */

It would be better to have this right underneath PSP_CMDRESP_STS (you 
can use one extra space to indent different from the mask and bits).

Also, there's inconsistency in STS vs STATUS in the naming.

> +
>  #define PSP_DRBL_MSG		PSP_CMDRESP_CMD
>  #define PSP_DRBL_RING		BIT(0)
>  
> 

-- 
 i.

