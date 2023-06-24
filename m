Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF27AEB64DA
	for <linux-crypto@archiver.kernel.org>; Sat, 24 Jun 2023 07:41:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbjFXHlX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 24 Jun 2023 03:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbjFXHlW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 24 Jun 2023 03:41:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D062B2950
        for <linux-crypto@vger.kernel.org>; Sat, 24 Jun 2023 00:41:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AC3D60B86
        for <linux-crypto@vger.kernel.org>; Sat, 24 Jun 2023 07:41:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 984C2C433CC
        for <linux-crypto@vger.kernel.org>; Sat, 24 Jun 2023 07:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687592472;
        bh=avZPsBEagJV1X6yWFemzFd3KKpTlFWMQ2aBJ544GOm4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qY9v29XX/xhWJjTkHFbhoaIP1m6vqHppompViPqOnd/rTmHyq5EDBrKLXLXZHxwsr
         wfiKbYPV5LN9FXFCRHc5YSlOSUQOoi/nAex66is/yTBkjNefboCWRf9GMGUYJo9XuY
         VG5O6y5bLRpyZHcg7xS0fYrY7z1ZxFP+aBwc/iJQUY6O4cne5yOcnMlKqN6o2CDYTy
         SFAtJGBxjrHVLMZqLLIxiDf1pjkGmXHeRpISWAFjj6OEIdAhYYCblBDWj/RIpa2kl3
         ii8DtgXy2IV8PBwArZ7UtjSodar4Z/zP87oWkfdLONM/Z7ReGx3EGztbMHE7tXCR7H
         6z9pJJwUXZ1Rg==
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-4f871c93a5fso1907430e87.2
        for <linux-crypto@vger.kernel.org>; Sat, 24 Jun 2023 00:41:12 -0700 (PDT)
X-Gm-Message-State: AC+VfDw1jXsK2MBm0CRtll/9xUwOpoLdrVoj/X1pEjJa8ELzjTKOwoZ6
        Zn3mD850uCSUTK+LUs06Hig8SfRSLodsYihhgZs=
X-Google-Smtp-Source: ACHHUZ7+NKjRZFpsalZkjMNh2oIyWbdUyClJ8buxDj6a5GSz0vbyONo1glmlzVWeC8egy8/EeToXZf4pdRlV4y8MaGY=
X-Received: by 2002:a19:915d:0:b0:4ec:9ef9:e3d with SMTP id
 y29-20020a19915d000000b004ec9ef90e3dmr14682823lfj.26.1687592470554; Sat, 24
 Jun 2023 00:41:10 -0700 (PDT)
MIME-Version: 1.0
References: <202306231917.utO12sx8-lkp@intel.com> <ZJZ8/JifEeygojAq@gondor.apana.org.au>
In-Reply-To: <ZJZ8/JifEeygojAq@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 24 Jun 2023 09:40:59 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGKnusvWDV8rSUhQexeKy1e2+x2-ZXw6_6RiExvtiR_8A@mail.gmail.com>
Message-ID: <CAMj1kXGKnusvWDV8rSUhQexeKy1e2+x2-ZXw6_6RiExvtiR_8A@mail.gmail.com>
Subject: Re: [PATCH] crypto: sm2 - Provide sm2_compute_z_digest when sm2 is disabled
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 24 Jun 2023 at 07:20, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Fri, Jun 23, 2023 at 07:22:29PM +0800, kernel test robot wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> > head:   b335f258e8ddafec0e8ae2201ca78d29ed8f85eb
> > commit: e5221fa6a355112ddcc29dc82a94f7c3a1aacc0b [76/81] KEYS: asymmetric: Move sm2 code into x509_public_key
> > config: nios2-randconfig-r031-20230622 (https://download.01.org/0day-ci/archive/20230623/202306231917.utO12sx8-lkp@intel.com/config)
> > compiler: nios2-linux-gcc (GCC) 12.3.0
> > reproduce: (https://download.01.org/0day-ci/archive/20230623/202306231917.utO12sx8-lkp@intel.com/reproduce)
>
> ---8<---
> When sm2 is disabled we need to provide an implementation of
> sm2_compute_z_digest.
>
> Fixes: e5221fa6a355 ("KEYS: asymmetric: Move sm2 code into x509_public_key")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202306231917.utO12sx8-lkp@intel.com/
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/include/crypto/sm2.h b/include/crypto/sm2.h
> index 7094d75ed54c..04a92c1013c8 100644
> --- a/include/crypto/sm2.h
> +++ b/include/crypto/sm2.h
> @@ -13,7 +13,16 @@
>
>  struct shash_desc;
>
> +#if IS_REACHABLE(CONFIG_CRYPTO_SM2)
>  int sm2_compute_z_digest(struct shash_desc *desc,
>                          const void *key, unsigned int keylen, void *dgst);
> +#else
> +static inline int sm2_compute_z_digest(struct shash_desc *desc,
> +                                      const void *key, unsigned int keylen,
> +                                      void *dgst)
> +{
> +       return -ENOTSUPP;
> +}
> +#endif
>
>  #endif /* _CRYPTO_SM2_H */

How is this supposed to work when
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y but SM2 is configured as a
module?
