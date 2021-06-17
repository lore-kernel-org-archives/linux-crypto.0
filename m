Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D081FC2B9F4
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 23:24:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A47D26117A
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 23:24:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbhFQX05 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Jun 2021 19:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbhFQX05 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jun 2021 19:26:57 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E750C061574
        for <linux-crypto@vger.kernel.org>; Thu, 17 Jun 2021 16:24:49 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id e33so6237780pgm.3
        for <linux-crypto@vger.kernel.org>; Thu, 17 Jun 2021 16:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=CfqAelGsB2GVkfCjgTBItidiNykTIW0YkEXIru4x3DQ=;
        b=GGeN94q7f6Uy8+5ozUkcv61KhMJF2rPz+vcnv2uiioPCzCB9HIzhseJRnzDml624q3
         P1+p3lEV91jeYa08z89vtHZVYPH+xgBhIdeuoC3UhtE38G+in4ZsqGjf8sVNzG90oVPd
         oTxPLFSl+FBDaxcN0/fWrsWR0kocAZtmKgADA8B1q/izQI+JA4SFST38JWliQ6nhRvC+
         l4noadVSgrMM6XfVi9r9P81vXDhy9qCNJ3oMTIX/UujzSbdZCOW/FktuQ7Hi/1KH3Psf
         XdoBOJmIn+lBQ6kvC8S5DH/D8tXWCzcgLsvYQLvpsLF7/VFxYd3sGwNi6uGhykKnAx/m
         6Xyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=CfqAelGsB2GVkfCjgTBItidiNykTIW0YkEXIru4x3DQ=;
        b=Wj1imEbE6YusIxoWfOArFRurv1oNonZNFmDoWHdeqjBnXbdxiTK/B8ttsI+Jug+snK
         fGLNioF9MNfzhLxAnjMQDuLLYbpKfdyVC3y/ybe8DCjVoxvc2p2DKtwjwohC+DsJwLoa
         QcklBnJCfbT9Qr1NdZxESGOY388ZL6rkXSx1ey2M9XAsClGtdJ2u6eDX921fErYbyLvz
         39Aw5Un1VEZmNrrqqQ+2wqZa9JUP0Ze3W/3a/0xv5Rwv+XMe8nFa3D8v4Loz3IXOLHUq
         CNwWdBpqFNOBA05S93wxTIs942KGBkgy+A8yGyFzxf4OQ4BIRW4K+6+IUJReXtaUUHpl
         FFFQ==
X-Gm-Message-State: AOAM531BN4umvBVa2DXHT3lIyJoxouXpqNlceNSHLmO0gZjSMN0NP4V7
        oFQn9kw+DDWl43NlHzFnYeE=
X-Google-Smtp-Source: ABdhPJy7PHMHqG8eTxUguJ6ytEFHS+7DB/esPUmzkA5SSPq7BCDtId/+0fOM0Nh8mhSoYhu364pMsw==
X-Received: by 2002:a63:4842:: with SMTP id x2mr7260754pgk.288.1623972288644;
        Thu, 17 Jun 2021 16:24:48 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id j7sm11431464pjf.0.2021.06.17.16.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 16:24:48 -0700 (PDT)
Date:   Fri, 18 Jun 2021 09:24:42 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v6 11/17] powerpc/pseries/vas: Implement getting
 capabilities from hypervisor
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <827bf56dce09620ebecd8a00a5f97105187a6205.camel@linux.ibm.com>
        <177c88608cb88f7b87d1c546103f18cec6c056b4.camel@linux.ibm.com>
In-Reply-To: <177c88608cb88f7b87d1c546103f18cec6c056b4.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1623972214.66b5w89bfe.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of June 18, 2021 6:35 am:
>=20
> The hypervisor provides VAS capabilities for GZIP default and QoS
> features. These capabilities gives information for the specific
> features such as total number of credits available in LPAR,
> maximum credits allowed per window, maximum credits allowed in
> LPAR, whether usermode copy/paste is supported, and etc.
>=20
> This patch adds the following:
> - Retrieve all features that are provided by hypervisor using
>   H_QUERY_VAS_CAPABILITIES hcall with 0 as feature type.
> - Retrieve capabilities for the specific feature using the same
>   hcall and the feature type (1 for QoS and 2 for default type).
>=20
> Signed-off-by: Haren Myneni <haren@linux.ibm.com>

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

