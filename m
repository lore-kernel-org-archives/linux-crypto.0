Return-Path: <SRS0=b68P=YU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00A33CA9EAF
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Oct 2019 09:51:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB15D20650
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Oct 2019 09:51:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="atSdeIus"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbfJ0Jvy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 27 Oct 2019 05:51:54 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38692 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbfJ0Jvy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 27 Oct 2019 05:51:54 -0400
Received: by mail-wr1-f67.google.com with SMTP id v9so6828208wrq.5
        for <linux-crypto@vger.kernel.org>; Sun, 27 Oct 2019 02:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7QehFsmbEUXBylp6I6c0hm1gnaW+3GE6hBpKIJOLIUE=;
        b=atSdeIusOWVh5qnTdrFHuao3J9beARpY5rsOQWusSPPET4sJGwRDZPzkQeoa1XEM7E
         rrOrBoEMwH5vqMse748k9GWIXC2OW42eG3wHy5bAmYZjjm7gmyecmXIzxNFQ5LIqmbTF
         oNneVaDnKZJNCgNFVNed3CubOjGFikctV6C0PiErzaCNJyQmR7+GvmcGT3pEhEgbwJzG
         +W75Nt+ake1Q6TVoQHaNyMVw+Jq08xL14S4XSSqwDRcdytiFwptRVzRRF0o+tVosrdg8
         2vUCx7KakFUI9DhFBK/3Gsmmhv76UIZS54yJ1wDGjPguO/mPof7STAXuIJw/kCenxqMY
         PO3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7QehFsmbEUXBylp6I6c0hm1gnaW+3GE6hBpKIJOLIUE=;
        b=UFEfs9rPeefQHQetwihOVZaqWdDMb1TTcA2cpN/XS1iriG9vh+3Nq6ox02lQHp4qWw
         dZg93/DWHflM0mWGwfWMYoQUP6ESNFs7jaggLCo/NA5fCTWj01NW42KLVXvHmBgXWArl
         7Cdo+kE+yD5Hblqjt6b5bAHBO1jrnbjTCC9fhG3z4N0wHQDoUeWJN0sqHTBDjwILu6RP
         33mpgWR6hsfhQjpcSc4IXBtSaMJovbXxDXvwD5GRZFNcjNO5uVr2yFMcu3mu4oealmKm
         hBVWzy3yVN8t6DXbwSo3LaAtp4F6A17J67wngqfmXfGkfBJybZzIU7YnQ6hoEfvyOgSP
         Hpsw==
X-Gm-Message-State: APjAAAV6QV8oM51MVpePjKjb2UPYmnIoV07o9wvkI+7AQWuX+y444k8P
        dMDnFUbuuErmr5ZYqF7j0yaKDw==
X-Google-Smtp-Source: APXvYqwXWJAx4TFkPZ/jCumpsKejQPTmJr2wPvincZSoLJ2tJSSMIhTLY8tM/NQHxD8/kDoyShHtMQ==
X-Received: by 2002:adf:fec7:: with SMTP id q7mr10818440wrs.267.1572169912002;
        Sun, 27 Oct 2019 02:51:52 -0700 (PDT)
Received: from [192.168.1.9] (hst-221-5.medicom.bg. [84.238.221.5])
        by smtp.googlemail.com with ESMTPSA id i3sm8067094wrw.69.2019.10.27.02.51.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Oct 2019 02:51:51 -0700 (PDT)
Subject: Re: [PATCH v2 20/27] crypto: qce - switch to skcipher API
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel@lists.infradead.org
References: <20191024132345.5236-1-ard.biesheuvel@linaro.org>
 <20191024132345.5236-21-ard.biesheuvel@linaro.org>
From:   Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <d587463d-2aa5-1ec3-ab0d-f4a985ec5551@linaro.org>
Date:   Sun, 27 Oct 2019 11:51:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191024132345.5236-21-ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ard,

Thanks for the patch!

On 10/24/19 4:23 PM, Ard Biesheuvel wrote:
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
> Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  drivers/crypto/qce/Makefile                     |   2 +-
>  drivers/crypto/qce/cipher.h                     |   8 +-
>  drivers/crypto/qce/common.c                     |  12 +-
>  drivers/crypto/qce/common.h                     |   3 +-
>  drivers/crypto/qce/core.c                       |   2 +-
>  drivers/crypto/qce/{ablkcipher.c => skcipher.c} | 172 ++++++++++----------
>  6 files changed, 100 insertions(+), 99 deletions(-)

Reviewed-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>

-- 
regards,
Stan
