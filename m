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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10CF0C433ED
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 06:38:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB0FF60234
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 06:38:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbhEJGjb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 May 2021 02:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbhEJGjb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 May 2021 02:39:31 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E16C061573
        for <linux-crypto@vger.kernel.org>; Sun,  9 May 2021 23:38:26 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id i14so12589139pgk.5
        for <linux-crypto@vger.kernel.org>; Sun, 09 May 2021 23:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=avMmQkqPq3ZK6KdqTCGnz6Br6PUKj5adgsHq71kJhzU=;
        b=nVk4cdEFN02eydxyUSfohHQMO6Tulawffbm1sjoFbg6eFJM58XESIJdbvolpJjxhyu
         iMLPLw9Kb+ZHtSkQi0slf0hOJL2wjpBVqJ9uAx+YWqYNT1NyNdYagsMZ3BQMQfV4NK5R
         SOJdZGi47PKEhwbW6g+pQ/GFMA3205yY41mcV2bPoGdO4YXSZNg6mBocHHyfCVjoP5zm
         8MtFJ8gvN3+QE/mmdib4H6hVuLU10imWTaALViyCPLUUikvdD0iBs6YCv1fR1HYH5K/a
         Jq+YYTFOLaaTyYhS8FHzISgCPXmFvs2nCplsuUnQB61/TvtrTz64C8rMtzkBeCRuYodo
         OcDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=avMmQkqPq3ZK6KdqTCGnz6Br6PUKj5adgsHq71kJhzU=;
        b=RcUXZJXNZHwuQ7ez/RMqBUY5VAf0YdIY8IZGYlAk6xNfSTIQyqwaSKONo8mXW0j/p+
         MyF1Pk2iINjTqpCF7Biev+0CXglU0OA0rH1O7KRmokYcwxmAHdfQsQ/E62dF/+DEtchx
         Z2DT7Nvkl+DN6qjXKWBW25DBO5DZ5JpY/hMDsLB05ndgp6z+JSoQPvM2AZuHAKux+qEe
         /zwC02DHpEHFBoBmoN+zkIf11yEcjgwhcnvFG5OAiSBswTHwP3agi1b+jspYPp3dsFrV
         FjDsdUHm3wuHF8gM1vMP08kR/7ztyXoduSFPF1v8tnt1DMMLUISkdk8ySVFq1q/lKnJj
         UVDQ==
X-Gm-Message-State: AOAM530TsOBlr+Bw2ip0lqXCYFl8pPHd4rW8zfVcJK8kFbLVZ7f6lh9I
        SoeZ+pgclI7C70EULeNxFcitmIY45s4=
X-Google-Smtp-Source: ABdhPJzFZ7yfyn6/TMczNFF0hvFQIl4wu2x+s6wTrCFq0vTlrKVVcrR3rP6beVQcr+nuVYmqxaRFSw==
X-Received: by 2002:a05:6a00:d4e:b029:291:19f7:ddd4 with SMTP id n14-20020a056a000d4eb029029119f7ddd4mr24057721pfv.52.1620628706008;
        Sun, 09 May 2021 23:38:26 -0700 (PDT)
Received: from localhost (60-241-47-46.tpgi.com.au. [60.241.47.46])
        by smtp.gmail.com with ESMTPSA id k7sm10289263pfc.16.2021.05.09.23.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 23:38:25 -0700 (PDT)
Date:   Mon, 10 May 2021 16:38:20 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [V3 PATCH 15/16] crypto/nx: Get NX capabilities for GZIP
 coprocessor type
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <a910e5bd3f3398b4bd430b25a856500735b993c3.camel@linux.ibm.com>
        <e5fff6adbf3ce7769b0efe4846f39dbc6c795dd1.camel@linux.ibm.com>
In-Reply-To: <e5fff6adbf3ce7769b0efe4846f39dbc6c795dd1.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1620628516.4xglqwl3t1.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of April 18, 2021 7:12 am:
>=20
> phyp provides NX capabilities which gives recommended minimum
> compression / decompression length and maximum request buffer size
> in bytes.
>=20
> Changes to get NX overall capabilities which points to the specific
> features phyp supports. Then retrieve NXGZIP specific capabilities.
>=20
> Signed-off-by: Haren Myneni <haren@linux.ibm.com>
> ---
>  drivers/crypto/nx/nx-common-pseries.c | 83 +++++++++++++++++++++++++++
>  1 file changed, 83 insertions(+)
>=20
> diff --git a/drivers/crypto/nx/nx-common-pseries.c b/drivers/crypto/nx/nx=
-common-pseries.c
> index 9a40fca8a9e6..49224870d05e 100644
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
> @@ -20,6 +21,24 @@ MODULE_DESCRIPTION("842 H/W Compression driver for IBM=
 Power processors");
>  MODULE_ALIAS_CRYPTO("842");
>  MODULE_ALIAS_CRYPTO("842-nx");
> =20
> +struct nx_ct_capabs_be {

What does "ct" mean? I've seen it in a few other places too.

> +	__be64	descriptor;
> +	__be64	req_max_processed_len;	/* Max bytes in one GZIP request */
> +	__be64	min_compress_len;	/* Min compression size in bytes */
> +	__be64	min_decompress_len;	/* Min decompression size in bytes */
> +} __packed __aligned(0x1000);
> +
> +struct nx_ct_capabs {
> +	char	name[VAS_DESCR_LEN + 1];
> +	u64	descriptor;
> +	u64	req_max_processed_len;	/* Max bytes in one GZIP request */
> +	u64	min_compress_len;	/* Min compression in bytes */
> +	u64	min_decompress_len;	/* Min decompression in bytes */
> +};
> +
> +u64 capab_feat =3D 0;

Why is this here and not a local variable?

> +struct nx_ct_capabs nx_ct_capab;

It's okay and generally better to use the same name as the struct name
in this situation, i.e.,

"struct nx_ct_capabs nx_ct_capabs"

(modulo static / caps / etc)

Thanks,
Nick
