From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] crypto: arm: ignore generated SHA2 assembly files
Date: Mon, 6 Jul 2015 08:56:15 +0200
Message-ID: <CAKv+Gu_CN1pH-4uEk0x6kScAvo_hBY-bZMcCeZNpKADYWGQFQQ@mail.gmail.com>
References: <e9fad4b90e8d3aac883e2a5ac99b330653bcc354.1436155417.git.baruch@tkos.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
To: Baruch Siach <baruch@tkos.co.il>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:35885 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbbGFG4P (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Jul 2015 02:56:15 -0400
Received: by igrv9 with SMTP id v9so147702622igr.1
        for <linux-crypto@vger.kernel.org>; Sun, 05 Jul 2015 23:56:15 -0700 (PDT)
In-Reply-To: <e9fad4b90e8d3aac883e2a5ac99b330653bcc354.1436155417.git.baruch@tkos.co.il>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 6 July 2015 at 06:03, Baruch Siach <baruch@tkos.co.il> wrote:
> These files are generated since commits f2f770d74a8d (crypto: arm/sha256 - Add
> optimized SHA-256/224, 2015-04-03) and c80ae7ca3726 (crypto: arm/sha512 -
> accelerated SHA-512 using ARM generic ASM and NEON, 2015-05-08).
>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  arch/arm/crypto/.gitignore | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/arm/crypto/.gitignore b/arch/arm/crypto/.gitignore
> index 6231d36b3635..31e1f538df7d 100644
> --- a/arch/arm/crypto/.gitignore
> +++ b/arch/arm/crypto/.gitignore
> @@ -1 +1,3 @@
>  aesbs-core.S
> +sha256-core.S
> +sha512-core.S
> --
> 2.1.4
>
