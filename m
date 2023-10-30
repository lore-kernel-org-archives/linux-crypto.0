Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7524C4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Oct 2023 09:15:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbjJ3JP1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Oct 2023 05:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232374AbjJ3JP0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Oct 2023 05:15:26 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65269B6
        for <linux-crypto@vger.kernel.org>; Mon, 30 Oct 2023 02:15:24 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-4083f61322fso33200215e9.1
        for <linux-crypto@vger.kernel.org>; Mon, 30 Oct 2023 02:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698657323; x=1699262123; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lTNUjRX3ECq7ehIr2zP5G3ay0ebpeMQRBEnNy7LpYnE=;
        b=R8kvBOdk/MfBmNP/ljYZOMDZKjVhydlqzZaWsz0ehUtyqhBmhhnINmTNRvORkWw42n
         gEQhb19DYL1Sn/L0WvUEBB3BFjV7vlUJbA8INyR1+xiLrU7zuZV4yoO1SI3DcXtBYrbv
         XPqkHAz5IMoFAQ6mLR/PN1ZT1otchLgU20811PF1zpgjd6Ut8g6gd8Hh1YDO6LeSI4oG
         AnbgpZVAW32/rPn7b8+DedB98JgrfKs14/KIS6DBP6iTNvMxG0G41gsSAZSGarZUF1fp
         tLSdXS8OLFC4uTP7Z0HdZ2AZtJMWwe/1guwBos+hybv7+VfxCi9KV63T6POHLRVx7tOd
         VSOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698657323; x=1699262123;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lTNUjRX3ECq7ehIr2zP5G3ay0ebpeMQRBEnNy7LpYnE=;
        b=LwEah7EWLDJ5OS62I5tp/5e6IE79Q6vCeqX5AuGVxRehtsd7J/o+KdSZ4TiFI/PBZT
         IpYo4tOIY+jmlNEOqu9cFtuniW+UsoZ4a9r6MtWloKubQl0An11O7jYk3SlWx6yuY2EW
         Q1FW0Ft/6UN6dhQBZVjNqDwG2S3CHhDEbX1waBKe15DywM425VFktUzcdgBYEucCZMQA
         j5sBDQl3Mjr1bk/aEdCI1da4M63qj3PTljWGtnYzZHyToyFxmjcLcvU7YX0Aprj/BgyS
         ulw0AxI9bgqVgmaEOq7Jp+DUx39LyHZBMoN8Yx1quikvKCm5HTuMWb2cEidbFV3rzrtY
         29hA==
X-Gm-Message-State: AOJu0YylvKO6G16uitdHSHleAWQ+rC0ZGqnAtStjEkLaesZTQaKNm4px
        hGmynx1qgOmrvxxNkvcb2vIRIVBOcbdJlW3gEn8=
X-Google-Smtp-Source: AGHT+IFWqfiqIA5CXsh+JANuT5+BV8FcjUfQ6nP3L+Rkd93JFQGo+1+6aEMAKj4wrjDNjY2PchllmQ==
X-Received: by 2002:a05:600c:4750:b0:408:3d91:8251 with SMTP id w16-20020a05600c475000b004083d918251mr7344980wmo.5.1698657322727;
        Mon, 30 Oct 2023 02:15:22 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id j7-20020a05600c1c0700b003fefb94ccc9sm8681319wms.11.2023.10.30.02.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 02:15:22 -0700 (PDT)
Date:   Mon, 30 Oct 2023 12:15:19 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Mahmoud Adam <mngyadam@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stephan Mueller <smueller@chronox.de>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: rsa - add a check for allocation failure
Message-ID: <43d34a02-fc43-4ce8-b3ca-d996cf605ba2@kadam.mountain>
References: <d870c278-3f0e-4386-a58d-c9e2c97a7c6c@moroto.mountain>
 <ZT9zRaTmFp6xl9x3@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZT9zRaTmFp6xl9x3@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 30, 2023 at 05:11:33PM +0800, Herbert Xu wrote:
> On Mon, Oct 30, 2023 at 12:02:59PM +0300, Dan Carpenter wrote:
> > Static checkers insist that the mpi_alloc() allocation can fail so add
> > a check to prevent a NULL dereference.  Small allocations like this
> > can't actually fail in current kernels, but adding a check is very
> > simple and makes the static checkers happy.
> > 
> > Fixes: 6637e11e4ad2 ("crypto: rsa - allow only odd e and restrict value in FIPS mode")
> > Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> > ---
> >  crypto/rsa.c | 2 ++
> >  1 file changed, 2 insertions(+)
> 
> Nack.  Please fix the static checker instead.

The checker is not wrong.  Kernel policy is that every allocation has
to be checked for failure.  In *current* kernels it won't but we have
discussed changing this so the policy makes sense.

I have tested this some years back and I don't think it's so infeasible
as people think to allow these allocations to fail.

regards,
dan carpenter

