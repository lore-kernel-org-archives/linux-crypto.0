Return-Path: <SRS0=8F2V=WQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A4CEC3A589
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 10:08:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E681620C01
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 10:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1566295683;
	bh=xjzxPC39roF359iKa4+85RErHu2AaZeqNn0TAyH5nYs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=txPH/hILllfSNI5qcWivKmsihKGpWJX4cUHo8ZrrA5qbXbBFGI7cvRj+HmvOISMhe
	 MdgbQ3g5Of85ELPpV8n9czUp86P5g1L6UsqB2qpxyWacAJuxioNLbqECRPrgUyOG1V
	 KyuhxfLVV28Qv+ueib8tYJiJBcES45YE57rxtU3Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbfHTKIB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Aug 2019 06:08:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728771AbfHTKIA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Aug 2019 06:08:00 -0400
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F166C22D6D;
        Tue, 20 Aug 2019 10:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566295679;
        bh=xjzxPC39roF359iKa4+85RErHu2AaZeqNn0TAyH5nYs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=2dDvhxC0lxyuJ/Y0FeBCg8RXf0uP7HuEQX7TYEkmlMj9hOeq9bdzDiZdI4Ke3+rUm
         84SZ+vom60ztBDUGHB8bCXbnMf52NhscpAawCdftNwaYSgWpN0cchQ+IaqSW/6mTT3
         4W97ILc8PyDNR2Q9SsGJ/nR9FXZJtUkVEurMmpqQ=
Received: by mail-lf1-f41.google.com with SMTP id c19so3662549lfm.10;
        Tue, 20 Aug 2019 03:07:58 -0700 (PDT)
X-Gm-Message-State: APjAAAU1NKEtVtUM7O6Wvizba6lz+0vvK5Qjmn/IA+HJDxSiWQL6gmpb
        ANJs3MUMiLAiV5Xwijf8CbDUjVcABNHkRGDswi4=
X-Google-Smtp-Source: APXvYqyuG/lnZwuFpaUhl05E0h94z4MczW8DgBUl9IWhMZ+2cuyoudWu2K18OwHUjWYRjb/8kYdm3IP/jwEoegViumI=
X-Received: by 2002:a19:c20b:: with SMTP id l11mr14818137lfc.106.1566295677082;
 Tue, 20 Aug 2019 03:07:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190819142226.1703-1-ard.biesheuvel@linaro.org> <20190819142226.1703-2-ard.biesheuvel@linaro.org>
In-Reply-To: <20190819142226.1703-2-ard.biesheuvel@linaro.org>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Tue, 20 Aug 2019 12:07:45 +0200
X-Gmail-Original-Message-ID: <CAJKOXPeThmq9yOC9JkP6utdDYTszHeiW=VaBhNUSMOMYi8Tm+A@mail.gmail.com>
Message-ID: <CAJKOXPeThmq9yOC9JkP6utdDYTszHeiW=VaBhNUSMOMYi8Tm+A@mail.gmail.com>
Subject: Re: [PATCH 1/2] crypto: s5p - deal gracefully with bogus input sizes
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        Vladimir Zapolskiy <vz@mleia.com>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 19 Aug 2019 at 16:24, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> The s5p skcipher driver returns -EINVAL for zero length inputs, which
> deviates from the behavior of the generic ECB template, and causes fuzz
> tests to fail. In cases where the input is not a multiple of the AES
> block size (and the chaining mode is not CTR), it prints an error to
> the kernel log, which is a thing we usually try to avoid in response
> to situations that can be triggered by unprivileged users.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  drivers/crypto/s5p-sss.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
