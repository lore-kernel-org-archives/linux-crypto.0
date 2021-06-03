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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 251C3C47082
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Jun 2021 04:57:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01650613D7
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Jun 2021 04:57:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbhFCE6w (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Jun 2021 00:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbhFCE6w (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jun 2021 00:58:52 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC27C06174A
        for <linux-crypto@vger.kernel.org>; Wed,  2 Jun 2021 21:57:08 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id l1so4211625pgm.1
        for <linux-crypto@vger.kernel.org>; Wed, 02 Jun 2021 21:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=YbJlb+U6Cq7QVT8VB9vIbfxh76GCAzbgwZnvGgEObCs=;
        b=B8bdVKyvk7/OdGOJmCwYt+j89tZQvZW46oKQJ8YdVp0B18lTYHIWMypENRP/F6WFbU
         00u4xUWD3l3nyUtzspWZSxNVJrV4/Ep3u/5OahtYWaV/f6n1JOsrlZOtvDLXnZOevHsP
         p+aufDa1E0FU1fuUsW21Frinu5O3Rp70Z1IZKeEsJqY42q819NuegAOcWICSHZkpqDJy
         3M+2B0hhLdWxKlNbaEseJiIHnY+Xw+HzgRhwnigfs8cqiIkO+a52Swn0y/3x58nVhEQy
         9w08Xg+o0JYuCZXxRKU4ouyNMH7Iie/c+kpCtpy6DEG8T5e+nCKoKEFRWpo5JFn1g3xS
         37Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=YbJlb+U6Cq7QVT8VB9vIbfxh76GCAzbgwZnvGgEObCs=;
        b=qdstfE7wn2eNYHsB2eC7rR56sJWJ3cf5d1R4WJMLfjCaYZn1pJceGnPofohj98WmBH
         UKxZ42E7Rf9pWnvrCw2vJDs++odrUYtHJSqx9gbm25ZilOJGOLCQHA2beQBdz/J+OmlI
         gsh/NcBxPlGtbFlJCarn5Cq8dg+ETA7wdsgGTdl15nWZbLgzo50KKfB1PuyvuhbIwZLF
         V4ZVowCTnt18m9FWZoEiCStz5rGy+2PK+VplrhjU2qgTx6Nc9oggTWKto5/j0XPHGx3k
         6YrSpMOYW/YrqBQ/ddQZ2fGLxEjJTD7nnX0GWBzHDvH9gVyLIXLjfUfPm1w6M/oW4Fdf
         HrJw==
X-Gm-Message-State: AOAM532hPQ/c0p52PYyKjjDf9MKGlzXuNxW4YbMynA9bQ/TeXoXLF3D0
        xBLges/kJRAx8tX9kgphH+U=
X-Google-Smtp-Source: ABdhPJzgX7MBXMw7vOxw23SkJX23FZPbIAEydkluRITKaQBeq4LWwsFw2Nv1+Cyj8Uct0nlf4QmFCw==
X-Received: by 2002:a63:ae01:: with SMTP id q1mr36833619pgf.216.1622696227668;
        Wed, 02 Jun 2021 21:57:07 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l126sm1059804pfl.16.2021.06.02.21.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 21:57:07 -0700 (PDT)
Date:   Thu, 03 Jun 2021 14:57:02 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 16/16] crypto/nx: Add sysfs interface to export NX
 capabilities
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <8d219c0816133a8643d650709066cf04c9c77322.camel@linux.ibm.com>
        <35bca44c5a8af7bdffbe03b22fd82713bced8d0e.camel@linux.ibm.com>
In-Reply-To: <35bca44c5a8af7bdffbe03b22fd82713bced8d0e.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1622696109.949hlg4tnq.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of May 21, 2021 7:42 pm:
>=20
> Changes to export the following NXGZIP capabilities through sysfs:
>=20
> /sys/devices/vio/ibm,compression-v1/NxGzCaps:

Where's the horrible camel case name coming from? PowerVM?

Thanks,
Nick

> min_compress_len  /*Recommended minimum compress length in bytes*/
> min_decompress_len /*Recommended minimum decompress length in bytes*/
> req_max_processed_len /* Maximum number of bytes processed in one
> 			request */
>=20
> NX will return RMA_Reject if the request buffer size is greater
> than req_max_processed_len.
>=20
> Signed-off-by: Haren Myneni <haren@linux.ibm.com>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  drivers/crypto/nx/nx-common-pseries.c | 43 +++++++++++++++++++++++++++
>  1 file changed, 43 insertions(+)
>=20
> diff --git a/drivers/crypto/nx/nx-common-pseries.c b/drivers/crypto/nx/nx=
-common-pseries.c
> index 4a7278464156..121718a337fd 100644
> --- a/drivers/crypto/nx/nx-common-pseries.c
> +++ b/drivers/crypto/nx/nx-common-pseries.c
> @@ -968,6 +968,36 @@ static struct attribute_group nx842_attribute_group =
=3D {
>  	.attrs =3D nx842_sysfs_entries,
>  };
> =20
> +#define	nxct_caps_read(_name)						\
> +static ssize_t nxct_##_name##_show(struct device *dev,			\
> +			struct device_attribute *attr, char *buf)	\
> +{									\
> +	return sprintf(buf, "%lld\n", nx_ct_caps._name);		\
> +}
> +
> +#define NXCT_ATTR_RO(_name)						\
> +	nxct_caps_read(_name);						\
> +	static struct device_attribute dev_attr_##_name =3D __ATTR(_name,	\
> +						0444,			\
> +						nxct_##_name##_show,	\
> +						NULL);
> +
> +NXCT_ATTR_RO(req_max_processed_len);
> +NXCT_ATTR_RO(min_compress_len);
> +NXCT_ATTR_RO(min_decompress_len);
> +
> +static struct attribute *nxct_caps_sysfs_entries[] =3D {
> +	&dev_attr_req_max_processed_len.attr,
> +	&dev_attr_min_compress_len.attr,
> +	&dev_attr_min_decompress_len.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group nxct_caps_attr_group =3D {
> +	.name	=3D	nx_ct_caps.name,
> +	.attrs	=3D	nxct_caps_sysfs_entries,
> +};
> +
>  static struct nx842_driver nx842_pseries_driver =3D {
>  	.name =3D		KBUILD_MODNAME,
>  	.owner =3D	THIS_MODULE,
> @@ -1057,6 +1087,16 @@ static int nx842_probe(struct vio_dev *viodev,
>  		goto error;
>  	}
> =20
> +	if (caps_feat) {
> +		if (sysfs_create_group(&viodev->dev.kobj,
> +					&nxct_caps_attr_group)) {
> +			dev_err(&viodev->dev,
> +				"Could not create sysfs NX capability entries\n");
> +			ret =3D -1;
> +			goto error;
> +		}
> +	}
> +
>  	return 0;
> =20
>  error_unlock:
> @@ -1076,6 +1116,9 @@ static void nx842_remove(struct vio_dev *viodev)
>  	pr_info("Removing IBM Power 842 compression device\n");
>  	sysfs_remove_group(&viodev->dev.kobj, &nx842_attribute_group);
> =20
> +	if (caps_feat)
> +		sysfs_remove_group(&viodev->dev.kobj, &nxct_caps_attr_group);
> +
>  	crypto_unregister_alg(&nx842_pseries_alg);
> =20
>  	spin_lock_irqsave(&devdata_mutex, flags);
> --=20
> 2.18.2
>=20
>=20
>=20
