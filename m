Return-Path: <SRS0=vKz2=A6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4C14C433E0
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Jul 2020 19:42:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C782422CAE
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Jul 2020 19:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595187763;
	bh=6LTJUnGLZ6tds7pPsCSEsRZ75739WQiyjsg9sK+Q+R0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=jKK8PfQYW9W4t27aYqerCvtpLf7UJup1YfoZQI2iD8Wt1sCp53bdEatkfnUBfZK8V
	 nHn7U1wpMrgBDFenoyADkVXxUJMyMF1i4p5i+J/iMawtLZQPgKOjBFWZwpcIOq/s/z
	 kx4eCzV/nkUBe/H/+HuJxrD1ctwULdNdSILkCIA0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726093AbgGSTmn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 19 Jul 2020 15:42:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726073AbgGSTmm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 Jul 2020 15:42:42 -0400
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87B382176B;
        Sun, 19 Jul 2020 19:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595187760;
        bh=6LTJUnGLZ6tds7pPsCSEsRZ75739WQiyjsg9sK+Q+R0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jnPjTmr4OeQdxFZcOKzaZ/dMvJ/LwsWXTD0ASOn20uWifE1pRjioapM8beqJqBlc7
         9E+/aoGBgHyL7078fPI6Rp0jfLwXt7G/XX+YmLL9TltBodPy/TnkzteNWZLR4nm4r8
         TM1YJX9cqnb+zPKhgx+PKc5Wy9GbNA1dPxrv7xxs=
Received: by mail-oi1-f179.google.com with SMTP id k4so12762267oik.2;
        Sun, 19 Jul 2020 12:42:40 -0700 (PDT)
X-Gm-Message-State: AOAM531dqsiRR+I6sR2Q25eWjDXwmaJXZCQsS0CzjT+fu7HOfht9PW62
        PrNWoIQ60jjDSfIb1fRKF1O6tK0CKDaJQw44nKA=
X-Google-Smtp-Source: ABdhPJzLkJPj6LZsMFUVkScIOAd/UVcB+Mwuta/LAEAGxpYSmiu0pBlzFJgLo7PEkf4xOnyaRWGpaEJi5BUdrbmkdis=
X-Received: by 2002:aca:f257:: with SMTP id q84mr15941187oih.174.1595187759808;
 Sun, 19 Jul 2020 12:42:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200719162938.60161-1-grandmaster@al2klimov.de>
In-Reply-To: <20200719162938.60161-1-grandmaster@al2klimov.de>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sun, 19 Jul 2020 22:42:28 +0300
X-Gmail-Original-Message-ID: <CAMj1kXEzaa3BtNF9kgB=UGMx-uvosGwcUbdT3O2qZ1K0XhyUiQ@mail.gmail.com>
Message-ID: <CAMj1kXEzaa3BtNF9kgB=UGMx-uvosGwcUbdT3O2qZ1K0XhyUiQ@mail.gmail.com>
Subject: Re: [PATCH for v5.9] arm64: Replace HTTP links with HTTPS ones
To:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Brown <broonie@kernel.org>, hankecai@bbktel.com,
        hankecai@vivo.com,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 19 Jul 2020 at 19:29, Alexander A. Klimov
<grandmaster@al2klimov.de> wrote:
>
> Rationale:
> Reduces attack surface on kernel devs opening the links for MITM
> as HTTPS traffic is much harder to manipulate.
>
> Deterministic algorithm:
> For each file:
>   If not .svg:
>     For each line:
>       If doesn't contain `\bxmlns\b`:
>         For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
>           If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
>             If both the HTTP and HTTPS versions
>             return 200 OK and serve the same content:
>               Replace HTTP with HTTPS.
>
> Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>

Please do not modify  .S_shipped files or the .pl file that generates
them - they were taken from other projects, and should remain in sync
with their upstream counterparts.

