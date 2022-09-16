Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43510C54EE9
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Sep 2022 10:57:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbiIPK5G (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Sep 2022 06:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbiIPK4q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Sep 2022 06:56:46 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BF0175AE
        for <linux-crypto@vger.kernel.org>; Fri, 16 Sep 2022 03:44:42 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id l10so21040176plb.10
        for <linux-crypto@vger.kernel.org>; Fri, 16 Sep 2022 03:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=Ybw6x/sEIgft5n0Hs8+GsHpdeS7rV0eTKUU7WPuhZTE=;
        b=kDBXc+KoRCNU+VmJ/m07zdGZ8JSHd+Rru3+8cJVzhqWWtysVQ2sCS+h3mWECYzmBya
         aRmKrNPpGiggsQUK+4OFFftISgC85/zLaWR0YE7oHRkcp3XS1bUH81yrhc2ZUaQs9wfR
         Y23qdbJ4FAhjtPb6ubFkYCLI1AHpDitutssYqRm52QGo8MaUuY8Bj4ejcSYmrdOQItap
         LhEKlb4LmbBSnKeOw59Vrrwuw8WE8TiOPL11AS/j2vU4InlOWzizsJDMQCTR/bfIQgBK
         EZH6fw3BzkO3212vi0Ii1w2zywEfIX5/44YdlFj1ubVW+6Yun2tHF2+y38DAFLEBLmpR
         XoLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=Ybw6x/sEIgft5n0Hs8+GsHpdeS7rV0eTKUU7WPuhZTE=;
        b=SOR6feXO2XJV8mLtl25Qprap0ryZckcazeP8PG8XBmTrSvAzzyWqQ/qnTj0vg+PbhI
         tX/ITOTjEgJuWOzQu4OQL8J0IZ7OJOo2rTEsY9XHK8KvzgnTDwv8AeR6u15QK2UJkMiJ
         J/J9Aq1VldTY+TwUSkaYOZQQc+Dt4oTf8syaJtOodpaVlyRYVoH8Uu57KVfNgzKKg1QE
         bXQ/vN/SNzFXmJ/fITVOGpMy5XP7P7O43suFOZhe7abRgfJ32mPT1EmZoDV0NB0HH9+a
         LQfjh4TCKkg1nQszLVdoMRka/rfYHixGwuCXDk0OC5PPGVy4ovX0mOQQodqkgOk8hZtr
         8sGg==
X-Gm-Message-State: ACrzQf2qz36TJnBNT3d0J6N6q2fYoWkq+Zp0sL19PN23BeP/d1OCNDId
        lwZakm23ZI0jySjQBEGmvRk=
X-Google-Smtp-Source: AMsMyM4U+OMid9g4zjE/3diL0BlrATLZVCCbjayNcdWn787wXER98TMFs/N+5xceUoFYJGgtbfgvSQ==
X-Received: by 2002:a17:902:da8f:b0:178:399b:89bb with SMTP id j15-20020a170902da8f00b00178399b89bbmr4086567plx.57.1663325081568;
        Fri, 16 Sep 2022 03:44:41 -0700 (PDT)
Received: from [192.168.123.100] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id q9-20020a170902f34900b001768b6f9a97sm14419639ple.147.2022.09.16.03.44.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Sep 2022 03:44:40 -0700 (PDT)
Message-ID: <fdf50b63-2793-d0bb-04d2-aead6523ad91@gmail.com>
Date:   Fri, 16 Sep 2022 19:44:33 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v3 2/3] crypto: aria-avx: add AES-NI/AVX/x86_64/GFNI
 assembler implementation of aria cipher
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        jussi.kivilinna@iki.fi, elliott@hpe.com
References: <20220905094503.25651-1-ap420073@gmail.com>
 <20220905094503.25651-3-ap420073@gmail.com>
 <YyRPVxdZSAqvAXoL@gondor.apana.org.au>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <YyRPVxdZSAqvAXoL@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,
Thanks for your review!

2022. 9. 16. 오후 7:26에 Herbert Xu 이(가) 쓴 글:

 > On Mon, Sep 05, 2022 at 09:45:02AM +0000, Taehee Yoo wrote:
 >>
 >> +struct aria_avx_ops aria_ops;
 >
 > This creates a new sparse warning:
 >
 >    CHECK   ../arch/x86/crypto/aria_aesni_avx_glue.c
 > ../arch/x86/crypto/aria_aesni_avx_glue.c:34:21: warning: symbol 
'aria_ops' was not declared. Should it be static?
 >
 > Please fix.
 >

Thanks a lot, I checked it with C=1 option.
So I will fix this in the v4 patch.

Thanks a lot!
Taehee Yoo
