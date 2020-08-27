Return-Path: <SRS0=IKCX=CF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C68C8C433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 14:52:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7AE122B4E
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 14:52:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kZd6UaPO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728155AbgH0Owb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Aug 2020 10:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbgH0OwZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Aug 2020 10:52:25 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F23CC061264;
        Thu, 27 Aug 2020 07:52:25 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id u18so5443809wmc.3;
        Thu, 27 Aug 2020 07:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jaeNLpsr8Lq2JSXGOnPmF1qMG1fiYbDN5QhNqdIriF8=;
        b=kZd6UaPODsywloqPEXYGJE2wX1gHdTZH7hOlYW8yEjV/sq97IdGkfXMtF9vicvcwRm
         KcJyQ6o2yMsjJOL2+s192UFD0bsxxS+9VHF43c6vcTFiRYA7JDLbz4itwwtuolELeCXK
         D2VNogesiQaePTJ5fupCEAeBthgq8jr34crL+aE33HCzo/zMEoZ1+AaoQUkbz2wS0JfZ
         psKxwafIEd9ZDy5KlS+qQaVT6xOT2P6Fsr1JYIERjesbxs5g4hlcQcQEkAlYttZ8apv+
         0YL7sL5UUrNOOjQt0A/R761JJjb8zaiY6NOzhBoJaexFSe1nbXCV1eFPEsUyo5YxeGwL
         5qAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jaeNLpsr8Lq2JSXGOnPmF1qMG1fiYbDN5QhNqdIriF8=;
        b=OAHK8a5r4FIpOjsjJQ0GL3roSDlBZBTiQdvUMln9I3/GpeguALqFYDxVpoXdbydBCP
         lvncT+KFqJCgCFfjEaHO8caPRlXkJfMKbQFlBmLZRD56ztHuvRjDd9IsWCb7w8xNRyW1
         wNcdUU8cFuplZz0uaC+UbyOQTtq3es1jc4wWU2qqHAtesbvSope2Gh4BJZP3iuCZmXtA
         tRr9SO9U1lcKqsii0KMVanlso3PoZ/8aYmkYmUK6TF5l//ogxN6yRGSA3Red7DLgv1ik
         eHkAnD9ZEidoJEYnILONS0IK5jNJ1duGnBjoKTBzEoZYtNWlYp8DeCWj+icje5bPhflp
         4wiw==
X-Gm-Message-State: AOAM530d+x7G6wf8eutvHsa2fM0sb5SqzbIuzRVYHMSE82eKXNfG/DCm
        3umaIQrU3QgZk/S9IqKaLLQ=
X-Google-Smtp-Source: ABdhPJxObSFHl9EJZG44VyoYurqG2wa1VHgnKMJmUIawdImzxJvkV/78RYAh0OwF0PyYou3oscpcWA==
X-Received: by 2002:a1c:2dcc:: with SMTP id t195mr11553794wmt.166.1598539943771;
        Thu, 27 Aug 2020 07:52:23 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id q12sm6328221wrm.39.2020.08.27.07.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 07:52:23 -0700 (PDT)
Date:   Thu, 27 Aug 2020 16:52:21 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Denis Efremov <efremov@linux.com>, antoine.tenart@bootlin.com
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] crypto: inside-secure - use kfree_sensitive()
Message-ID: <20200827145221.GB14173@Red>
References: <20200827064402.7130-1-efremov@linux.com>
 <20200827064402.7130-2-efremov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827064402.7130-2-efremov@linux.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 27, 2020 at 09:43:59AM +0300, Denis Efremov wrote:
> Use kfree_sensitive() instead of open-coding it.
> 
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
>  drivers/crypto/inside-secure/safexcel_hash.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
> index 16a467969d8e..5ffdc1cd5847 100644
> --- a/drivers/crypto/inside-secure/safexcel_hash.c
> +++ b/drivers/crypto/inside-secure/safexcel_hash.c
> @@ -1082,8 +1082,7 @@ static int safexcel_hmac_init_pad(struct ahash_request *areq,
>  		}
>  
>  		/* Avoid leaking */
> -		memzero_explicit(keydup, keylen);
> -		kfree(keydup);
> +		kfree_sensitive(keydup);
>  
>  		if (ret)
>  			return ret;
> -- 
> 2.26.2
> 

The maintainer of this driver was not TO/CC.

I Add him.

Regards
