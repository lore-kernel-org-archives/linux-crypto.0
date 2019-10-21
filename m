Return-Path: <SRS0=EZON=YO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBE35CA9EB7
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 10:05:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 926F320684
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 10:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571652323;
	bh=pgSk2KtduBp9PVIz+N5OKtQK4nmDH7RPQ5MQnH3IydA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=n/WS9XXgDUWJeCO+pKQqAr0PEz7vKdlrMhm4TuXeFAIBfixIKvYooJXntcytzihl/
	 3EqhOvsa3ZNWQw+QbOHnKN3EZ0Mhgy0PGQ5DWmjzwusZtM89ehk8rMIAiqgJZiYNqU
	 3ZfHVxE32ErakdnB4huAbrlZboKeMRTvXhZf30u4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbfJUKFW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Oct 2019 06:05:22 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:38865 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727640AbfJUKFW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Oct 2019 06:05:22 -0400
Received: by mail-ed1-f66.google.com with SMTP id l21so9545580edr.5;
        Mon, 21 Oct 2019 03:05:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VIly/GOwYf9JLFy1KZhN7RsSTWZDQWPbQNHGbDM5vaQ=;
        b=X0mwRGFELBv7O9j88NXVr1S4VmvrFBVjtvLIMn9gg5ebCMAT0Bl8qWds9ACAyMo0Fr
         oOl99FsTSj5BU7g+QpemgdGTAWMOhvsOfp4bfUrX7XKDR9iFBEJQm0LFqzBF40hWG7eN
         8nnUmHVL8QwsJ+hUiredAQGKwfhNKj8/JIZxBgB6N1gj1eu0UB7S+NJuZpFnDTOkfbfK
         807wG9t27QV8d2O05j6S8F/taqCZAKgVtqRRPnW1tdzVhxU+FrQyNlR1MsLPdDdiNTlj
         UX3axoicR/amkhaM3z/yZ6EzMthLGOcj3xbD+fp2vDqOeFa4wRNchNMQBglRBKbCLzgw
         YiRQ==
X-Gm-Message-State: APjAAAXLdTETe5E1VhAlhZ+yX0rE5lVfblaBzMYl1D66lwxOLG0hG+E4
        aWXfvEILaQENpm89lYPIm8Y=
X-Google-Smtp-Source: APXvYqxQjjcwyceE7CWb0t81HxVmTXnzUIM+gkThYKYGIul4COny7XO62D/6deIRXBTPxyD2sN9ecg==
X-Received: by 2002:a05:6402:88c:: with SMTP id e12mr10387252edy.170.1571652320623;
        Mon, 21 Oct 2019 03:05:20 -0700 (PDT)
Received: from pi3 ([194.230.155.217])
        by smtp.googlemail.com with ESMTPSA id y7sm253102edb.97.2019.10.21.03.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 03:05:19 -0700 (PDT)
Date:   Mon, 21 Oct 2019 12:05:17 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Zapolskiy <vz@mleia.com>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 07/25] crypto: s5p - switch to skcipher API
Message-ID: <20191021100517.GA1780@pi3>
References: <20191014121910.7264-1-ard.biesheuvel@linaro.org>
 <20191014121910.7264-8-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191014121910.7264-8-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 14, 2019 at 02:18:52PM +0200, Ard Biesheuvel wrote:
> Commit 7a7ffe65c8c5 ("crypto: skcipher - Add top-level skcipher interface")
> dated 20 august 2015 introduced the new skcipher API which is supposed to
> replace both blkcipher and ablkcipher. While all consumers of the API have
> been converted long ago, some producers of the ablkcipher remain, forcing
> us to keep the ablkcipher support routines alive, along with the matching
> code to expose [a]blkciphers via the skcipher API.
> 
> So switch this driver to the skcipher API, allowing us to finally drop the
> blkcipher code in the near future.
> 
> Cc: Krzysztof Kozlowski <krzk@kernel.org>
> Cc: Vladimir Zapolskiy <vz@mleia.com>
> Cc: Kamil Konieczny <k.konieczny@partner.samsung.com>
> Cc: linux-samsung-soc@vger.kernel.org
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  drivers/crypto/s5p-sss.c | 191 ++++++++++----------
>  1 file changed, 91 insertions(+), 100 deletions(-)
> 
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index 010f1bb20dad..e6f1d4d5186c 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -303,7 +303,7 @@ struct s5p_aes_dev {
>  	void __iomem			*aes_ioaddr;
>  	int				irq_fc;
>  
> -	struct ablkcipher_request	*req;
> +	struct skcipher_request	*req;

You mix here indentation.

Beside that:

Acked-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
