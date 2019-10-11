Return-Path: <SRS0=ziyG=YE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80BECC47404
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 06:14:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CAE821A4A
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 06:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570774469;
	bh=7DibrgcQiO1KOMvh5FcN14C+/3TTbHwd3m9eREMTXnA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=i2VtcdyoAnLOb2MARwWElkYP5jFIEklmc/GAWelq+uOxlH2/rG9CmA6k9ty2rYCCO
	 B6nV0A3RCBJ8XYAd4aJPd8rIPAtXZ299j2/+a5hfn0nkbAyszPe5NCZ194LEV/Kdnx
	 XI4SzBnSo0oYY6siXac9bJPTLhC64AyvjdMKs2dA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbfJKGO2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Oct 2019 02:14:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726635AbfJKGO2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Oct 2019 02:14:28 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A69AF2196E;
        Fri, 11 Oct 2019 06:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570774468;
        bh=7DibrgcQiO1KOMvh5FcN14C+/3TTbHwd3m9eREMTXnA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UYJHxpr3LPqftYRCr0TX6VSSJK8Jlwb/3PKrRrSJmx0kF8aIbACW6RN28C9RsZ6j8
         0iwkMPJPdw2IcpOwLUbGuaeykW6WQmT6A+AAookVWD/QzVbqNfG5HbyEK1pKwsUjiv
         EXiGM+cDbA5T30Hef5ixYwoU8ONbKoID8VMNl2Co=
Date:   Thu, 10 Oct 2019 23:14:26 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>
Subject: Re: [PATCH v3 28/29] crypto: chacha20poly1305 - import construction
 and selftest from Zinc
Message-ID: <20191011061426.GE23882@sol.localdomain>
Mail-Followup-To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>
References: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
 <20191007164610.6881-29-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007164610.6881-29-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 07, 2019 at 06:46:09PM +0200, Ard Biesheuvel wrote:
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index b9b0e969a1ce..05e80d7d5e40 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -302,6 +302,13 @@ config CRYPTO_GCM
>  	  Support for Galois/Counter Mode (GCM) and Galois Message
>  	  Authentication Code (GMAC). Required for IPSec.
>  
> +config CRYPTO_LIB_CHACHA20POLY1305
> +	tristate "ChaCha20Poly1305 AEAD support (8-byte nonce library version)"
> +	depends on CRYPTO_ARCH_HAVE_LIB_CHACHA || !CRYPTO_ARCH_HAVE_LIB_CHACHA
> +	depends on CRYPTO_ARCH_HAVE_LIB_POLY1305 || !CRYPTO_ARCH_HAVE_LIB_POLY1305
> +	select CRYPTO_LIB_CHACHA
> +	select CRYPTO_LIB_POLY1305
> +
>  config CRYPTO_CHACHA20POLY1305
>  	tristate "ChaCha20-Poly1305 AEAD support"
>  	select CRYPTO_CHACHA20

Nit: The first kconfig option calls it "ChaCha20Poly1305" while the second calls
it "ChaCha20-Poly1305".

- Eric
