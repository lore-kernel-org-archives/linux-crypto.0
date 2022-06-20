Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86189C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jun 2022 21:15:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238141AbiFTVP4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Jun 2022 17:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237153AbiFTVPz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Jun 2022 17:15:55 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812DB25DE;
        Mon, 20 Jun 2022 14:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=NOD4Ws7rksMIS409LYtTljHyxW0iRWVoS9JjYrieCZA=; b=rh4oOFmE4f1xm+baCYzsrZWD6Z
        FpLjksiMeRLXOhvha4JCWs9iJaRN7Xj660vokilB971ZsZrD408lQhpGRkYzFxWbRYewpdfg/uYyc
        1rES7DdSmTUk1VpcE2/sckL1d4vNOPfVwhe17MzyBA05c/tVAwzsRE1J5ocXSEk21dIwN8iojqREH
        LBeV3Nyc4rOD8aJ0zMnrFu6Du4aJLfdx9GzVEb70TPsBqqxumKW9lJjoGPj2unS/Z/5puk62zrDrs
        DAD2DfcFFeJs8pb06lozkrgrZBDR9DjLpM5Do46c10kL1WS51t0h99JxkWhA/cDWdZmYE29u2aedf
        tGk7CcKw==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o3Ojh-009vPg-4e; Mon, 20 Jun 2022 21:15:22 +0000
Message-ID: <23bc9020-4519-65ba-725e-e7efd226c192@infradead.org>
Date:   Mon, 20 Jun 2022 14:15:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] crypto: fips - make proc files report fips module name
 and version
Content-Language: en-US
To:     Vladis Dronov <vdronov@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Simo Sorce <simo@redhat.com>
References: <20220620131618.952133-1-vdronov@redhat.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220620131618.952133-1-vdronov@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi--

On 6/20/22 06:16, Vladis Dronov wrote:
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 1d44893a997b..082ff03d9f6c 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -33,6 +33,27 @@ config CRYPTO_FIPS
>  	  certification.  You should say no unless you know what
>  	  this is.
>  
> +config CRYPTO_FIPS_NAME
> +	string "FIPS Module Name"
> +	default "Linux Kernel Cryptographic API"
> +	depends on (CRYPTO_FIPS)

No parentheses.

> +	help
> +	  This option sets the FIPS Module name reported by the Crypto API via
> +	  the /proc/sys/crypto/fips_name file.
> +
> +config CRYPTO_FIPS_CUSTOM_VERSION
> +	bool "Use Custom FIPS Module Version"
> +	depends on (CRYPTO_FIPS)

Ditto.

> +	default n
> +
> +config CRYPTO_FIPS_VERSION
> +	string "FIPS Module Version"
> +	default "(none)"
> +	depends on (CRYPTO_FIPS_CUSTOM_VERSION)

Ditto.

> +	help
> +	  This option provides the ability to override the FIPS Module Version.
> +	  By default the KERNELRELEASE value is used.

-- 
~Randy
