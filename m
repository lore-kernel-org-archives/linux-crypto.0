Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20A53C6377D
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Jul 2021 04:46:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 045BC61248
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Jul 2021 04:46:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbhGVEGP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Jul 2021 00:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhGVEGM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Jul 2021 00:06:12 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B16C0613C1
        for <linux-crypto@vger.kernel.org>; Wed, 21 Jul 2021 21:46:47 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id t20so5799912ljd.2
        for <linux-crypto@vger.kernel.org>; Wed, 21 Jul 2021 21:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m+ImiuWzNqmI8K2PIEg02Mz48WRBGIbjXfLvvXNUNok=;
        b=uWoobcJ6wPxdEWQ+zIEubTT/8UDlnfjGagPUyBfi8xaCA10fP6SwaCCOkKMCSIDpFf
         ZzipP3NUALF4BWTE5GSTZtmVLDEdZTH/y+k3wWL0aQTTTkvi79qLts3pRTsakOypiQRm
         nWN5h8C7U4ia0J/3UaftG5jI4Xp7Iw7GzacJtRjtEKD6fXzOOT4+1r9fWjrCKEXar4xS
         P+fqjf21PBlGMVJq44L+ZIy8IHW2txYgxm8XbnsJ8B9K/gwnwJVVHxakfe7H8JqohLpF
         9c+kZPfZsUt5SapY+TluJ34w4B9yJHd9aESho97AfZQiy9g1oAgftcltdWWIcg0+j2Is
         RUOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m+ImiuWzNqmI8K2PIEg02Mz48WRBGIbjXfLvvXNUNok=;
        b=Ne5bwao7G3RJJBZeumXvV4e1prYQ4CAkJe8R6sYq2Kde6T0A/xoLzNZ+DXSJt5SZ3u
         bgfBCaq+EB42u0fNx671PcTHYZ1JNKd+xgV1wbriLY7LpIZSS2Z7F+Pr5VIiTFq8SoMq
         KMmjf0DHTeo4YZfclH1XpeHzGO6AaZ28XbIV0tKpHaNzjXzWItcKJZU9vExNsPziFRfW
         cm4+RAZC2O6VrKCTkZgLyRcm+0AORO7UsWFEXgPjyDvU+UZI3qsx3vuurESY1yc08MLn
         8+y8jDxN8+qkCe+WlldQ+QR9CXPpfXmxqL3U8816aRpLyGh7ZAfi3v4RmaCtlpMNYX89
         1x1g==
X-Gm-Message-State: AOAM531vFJisoBlGOUZ4MPR/6HMwGKsCZyl1ArsZQoVh+E/5dx9tEVY0
        4+aEIH+kKxcjt4a8Mlp08w9Pj6QJiczAta7VUda4Og==
X-Google-Smtp-Source: ABdhPJwpIXZELiOM8RYuH/iMiY6CUV6QgKd0XdEPCLARV9RJGVi/GRVX1zk7gJc80kEYUqwKhvkI+dY2lKZReh8xfjY=
X-Received: by 2002:a2e:5348:: with SMTP id t8mr32751947ljd.343.1626929205224;
 Wed, 21 Jul 2021 21:46:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210721160258.7024-1-a.fatoum@pengutronix.de>
In-Reply-To: <20210721160258.7024-1-a.fatoum@pengutronix.de>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Thu, 22 Jul 2021 10:16:32 +0530
Message-ID: <CAFA6WYPz048E7+LU=jefU=RrppuYd9Dgn1+jD6Dn8G=J9UJtpw@mail.gmail.com>
Subject: Re: [PATCH v2] KEYS: trusted: fix use as module when CONFIG_TCG_TPM=m
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        kernel <kernel@pengutronix.de>,
        Andreas Rammhold <andreas@rammhold.de>,
        David Gstir <david@sigma-star.at>,
        Richard Weinberger <richard@nod.at>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:SECURITY SUBSYSTEM" 
        <linux-security-module@vger.kernel.org>,
        linux-integrity <linux-integrity@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 21 Jul 2021 at 21:34, Ahmad Fatoum <a.fatoum@pengutronix.de> wrote:
