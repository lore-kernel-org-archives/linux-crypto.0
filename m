Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07CA4C70;
	Thu, 27 Feb 2025 01:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740621229; cv=none; b=FtRHrp4cvdEM7XLzT4AUx60qKc2oqg/W5SOL6gh3Hwwxzn5jJzkAPqTkLShesfBU+JWcIY4TnAL6MS1USzidDRvoxr0d+WdzAJcJdlqPeog/HoLukWQbpp/FB4IPCoRYgaCD/5fijekhh59Z3FwOhft8agGk1m+uLVMO1eGrKD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740621229; c=relaxed/simple;
	bh=dd5xHZI2IoqCVIdqvfx4m4XJWKLS777Vrqv/TxsFllU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gbPZz0In1iKqc2NReFtK498+zrGwvvXElqcjzj3hgx9PlTVtOHTRTibmh6jfnCE+bxjQ3StR5J8p5OGOBPAkoVBmGOIEO+0wZ0BLNIidHuizktpW6xbTD5Xflq2IMBIAlK+P3bnIL71MjtYpMGU/g4ZLxrznuFrE4lnCUk/WPxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=DDmR15cn; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="DDmR15cn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=+teUizgx5y9+h6rGribSX/zyUFaoyiOJJ6ceKOAnSM8=; b=DDmR15cnTnc3k1N4
	h9cb3yYTrr+GHS8RAtRYVKXZV5bXAURiwxlumE12mugVZXUCHp6cYYRjV6rdJvvrNyjkgXHDgRpuZ
	wbFu8Lb/VhwlYmpUNLRfeP9jZYfP9oHajkBPQuocLGWhPXznDItKATrGo1+I3X8gwovK2o274vCAC
	sgAjh1lk+6WbpfOtgDuAyPX70CAvkeuNlpVp35uZP7racwD15UWjeUd6TCYgLW0uh/bkFQGET5hCh
	5spzZwyo5LjqAWfRIkyNF9g9JDMPMYWv1DNSacd9dmlODd2IL8YVPv6oTGKHnngRWnlz4URfIwjiC
	W7FiK6P3DxAdHuPClw==;
Received: from dg by mx.treblig.org with local (Exim 4.96)
	(envelope-from <dg@treblig.org>)
	id 1tnT5f-001DNr-0E;
	Thu, 27 Feb 2025 01:53:31 +0000
Date: Thu, 27 Feb 2025 01:53:31 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: bbrezillon@kernel.org, schalla@marvell.com
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: octeontx2 - Remove unused
 otx2_cpt_print_uc_dbg_info
Message-ID: <Z7_Fm5jyyOwsG89W@gallifrey>
References: <20250223005354.86234-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20250223005354.86234-1-linux@treblig.org>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.1.0-21-amd64 (x86_64)
X-Uptime: 01:52:44 up 294 days, 13:06,  1 user,  load average: 0.04, 0.01,
 0.00
User-Agent: Mutt/2.2.12 (2023-09-09)

Note: Arnaud's email address is bouncing:

A message that you sent could not be delivered to one or more of its
recipients. This is a permanent error. The following address(es) failed:

  arno@natisbad.org
    all hosts for 'natisbad.org' have been failing for a long time (and retry time not reached)

