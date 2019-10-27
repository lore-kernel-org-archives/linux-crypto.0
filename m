Return-Path: <SRS0=b68P=YU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C748FCA9EAF
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Oct 2019 10:08:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9480E20717
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Oct 2019 10:08:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VKNzI+eO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfJ0KI1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 27 Oct 2019 06:08:27 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33862 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbfJ0KI1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 27 Oct 2019 06:08:27 -0400
Received: by mail-wm1-f68.google.com with SMTP id v3so7403011wmh.1
        for <linux-crypto@vger.kernel.org>; Sun, 27 Oct 2019 03:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i2K85C0xh/mBwjLjwodqXpGNynU3855Gigp34MliOso=;
        b=VKNzI+eOmJOxBCAM/Nn3qMGme/HCb+OkV5LUbvkSHNDhs7RXVc3sCru4IyMxq2MygP
         s0kAjKXLZSM46eITbbWoJG02lOa+JoyqxVSWOqd0rOj0TdByrpvCusNlK0Q5LxpyHb6E
         T6GyiXVmznhxBYUdb6Bm1AdWWMRHaBBl7xpdPSJpBoBmqeZz2f2/2+ui3ksDNb7WKuIC
         NkZuKpfjqbb3oJhFUeLVUFSeRBK/HFnGKX+fCJIH0it9uMZvIVErGdnFl8QyIveztUAL
         r+CShUblbjf8SQDg3qfbgWrU7XI3d1HdMyRSfNGzpjRTlVXSds/LQylr2v/aH9RjwPzv
         h1Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i2K85C0xh/mBwjLjwodqXpGNynU3855Gigp34MliOso=;
        b=Ic0zFLhEQibH8XRzKqln0O0hhKeVU8QqZ2LIWHQjstNtJ4wTZhx0n10sz+f2DeXU0i
         9YKoOwOv6masoGs7dornAP/Gg3sjTiqtdV/0TM5ms10saLy7k9W75rOssZGbmDhAoPAy
         TItxVvGJ7FrwL9cKGIwh8mMeN16Owi0cKayNNtwFEe40qknkKix2XG2UlT/EPBDregEk
         6LaQFS/9hdnIQg+/G6oOe8JBJ4r5Z0qSyBBMSupnd+8smJ8atJgLmQ2GXAuBdxj/MvRK
         rAwxDGl5wq6PnpoSkWuRRohAdq00ANKGUP+p8p9j6PHanWE+4O5akI+3uJySikvdmRGY
         EDzg==
X-Gm-Message-State: APjAAAWW59JfZpl1bqVeUykBzB4ffq6xv3OIkHTinV4GEKz5oHNSUvDZ
        K4sjsTS3xAqrhhmQif1RHBc=
X-Google-Smtp-Source: APXvYqzEeREwdtLq3tet8l38gYbcO0zS6i1ak/6h1vadWiADIX/0/vypgnr9eDpT1LoPIovQrpLtHw==
X-Received: by 2002:a1c:5f82:: with SMTP id t124mr11557345wmb.114.1572170904822;
        Sun, 27 Oct 2019 03:08:24 -0700 (PDT)
Received: from debian64.daheim (p5B0D7E0E.dip0.t-ipconnect.de. [91.13.126.14])
        by smtp.gmail.com with ESMTPSA id 37sm13475991wrc.96.2019.10.27.03.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2019 03:08:23 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1] helo=debian64.localnet)
        by debian64.daheim with esmtp (Exim 4.92.3)
        (envelope-from <chunkeey@gmail.com>)
        id 1iOfTC-0002Ej-Lm; Sun, 27 Oct 2019 11:08:22 +0100
From:   Christian Lamparter <chunkeey@gmail.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        ebiggers@google.com
Subject: Re: [PATCH v4 24/32] crypto: amcc/aes - switch to AES library for GCM key derivation
Date:   Sun, 27 Oct 2019 11:08:22 +0100
Message-ID: <7787734.Led6RIzHno@debian64>
In-Reply-To: <20190702194150.10405-25-ard.biesheuvel@linaro.org>
References: <20190702194150.10405-1-ard.biesheuvel@linaro.org> <20190702194150.10405-25-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On Tuesday, July 2, 2019 9:41:42 PM CET Ard Biesheuvel wrote:
> The AMCC code for GCM key derivation allocates a AES cipher to
> perform a single block encryption. So let's switch to the new
> and more lightweight AES library instead.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  drivers/crypto/Kconfig              |  2 +-
>  drivers/crypto/amcc/crypto4xx_alg.c | 24 +++++++-------------
>  2 files changed, 9 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index b30b84089d11..c7ac1e6d23d4 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -311,7 +311,7 @@ config CRYPTO_DEV_PPC4XX
>  	depends on PPC && 4xx
>  	select CRYPTO_HASH
>  	select CRYPTO_AEAD
> -	select CRYPTO_AES
> +	select CRYPTO_LIB_AES

I think that getting rid of CRYPTO_AES was not a good idea here.
Reason being that the crypto4xx driver registers fallbacks to cover
edge-cases for AES-CTR, AES-CCM and AES-GCM modes that the hardware
is incapbale of handling itself.

So without the dependency of CRYPTO_AES, I think there's now a way
to build the crypto4xx module without necessarily having CRYPTO_AES.
And if that's the case then the necessary fallbacks cannot be
instantiated and the driver will not provide the afromentioned modes.

Can somebody clarify?

Regards,
Christian


