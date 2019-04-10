Return-Path: <SRS0=kwSW=SM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEE8DC10F11
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 18:08:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83CD220830
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 18:08:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tRVXxfaU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731122AbfDJSIU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Apr 2019 14:08:20 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:43652 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729439AbfDJSIU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Apr 2019 14:08:20 -0400
Received: by mail-io1-f68.google.com with SMTP id x3so2949850iol.10
        for <linux-crypto@vger.kernel.org>; Wed, 10 Apr 2019 11:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=owKLFD4p/ewisZpQXc+TRYyqAmJwxjt/PR/5jJ/den4=;
        b=tRVXxfaUx6yqbOV+EjXkKuFKRLYsWbcD1r9ClergnWWTlWNqdU+qqRD3Er+4tMboZ3
         ltugMhB2xqsm1eH2N5EFDPVCAe5MLTFJtzBcpQSoADJFgSh5WuVXS3qfU/2jL9QDhYs5
         sPuND0SinBkgiAPdxrmMk8s94b9OA+sojxcODQULUpHcb0bRQfMhySHHkmNq1O++9mZA
         AHY8s7KTNysMRVOmJtrvqMFPu/R+S77PnXSqQJ6laXaaukQZ/1QpkIkXe1HSIuH/U8nF
         KjGsLilTb1ly4bB5UrKQky3X+P4mIsP4VLzrWiRb/rWOLghadzvHDR+rFMh+fXbYqnGQ
         wgig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=owKLFD4p/ewisZpQXc+TRYyqAmJwxjt/PR/5jJ/den4=;
        b=Yzyf96nCkzJiCJltupW5jDtTX87bP+u2AypCN5Eva8LfnZIWBj0k9SMRBamY4cIpG8
         oZvK6UPkLkyLj25fS1sYQaWsAWJHiPqSqofRRYt9iQcG6IYGx1x9ocWQVCCL0Spsp2Il
         C/wHvNeQA9F2MG5CH79/D2PBJhAn8UoxKbwwVpO01LPyoMzkjcG/tjtBxAjJLNC2XW1C
         vOsLWmZVco/8wh/fxUBEVRf0lMTc0WGQg9eRg++x6MGOv2Pjcx7+VUg+DLBl3uKQ4q4l
         S9n8LM9AxbvYCWzdPRmKLc/7IjULsa0BJuwbD3dnPCx2jaRgR3KWxjkFl0rILkYBv2o5
         br6Q==
X-Gm-Message-State: APjAAAUNsdKNRK2TFtfoOvsSwcvalQk1215K88A4cn3xgqVKZtsVvdaD
        PoyadoYfGfSfjq72Qd6THEJ/z78VQF+WTuqALpF+Ag==
X-Google-Smtp-Source: APXvYqxisy8AJDTJkvcOg8hPFA0NiN+zVDZq+bZDiHCpCKiI35qA82ns3PyLUbaAFZKArdEiZUfdCl0lN95hOo8qtOo=
X-Received: by 2002:a5d:840d:: with SMTP id i13mr22442354ion.186.1554919699276;
 Wed, 10 Apr 2019 11:08:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190410064635.11813-1-ebiggers@kernel.org>
In-Reply-To: <20190410064635.11813-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 10 Apr 2019 11:08:08 -0700
Message-ID: <CAKv+Gu83UP3xYPPN22dnDJyZ=CjONiGUXteXuBgxPVwh2_L-zQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] crypto: fixes in preparation of new fuzz tests
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 9 Apr 2019 at 23:48, Eric Biggers <ebiggers@kernel.org> wrote:
>
> This series contains the remaining fixes in preparation of the
> comparison fuzz tests I've proposed in the series
> "crypto: fuzz algorithms against their generic implementation".
>
> I will send a new version of the testmgr patches separately.
>
> These fixes and my latest tests can also be retrieved from git at:
>
>         Repository: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
>         Branch: cryptofuzz-vs-generic
>
> Eric Biggers (7):
>   crypto: lrw - don't access already-freed walk.iv
>   crypto: salsa20 - don't access already-freed walk.iv
>   crypto: arm/aes-neonbs - don't access already-freed walk.iv
>   crypto: arm64/aes-neonbs - don't access already-freed walk.iv
>   crypto: gcm - fix incompatibility between "gcm" and "gcm_base"
>   crypto: ccm - fix incompatibility between "ccm" and "ccm_base"
>   crypto: vmx - return correct error code on failed setkey
>

For the series

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

>  arch/arm/crypto/aes-neonbs-glue.c   |  2 ++
>  arch/arm64/crypto/aes-neonbs-glue.c |  2 ++
>  crypto/ccm.c                        | 43 ++++++++++++-----------------
>  crypto/gcm.c                        | 32 ++++++---------------
>  crypto/lrw.c                        |  4 ++-
>  crypto/salsa20_generic.c            |  2 +-
>  drivers/crypto/vmx/aes.c            |  7 +++--
>  drivers/crypto/vmx/aes_cbc.c        |  7 +++--
>  drivers/crypto/vmx/aes_ctr.c        |  5 ++--
>  drivers/crypto/vmx/aes_xts.c        |  9 +++---
>  10 files changed, 50 insertions(+), 63 deletions(-)
>
> --
> 2.21.0
>
