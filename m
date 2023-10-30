Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE1A3C4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Oct 2023 09:20:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbjJ3JUh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Oct 2023 05:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232212AbjJ3JUg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Oct 2023 05:20:36 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1207A7
        for <linux-crypto@vger.kernel.org>; Mon, 30 Oct 2023 02:20:33 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-307d58b3efbso2669769f8f.0
        for <linux-crypto@vger.kernel.org>; Mon, 30 Oct 2023 02:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698657632; x=1699262432; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XLvSJ4WILzCQbRai7VhjkCmCDbJmlR0hsNCXw7/mMsA=;
        b=l5sJ1tPTSJVi9/tNni9tbb5Ip0Sb4Ykr6Kuv8xjwKoBnSdYOZf6cm00DdhZlAylfxI
         j3/I5g6Kq8scKj03j+wfwZQMRZiEmBG9Ic6zw74irf4gJWQpIfY0cAj4L2CH3KIY227B
         q9LtX9JdYep3T13u5oKUOsvFD98R6GASF6qcCuD9t1Da98WC+2S9jxkRteBfIOC0Aulh
         OXkIaiM5zVd5BQ68DIBBr0OuHVSMryYqOHVPBGjlMKMtADGQzUcxAAA3TeaPzihEkzIM
         rVAdUgW23Ce0F50c5cZG0tS7nZLjYi2F8odNIQw9wM+Xz9tuXgQf1XC9AkQLWx5LeJqi
         tKJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698657632; x=1699262432;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XLvSJ4WILzCQbRai7VhjkCmCDbJmlR0hsNCXw7/mMsA=;
        b=eOXkDO5+u/49B5T0LeFpcumXYrUEPzD/hS8/rWC5pqJyVYW2IBsq7X1NFSm0muvb05
         WajQ5hCcvy9Ierpf68SxqoM353GsktBEtSrmSP+uWb1GdQpsgzaAfRb5Gdh3wfarUTSR
         M4UAsBj66y/XUJFZHLnLWYbpQZhLt0MxKSamZR8cXCSp41ZB2eXK4jRBvAIjVuM2IssS
         bT0rO8WvHucwEhCZHGKnaCmv+XE+aF+BPdI5yZKRZPlRyxLsb2KK3tZbD1q9LWEudZFZ
         +l74IxkWnxA6Kuo9QE7M8UgBTFKB8RJtxSnEEJ5I9jv0aMhgwC0C2IsksYBP1aBVp12Y
         EpuQ==
X-Gm-Message-State: AOJu0YxWw9XvL6X7XTTZOsJ0L/i9rFJK/daqWhiJrRqKaCyGJgkuhQ/I
        SfgGe17ugCf4uPZ7EVteUI9KBQ==
X-Google-Smtp-Source: AGHT+IHGsT/YTW07JZa6BB2LlyG3+WAKOizPA0kax+aj3lRWAFPbwJUUPk0n3MXi8E1VhVfV1XAu2Q==
X-Received: by 2002:a5d:6dad:0:b0:32f:7d21:fd7b with SMTP id u13-20020a5d6dad000000b0032f7d21fd7bmr4342284wrs.39.1698657632132;
        Mon, 30 Oct 2023 02:20:32 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id ba13-20020a0560001c0d00b0032db4825495sm7979207wrb.22.2023.10.30.02.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 02:20:31 -0700 (PDT)
Date:   Mon, 30 Oct 2023 12:20:29 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Mahmoud Adam <mngyadam@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stephan Mueller <smueller@chronox.de>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: rsa - add a check for allocation failure
Message-ID: <6f0902b8-f323-4534-9ad5-90c4ff92b677@kadam.mountain>
References: <d870c278-3f0e-4386-a58d-c9e2c97a7c6c@moroto.mountain>
 <ZT9zRaTmFp6xl9x3@gondor.apana.org.au>
 <43d34a02-fc43-4ce8-b3ca-d996cf605ba2@kadam.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43d34a02-fc43-4ce8-b3ca-d996cf605ba2@kadam.mountain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 30, 2023 at 12:15:19PM +0300, Dan Carpenter wrote:
> On Mon, Oct 30, 2023 at 05:11:33PM +0800, Herbert Xu wrote:
> > On Mon, Oct 30, 2023 at 12:02:59PM +0300, Dan Carpenter wrote:
> > > Static checkers insist that the mpi_alloc() allocation can fail so add
> > > a check to prevent a NULL dereference.  Small allocations like this
> > > can't actually fail in current kernels, but adding a check is very
> > > simple and makes the static checkers happy.
> > > 
> > > Fixes: 6637e11e4ad2 ("crypto: rsa - allow only odd e and restrict value in FIPS mode")
> > > Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> > > ---
> > >  crypto/rsa.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > 
> > Nack.  Please fix the static checker instead.
> 
> The checker is not wrong.  Kernel policy is that every allocation has
> to be checked for failure.  In *current* kernels it won't but we have
> discussed changing this so the policy makes sense.

One way to fix the code would be to take gfp parameter and let people
pass a GFP_NOFAIL.  Unless there is a GFP_NOFAIL then the policy is that
the allocation can fail.

Or you could take the brtfs v1 approach and follow every kmalloc() with
a:
	p = kmalloc();
	BUG_on(!p);

regards,
dan carpenter

