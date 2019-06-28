Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB08C4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 05:08:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 001EA206E0
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 05:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561698502;
	bh=xFjUUYnHTlg0g5AYzulJrQaNU77kJnwSuVIIBo91h8E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=LKATX9j9CNJEGbwtZg6ZCWJ54g7riTCE5zKh7LXEdrB1Y7/2cJYOEJvi+qFX83HIg
	 MG73mc4d9K6NyS8ppGzZ8I4EM/6mhXyTy1dHd9wUEallQJ66JkeTeA/wtcUrOWePXd
	 KO74M/YlvJgx82j/KEHhT1W2uUEsbr2XoKw+R5vw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfF1FIA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 01:08:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726240AbfF1FIA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 01:08:00 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26E392086D;
        Fri, 28 Jun 2019 05:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561698478;
        bh=xFjUUYnHTlg0g5AYzulJrQaNU77kJnwSuVIIBo91h8E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Yo/rqnMJ4hlPwrOvSoY8j4fj8kRDmq/UzXkHIEsIiE55ez/1kSq9Sxw6kzUVUG87e
         Si78lWfLXiya9n/vIWVBJ7gX/mBLezd1CrKLb+sbBvcGjxcKDtZ/qLbfSBKiFHnXUW
         E85tlj7Bs+eB1YcVVsxR6PrA9SHIKThyel2Weehs=
Date:   Thu, 27 Jun 2019 22:07:56 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Keerthy <j-keerthy@ti.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        robh+dt@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        t-kristo@ti.com, linux-crypto@vger.kernel.org, nm@ti.com
Subject: Re: [RESEND PATCH 02/10] crypto: sa2ul: Add crypto driver
Message-ID: <20190628050756.GD673@sol.localdomain>
References: <20190628042745.28455-1-j-keerthy@ti.com>
 <20190628042745.28455-3-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190628042745.28455-3-j-keerthy@ti.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 28, 2019 at 09:57:37AM +0530, Keerthy wrote:
> The Security Accelerator (SA2_UL) subsystem provides hardware
> cryptographic acceleration for the following use cases:
> • Encryption and authentication for secure boot
> • Encryption and authentication of content in applications
>   requiring DRM (digital rights management) and
>   content/asset protection
> The device includes one instantiation of SA2_UL named SA2_UL0
> 
> SA2_UL supports the following cryptographic industry standards to enable data authentication, data
> integrity and data confidentiality.
> 
> Crypto function library for software acceleration
> o AES operation
> o 3DES operation
> o SHA1 operation
> o MD5 operation
> o SHA2 – 224, 256, 384, 512 operation
> 
> Authentication supported via following hardware cores
> o SHA1
> o MD5
> o SHA2 -224
> o SHA2-256
> o SHA2-384
> o SHA2-512

What about HMAC?  

Your actual driver only exposes HMAC-SHA*, not SHA* anything.

What does the hardware actually support?

> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 603413f28fa3..b9a3fa026c74 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -785,4 +785,21 @@ config CRYPTO_DEV_CCREE
>  
>  source "drivers/crypto/hisilicon/Kconfig"
>  
> +config CRYPTO_DEV_SA2UL
> +	tristate "Support for TI security accelerator"
> +	depends on ARCH_K3 || COMPILE_TEST
> +	select ARM64_CRYPTO
> +	select CRYPTO_AES
> +	select CRYPTO_AES_ARM64
> +	select CRYPTO_SHA1
> +	select CRYPTO_MD5
> +	select CRYPTO_ALGAPI
> +	select CRYPTO_AUTHENC
> +	select HW_RANDOM
> +	default m if ARCH_K3
> +	help
> +	  Keystone devices include a security accelerator engine that may be
> +	  used for crypto offload.  Select this if you want to use hardware
> +	  acceleration for cryptographic algorithms on these devices.

This shouldn't be enabled by default.  Note that arm64 defconfig sets ARCH_K3 as
well as lots of other ARCH_* options, so clearly just because ARCH_K3 is set
doesn't mean the kernel is being built specifically for your platform.

> +/*
> + * Mode Control Instructions for various Key lengths 128, 192, 256
> + * For CBC (Cipher Block Chaining) mode for encryption
> + */
> +static u8 mci_cbc_enc_array[3][MODE_CONTROL_BYTES] = {
> +	{	0x21, 0x00, 0x00, 0x18, 0x88, 0x0a, 0xaa, 0x4b, 0x7e, 0x00,
> +		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	},
> +	{	0x21, 0x00, 0x00, 0x18, 0x88, 0x4a, 0xaa, 0x4b, 0x7e, 0x00,
> +		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	},
> +	{	0x21, 0x00, 0x00, 0x18, 0x88, 0x8a, 0xaa, 0x4b, 0x7e, 0x00,
> +		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	},
> +};

Use 'const' for static constants.

> +static int sa_aes_cbc_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
> +			     unsigned int keylen)
> +{
> +	struct algo_data *ad = kzalloc(sizeof(*ad), GFP_KERNEL);

Need to check from error for all memory allocations.

> +static struct sa_alg_tmpl sa_algs[] = {
> +	{.type = CRYPTO_ALG_TYPE_ABLKCIPHER,

ablkcipher API is deprecated.  Use skcipher instead.

(To be clear, these are just a few things I happened to notice from very quickly
skimming through this patch.  I don't have time to do a proper review of random
drivers.)

- Eric
