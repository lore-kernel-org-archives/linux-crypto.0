Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D31F5C25B50
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Jan 2023 19:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbjATTVS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Jan 2023 14:21:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbjATTVR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Jan 2023 14:21:17 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711FDC13DD
        for <linux-crypto@vger.kernel.org>; Fri, 20 Jan 2023 11:21:16 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id k10-20020a17090a590a00b0022ba875a1a4so3000022pji.3
        for <linux-crypto@vger.kernel.org>; Fri, 20 Jan 2023 11:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8SDRSdhk6EPykAw/g+Wl8hh3w6cuRY9QuwzZ8iaDbYE=;
        b=erXn/iE6iiZjbHA68rk3r66LhlmEmI7xCR/nOyeiE8l5IpFc7vk/4JEYq/P4spmPox
         uS4/kD5WPpbGZsniUvTUpGe9xZNDWMKs82nxqzsqaT1BqDz4RNqJQyJ42MfeAowuorwJ
         RvwxYIKQj26CjI54rPaQDEtVyzvyDffjT/cf0vhwdY539e+SZ9xQNuBaUDwx19qMtZ3L
         qX048waUOdaFW5AXRIgWF+NQDDYiU+TZVghGzHQGZ46YDO+rt6apX4QHcZJxSsjw7365
         ZxJ0jurd8opU6xSw6LvaScv02k7JxgVPdVGmN3mSBu+vEsKFmFMNWDq5+sSEZn4W6oFq
         QVOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8SDRSdhk6EPykAw/g+Wl8hh3w6cuRY9QuwzZ8iaDbYE=;
        b=3B0WKmmVuEbRG9R5hpon60HFuWBVDq8CfQazKdlYy1yaoGFdp+WxLCRZbf+6UoV2wf
         dB5RgXl6uh/Od+r9oQJyWHfH/QRQUeksn6prUJe0pX5TCkD51xYgwmILsjtNZX8FUWQD
         aek3QDnHBkJt599+O4pJCfYS0zAG858R80TncitrP8baqgZlutvZWpkJk2X637Dyo18F
         q17T7h6oUU9t4HlZKb7VTSJ5n6i4V6IVY+PDVgHxx/DI9LYV0ae7qxQAoEUL0wJaRydW
         2fKn9eUR+hNinqGuFuB3oNZ1bhWH2wd912H6DH6cXhoyta+wkM/t7f4KsOClaSqh763D
         xeNg==
X-Gm-Message-State: AFqh2kpaneNU34XyPymSFpSOIbf70EKImfZRSFoTtU70rIqy7HZc//Sf
        BVpQQD7yLBz3loLyremA4vnn+vkQS0WlxfT4ec7L/hkVjsbv
X-Google-Smtp-Source: AMrXdXuJbuMwEO0e7v3IjYffd4x3UmGyhnjQEzqwX4NQeML3LdO9TXhtdelhymz58k8pwIt5Px+CkOw7dym9Qnyw4lQ=
X-Received: by 2002:a17:90a:17a1:b0:229:9ffe:135b with SMTP id
 q30-20020a17090a17a100b002299ffe135bmr1700587pja.72.1674242475803; Fri, 20
 Jan 2023 11:21:15 -0800 (PST)
MIME-Version: 1.0
References: <20221207105430.248613-1-roberto.sassu@huaweicloud.com>
In-Reply-To: <20221207105430.248613-1-roberto.sassu@huaweicloud.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 20 Jan 2023 14:21:04 -0500
Message-ID: <CAHC9VhRSLh9y7KBCOhpvK2cwPmhyMr2dudhjcsEZ-Qmovi86Nw@mail.gmail.com>
Subject: Re: [PATCH] public_key: Add a comment to public_key_signature struct definition
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>, dhowells@redhat.com
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        zohar@linux.ibm.com, dmitry.kasatkin@gmail.com, jmorris@namei.org,
        serge@hallyn.com, ebiggers@kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 7, 2022 at 5:55 AM Roberto Sassu
<roberto.sassu@huaweicloud.com> wrote:
>
> From: Roberto Sassu <roberto.sassu@huawei.com>
>
> public_key_verify_signature() calls sg_set_buf() to set the signature and
> digest for the signature verification.
>
> As sg_set_buf() requires the buffer to be in physically contiguous memory,
> see commit ac4e97abce9b8 ("scatterlist: sg_set_buf() argument must be in
> linear mapping"), mention that in a comment for the signature and digest
> fields of the public_key_signature structure.
>
> Link: https://lore.kernel.org/linux-integrity/Y4pIpxbjBdajymBJ@sol.localdomain/
> Suggested-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>  include/crypto/public_key.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

This seems especially important considering the BUG_ON that could be triggered.

David, are you going to pick this up?

Reviewed-by: Paul Moore <paul@paul-moore.com>

> diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
> index 68f7aa2a7e55..6d623e063034 100644
> --- a/include/crypto/public_key.h
> +++ b/include/crypto/public_key.h
> @@ -37,8 +37,8 @@ extern void public_key_free(struct public_key *key);
>   */
>  struct public_key_signature {
>         struct asymmetric_key_id *auth_ids[3];
> -       u8 *s;                  /* Signature */
> -       u8 *digest;
> +       u8 *s;                  /* Signature (in physically contiguous mem) */
> +       u8 *digest;             /* Digest (in physically contiguous mem) */
>         u32 s_size;             /* Number of bytes in signature */
>         u32 digest_size;        /* Number of bytes in digest */
>         const char *pkey_algo;
> --
> 2.25.1

-- 
paul-moore.com