> ---
>  Continuing my work started at 93431e0607e5.
>  See also: git log --oneline '--author=Alexander A. Klimov <grandmaster@al2klimov.de>' v5.7..master
>  (Actually letting a shell for loop submit all this stuff for me.)
>
>  If there are any URLs to be removed completely
>  or at least not (just) HTTPSified:
>  Just clearly say so and I'll *undo my change*.
>  See also: https://lkml.org/lkml/2020/6/27/64
>
>  If there are any valid, but yet not changed URLs:
>  See: https://lkml.org/lkml/2020/6/26/837
>
>  If you apply the patch, please let me know.
>
>  Sorry again to all maintainers who complained about subject lines.
>  Now I realized that you want an actually perfect prefixes,
>  not just subsystem ones.
>  I tried my best...
>  And yes, *I could* (at least half-)automate it.
>  Impossible is nothing! :)
>
>
>  Documentation/arm64/arm-acpi.rst        | 2 +-
>  arch/arm64/crypto/sha256-core.S_shipped | 2 +-
>  arch/arm64/crypto/sha512-armv8.pl       | 2 +-
>  arch/arm64/crypto/sha512-core.S_shipped | 2 +-
>  arch/arm64/lib/copy_template.S          | 2 +-
>  arch/arm64/lib/memcmp.S                 | 2 +-
>  arch/arm64/lib/memcpy.S                 | 2 +-
>  arch/arm64/lib/memmove.S                | 2 +-
>  arch/arm64/lib/memset.S                 | 2 +-
>  arch/arm64/lib/strcmp.S                 | 2 +-
>  arch/arm64/lib/strlen.S                 | 2 +-
>  arch/arm64/lib/strncmp.S                | 2 +-
>  arch/arm64/lib/strnlen.S                | 2 +-
>  13 files changed, 13 insertions(+), 13 deletions(-)
>
> diff --git a/Documentation/arm64/arm-acpi.rst b/Documentation/arm64/arm-acpi.rst
> index 872dbbc73d4a..8f675c38c244 100644
> --- a/Documentation/arm64/arm-acpi.rst
> +++ b/Documentation/arm64/arm-acpi.rst
> @@ -273,7 +273,7 @@ only use the _DSD Device Properties UUID [5]:
>
>     - UUID: daffd814-6eba-4d8c-8a91-bc9bbf4aa301
>
> -   - http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
> +   - https://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
>
>  The UEFI Forum provides a mechanism for registering device properties [4]
>  so that they may be used across all operating systems supporting ACPI.
> diff --git a/arch/arm64/crypto/sha256-core.S_shipped b/arch/arm64/crypto/sha256-core.S_shipped
> index 7c7ce2e3bad6..dd4867742a2e 100644
> --- a/arch/arm64/crypto/sha256-core.S_shipped
> +++ b/arch/arm64/crypto/sha256-core.S_shipped
> @@ -19,7 +19,7 @@
>  // Written by Andy Polyakov <appro@openssl.org> for the OpenSSL
>  // project. The module is, however, dual licensed under OpenSSL and
>  // CRYPTOGAMS licenses depending on where you obtain it. For further
> -// details see http://www.openssl.org/~appro/cryptogams/.
> +// details see https://www.openssl.org/~appro/cryptogams/.
>  // ====================================================================
>  //
>  // SHA256/512 for ARMv8.
> diff --git a/arch/arm64/crypto/sha512-armv8.pl b/arch/arm64/crypto/sha512-armv8.pl
> index 2d8655d5b1af..48c9da50b7ec 100644
> --- a/arch/arm64/crypto/sha512-armv8.pl
> +++ b/arch/arm64/crypto/sha512-armv8.pl
> @@ -20,7 +20,7 @@
>  # Written by Andy Polyakov <appro@openssl.org> for the OpenSSL
>  # project. The module is, however, dual licensed under OpenSSL and
>  # CRYPTOGAMS licenses depending on where you obtain it. For further
> -# details see http://www.openssl.org/~appro/cryptogams/.
> +# details see https://www.openssl.org/~appro/cryptogams/.
>  # ====================================================================
>  #
>  # SHA256/512 for ARMv8.
> diff --git a/arch/arm64/crypto/sha512-core.S_shipped b/arch/arm64/crypto/sha512-core.S_shipped
> index e063a6106720..421cb9977d39 100644
> --- a/arch/arm64/crypto/sha512-core.S_shipped
> +++ b/arch/arm64/crypto/sha512-core.S_shipped
> @@ -19,7 +19,7 @@
>  // Written by Andy Polyakov <appro@openssl.org> for the OpenSSL
>  // project. The module is, however, dual licensed under OpenSSL and
>  // CRYPTOGAMS licenses depending on where you obtain it. For further
> -// details see http://www.openssl.org/~appro/cryptogams/.
> +// details see https://www.openssl.org/~appro/cryptogams/.
>  // ====================================================================
>  //
>  // SHA256/512 for ARMv8.
> diff --git a/arch/arm64/lib/copy_template.S b/arch/arm64/lib/copy_template.S
> index 488df234c49a..fce1e070c13a 100644
> --- a/arch/arm64/lib/copy_template.S
> +++ b/arch/arm64/lib/copy_template.S
> @@ -6,7 +6,7 @@
>   * This code is based on glibc cortex strings work originally authored by Linaro
>   * be found @
>   *
> - * http://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
> + * https://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
>   * files/head:/src/aarch64/
>   */
>
> diff --git a/arch/arm64/lib/memcmp.S b/arch/arm64/lib/memcmp.S
> index c0671e793ea9..8b7c94917f98 100644
> --- a/arch/arm64/lib/memcmp.S
> +++ b/arch/arm64/lib/memcmp.S
> @@ -6,7 +6,7 @@
>   * This code is based on glibc cortex strings work originally authored by Linaro
>   * be found @
>   *
> - * http://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
> + * https://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
>   * files/head:/src/aarch64/
>   */
>
> diff --git a/arch/arm64/lib/memcpy.S b/arch/arm64/lib/memcpy.S
> index e0bf83d556f2..dc816480cebd 100644
> --- a/arch/arm64/lib/memcpy.S
> +++ b/arch/arm64/lib/memcpy.S
> @@ -6,7 +6,7 @@
>   * This code is based on glibc cortex strings work originally authored by Linaro
>   * be found @
>   *
> - * http://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
> + * https://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
>   * files/head:/src/aarch64/
>   */
>
> diff --git a/arch/arm64/lib/memmove.S b/arch/arm64/lib/memmove.S
> index 02cda2e33bde..3cd7ba7311e5 100644
> --- a/arch/arm64/lib/memmove.S
> +++ b/arch/arm64/lib/memmove.S
> @@ -6,7 +6,7 @@
>   * This code is based on glibc cortex strings work originally authored by Linaro
>   * be found @
>   *
> - * http://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
> + * https://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
>   * files/head:/src/aarch64/
>   */
>
> diff --git a/arch/arm64/lib/memset.S b/arch/arm64/lib/memset.S
> index 77c3c7ba0084..ff1e38b96d1c 100644
> --- a/arch/arm64/lib/memset.S
> +++ b/arch/arm64/lib/memset.S
> @@ -6,7 +6,7 @@
>   * This code is based on glibc cortex strings work originally authored by Linaro
>   * be found @
>   *
> - * http://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
> + * https://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
>   * files/head:/src/aarch64/
>   */
>
> diff --git a/arch/arm64/lib/strcmp.S b/arch/arm64/lib/strcmp.S
> index 4e79566726c8..9dab831b1558 100644
> --- a/arch/arm64/lib/strcmp.S
> +++ b/arch/arm64/lib/strcmp.S
> @@ -6,7 +6,7 @@
>   * This code is based on glibc cortex strings work originally authored by Linaro
>   * be found @
>   *
> - * http://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
> + * https://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
>   * files/head:/src/aarch64/
>   */
>
> diff --git a/arch/arm64/lib/strlen.S b/arch/arm64/lib/strlen.S
> index ee3ed882dd79..f981b639d549 100644
> --- a/arch/arm64/lib/strlen.S
> +++ b/arch/arm64/lib/strlen.S
> @@ -6,7 +6,7 @@
>   * This code is based on glibc cortex strings work originally authored by Linaro
>   * be found @
>   *
> - * http://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
> + * https://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
>   * files/head:/src/aarch64/
>   */
>
> diff --git a/arch/arm64/lib/strncmp.S b/arch/arm64/lib/strncmp.S
> index 2a7ee949ed47..0243547021b2 100644
> --- a/arch/arm64/lib/strncmp.S
> +++ b/arch/arm64/lib/strncmp.S
> @@ -6,7 +6,7 @@
>   * This code is based on glibc cortex strings work originally authored by Linaro
>   * be found @
>   *
> - * http://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
> + * https://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
>   * files/head:/src/aarch64/
>   */
>
> diff --git a/arch/arm64/lib/strnlen.S b/arch/arm64/lib/strnlen.S
> index b72913a99038..ffe5ba5a3387 100644
> --- a/arch/arm64/lib/strnlen.S
> +++ b/arch/arm64/lib/strnlen.S
> @@ -6,7 +6,7 @@
>   * This code is based on glibc cortex strings work originally authored by Linaro
>   * be found @
>   *
> - * http://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
> + * https://bazaar.launchpad.net/~linaro-toolchain-dev/cortex-strings/trunk/
>   * files/head:/src/aarch64/
>   */
>
> --
> 2.27.0
>
