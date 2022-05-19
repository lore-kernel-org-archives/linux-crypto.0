Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35A2FC433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 19 May 2022 17:07:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242343AbiESRHT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 May 2022 13:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237863AbiESRHS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 May 2022 13:07:18 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C539C2CD
        for <linux-crypto@vger.kernel.org>; Thu, 19 May 2022 10:07:17 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id u23so10254689lfc.1
        for <linux-crypto@vger.kernel.org>; Thu, 19 May 2022 10:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZBzTfN538cxBF+q89A7MrTkcGPI553HZ7cX5UmHJfys=;
        b=B0Mu/43QbEIOlNIrY4EF6Nu9VKILrU5jInF7PJeWChpZlGVenW1CcucpwyTj5xpz2Z
         9BJ8VarPMzBRSmVfD8oVbg/DS4cvoIHaMVke/ZWI+u8FNxumHWBcEMh/ifz4r4ArBK79
         Izlrm8gSFCMY8EWlqttn/m0VKTJSwQxlLFdSGF5hbCXUMDxPgMsCNPhE822mEGsihzm8
         hDh9a6GVpgmwYpOxpjwsuP1EDOlU/7NgPHLphuwnYICM27RfSisYO58bc6btroxc3Huo
         GuEdhFK/AkvX68eTJmt8Xa30n5AOBcNCA7Gbk2rXpO9NAyaZVuae9c8d3wt3brM04Xkv
         aKFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZBzTfN538cxBF+q89A7MrTkcGPI553HZ7cX5UmHJfys=;
        b=3DpeEZlLq6K2+S4lHxOlno5z+PH1BUAt5yg9YbrKqNwg2Q5bFavNExrCCoszT+2DP4
         AP4lHjjHhUmNR4fA4lNkE401T6kzP17Y+gRAA2AQBJIszfbHwF07cT7Fwykth6rzmuSG
         D4s2jUClCSz0R3EjVP0wycJv1MLwEYs51s2e2zqfrQss6U1fKtb4lZnBbXY4O5TL2aex
         WcwzDdKExcKxXymVfmBSSHzjCNygPKTytM69x0s8S0h/vOjPgDDpRYzyJt9F7N2X7JPn
         EUyLgCVcMlC7j4kwrzOw8Ha5vzTsY8ODzLRTQDB5vtLP6tLxJda3oJMhwJApeLzZTY53
         0M/Q==
X-Gm-Message-State: AOAM531yvPcIB5FxNi9Le6aUCFjwgGjVLUAiX+BNy+KJ+WH7UpuaNGcc
        1nHoybpIcf6AeNEdNgilg6BieyFCkXALue8Pz5OnjQ==
X-Google-Smtp-Source: ABdhPJxxxdKP9TrSrJ1YhuI+eB9YOKpKXMYmaWR0EnKvCcI2zCLJBZAr1P2MAvT+1/RWMg3ZJu8s6kfpkgU7FL7qp3k=
X-Received: by 2002:a05:6512:23a6:b0:477:943a:818d with SMTP id
 c38-20020a05651223a600b00477943a818dmr3942903lfv.644.1652980035171; Thu, 19
 May 2022 10:07:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220518153126.265074-1-john.allen@amd.com>
In-Reply-To: <20220518153126.265074-1-john.allen@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Thu, 19 May 2022 10:07:03 -0700
Message-ID: <CAMkAt6p7YCZye7C974TLBzrXE3Wt=m6bFGOrV=p8g8w7P3fnbw@mail.gmail.com>
Subject: Re: [PATCH v4] crypto: ccp - Use kzalloc for sev ioctl interfaces to
 prevent kernel memory leak
To:     John Allen <john.allen@amd.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Nguyen <theflow@google.com>,
        David Rientjes <rientjes@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 18, 2022 at 8:31 AM John Allen <john.allen@amd.com> wrote:
>
> For some sev ioctl interfaces, input may be passed that is less than or
> equal to SEV_FW_BLOB_MAX_SIZE, but larger than the data that PSP
> firmware returns. In this case, kmalloc will allocate memory that is the
> size of the input rather than the size of the data. Since PSP firmware
> doesn't fully overwrite the buffer, the sev ioctl interfaces with the
> issue may return uninitialized slab memory.
>
> Currently, all of the ioctl interfaces in the ccp driver are safe, but
> to prevent future problems, change all ioctl interfaces that allocate
> memory with kmalloc to use kzalloc and memset the data buffer to zero
> in sev_ioctl_do_platform_status.
>
> Fixes: 38103671aad3 ("crypto: ccp: Use the stack and common buffer for status commands")
> Fixes: e799035609e15 ("crypto: ccp: Implement SEV_PEK_CSR ioctl command")
> Fixes: 76a2b524a4b1d ("crypto: ccp: Implement SEV_PDH_CERT_EXPORT ioctl command")
> Fixes: d6112ea0cb344 ("crypto: ccp - introduce SEV_GET_ID2 command")
> Cc: stable@vger.kernel.org
> Reported-by: Andy Nguyen <theflow@google.com>
> Suggested-by: David Rientjes <rientjes@google.com>
> Suggested-by: Peter Gonda <pgonda@google.com>
> Signed-off-by: John Allen <john.allen@amd.com>

Reviewed-by: Peter Gonda <pgonda@google.com>
