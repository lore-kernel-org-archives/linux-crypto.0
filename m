Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B074E92FD4
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Oct 2023 02:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjJFC1F (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Oct 2023 22:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjJFC1E (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Oct 2023 22:27:04 -0400
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A2ED8
        for <linux-crypto@vger.kernel.org>; Thu,  5 Oct 2023 19:26:17 -0700 (PDT)
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-775751c35d4so100211985a.0
        for <linux-crypto@vger.kernel.org>; Thu, 05 Oct 2023 19:26:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696559176; x=1697163976;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FfXO766UylwaXpVj/Oq96aej9C9Ew70cll8S/lw9EnM=;
        b=bauf8FSh0EGBbGapq0r+ibHO3x1dhLHmaKgITBOlJw75tmqs5kM6ozj5WqMaeAgvoS
         dDAyuxYBCq+AfjuvqpFwQiMX9Od4g5tfLibMH4w3x92R6UZsNC30/ppLPVj43luDCQU6
         B2yHDy2vg6+jQAXXM6XgAGE3+6Bfp4KPRntMJN0vi198n+7r4SvyWeRLojsi9wGNy+rU
         LAxWyzqOMZzMBMUk+DxZ9n9X0RRJ3jDuYUTNf6U9MkM6R0EHA7UepyLlCvK5oeCdUJS2
         +cvELH0FMGUqBychfmmvi6xqkrzpZ/rpA057mme3xK5KOYXNY7Ar1KHDTjZyE6XQUxNy
         9Arg==
X-Gm-Message-State: AOJu0YztLSGOzy/Ztenkcr709lwTi69eF7WUKNXMYceEHYI91KsjqhRZ
        9m4nRVcBJAkI2L4IQMyx5bgu
X-Google-Smtp-Source: AGHT+IEbnZ5An5rfeR8TQKTpHfEHRlPnV15GqqvAmbaV4MRtIXV55yHwkiIiw6qRvj6rDgqFs1thjQ==
X-Received: by 2002:a05:620a:c54:b0:773:c6a1:a4ce with SMTP id u20-20020a05620a0c5400b00773c6a1a4cemr7691743qki.36.1696559176408;
        Thu, 05 Oct 2023 19:26:16 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id du33-20020a05620a47e100b0076db1caab16sm948320qkb.22.2023.10.05.19.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Oct 2023 19:26:15 -0700 (PDT)
Date:   Thu, 5 Oct 2023 22:26:14 -0400
From:   Mike Snitzer <snitzer@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Regressions <regressions@lists.linux.dev>,
        Tatu =?iso-8859-1?Q?Heikkil=E4?= <tatu.heikkila@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Device Mapper <dm-devel@redhat.com>,
        Alasdair Kergon <agk@redhat.com>
Subject: Re: dm crypt: Fix reqsize in crypt_iv_eboiv_gen
Message-ID: <ZR9wRq7Rkz+LocDX@redhat.com>
References: <f1b8d8f5-2079-537e-9d0f-d58da166fe50@gmail.com>
 <ZR9dEiXhQv-wBVA2@debian.me>
 <ZR9l446ndB4n1Xl4@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZR9l446ndB4n1Xl4@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 05 2023 at  9:41P -0400,
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Fri, Oct 06, 2023 at 08:04:18AM +0700, Bagas Sanjaya wrote:
> >
> > > Git bisect lead me to:
> > > # first bad commit: [e3023094dffb41540330fb0c74cd3a019cd525c2] dm crypt:
> > > Avoid using MAX_CIPHER_BLOCKSIZE
> > > 
> > > If I git revert e3023094dffb41540330fb0c74cd3a019cd525c2 on current Linus'
> > > git master, the issue goes away. So I'm personally not all that affected
> > > anymore (if I'm ready to compile my kernels from now on), and I understand
> > > that you have no clear way to reproduce this as it seems strongly bound to
> > > hardware, but seems like this could point to a potentially serious security
> > > issue since it involves both crypto and undefined behaviour.
> 
> Thanks for the report.  Sorry this is indeed my fault.  The allocated
> buffer is too small as it's missing the size for the request object
> itself.
> 
> Mike, would you be OK with me picking this fix up and pushing it to
> Linus?
> 
> Cheers,
> 
> ---8<---
> A skcipher_request object is made up of struct skcipher_request
> followed by a variable-sized trailer.  The allocation of the
> skcipher_request and IV in crypt_iv_eboiv_gen is missing the
> memory for struct skcipher_request.  Fix it by adding it to
> reqsize.
> 
> Fixes: e3023094dffb ("dm crypt: Avoid using MAX_CIPHER_BLOCKSIZE")
> Reported-by: Tatu Heikkil� <tatu.heikkila@gmail.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index f2662c21a6df..5315fd261c23 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -753,7 +753,8 @@ static int crypt_iv_eboiv_gen(struct crypt_config *cc, u8 *iv,
>  	int err;
>  	u8 *buf;
>  
> -	reqsize = ALIGN(crypto_skcipher_reqsize(tfm), __alignof__(__le64));
> +	reqsize = sizeof(*req) + crypto_skcipher_reqsize(tfm);
> +	reqsize = ALIGN(reqsize, __alignof__(__le64));
>  
>  	req = kmalloc(reqsize + cc->iv_size, GFP_NOIO);
>  	if (!req)

Sure, please do.  Shouldn't your header Cc: stable given that the
Fixes commit implies v6.5 needs this fix?

(sorry I missed this the first time I 'Reviewed-by' the original
commit)

Reviewed-by: Mike Mike Snitzer <snitzer@kernel.org>

Thanks,
Mike
