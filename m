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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6F6AC2B9F4
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 23:36:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98D5261369
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 23:36:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbhFQXiN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Jun 2021 19:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbhFQXiN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jun 2021 19:38:13 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE15C061574
        for <linux-crypto@vger.kernel.org>; Thu, 17 Jun 2021 16:36:05 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id y15so433785pfl.4
        for <linux-crypto@vger.kernel.org>; Thu, 17 Jun 2021 16:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=b6HgWIOu0cJcB49Rw6z7AqZc8TPM4Uq78OfjrLVGDzw=;
        b=Xx2gSZ/N+hg4dNtAuX4EwgpTdMG72Yuy2gT1JRkipMgZGFrA3aNw69Du70BswrSHLJ
         rw9NrA7nCMUCNCoxU5ys4kYw/1yZODIcC9w+P3iCsYbbPPwMrnqtXJOCjBygz6LXvBNq
         WsHMs5ZvMR/KdjwkRnqFhBDAr47SwC+w5TqV+r1Z9nmg22XR4/jMcY62p+zgwzsXVbhT
         V16n3GHibtGAPMumFZ6yI49/al0R54YCtrd9+ybEn03aXyAjQNwXiU+4aKuB6rIalTCR
         XiI8BJDH9MLZ0iqn3M3TU5qunx9x1FyGSyNSHNSrjcz5voV5TfEijPdYxSitQCkrP9Xf
         5Byg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=b6HgWIOu0cJcB49Rw6z7AqZc8TPM4Uq78OfjrLVGDzw=;
        b=dQ2RJ9XaLEgPo5WGgCLSVJpJqlBhfj601O1ZqTuFhh5Xv+P+ZZgmiRPcLYoyVoI0hm
         XzVMM2m82qxcbTGUoAc1JWeEOGY36ksCPXGWj7TnlWxijafNuL6qZAxFA9fPbHc3J5fs
         cU27S12wARfjBd9O2937YXC3C0GuKY6nYvZirQC4qyzStpBvuEJCrM4o0xTzvj2ju65e
         +RypFIZBeqCDyYyacjkF9bNcAVYkqKybv4LGBiZ2CzzXcwFEcKGRb0fQwm0n8imThmWN
         C8lvDZ1zRNZDAG6smplekXFt7T+iDFcEqpsLiObU5Hls3DI6AuvbAXknt583zv3DVI3t
         CixA==
X-Gm-Message-State: AOAM5326fBRyvxQv1zEBpAw3uedNDUc2jKsCCgGLZF4Uejj0TU0lm5Vb
        7lrGjhbpeIa4GEWssZxEwhU=
X-Google-Smtp-Source: ABdhPJy/n7+hCCYpQXpXnGgUO7AN4o6NZYVY3u6DdOqbW3rZjpi+XyDsfOSbqvsk3UzpqThZo6udYw==
X-Received: by 2002:a63:e309:: with SMTP id f9mr7113554pgh.443.1623972964845;
        Thu, 17 Jun 2021 16:36:04 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id t5sm5882620pfe.116.2021.06.17.16.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 16:36:04 -0700 (PDT)
Date:   Fri, 18 Jun 2021 09:35:59 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v6 15/17] crypto/nx: Get NX capabilities for GZIP
 coprocessor type
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <827bf56dce09620ebecd8a00a5f97105187a6205.camel@linux.ibm.com>
        <f2b6a1fb8b6112595a73d81c67a35af4e7f5d0a3.camel@linux.ibm.com>
In-Reply-To: <f2b6a1fb8b6112595a73d81c67a35af4e7f5d0a3.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1623972924.juhnvnlfsg.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of June 18, 2021 6:38 am:
>=20
> The hypervisor provides different NX capabilities that it
> supports. These capabilities such as recommended minimum
> compression / decompression lengths and the maximum request
> buffer size in bytes are used to define the user space NX
> request.
>=20
> NX will reject the request if the buffer size is more than
> the maximum buffer size. Whereas compression / decompression
> lengths are recommended values for better performance.
>=20
> Changes to get NX overall capabilities which points to the
> specific features that the hypervisor supports. Then retrieve
> the capabilities for the specific feature (available only
> for NXGZIP).
>=20
> Signed-off-by: Haren Myneni <haren@linux.ibm.com>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Nicholas Piggin <npiggin@gmail.com>

