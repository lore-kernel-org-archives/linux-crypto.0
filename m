Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48707C77B7F
	for <linux-crypto@archiver.kernel.org>; Fri, 19 May 2023 14:42:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbjESOl6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 May 2023 10:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232032AbjESOl5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 May 2023 10:41:57 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB67613D
        for <linux-crypto@vger.kernel.org>; Fri, 19 May 2023 07:41:55 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f4249b7badso33532365e9.3
        for <linux-crypto@vger.kernel.org>; Fri, 19 May 2023 07:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1684507314; x=1687099314;
        h=content-transfer-encoding:in-reply-to:from:cc:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZPCIL09AOSqWQqhHIiNOjpVpg9ys42pH9qllL6EB20s=;
        b=KC0A8M82FSRL/w3Z+0G8RLwuRw/Qk03zulwBFRg3/hdqlst759Rz4XGxUIbHwWBC7E
         fMPl8XZyRJQsIKyw/Wa9pZh//XpMcpfcca39syIFkTwWy3zcy+z1hjLmIcnixYqg7jqB
         ly/61l24DfCGYwaUOmhDUGyMiE8YagWB24R+0fsepwW2SERyDUdFIer47xEM6hjEeKyL
         J99UuswxuJx7VDawy/YNH7aVF3Wp0dnruIPsleqsHFqbG3jNBk1D0JDa88HKiG7mcvW7
         JUrkvOcvMih8bgZznYc2dzP0syFcITerosfUuX3HSWiKW5q2rnPJxVdbadXUTcWCBRBd
         8jzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684507314; x=1687099314;
        h=content-transfer-encoding:in-reply-to:from:cc:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZPCIL09AOSqWQqhHIiNOjpVpg9ys42pH9qllL6EB20s=;
        b=WybuyOyfoeTv/FEMD4bsiorb68qw2W/kSfeZEqmDm3gNKvDvj7ayMzu2M+gingqdjW
         XPvbA7xqFlh/d4svb2+fydg8I62eHV+cGcx464ljVoRxz4K5FMqqcTtYJM9FzGr+jmte
         /NOAPMUY4g5/eBRcUH8IBtCM8ZdTOAcKFRT/+ZxSLFbdWGSMxc21BViLGjce+5LruuSe
         sDFVTLCnvWBJxGB+1WnX4n1++epYM+y7ph4mUvv9dMXRbOsEGebN0mi9tilcL0OhTxzK
         z1wvWcBhj9bBR8XSkVX4TlgcC42+WAcS/16bjEUh7nUUo9uT68DSX/wsrso/NZXSjAVU
         ureQ==
X-Gm-Message-State: AC+VfDz4ncIVfUuIrgKv8YH+mzJkvCGpO47wco8LJMGo9WIagpRfmU0d
        Prdn1bQ103zVjvJ5/dKyBFqVdw==
X-Google-Smtp-Source: ACHHUZ6Fv1Pzw1Fi3QT/Y7/GISidkfYh+x+0jaaTg7mLE9TBRave9jZ25l6kp6Y5J2PrgmwFWrd8QQ==
X-Received: by 2002:a7b:cbc4:0:b0:3f4:21ff:b91f with SMTP id n4-20020a7bcbc4000000b003f421ffb91fmr1523271wmi.28.1684507314420;
        Fri, 19 May 2023 07:41:54 -0700 (PDT)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id m25-20020a7bcb99000000b003f195d540d9sm2638102wmi.14.2023.05.19.07.41.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 May 2023 07:41:53 -0700 (PDT)
Message-ID: <4f72f65f-80de-6e15-b314-a4a5e4410d88@arista.com>
Date:   Fri, 19 May 2023 15:41:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 3/3] crypto: cmac - Add support for cloning
To:     Herbert Xu <herbert@gondor.apana.org.au>
References: <ZGcyuyjJwZhdYS/G@gondor.apana.org.au>
 <E1pzvTZ-00AnMQ-5M@formenos.hmeau.com>
Content-Language: en-US
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <error27@gmail.com>,
        David Laight <David.Laight@aculab.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri05@gmail.com>,
        Ivan Delalande <colona@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org
From:   Dmitry Safonov <dima@arista.com>
In-Reply-To: <E1pzvTZ-00AnMQ-5M@formenos.hmeau.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

Thanks for the patches!

On 5/19/23 09:28, Herbert Xu wrote:
> Allow hmac to be cloned.  The underlying cipher needs to support

Small nit ^cmac

> cloning by not having a cra_init function (all implementations of
> aes that do not require a fallback can be cloned).
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

I'll remove per-CPU request allocations and base version7 on this.

Thanks,
         Dmitry

