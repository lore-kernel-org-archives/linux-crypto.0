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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B117C433B4
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 06:13:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D84BE6142D
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 06:13:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbhEJGOT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 May 2021 02:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbhEJGOS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 May 2021 02:14:18 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76872C061573
        for <linux-crypto@vger.kernel.org>; Sun,  9 May 2021 23:13:14 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id gx21-20020a17090b1255b02901589d39576eso3113735pjb.0
        for <linux-crypto@vger.kernel.org>; Sun, 09 May 2021 23:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=E7fPAyDsgNQKBABIpTTisqqIXxwzsczxL2R06rfhFDI=;
        b=MLYxti87ppq5UVUY92+gj95tRCUV6P8JqTHWQTq/eOgrUOqnU9TGVfcdv2VhjNHp2A
         JPxyqiJFYlwmIRdE1rjJxnc/g9fNe+su2as26eBKgL/Ghy+2VGJ287WU8SJMJqhSx9ci
         HX+dtfTELKu5MpEEx9Bq5kPiFAKlDlntVlkAmWb2Z+Fvl1oEk6GgZNsjEnOI6BsynOmg
         MxbgCcOW+6f66Q8ngo9FW5v8B+XLko4ZEhwCeesYmo/NVyQsBKFxaZhHD8HxVWcDSzcH
         1+Vngl9Zcv5hwryA2ALO86Uez8ILT5uFMXCAZ9/9Rc47JJIJSDOlqymdxBt+z1dde7/B
         fMDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=E7fPAyDsgNQKBABIpTTisqqIXxwzsczxL2R06rfhFDI=;
        b=PNKoReFzl/v0qnCP1u2b/2ZZGfCqNeU4xeD8hB/H7ryPfh9MceVlZ/sjoG4hT2frhR
         SyhNuzsTJV2SzBbVrGbGPagRJELKt5V7wBYzB+FHQSEiUPikLUi6VpR4bSuVVVLMgKAP
         szmr/h+kSkrJ3Nkxcyym4MRBSYhHKFmUC3uJW5Qhjrfb1L0XgZr1/IeVvVN4dXZvgCI5
         aqiPfiLS09uETf+I8SVbfzfLJZ0kINTdrUF5GdrqtWQ6QeeAAIPwzNV5H7vKIbspLHfv
         0M9i4RThsVRyx9b2P4LTpOtDApNyio8fEpPZ8yS29QlIj6bg/dRc1uTHFpgGiVDBGOD7
         GWQg==
X-Gm-Message-State: AOAM532kdaRKVKTScYAU6n1nd6wkLdMAXrhCKjt7nxiinzeCHY2OrcMP
        W26oeVOSEE1EgTUjF0Ttv7o=
X-Google-Smtp-Source: ABdhPJwi86LG1rzD1jOShk01HO2vYrZCiIN2edLT4WMXIsU2NwDWZMYkV7ZDvJ8aD7+egzmA5LYN7Q==
X-Received: by 2002:a17:90a:390d:: with SMTP id y13mr2687166pjb.133.1620627194006;
        Sun, 09 May 2021 23:13:14 -0700 (PDT)
Received: from localhost (60-241-47-46.tpgi.com.au. [60.241.47.46])
        by smtp.gmail.com with ESMTPSA id v123sm10164091pfb.80.2021.05.09.23.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 23:13:13 -0700 (PDT)
Date:   Mon, 10 May 2021 16:13:08 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [V3 PATCH 09/16] powerpc/pseries/vas: Implement to get all
 capabilities
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <a910e5bd3f3398b4bd430b25a856500735b993c3.camel@linux.ibm.com>
        <f6cdf811a29c22056740d48fa3de010f4ea4b848.camel@linux.ibm.com>
In-Reply-To: <f6cdf811a29c22056740d48fa3de010f4ea4b848.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1620626553.7v3m168yl3.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of April 18, 2021 7:08 am:
>=20
> pHyp provides various VAS capabilities such as GZIP default and QoS
> capabilities which are used to determine total number of credits
> available in LPAR, maximum window credits, maximum LPAR credits,
> whether usermode copy/paste is supported, and etc.
>=20
> So first retrieve overall vas capabilities using
> H_QUERY_VAS_CAPABILITIES HCALL which tells the specific features that
> are available. Then retrieve the specific capabilities by using the
> feature type in H_QUERY_VAS_CAPABILITIES HCALL.
>=20
> pHyp supports only GZIP default and GZIP QoS capabilities right now.

Changelog and title could use a bit of work.

>=20
> Signed-off-by: Haren Myneni <haren@linux.ibm.com>
> ---
>  arch/powerpc/platforms/pseries/vas.c | 130 +++++++++++++++++++++++++++
>  1 file changed, 130 insertions(+)
>=20
> diff --git a/arch/powerpc/platforms/pseries/vas.c b/arch/powerpc/platform=
s/pseries/vas.c
> index 06960151477c..35946fb02995 100644
> --- a/arch/powerpc/platforms/pseries/vas.c
> +++ b/arch/powerpc/platforms/pseries/vas.c
> @@ -30,6 +30,13 @@
>  /* phyp allows one credit per window right now */
>  #define DEF_WIN_CREDS		1
> =20
> +static struct vas_all_capabs capabs_all;

Does this name come from PAPR? If not, capabilities or caps are better=20
for readability than capabs.

> +static int copypaste_feat;

Should be a bool? And what does it mean? copy-paste is a host core=20
capability.

> +
> +struct vas_capabs vcapabs[VAS_MAX_FEAT_TYPE];
> +
> +DEFINE_MUTEX(vas_pseries_mutex);

