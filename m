Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0305DC48BE6
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Jun 2021 03:39:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3F24613AB
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Jun 2021 03:39:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbhFNDlT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Jun 2021 23:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232251AbhFNDlT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Jun 2021 23:41:19 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6142BC061574
        for <linux-crypto@vger.kernel.org>; Sun, 13 Jun 2021 20:39:17 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id x19so5827446pln.2
        for <linux-crypto@vger.kernel.org>; Sun, 13 Jun 2021 20:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=nf5HwWFyhplJT91xsgfa1P2gXUGFqDD4GsWEOo8HQgY=;
        b=JvEF9m1J6+jbANDnJbBL76yGtuvsN/qFWcvptlCo0cTHcpTawis/9u1oemmMi62xdT
         wqJpsCCdxNMBnaBTCjzTWarXoCBiTwSBI8wJCnmhWDB0MRgW9kupLxAYSovoQI1wB5z3
         GL1gQVj23jYO7vzy9ieWvm76qV61z5K3N5Hqq9FZtTWumetKr7BVffi2AZR/zWcpMnP8
         KYFX0gOJmrHBSvPMKJ11N2a0MGwKzsayX24R19UeiJzplmUNQlvqsaGin+dsJU3MfKB/
         TR/dLXC03fT2/I7563hiCCpSATknUE/RnjxHRTWmdvSXXX2vJA6Z0ISV+OoPRXEH9GQN
         5szw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=nf5HwWFyhplJT91xsgfa1P2gXUGFqDD4GsWEOo8HQgY=;
        b=gzf/q7vI/nj9wHvifOGJLRnH2zUapjp5nV/tmRFHPJkkmh0jU/wqOrZaaKFP3NcHaI
         gNR/YQxyJKBOjCYiDtfW0b48BWDUOoXIEQ9novYlP4EYdjAexVS1RZ380VQSCoRN3xuh
         tlANhinnLtNFro1lYLmKZfptZ84nxBIu0Zj5c9OuGIFrSfqiyHbAndTa579FThYgtjna
         2KuKrN07tQlqCAaNOgr/NWkKBgh3OWY4Wl/tUFIt8OfqyLRz1HlFzJoi8coowl075lRD
         I+2fKmwJc8mhkejbKvWn+PzL/MFJHp9J198zmOjp6lXAeYWKON8rHmQ7jO60xwnB6AeX
         exvQ==
X-Gm-Message-State: AOAM5333YhCCk6HYGIM2EL5MhlK8s5QkJ5j5DkIsUE278Ccm0XgjfHuK
        thbP1K7/FRvN2MwcPOKv4AQ=
X-Google-Smtp-Source: ABdhPJzt6jNeDhee79NabstNUrGI44WWdA8hyMRnpl2pKzsdsd5NumCPAGfQ3e7cj7JErosE5dyITg==
X-Received: by 2002:a17:90b:380a:: with SMTP id mq10mr11524882pjb.79.1623641956938;
        Sun, 13 Jun 2021 20:39:16 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id i2sm15342207pjj.25.2021.06.13.20.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 20:39:16 -0700 (PDT)
Date:   Mon, 14 Jun 2021 13:39:11 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v5 16/17] crypto/nx: Get NX capabilities for GZIP
 coprocessor type
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <ed7a09822cf3a2e463f942e5a37309a2365c9d79.camel@linux.ibm.com>
        <726de270eb20e0898f4391a0b0e7077697db66ab.camel@linux.ibm.com>
In-Reply-To: <726de270eb20e0898f4391a0b0e7077697db66ab.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1623641787.0rdwnv3k4u.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of June 13, 2021 9:04 pm:
>=20
> The hypervisor provides different capabilities that it supports
> to define the user space NX request. These capabilities are
> recommended minimum compression / decompression lengths and the
> maximum request buffer size in bytes.
>=20
> Changes to get NX overall capabilities which points to the
> specific features that the hypervisor supports. Then retrieve
> the capabilities for the specific feature (available only
> for NXGZIP).