* linux@treblig.org (linux@treblig.org) wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> otx2_cpt_print_uc_dbg_info() has been unused since 2023's
> commit 82f89f1aa6ca ("crypto: octeontx2 - add devlink option to set t106
> mode")
> 
> Remove it and the get_engs_info() helper it's the only user of.
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> ---
>  .../marvell/octeontx2/otx2_cptpf_ucode.c      | 99 -------------------
>  .../marvell/octeontx2/otx2_cptpf_ucode.h      |  1 -
>  2 files changed, 100 deletions(-)
> 
> diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
> index 5c9484646172..0af34e0e46f2 100644
> --- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
> +++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
> @@ -1774,102 +1774,3 @@ int otx2_cpt_dl_custom_egrp_delete(struct otx2_cptpf_dev *cptpf,
>  	dev_err(dev, "%s\n", err_msg);
>  	return -EINVAL;
>  }
> -
> -static void get_engs_info(struct otx2_cpt_eng_grp_info *eng_grp, char *buf,
> -			  int size, int idx)
> -{
> -	struct otx2_cpt_engs_rsvd *mirrored_engs = NULL;
> -	struct otx2_cpt_engs_rsvd *engs;
> -	int len, i;
> -
> -	buf[0] = '\0';
> -	for (i = 0; i < OTX2_CPT_MAX_ETYPES_PER_GRP; i++) {
> -		engs = &eng_grp->engs[i];
> -		if (!engs->type)
> -			continue;
> -		if (idx != -1 && idx != i)
> -			continue;
> -
> -		if (eng_grp->mirror.is_ena)
> -			mirrored_engs = find_engines_by_type(
> -				&eng_grp->g->grp[eng_grp->mirror.idx],
> -				engs->type);
> -		if (i > 0 && idx == -1) {
> -			len = strlen(buf);
> -			scnprintf(buf + len, size - len, ", ");
> -		}
> -
> -		len = strlen(buf);
> -		scnprintf(buf + len, size - len, "%d %s ",
> -			  mirrored_engs ? engs->count + mirrored_engs->count :
> -					  engs->count,
> -			  get_eng_type_str(engs->type));
> -		if (mirrored_engs) {
> -			len = strlen(buf);
> -			scnprintf(buf + len, size - len,
> -				  "(%d shared with engine_group%d) ",
> -				  engs->count <= 0 ?
> -					  engs->count + mirrored_engs->count :
> -					  mirrored_engs->count,
> -				  eng_grp->mirror.idx);
> -		}
> -	}
> -}
> -
> -void otx2_cpt_print_uc_dbg_info(struct otx2_cptpf_dev *cptpf)
> -{
> -	struct otx2_cpt_eng_grps *eng_grps = &cptpf->eng_grps;
> -	struct otx2_cpt_eng_grp_info *mirrored_grp;
> -	char engs_info[2 * OTX2_CPT_NAME_LENGTH];
> -	struct otx2_cpt_eng_grp_info *grp;
> -	struct otx2_cpt_engs_rsvd *engs;
> -	int i, j;
> -
> -	pr_debug("Engine groups global info");
> -	pr_debug("max SE %d, max IE %d, max AE %d", eng_grps->avail.max_se_cnt,
> -		 eng_grps->avail.max_ie_cnt, eng_grps->avail.max_ae_cnt);
> -	pr_debug("free SE %d", eng_grps->avail.se_cnt);
> -	pr_debug("free IE %d", eng_grps->avail.ie_cnt);
> -	pr_debug("free AE %d", eng_grps->avail.ae_cnt);
> -
> -	for (i = 0; i < OTX2_CPT_MAX_ENGINE_GROUPS; i++) {
> -		grp = &eng_grps->grp[i];
> -		pr_debug("engine_group%d, state %s", i,
> -			 grp->is_enabled ? "enabled" : "disabled");
> -		if (grp->is_enabled) {
> -			mirrored_grp = &eng_grps->grp[grp->mirror.idx];
> -			pr_debug("Ucode0 filename %s, version %s",
> -				 grp->mirror.is_ena ?
> -					 mirrored_grp->ucode[0].filename :
> -					 grp->ucode[0].filename,
> -				 grp->mirror.is_ena ?
> -					 mirrored_grp->ucode[0].ver_str :
> -					 grp->ucode[0].ver_str);
> -			if (is_2nd_ucode_used(grp))
> -				pr_debug("Ucode1 filename %s, version %s",
> -					 grp->ucode[1].filename,
> -					 grp->ucode[1].ver_str);
> -		}
> -
> -		for (j = 0; j < OTX2_CPT_MAX_ETYPES_PER_GRP; j++) {
> -			engs = &grp->engs[j];
> -			if (engs->type) {
> -				u32 mask[5] = { };
> -
> -				get_engs_info(grp, engs_info,
> -					      2 * OTX2_CPT_NAME_LENGTH, j);
> -				pr_debug("Slot%d: %s", j, engs_info);
> -				bitmap_to_arr32(mask, engs->bmap,
> -						eng_grps->engs_num);
> -				if (is_dev_otx2(cptpf->pdev))
> -					pr_debug("Mask: %8.8x %8.8x %8.8x %8.8x",
> -						 mask[3], mask[2], mask[1],
> -						 mask[0]);
> -				else
> -					pr_debug("Mask: %8.8x %8.8x %8.8x %8.8x %8.8x",
> -						 mask[4], mask[3], mask[2], mask[1],
> -						 mask[0]);
> -			}
> -		}
> -	}
> -}
> diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
> index 365fe8943bd9..7e6a6a4ec37c 100644
> --- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
> +++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
> @@ -166,7 +166,6 @@ int otx2_cpt_dl_custom_egrp_create(struct otx2_cptpf_dev *cptpf,
>  				   struct devlink_param_gset_ctx *ctx);
>  int otx2_cpt_dl_custom_egrp_delete(struct otx2_cptpf_dev *cptpf,
>  				   struct devlink_param_gset_ctx *ctx);
> -void otx2_cpt_print_uc_dbg_info(struct otx2_cptpf_dev *cptpf);
>  struct otx2_cpt_engs_rsvd *find_engines_by_type(
>  					struct otx2_cpt_eng_grp_info *eng_grp,
>  					int eng_type);
> -- 
> 2.48.1
> 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