Can these be made static if they're only used here, and export them if a=20
future patch uses them (or add the header declaration now).


> +
>  static int64_t hcall_return_busy_check(int64_t rc)
>  {
>  	/* Check if we are stalled for some time */
> @@ -215,3 +222,126 @@ int plpar_vas_query_capabilities(const u64 hcall, u=
8 query_type,
>  		return -EIO;
>  	}
>  }
> +
> +/*
> + * Get the specific capabilities based on the feature type.
> + * Right now supports GZIP default and GZIP QoS capabilities.
> + */
> +static int get_vas_capabilities(u8 feat, enum vas_cop_feat_type type,
> +				struct vas_ct_capabs_be *capab_be)
> +{
> +	struct vas_ct_capabs *capab;
> +	struct vas_capabs *vcapab;
> +	int rc =3D 0;
> +
> +	vcapab =3D &vcapabs[type];
> +	memset(vcapab, 0, sizeof(*vcapab));
> +	INIT_LIST_HEAD(&vcapab->list);
> +
> +	capab =3D &vcapab->capab;
> +
> +	rc =3D plpar_vas_query_capabilities(H_QUERY_VAS_CAPABILITIES, feat,
> +					  (u64)virt_to_phys(capab_be));
> +	if (rc)
> +		return rc;
> +
> +	capab->user_mode =3D capab_be->user_mode;
> +	if (!(capab->user_mode & VAS_COPY_PASTE_USER_MODE)) {
> +		pr_err("User space COPY/PASTE is not supported\n");
> +		return -ENOTSUPP;
> +	}
> +
> +	snprintf(capab->name, VAS_DESCR_LEN + 1, "%.8s",
> +		 (char *)&capab_be->descriptor);
> +	capab->descriptor =3D be64_to_cpu(capab_be->descriptor);
> +	capab->win_type =3D capab_be->win_type;
> +	if (capab->win_type >=3D VAS_MAX_FEAT_TYPE) {
> +		pr_err("Unsupported window type %u\n", capab->win_type);
> +		return -EINVAL;
> +	}
> +	capab->max_lpar_creds =3D be16_to_cpu(capab_be->max_lpar_creds);
> +	capab->max_win_creds =3D be16_to_cpu(capab_be->max_win_creds);
> +	atomic_set(&capab->target_lpar_creds,
> +		   be16_to_cpu(capab_be->target_lpar_creds));
> +	if (feat =3D=3D VAS_GZIP_DEF_FEAT) {
> +		capab->def_lpar_creds =3D be16_to_cpu(capab_be->def_lpar_creds);
> +
> +		if (capab->max_win_creds < DEF_WIN_CREDS) {
> +			pr_err("Window creds(%u) > max allowed window creds(%u)\n",
> +			       DEF_WIN_CREDS, capab->max_win_creds);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	copypaste_feat =3D 1;
> +
> +	return 0;
> +}
> +
> +static int __init pseries_vas_init(void)
> +{
> +	struct vas_ct_capabs_be *ct_capabs_be;
> +	struct vas_all_capabs_be *capabs_be;
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
> +	capabs_be =3D kmalloc(sizeof(*capabs_be), GFP_KERNEL);
> +	if (!capabs_be)
> +		return -ENOMEM;
> +	/*
> +	 * Get VAS overall capabilities by passing 0 to feature type.
> +	 */
> +	rc =3D plpar_vas_query_capabilities(H_QUERY_VAS_CAPABILITIES, 0,
> +					  (u64)virt_to_phys(capabs_be));
> +	if (rc)
> +		goto out;
> +
> +	snprintf(capabs_all.name, VAS_DESCR_LEN, "%.7s",
> +		 (char *)&capabs_be->descriptor);
> +	capabs_all.descriptor =3D be64_to_cpu(capabs_be->descriptor);
> +	capabs_all.feat_type =3D be64_to_cpu(capabs_be->feat_type);
> +
> +	ct_capabs_be =3D kmalloc(sizeof(*ct_capabs_be), GFP_KERNEL);
> +	if (!ct_capabs_be) {
> +		rc =3D -ENOMEM;
> +		goto out;
> +	}
> +	/*
> +	 * QOS capabilities available
> +	 */
> +	if (capabs_all.feat_type & VAS_GZIP_QOS_FEAT_BIT) {
> +		rc =3D get_vas_capabilities(VAS_GZIP_QOS_FEAT,
> +					  VAS_GZIP_QOS_FEAT_TYPE, ct_capabs_be);
> +
> +		if (rc)
> +			goto out_ct;
> +	}
> +	/*
> +	 * Default capabilities available
> +	 */
> +	if (capabs_all.feat_type & VAS_GZIP_DEF_FEAT_BIT) {
> +		rc =3D get_vas_capabilities(VAS_GZIP_DEF_FEAT,
> +					  VAS_GZIP_DEF_FEAT_TYPE, ct_capabs_be);
> +		if (rc)
> +			goto out_ct;
> +	}

Using the same buffer for two hcalls? Do they fill in different parts of=20
it?

> +
> +	if (!copypaste_feat)
> +		pr_err("GZIP feature is not supported\n");

This is dead code AFAIKS, because errors will always branch to out.

Thanks,
Nick

> +
> +	pr_info("GZIP feature is available\n");
> +
> +out_ct:
> +	kfree(ct_capabs_be);
> +out:
> +	kfree(capabs_be);
> +	return rc;
> +}
> +machine_device_initcall(pseries, pseries_vas_init);
> --=20
> 2.18.2
>=20
>=20
>=20
