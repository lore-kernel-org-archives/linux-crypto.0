Return-Path: <SRS0=tzqc=YR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=2.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09EFCC47E49
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 16:37:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1362205C9
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 16:37:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YAtBLeDH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503479AbfJXQhi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Oct 2019 12:37:38 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37445 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503426AbfJXQhi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Oct 2019 12:37:38 -0400
Received: by mail-wm1-f65.google.com with SMTP id q130so3077663wme.2
        for <linux-crypto@vger.kernel.org>; Thu, 24 Oct 2019 09:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cL0rL+e6dPKDcERGvr10gkiulVarZGNgQ3/VSDqHj5c=;
        b=YAtBLeDHbWOn/YlERVnaiSES7qY7hYVuwXWGd563zE7U6gbH4CQ5FKuJEBFbsCAji6
         TSh1agK5mGBNOQQ3EoQO2n9KepAuEaQhq2G8AbiordQ56cjYkzjQQ1DXZdpUbHt4eZjW
         yFdcmpWDKS05BUpPOfUWpGsZ6dXYzXDj+1Unmhr+U+rJF3zIYygcbBsjrYNBveqUObFb
         Rwub/7CpKq1421jTM3nTNG9Jta5mP6zSxbTbC5hVyOwUgGw69zIkDW8RuDv2bH1RDuo/
         pPiy0cD1gB30TQY02zDfLGUJB1+k36orE+zZKykQhGvR7UBtNWgKjl+cd4l7ysIn3xBW
         NEMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cL0rL+e6dPKDcERGvr10gkiulVarZGNgQ3/VSDqHj5c=;
        b=WKLj/hcniFEwCJydtxB0CR7vkt9oR1JpBzKpz9UDqN2vy9eqxjLPWurx6Zuk72j3V+
         23sKknfEmXvh8GYdS9Spc4aWgulMSOjht6xjtZC2V8ul/ukpjaoIjqtcvwtn66TSo888
         T8vi9c2w2jXkE9dt7ateQ5AIzohoeEJUm2oYkUaV2CIiHGESJI/e69mxfR27hA1Wiw1P
         zEBiLyeSkQ79qIlrdwVhOY35Ru8egfhj7m0UGU7mTSrp8Rg7qEz3QyHXv0lS0dFsnBi9
         qjxOv81uN8mhS2N9gCjCAAWLnQGBZlGBqkSxdEitxdXFOFDe7msLIc7F7Qz0N2g20SNL
         pTYw==
X-Gm-Message-State: APjAAAUrfvI6OLn6HZon2sOzZ7Q2BCjd/MValoAArahg3jKM/nRA3X2x
        dcbEVM2FXRvvKuVKcvlCDsDb/FhZ9NwJ9ZrHXCFEBg==
X-Google-Smtp-Source: APXvYqylfwXITwa47rYpFI4g7/0ubs6Lfh25RKhAQErmi+DSgj9X2/6yKW3cg5Hy5EvsbaKtQ48FdHlOTjHBFdv7BaQ=
X-Received: by 2002:a1c:9d07:: with SMTP id g7mr5777924wme.53.1571935055716;
 Thu, 24 Oct 2019 09:37:35 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1571934170.git.dsterba@suse.com>
In-Reply-To: <cover.1571934170.git.dsterba@suse.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 24 Oct 2019 18:37:24 +0200
Message-ID: <CAKv+Gu96H_N33dtLApBT_9LAwdSp3TDRsisMqjhh8mvaUecB9Q@mail.gmail.com>
Subject: Re: [PATCH v7 0/2] BLAKE2b generic implementation
To:     David Sterba <dsterba@suse.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 24 Oct 2019 at 18:28, David Sterba <dsterba@suse.com> wrote:
>
> The patchset adds blake2b reference implementation and test vectors.
>
> V7:
>
> Contents of include/crypto/blake2b.h moved to blake2b_generic.c, as the
> exported constants or structures are not needed by anything as for now.
>
> V1: https://lore.kernel.org/linux-crypto/cover.1569849051.git.dsterba@suse.com/
> V2: https://lore.kernel.org/linux-crypto/e31c2030fcfa7f409b2c81adf8f179a8a55a584a.1570184333.git.dsterba@suse.com/
> V3: https://lore.kernel.org/linux-crypto/e7f46def436c2c705c0b2cac3324f817efa4717d.1570715842.git.dsterba@suse.com/
> V4: https://lore.kernel.org/linux-crypto/cover.1570812094.git.dsterba@suse.com/
> V5: https://lore.kernel.org/linux-crypto/cover.1571043883.git.dsterba@suse.com/
> V6: https://lore.kernel.org/linux-crypto/cover.1571788861.git.dsterba@suse.com/
>
> David Sterba (2):
>   crypto: add blake2b generic implementation
>   crypto: add test vectors for blake2b
>

For the series,

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org> # arm64 big-endian



>  crypto/Kconfig           |  17 ++
>  crypto/Makefile          |   1 +
>  crypto/blake2b_generic.c | 435 +++++++++++++++++++++++++++++++++++++++
>  crypto/testmgr.c         |  28 +++
>  crypto/testmgr.h         | 307 +++++++++++++++++++++++++++
>  5 files changed, 788 insertions(+)
>  create mode 100644 crypto/blake2b_generic.c
>
> --
> 2.23.0
>
