Return-Path: <SRS0=MR99=BD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58C1AC433E4
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Jul 2020 18:02:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38E7E20748
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Jul 2020 18:02:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dczfbAau"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgGXSCi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Jul 2020 14:02:38 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44049 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726763AbgGXSCi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Jul 2020 14:02:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595613757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a3LS+2HMIRnH0dyaHx9EQH8TAt/mWrj7/xGvBiqD2iA=;
        b=dczfbAauikd2p7cFyzPkjRKHH3d72PYIxyoP7rut2U1oZbPtxjIIlbRHbspeHyOI/5VRtt
        JN7JzFSrpKq4AvVak9MzOVWVGX6stPjr8y3DeByiCagS9QVVWYpWYVUnP15bt+nbHFXXWg
        DrcXxY9OCBU3uy0qj+I1vecw93Dqj6w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-FrCCai7XOcCaU-glsIfkeg-1; Fri, 24 Jul 2020 14:02:35 -0400
X-MC-Unique: FrCCai7XOcCaU-glsIfkeg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A31CD80BCAF;
        Fri, 24 Jul 2020 18:02:33 +0000 (UTC)
Received: from desktop-in5iihd.lan (ovpn-115-213.rdu2.redhat.com [10.10.115.213])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 90E79726AE;
        Fri, 24 Jul 2020 18:02:25 +0000 (UTC)
Date:   Fri, 24 Jul 2020 14:02:24 -0400
From:   Neil Horman <nhorman@redhat.com>
To:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        ard.biesheuvel@linaro.org, simo@redhat.com
Subject: Re: [PATCH v3 3/5] crypto: DH - check validity of Z before export
Message-ID: <20200724180224.GA65447@desktop-in5iihd.lan>
References: <2543601.mvXUDI8C0e@positron.chronox.de>
 <5722559.lOV4Wx5bFT@positron.chronox.de>
 <2544426.mvXUDI8C0e@positron.chronox.de>
 <3064298.aeNJFYEL58@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3064298.aeNJFYEL58@positron.chronox.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 20, 2020 at 07:08:32PM +0200, Stephan Müller wrote:
> SP800-56A rev3 section 5.7.1.1 step 2 mandates that the validity of the
> calculated shared secret is verified before the data is returned to the
> caller. This patch adds the validation check.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  crypto/dh.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/crypto/dh.c b/crypto/dh.c
> index 566f624a2de2..f84fd50ec79b 100644
> --- a/crypto/dh.c
> +++ b/crypto/dh.c
> @@ -9,6 +9,7 @@
>  #include <crypto/internal/kpp.h>
>  #include <crypto/kpp.h>
>  #include <crypto/dh.h>
> +#include <linux/fips.h>
>  #include <linux/mpi.h>
>  
>  struct dh_ctx {
> @@ -179,6 +180,34 @@ static int dh_compute_value(struct kpp_request *req)
>  	if (ret)
>  		goto err_free_base;
>  
> +	/* SP800-56A rev3 5.7.1.1 check: Validation of shared secret */
> +	if (fips_enabled && req->src) {
> +		MPI pone;
> +
> +		/* z <= 1 */
> +		if (mpi_cmp_ui(val, 1) < 1) {
> +			ret = -EBADMSG;
> +			goto err_free_base;
> +		}
> +
> +		/* z == p - 1 */
> +		pone = mpi_alloc(0);
> +
> +		if (!pone) {
> +			ret = -ENOMEM;
> +			goto err_free_base;
> +		}
> +
> +		ret = mpi_sub_ui(pone, ctx->p, 1);
> +		if (!ret && !mpi_cmp(pone, val))
> +			ret = -EBADMSG;
> +
> +		mpi_free(pone);
> +
> +		if (ret)
> +			goto err_free_base;
> +	}
> +
>  	ret = mpi_write_to_sgl(val, req->dst, req->dst_len, &sign);
>  	if (ret)
>  		goto err_free_base;
> -- 
> 2.26.2
> 
> 
> 
> 
Acked-by: Neil Horman <nhorman@redhat.com>