> ---
>  drivers/crypto/nx/nx-common-pseries.c | 87 +++++++++++++++++++++++++++
>  1 file changed, 87 insertions(+)
>=20
> diff --git a/drivers/crypto/nx/nx-common-pseries.c b/drivers/crypto/nx/nx=
-common-pseries.c
> index cc8dd3072b8b..9fc2abb56019 100644
> --- a/drivers/crypto/nx/nx-common-pseries.c
> +++ b/drivers/crypto/nx/nx-common-pseries.c
> @@ -9,6 +9,8 @@
>   */
> =20
>  #include <asm/vio.h>
> +#include <asm/hvcall.h>
> +#include <asm/vas.h>
> =20
>  #include "nx-842.h"
>  #include "nx_csbcpb.h" /* struct nx_csbcpb */
> @@ -19,6 +21,29 @@ MODULE_DESCRIPTION("842 H/W Compression driver for IBM=
 Power processors");
>  MODULE_ALIAS_CRYPTO("842");
>  MODULE_ALIAS_CRYPTO("842-nx");
> =20
> +/*
> + * Coprocessor type specific capabilities from the hypervisor.
> + */
> +struct hv_nx_cop_caps {
> +	__be64	descriptor;
> +	__be64	req_max_processed_len;	/* Max bytes in one GZIP request */
> +	__be64	min_compress_len;	/* Min compression size in bytes */
> +	__be64	min_decompress_len;	/* Min decompression size in bytes */
> +} __packed __aligned(0x1000);
> +
> +/*
> + * Coprocessor type specific capabilities.
> + */
> +struct nx_cop_caps {
> +	u64	descriptor;
> +	u64	req_max_processed_len;	/* Max bytes in one GZIP request */
> +	u64	min_compress_len;	/* Min compression in bytes */
> +	u64	min_decompress_len;	/* Min decompression in bytes */
> +};
> +
> +static u64 caps_feat;
> +static struct nx_cop_caps nx_cop_caps;
> +
>  static struct nx842_constraints nx842_pseries_constraints =3D {
>  	.alignment =3D	DDE_BUFFER_ALIGN,
>  	.multiple =3D	DDE_BUFFER_LAST_MULT,
> @@ -1065,6 +1090,64 @@ static void nx842_remove(struct vio_dev *viodev)
>  	kfree(old_devdata);
>  }
> =20
> +/*
> + * Get NX capabilities from the hypervisor.
> + * Only NXGZIP capabilities are provided by the hypersvisor right
> + * now and these values are available to user space with sysfs.
> + */
> +static void __init nxcop_get_capabilities(void)
> +{
> +	struct hv_vas_all_caps *hv_caps;
> +	struct hv_nx_cop_caps *hv_nxc;
> +	int rc;
> +
> +	hv_caps =3D kmalloc(sizeof(*hv_caps), GFP_KERNEL);
> +	if (!hv_caps)
> +		return;
> +	/*
> +	 * Get NX overall capabilities with feature type=3D0
> +	 */
> +	rc =3D h_query_vas_capabilities(H_QUERY_NX_CAPABILITIES, 0,
> +					  (u64)virt_to_phys(hv_caps));
> +	if (rc)
> +		goto out;
> +
> +	caps_feat =3D be64_to_cpu(hv_caps->feat_type);
> +	/*
> +	 * NX-GZIP feature available
> +	 */
> +	if (caps_feat & VAS_NX_GZIP_FEAT_BIT) {
> +		hv_nxc =3D kmalloc(sizeof(*hv_nxc), GFP_KERNEL);
> +		if (!hv_nxc)
> +			goto out;
> +		/*
> +		 * Get capabilities for NX-GZIP feature
> +		 */
> +		rc =3D h_query_vas_capabilities(H_QUERY_NX_CAPABILITIES,
> +						  VAS_NX_GZIP_FEAT,
> +						  (u64)virt_to_phys(hv_nxc));
> +	} else {
> +		pr_err("NX-GZIP feature is not available\n");
> +		rc =3D -EINVAL;
> +	}
> +
> +	if (!rc) {
> +		nx_cop_caps.descriptor =3D be64_to_cpu(hv_nxc->descriptor);
> +		nx_cop_caps.req_max_processed_len =3D
> +				be64_to_cpu(hv_nxc->req_max_processed_len);
> +		nx_cop_caps.min_compress_len =3D
> +				be64_to_cpu(hv_nxc->min_compress_len);
> +		nx_cop_caps.min_decompress_len =3D
> +				be64_to_cpu(hv_nxc->min_decompress_len);
> +	} else {
> +		caps_feat =3D 0;
> +	}
> +
> +	kfree(hv_nxc);
> +out:
> +	kfree(hv_caps);
> +}
> +
>  static const struct vio_device_id nx842_vio_driver_ids[] =3D {
>  	{"ibm,compression-v1", "ibm,compression"},
>  	{"", ""},
> @@ -1092,6 +1175,10 @@ static int __init nx842_pseries_init(void)
>  		return -ENOMEM;
> =20
>  	RCU_INIT_POINTER(devdata, new_devdata);
> +	/*
> +	 * Get NX capabilities from the hypervisor.
> +	 */
> +	nxcop_get_capabilities();
> =20
>  	ret =3D vio_register_driver(&nx842_vio_driver);
>  	if (ret) {
> --=20
> 2.18.2
>=20
>=20
>=20
