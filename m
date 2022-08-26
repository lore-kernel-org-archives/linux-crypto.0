Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AA91ECAAA3
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Aug 2022 14:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343602AbiHZOmU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Aug 2022 10:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233859AbiHZOmT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Aug 2022 10:42:19 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB72D3E5D
        for <linux-crypto@vger.kernel.org>; Fri, 26 Aug 2022 07:42:18 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id ay39-20020a05600c1e2700b003a5503a80cfso966698wmb.2
        for <linux-crypto@vger.kernel.org>; Fri, 26 Aug 2022 07:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=lZLJoIWsXsqa+EaO47AoJNbezNHg+wFL+Ah5uTdYlwk=;
        b=KLyLNrCoJwl+5GwKMfIX792NGKHxwN6CwoN19TkfC9cJysJIjrduUKHxb0+yWzgPD0
         E1cvx9do1g7IrPPt+Pb7osZ9oZI02WQCKE4T8tBaK0SmdrzMqVx85I4eRc+XvcrVNTXG
         veK3oQmN5PqjIuWiG7Wfc8/opAook1+EgHPj1wr8CMYu1OZbJijFDAvEUlu26MiT5tNi
         fgKnVtCy9t4zDW5s8MkjjwWmalXolPLhHi2fJpdJ8l/lxTAq9aJ76hpYnOLly7cPNUcq
         +MKkcsxtNyAhqRvSkYFMBAsZJcbLwhOPPZypSTBaBzzbN31iaZvSrhAarROudcEp38Nk
         HQWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=lZLJoIWsXsqa+EaO47AoJNbezNHg+wFL+Ah5uTdYlwk=;
        b=2OZJE32cXaqm4CbGj8Bl7Gh1WX391xcI04H1AaXmYHyf08qzdMzdRHVcnP0h8UuCW2
         lE/y4T8b1Af7hwkyRWsc64Z/V+iK3oxOzhHrq37CuqK69Utb+v0uXDbsZbc+cInEoDjV
         q9rqQJcN+rwmmTzksExNj+qsN8PtNd45QpZkSZtMLO8cdgwxygd1FmG+T6oSCoz+FO9Z
         iVjL36azowTy7IMv4GamtB2j794xxb3kEN/zeyoZL57wJZonLpyofcEjdlB6ulr5Xar0
         fmt0gL5pqC2Gmb+EWOkDCpouNxGEDjWbwubpSum5+ixqHh+ICN3SNl2A8uv+Y2I2PBTE
         9KGQ==
X-Gm-Message-State: ACgBeo25Y7o22tpvtM2D0RqLTvK7lA8h6VFLEqQzCipwAspYCVPzu/Ju
        JVaiwod6SPrD3BasdzCLvUX2wA==
X-Google-Smtp-Source: AA6agR6DMgDGXJ3XhgJFIVcmP9tyyxiw62Mu4CdcheESQmuIWil8nfX+s4MTdQxlI0jsktqF1CsfAQ==
X-Received: by 2002:a1c:3b04:0:b0:3a5:487c:6240 with SMTP id i4-20020a1c3b04000000b003a5487c6240mr11564634wma.152.1661524936715;
        Fri, 26 Aug 2022 07:42:16 -0700 (PDT)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id t18-20020a5d49d2000000b00224f5bfa890sm2052764wrs.97.2022.08.26.07.42.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Aug 2022 07:42:16 -0700 (PDT)
Message-ID: <843fda3c-f1bd-61e0-e94d-38026ad98e5f@arista.com>
Date:   Fri, 26 Aug 2022 15:42:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 02/31] crypto_pool: Add crypto_pool_reserve_scratch()
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>, kbuild@lists.01.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Cc:     lkp@intel.com, kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        David Ahern <dsahern@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-crypto@vger.kernel.org
References: <202208221817.t5uzfegL-lkp@intel.com>
From:   Dmitry Safonov <dima@arista.com>
In-Reply-To: <202208221817.t5uzfegL-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Dan,

On 8/22/22 11:45, Dan Carpenter wrote:
> Hi Dmitry,
[..]
> "err" not set.  It was supposed to be set to zero at the start.  But
> better to say "ret = i;" here maybe?
> 
> Why is i unsigned?  It leads to unsightly casts.  Presumably some static
> checker insists on this... :/

Thanks! Will be addressed/reworked in v2.

Thank you,
          Dmitry