So what does this give you which you didn't have before? Should
this go before the previous patch that enables the interface for guests,
or is there some functional-yet-degraded mode that is available without
this patch?

I would suggest even if this is the case to switch ordering of the=20
patches so as to reduce the matrix of functionality that userspace sees=20
when bisecting. Unless you specifically want this kind of bisectability,
in which case make that explicit in the changelog.

Thanks,
Nick

>=20
> Signed-off-by: Haren Myneni <haren@linux.ibm.com>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  drivers/crypto/nx/nx-common-pseries.c | 86 +++++++++++++++++++++++++++
>  1 file changed, 86 insertions(+)
>=20
> diff --git a/drivers/crypto/nx/nx-common-pseries.c b/drivers/crypto/nx/nx=
-common-pseries.c
> index 9a40fca8a9e6..60b5049ec9f7 100644
> --- a/drivers/crypto/nx/nx-common-pseries.c
> +++ b/drivers/crypto/nx/nx-common-pseries.c
> @@ -9,6 +9,7 @@
>   */
> =20
>  #include <asm/vio.h>
> +#include <asm/hvcall.h>
>  #include <asm/vas.h>
> =20
>  #include "nx-842.h"
> @@ -20,6 +21,29 @@ MODULE_DESCRIPTION("842 H/W Compression driver for IBM=
 Power processors");
>  MODULE_ALIAS_CRYPTO("842");
>  MODULE_ALIAS_CRYPTO("842-nx");
> =20
> +/*
> + * Coprocessor type specific capabilities from the hypervisor.
> + */
> +struct hv_nx_ct_caps {
> +	__be64	descriptor;
> +	__be64	req_max_processed_len;	/* Max bytes in one GZIP request */
> +	__be64	min_compress_len;	/* Min compression size in bytes */
> +	__be64	min_decompress_len;	/* Min decompression size in bytes */
> +} __packed __aligned(0x1000);
> +
> +/*
> + * Coprocessor type specific capabilities.
> + */
> +struct nx_ct_caps {
> +	u64	descriptor;
> +	u64	req_max_processed_len;	/* Max bytes in one GZIP request */
> +	u64	min_compress_len;	/* Min compression in bytes */
> +	u64	min_decompress_len;	/* Min decompression in bytes */
> +};
> +
> +static u64 caps_feat;
> +static struct nx_ct_caps nx_ct_caps;
> +
>  static struct nx842_constraints nx842_pseries_constraints =3D {
>  	.alignment =3D	DDE_BUFFER_ALIGN,
>  	.multiple =3D	DDE_BUFFER_LAST_MULT,
> @@ -1066,6 +1090,64 @@ static void nx842_remove(struct vio_dev *viodev)
>  	kfree(old_devdata);
>  }
> =20
> +/*
> + * Get NX capabilities from the hypervisor.
> + * Only NXGZIP capabilities are provided by the hypersvisor right
> + * now and these values are available to user space with sysfs.
> + */
> +static void __init nxct_get_capabilities(void)
> +{
> +	struct hv_vas_all_caps *hv_caps;
> +	struct hv_nx_ct_caps *hv_nxc;
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
> +		nx_ct_caps.descriptor =3D be64_to_cpu(hv_nxc->descriptor);
> +		nx_ct_caps.req_max_processed_len =3D
> +				be64_to_cpu(hv_nxc->req_max_processed_len);
> +		nx_ct_caps.min_compress_len =3D
> +				be64_to_cpu(hv_nxc->min_compress_len);
> +		nx_ct_caps.min_decompress_len =3D
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
> @@ -1093,6 +1175,10 @@ static int __init nx842_pseries_init(void)
>  		return -ENOMEM;
> =20
>  	RCU_INIT_POINTER(devdata, new_devdata);
> +	/*
> +	 * Get NX capabilities from the hypervisor.
> +	 */
> +	nxct_get_capabilities();
> =20
>  	ret =3D vio_register_driver(&nx842_vio_driver);
>  	if (ret) {
> --=20
> 2.18.2
>=20
>=20
>=20