> ---
>  arch/powerpc/platforms/pseries/vas.c | 122 +++++++++++++++++++++++++++
>  1 file changed, 122 insertions(+)
>=20
> diff --git a/arch/powerpc/platforms/pseries/vas.c b/arch/powerpc/platform=
s/pseries/vas.c
> index a73d7d00bf55..93794e12527d 100644
> --- a/arch/powerpc/platforms/pseries/vas.c
> +++ b/arch/powerpc/platforms/pseries/vas.c
> @@ -10,6 +10,7 @@
>  #include <linux/export.h>
>  #include <linux/types.h>
>  #include <linux/delay.h>
> +#include <asm/machdep.h>
>  #include <asm/hvcall.h>
>  #include <asm/plpar_wrappers.h>
>  #include <asm/vas.h>
> @@ -20,6 +21,11 @@
>  /* The hypervisor allows one credit per window right now */
>  #define DEF_WIN_CREDS		1
> =20
> +static struct vas_all_caps caps_all;
> +static bool copypaste_feat;
> +
> +static struct vas_caps vascaps[VAS_MAX_FEAT_TYPE];
> +
>  static long hcall_return_busy_check(long rc)
>  {
>  	/* Check if we are stalled for some time */
> @@ -145,3 +151,119 @@ int h_query_vas_capabilities(const u64 hcall, u8 qu=
ery_type, u64 result)
>  			hcall, rc, query_type, result);
>  	return -EIO;
>  }
> +
> +/*
> + * Get the specific capabilities based on the feature type.
> + * Right now supports GZIP default and GZIP QoS capabilities.
> + */
> +static int get_vas_capabilities(u8 feat, enum vas_cop_feat_type type,
> +				struct hv_vas_cop_feat_caps *hv_caps)
> +{
> +	struct vas_cop_feat_caps *caps;
> +	struct vas_caps *vcaps;
> +	int rc =3D 0;
> +
> +	vcaps =3D &vascaps[type];
> +	memset(vcaps, 0, sizeof(*vcaps));
> +	INIT_LIST_HEAD(&vcaps->list);
> +
> +	caps =3D &vcaps->caps;
> +
> +	rc =3D h_query_vas_capabilities(H_QUERY_VAS_CAPABILITIES, feat,
> +					  (u64)virt_to_phys(hv_caps));
> +	if (rc)
> +		return rc;
> +
> +	caps->user_mode =3D hv_caps->user_mode;
> +	if (!(caps->user_mode & VAS_COPY_PASTE_USER_MODE)) {
> +		pr_err("User space COPY/PASTE is not supported\n");
> +		return -ENOTSUPP;
> +	}
> +
> +	caps->descriptor =3D be64_to_cpu(hv_caps->descriptor);
> +	caps->win_type =3D hv_caps->win_type;
> +	if (caps->win_type >=3D VAS_MAX_FEAT_TYPE) {
> +		pr_err("Unsupported window type %u\n", caps->win_type);
> +		return -EINVAL;
> +	}
> +	caps->max_lpar_creds =3D be16_to_cpu(hv_caps->max_lpar_creds);
> +	caps->max_win_creds =3D be16_to_cpu(hv_caps->max_win_creds);
> +	atomic_set(&caps->target_lpar_creds,
> +		   be16_to_cpu(hv_caps->target_lpar_creds));
> +	if (feat =3D=3D VAS_GZIP_DEF_FEAT) {
> +		caps->def_lpar_creds =3D be16_to_cpu(hv_caps->def_lpar_creds);
> +
> +		if (caps->max_win_creds < DEF_WIN_CREDS) {
> +			pr_err("Window creds(%u) > max allowed window creds(%u)\n",
> +			       DEF_WIN_CREDS, caps->max_win_creds);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	copypaste_feat =3D true;
> +
> +	return 0;
> +}
> +
> +static int __init pseries_vas_init(void)
> +{
> +	struct hv_vas_cop_feat_caps *hv_cop_caps;
> +	struct hv_vas_all_caps *hv_caps;
> +	int rc;
> +
> +	/*
> +	 * Linux supports user space COPY/PASTE only with Radix
> +	 */
> +	if (!radix_enabled()) {
> +		pr_err("API is supported only with radix page tables\n");
> +		return -ENOTSUPP;
> +	}
> +
> +	hv_caps =3D kmalloc(sizeof(*hv_caps), GFP_KERNEL);
> +	if (!hv_caps)
> +		return -ENOMEM;
> +	/*
> +	 * Get VAS overall capabilities by passing 0 to feature type.
> +	 */
> +	rc =3D h_query_vas_capabilities(H_QUERY_VAS_CAPABILITIES, 0,
> +					  (u64)virt_to_phys(hv_caps));
> +	if (rc)
> +		goto out;
> +
> +	caps_all.descriptor =3D be64_to_cpu(hv_caps->descriptor);
> +	caps_all.feat_type =3D be64_to_cpu(hv_caps->feat_type);
> +
> +	hv_cop_caps =3D kmalloc(sizeof(*hv_cop_caps), GFP_KERNEL);
> +	if (!hv_cop_caps) {
> +		rc =3D -ENOMEM;
> +		goto out;
> +	}
> +	/*
> +	 * QOS capabilities available
> +	 */
> +	if (caps_all.feat_type & VAS_GZIP_QOS_FEAT_BIT) {
> +		rc =3D get_vas_capabilities(VAS_GZIP_QOS_FEAT,
> +					  VAS_GZIP_QOS_FEAT_TYPE, hv_cop_caps);
> +
> +		if (rc)
> +			goto out_cop;
> +	}
> +	/*
> +	 * Default capabilities available
> +	 */
> +	if (caps_all.feat_type & VAS_GZIP_DEF_FEAT_BIT) {
> +		rc =3D get_vas_capabilities(VAS_GZIP_DEF_FEAT,
> +					  VAS_GZIP_DEF_FEAT_TYPE, hv_cop_caps);
> +		if (rc)
> +			goto out_cop;
> +	}
> +
> +	pr_info("GZIP feature is available\n");
> +
> +out_cop:
> +	kfree(hv_cop_caps);
> +out:
> +	kfree(hv_caps);
> +	return rc;
> +}
> +machine_device_initcall(pseries, pseries_vas_init);
> --=20
> 2.18.2
>=20
>=20
>=20