>
> Since commit 5d0682be3189 ("KEYS: trusted: Add generic trusted keys
> framework"), trusted.ko built with CONFIG_TCG_TPM=CONFIG_TRUSTED_KEYS=m
> will not register the TPM trusted key type at runtime.
>
> This is because, after that rework, CONFIG_DEPENDENCY of the TPM
> and TEE backends were checked with #ifdef, but that's only true
> when they're built-in.
>
> Fix this by introducing two new boolean Kconfig symbols:
> TRUSTED_KEYS_TPM and TRUSTED_KEYS_TEE with the appropriate
> dependencies and use them to check which backends are available.
>
> This also has a positive effect on user experience:
>
>  - It's now possible to use TEE trusted keys without CONFIG_TCG_TPM
>  - It's now possible to enable CONFIG_TCG_TPM, but exclude TPM from
>    available trust sources
>  - TEE=m && TRUSTED_KEYS=y no longer leads to TEE support
>    being silently dropped
>
> Any code depending on the TPM trusted key backend or symbols exported
> by it will now need to explicitly state that it
>
>   depends on TRUSTED_KEYS && TRUSTED_KEYS_TPM
>
> The latter to ensure the dependency is built and the former to ensure
> it's reachable for module builds. This currently only affects
> CONFIG_ASYMMETRIC_TPM_KEY_SUBTYPE, so it's fixed up here as well.
>
> Reported-by: Andreas Rammhold <andreas@rammhold.de>
> Fixes: 5d0682be3189 ("KEYS: trusted: Add generic trusted keys framework")
> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> ---
>
> (Implicit) v1 was as a preparatory patch for CAAM trusted keys[1] with the
> goal of fixing the Kconfig inflexibility after the TEE trusted key rework.
>
> Unbeknownst to me, it also fixes a regression, which was later
> reported by Andreas[2] along with a patch.
>
> I split out the fix from the CAAM series and adjusted the commit
> message to explain the regression.
>
> v1 -> v2:
>   - Move rest of TPM-related selects from TRUSTED_KEYS to
>     TRUSTED_KEYS_TPM (Sumit)
>   - Remove left-over line in Makefile (Sumit)
>   - added Fixes: tag
>   - adjust commit message to reference the regression reported
>     by Andreas
>   - have ASYMMETRIC_TPM_KEY_SUBTYPE depend on TRUSTED_KEYS_TPM,
>     because it references global symbols that are exported
>     by the trusted key TPM backend.
>
> [1]: https://lore.kernel.org/linux-integrity/f8285eb0135ba30c9d846cf9dd395d1f5f8b1efc.1624364386.git-series.a.fatoum@pengutronix.de/
> [2]: https://lore.kernel.org/linux-integrity/20210719091335.vwfebcpkf4pag3wm@wrt/T/#t
>
> To: Jarkko Sakkinen <jarkko@kernel.org>
> To: James Morris <jmorris@namei.org>
> To: "Serge E. Hallyn" <serge@hallyn.com>
> To: James Bottomley <jejb@linux.ibm.com>
> To: Mimi Zohar <zohar@linux.ibm.com>
> To: Sumit Garg <sumit.garg@linaro.org>
> To: David Howells <dhowells@redhat.com>
> To: Herbert Xu <herbert@gondor.apana.org.au>
> To: "David S. Miller" <davem@davemloft.net>
> Cc: David Gstir <david@sigma-star.at>
> Cc: Richard Weinberger <richard@nod.at>
> Cc: keyrings@vger.kernel.org
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-security-module@vger.kernel.org
> Cc: linux-integrity@vger.kernel.org
> ---
>  crypto/asymmetric_keys/Kconfig            |  2 +-
>  security/keys/Kconfig                     | 18 ++++++--------
>  security/keys/trusted-keys/Kconfig        | 29 +++++++++++++++++++++++
>  security/keys/trusted-keys/Makefile       |  8 +++----
>  security/keys/trusted-keys/trusted_core.c |  4 ++--
>  5 files changed, 43 insertions(+), 18 deletions(-)
>  create mode 100644 security/keys/trusted-keys/Kconfig
>

Looks good to me apart from the minor comment below. With that fixed:

Reviewed-by: Sumit Garg <sumit.garg@linaro.org>

> diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
> index 1f1f004dc757..8886eddbf881 100644
> --- a/crypto/asymmetric_keys/Kconfig
> +++ b/crypto/asymmetric_keys/Kconfig
> @@ -25,7 +25,7 @@ config ASYMMETRIC_PUBLIC_KEY_SUBTYPE
>  config ASYMMETRIC_TPM_KEY_SUBTYPE
>         tristate "Asymmetric TPM backed private key subtype"
>         depends on TCG_TPM
> -       depends on TRUSTED_KEYS
> +       depends on TRUSTED_KEYS && TRUSTED_KEYS_TPM
>         select CRYPTO_HMAC
>         select CRYPTO_SHA1
>         select CRYPTO_HASH_INFO
> diff --git a/security/keys/Kconfig b/security/keys/Kconfig
> index 64b81abd087e..9ec302962fe2 100644
> --- a/security/keys/Kconfig
> +++ b/security/keys/Kconfig
> @@ -70,23 +70,19 @@ config BIG_KEYS
>
>  config TRUSTED_KEYS
>         tristate "TRUSTED KEYS"
> -       depends on KEYS && TCG_TPM
> -       select CRYPTO
> -       select CRYPTO_HMAC
> -       select CRYPTO_SHA1
> -       select CRYPTO_HASH_INFO
> -       select ASN1_ENCODER
> -       select OID_REGISTRY
> -       select ASN1
> +       depends on KEYS
>         help
>           This option provides support for creating, sealing, and unsealing
>           keys in the kernel. Trusted keys are random number symmetric keys,
> -         generated and RSA-sealed by the TPM. The TPM only unseals the keys,
> -         if the boot PCRs and other criteria match.  Userspace will only ever
> -         see encrypted blobs.
> +         generated and sealed by a trust source selected at kernel boot-time.
> +         Userspace will only ever see encrypted blobs.
>
>           If you are unsure as to whether this is required, answer N.
>
> +if TRUSTED_KEYS
> +source "security/keys/trusted-keys/Kconfig"
> +endif
> +
>  config ENCRYPTED_KEYS
>         tristate "ENCRYPTED KEYS"
>         depends on KEYS
> diff --git a/security/keys/trusted-keys/Kconfig b/security/keys/trusted-keys/Kconfig
> new file mode 100644
> index 000000000000..c163cfeedff6
> --- /dev/null
> +++ b/security/keys/trusted-keys/Kconfig
> @@ -0,0 +1,29 @@
> +config TRUSTED_KEYS_TPM
> +       bool "TPM-based trusted keys"
> +       depends on TCG_TPM >= TRUSTED_KEYS
> +       default y
> +       select CRYPTO
> +       select CRYPTO_HMAC
> +       select CRYPTO_SHA1
> +       select CRYPTO_HASH_INFO
> +       select ASN1_ENCODER
> +       select OID_REGISTRY
> +       select ASN1
> +       help
> +         Enable use of the Trusted Platform Module (TPM) as trusted key
> +         backend. Trusted keys are are random number symmetric keys,

s/are are/are/

-Sumit

> +         which will be generated and RSA-sealed by the TPM.
> +         The TPM only unseals the keys, if the boot PCRs and other
> +         criteria match.
> +
> +config TRUSTED_KEYS_TEE
> +       bool "TEE-based trusted keys"
> +       depends on TEE >= TRUSTED_KEYS
> +       default y
> +       help
> +         Enable use of the Trusted Execution Environment (TEE) as trusted
> +         key backend.
> +
> +if !TRUSTED_KEYS_TPM && !TRUSTED_KEYS_TEE
> +comment "No trust source selected!"
> +endif
> diff --git a/security/keys/trusted-keys/Makefile b/security/keys/trusted-keys/Makefile
> index feb8b6c3cc79..2e2371eae4d5 100644
> --- a/security/keys/trusted-keys/Makefile
> +++ b/security/keys/trusted-keys/Makefile
> @@ -5,10 +5,10 @@
>
>  obj-$(CONFIG_TRUSTED_KEYS) += trusted.o
>  trusted-y += trusted_core.o
> -trusted-y += trusted_tpm1.o
> +trusted-$(CONFIG_TRUSTED_KEYS_TPM) += trusted_tpm1.o
>
>  $(obj)/trusted_tpm2.o: $(obj)/tpm2key.asn1.h
> -trusted-y += trusted_tpm2.o
> -trusted-y += tpm2key.asn1.o
> +trusted-$(CONFIG_TRUSTED_KEYS_TPM) += trusted_tpm2.o
> +trusted-$(CONFIG_TRUSTED_KEYS_TPM) += tpm2key.asn1.o
>
> -trusted-$(CONFIG_TEE) += trusted_tee.o
> +trusted-$(CONFIG_TRUSTED_KEYS_TEE) += trusted_tee.o
> diff --git a/security/keys/trusted-keys/trusted_core.c b/security/keys/trusted-keys/trusted_core.c
> index d5c891d8d353..8cab69e5d0da 100644
> --- a/security/keys/trusted-keys/trusted_core.c
> +++ b/security/keys/trusted-keys/trusted_core.c
> @@ -27,10 +27,10 @@ module_param_named(source, trusted_key_source, charp, 0);
>  MODULE_PARM_DESC(source, "Select trusted keys source (tpm or tee)");
>
>  static const struct trusted_key_source trusted_key_sources[] = {
> -#if defined(CONFIG_TCG_TPM)
> +#if defined(CONFIG_TRUSTED_KEYS_TPM)
>         { "tpm", &trusted_key_tpm_ops },
>  #endif
> -#if defined(CONFIG_TEE)
> +#if defined(CONFIG_TRUSTED_KEYS_TEE)
>         { "tee", &trusted_key_tee_ops },
>  #endif
>  };
> --
> 2.30.2
>
