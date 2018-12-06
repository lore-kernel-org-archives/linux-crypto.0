Return-Path: <SRS0=k6po=OP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C35DC04EB8
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Dec 2018 07:28:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 375A220989
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Dec 2018 07:28:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="jfZFDI3b"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 375A220989
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbeLFH2C (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Dec 2018 02:28:02 -0500
Received: from mail-it1-f196.google.com ([209.85.166.196]:56028 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728758AbeLFH2C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Dec 2018 02:28:02 -0500
Received: by mail-it1-f196.google.com with SMTP id o19so25730342itg.5
        for <linux-crypto@vger.kernel.org>; Wed, 05 Dec 2018 23:28:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+7jPy8xdQIZvTWDeVqJIYAa6QW99ZYIwcIv92ClUGoE=;
        b=jfZFDI3b2lqg/XqLpcFuAqIx1ZFNshLEjKr5NZL+rg/+pOcwYj+aF0J+Y1JEPAmZeh
         Y1+yGQq9f0mURbEwjizH9ZzfpA/+TpnxLbNN/XvCkJiq4C6h82jkm4aapy3W7cke89J5
         xrphNLVJp4aDzXMIIcsDxBiByEsc6AK0g/ZDk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+7jPy8xdQIZvTWDeVqJIYAa6QW99ZYIwcIv92ClUGoE=;
        b=hoOInWNo3v44IH7qygiG0EB1rmEpnM2uw2l7/MHlTX6bPywwI2o0Te0GUDKRAxWVjK
         E8BuXIRx+HQTI3iFLgeyIZhtGZWCUXjkBq0r+MpTLQt7nRg3cfWqZDo70O3WObGPsUEJ
         +HyNo9uft2Tm7MavAgBvVmiiS/pt5H/d0RY7WOdHdMw7nPNvzUqUehbPGeRSe7yeaShH
         BKmRlK4o6ZubRu3QgicW8QNHgR+sihCHvML85xflB+rKgDEa0PNfqPU4ntcnd6/FrpXh
         FBnosdoMOO8Zkrv/co8tA96i0IiaF7GtNiJ9GylYu65qdLn0lfRhx7EeGoVngt2a34+a
         6J0A==
X-Gm-Message-State: AA+aEWbyMrTeJcSv3cOgRPLL6VHvukRqKaOJh9c5pveclLQwlb6iHKq0
        sX3LMQt9HIulCqXWEjATmXpwUhT8Q7ZFCUrF3G5vWg==
X-Google-Smtp-Source: AFSGD/WiD/UxNVKdV/GleV1rrXcCC7wUs85QZMQdQLDsdqTnTJmJzZp21QMN0uhAde44toxA6NUvDiKwAJU2X0kNlRg=
X-Received: by 2002:a24:710:: with SMTP id f16mr16122519itf.121.1544081280834;
 Wed, 05 Dec 2018 23:28:00 -0800 (PST)
MIME-Version: 1.0
References: <20181206045413.32531-1-ebiggers@kernel.org>
In-Reply-To: <20181206045413.32531-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 6 Dec 2018 08:27:49 +0100
Message-ID:
 <CAKv+Gu9cZFG1=Wq0nwXL7LH-w65tGp9mBJb-7_NCgusEiwtSkw@mail.gmail.com>
Subject: Re: [PATCH] dm verity: log the hash algorithm implementation
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     device-mapper development <dm-devel@redhat.com>,
        "Alasdair G. Kergon" <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181206072749.e58pSdkE-fMwbOP9uF3RgiKPoBvl1S6pi7dWcIGBscY@z>

On Thu, 6 Dec 2018 at 05:54, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Log the hash algorithm's driver name when a dm-verity target is created.
> This will help people determine whether the expected implementation is
> being used.  It can make an enormous difference; e.g., SHA-256 on ARM
> can be 8x faster with the crypto extensions than without.  It can also
> be useful to know if an implementation using an external crypto
> accelerator is being used instead of a software implementation.
>
> Example message:
>
> [   35.281945] device-mapper: verity: sha256 using implementation "sha256-ce"
>
> We've already found the similar message in fs/crypto/keyinfo.c to be
> very useful.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  drivers/md/dm-verity-target.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index fc65f0dedf7f..f4c31ffaa88e 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -1040,6 +1040,15 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
>                 v->tfm = NULL;
>                 goto bad;
>         }
> +
> +       /*
> +        * dm-verity performance can vary greatly depending on which hash
> +        * algorithm implementation is used.  Help people debug performance
> +        * problems by logging the ->cra_driver_name.
> +        */
> +       DMINFO("%s using implementation \"%s\"", v->alg_name,
> +              crypto_hash_alg_common(v->tfm)->base.cra_driver_name);
> +
>         v->digest_size = crypto_ahash_digestsize(v->tfm);
>         if ((1 << v->hash_dev_block_bits) < v->digest_size * 2) {
>                 ti->error = "Digest size too big";
> --
> 2.19.2
>
