Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54A2EC636D6
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Feb 2023 15:34:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbjBIPes (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Feb 2023 10:34:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbjBIPeq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Feb 2023 10:34:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464255D3D0
        for <linux-crypto@vger.kernel.org>; Thu,  9 Feb 2023 07:33:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675956829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dbLt6F+gwrBulotnYld3uU03VSnKP9NZ32TkjNFNBxA=;
        b=JqXFd+Ahwpuov+vuW5SwsdFZeaDm9r87EAxa3HlNNP0PvkoU4ctx/CQgP0+R4/TV0gQ2Oe
        qL7UaczAeeLGup/YvB6Je4QOE6kQLeBv8DtobneCJ4MH1CUfciVAGSUOKinxAhPPQZpVN/
        RDSFuPVCQqAbpeUhUKQiGk1H70jYBI0=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-510-9fZ_L74IMqGlhiQ1C9xXCg-1; Thu, 09 Feb 2023 10:33:48 -0500
X-MC-Unique: 9fZ_L74IMqGlhiQ1C9xXCg-1
Received: by mail-pj1-f69.google.com with SMTP id s24-20020a17090aa11800b00230ffd3f340so1120840pjp.9
        for <linux-crypto@vger.kernel.org>; Thu, 09 Feb 2023 07:33:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dbLt6F+gwrBulotnYld3uU03VSnKP9NZ32TkjNFNBxA=;
        b=YDMqOVwe+hpWYCrDOw2Z/Snm/GjfH2Gxngs1bVlvTwPh1LHs012q9vY9t6052MA05t
         rDe2NTKRIJGZ2YvkshggPFTTM5Tv7N4DG0OdyW4xUO/PrQTmEejIKauMw1JmxfbjWxcB
         RDDunnN2sCCxSydjRdt4JscDC19MlTeLsXScuu8zqeX/TtOesd5Zy/LngQPHfoPaU+NE
         lSVJt6y3QO5Wik+vMmbi/hnTJWsBJOqGcXdfBONyTqhTeKfLuG/xQ62FWiH2qLZN6R1I
         rqSIMGqA/jDtnEIyyFkwY8gnzMhAh+0ZqgGz0c/Ef/7WY2uok6vZ1PBWkXnVbkQ4sgh6
         sVcg==
X-Gm-Message-State: AO0yUKVfOOqNIvVmQUp/PCfFi/YQyFPpmIUeahwPgFCEyjHULrsRSqOs
        M2CnyiOsX54XHfsZlboh9c2AP6FocBZaL1H+y6kfgh2ThQ4RHzITY2VDRZ2XEjoX6V5IpsbTzIo
        vKmWUibdx25tJhON8ASIEaMyResqJebsqszPmdhZAUxC+I5Dpmfs=
X-Received: by 2002:a62:1e86:0:b0:578:7983:9391 with SMTP id e128-20020a621e86000000b0057879839391mr2251077pfe.41.1675956826916;
        Thu, 09 Feb 2023 07:33:46 -0800 (PST)
X-Google-Smtp-Source: AK7set8qVfxmv4h099KVHWmbN1fl6YDVdNSs3nH8fLlu076RRZ8Kz907RZM29u/MXiHZ4lbdCjGVHUW4r91rXcNfsjg=
X-Received: by 2002:a62:1e86:0:b0:578:7983:9391 with SMTP id
 e128-20020a621e86000000b0057879839391mr2251071pfe.41.1675956826660; Thu, 09
 Feb 2023 07:33:46 -0800 (PST)
MIME-Version: 1.0
References: <Y+NrB5q1VcIIa+jk@gondor.apana.org.au>
In-Reply-To: <Y+NrB5q1VcIIa+jk@gondor.apana.org.au>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Thu, 9 Feb 2023 16:33:34 +0100
Message-ID: <CAFqZXNubjSeB38suRe5h6LTpXSi+7Qy8UqgfbiGMNikvHKRB8A@mail.gmail.com>
Subject: Re: [PATCH] crypto: testmgr - Disable raw RSA in FIPS mode
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Clemens Lang <cllang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 8, 2023 at 10:27 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> As FIPS is only able to verify the compliance of pkcs1pad the
> underlying "rsa" algorithm should not be marked as fips_allowed.
>
> Reported-by: Clemens Lang <cllang@redhat.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Seems to work as expected - with the patch I get the following lines
in the kernel console (in FIPS MODE:

[    0.961355] alg: rsa (rsa-generic) is disabled due to FIPS
[    0.962025] alg: self-tests for pkcs1pad(rsa-generic,sha512)
(pkcs1pad(rsa,sha512)) passed
[    1.119701] alg: self-tests for pkcs1pad(rsa-generic,sha256)
(pkcs1pad(rsa,sha256)) passed

So I take it the pkcs1pad(...) algos work (the tests passed), while
the plain rsa will not be usable.

On a kernel without the patch I get (in FIPS mode):

[    0.990012] alg: self-tests for rsa-generic (rsa) passed
[    0.990753] alg: self-tests for pkcs1pad(rsa-generic,sha512)
(pkcs1pad(rsa,sha512)) passed
[    1.301441] alg: self-tests for pkcs1pad(rsa-generic,sha256)
(pkcs1pad(rsa,sha256)) passed

Also, if I additionally apply [1], the "fips: yes/no" output in
/proc/crypto matches the expectations.

Tested-by: Ondrej Mosnacek <omosnace@redhat.com>

[1] https://lore.kernel.org/all/Y+RJfZ5o59azXqSc@gondor.apana.org.au/

>
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index dd748832ed4a..6fbb56c6bd4c 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -5467,7 +5467,6 @@ static const struct alg_test_desc alg_test_descs[] = {
>         }, {
>                 .alg = "rsa",
>                 .test = alg_test_akcipher,
> -               .fips_allowed = 1,
>                 .suite = {
>                         .akcipher = __VECS(rsa_tv_template)
>                 }
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>

--
Ondrej Mosnacek
Senior Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

