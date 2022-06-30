Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C754C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Jun 2022 07:22:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbiF3HWv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Jun 2022 03:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiF3HWv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Jun 2022 03:22:51 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58CE137A00
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jun 2022 00:22:50 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id x138so14635640pfc.3
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jun 2022 00:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=yO4KfhyIPZOlRyWZfTyoLEm2I68M9hNvZJ64WV/qAN8=;
        b=LS8Rd8duRBUssZrwzeeED6gRn0viDPx9ftesrP6vJigPQDxlYH+/oMQrQxFnGPWuRU
         1d2yCVzCOUGwXwxmmRovZzvYby8ccJMLnDohHWOgSSvZCbHwJzWNTVRIKylKv3HLhtaS
         7qQohwQLlb80w6mdpMETu2CZ1tyE5/KwZomY9CpCKCPuZ+BEPxt8Sde1uM//HRwDK8CU
         D/bucKKa1J416+ezo0/3Sz0gv1XTDdOf/FF02LU7kCb0WnT/TQjZmKb1qZ/LVACbZ5Im
         QYtSwS5KtGZeNmiWHDEHIFrYBq/Q93Qz3kzGcoLnSmRDrCtF1qBIl3YQkaarM1SVhWLp
         35Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yO4KfhyIPZOlRyWZfTyoLEm2I68M9hNvZJ64WV/qAN8=;
        b=ftwEJNMrvTTr+cMbPDIyETPgYxPMbKkVSbd2vIjejUdNwB5bkdD0zpZTN5JK2lTSGM
         scfduICjZxQNIgtSErvTPpoGesorxuj+WuHc3eKCvRdjHqGHbjM1bavhFMbjv/qOS9wm
         XZEg7eg4w4fj432B60Fpc596BJoDG/1Xjr0zghLl4ARcrIRvMPyrPVrWaRObgjCXsRhx
         oyvy2dmbdwLCUaKS+s8r+K5iUF67ULMQSPidh93IKv69YjVUl2FR6nOKAk5/wojwmvhq
         fWa4K6V2MmNBG3hkBgVU8/QJW4jkMNx0uvn0NHYGtOWXhJ2vu8Iu7T6T4C52Brl9yCiN
         x5yQ==
X-Gm-Message-State: AJIora8n9UvCaeYkOtuh6RIA5B7w+HtBdFKOlxAD2HdwSXKCjXcYRS03
        6cTloyQZ+YzQW16zubf488MW7A2i9R8=
X-Google-Smtp-Source: AGRyM1uReQkX4LTIoYiOARD9JextKDG60vzWBvFGLTr4n0rP1ocQwYBwvmkfsQrVO/eWmrekxLZ1+w==
X-Received: by 2002:a63:8f13:0:b0:40c:f042:13a8 with SMTP id n19-20020a638f13000000b0040cf04213a8mr6550064pgd.619.1656573769651;
        Thu, 30 Jun 2022 00:22:49 -0700 (PDT)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id y11-20020a17090322cb00b0016b953872aesm4312473plg.112.2022.06.30.00.22.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 00:22:49 -0700 (PDT)
Message-ID: <b273e4ed-311e-3821-c742-a7911046f2b5@gmail.com>
Date:   Thu, 30 Jun 2022 16:22:46 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 0/2] crypto: Introduce ARIA symmetric cipher algorithm
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, davem@davemloft.net
References: <Yr1FBOC8Zi1ltlBi@gondor.apana.org.au>
 <50203730-35f1-4bf9-3f3a-ca6cd3b01d4a@gmail.com>
 <Yr1N376O00fS0Skd@gondor.apana.org.au>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <Yr1N376O00fS0Skd@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/30/22 16:16, Herbert Xu wrote:
 > On Thu, Jun 30, 2022 at 04:13:19PM +0900, Taehee Yoo wrote:
 >>
 >> So, my plan is to add the kTLS feature because aria-TLS[2] is now 
standard.
 >> So, Is it okay to add the aria-kTLS feature into the v2 patch, 
instead of
 >> aria-IPsec?
 >
 > Sure.  As long as the kTLS people are happy to add this then it's
 > good to go.
 >
 > Cheers,

I will add aria-kTLS feature into the v2 patch and I will send it to 
both the crypto and netdev mailing list after some tests.

Thanks a lot!
Taehee Yoo
