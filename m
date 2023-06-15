Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 008E9EB64DB
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Jun 2023 16:20:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbjFOQTe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Jun 2023 12:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234155AbjFOQTI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jun 2023 12:19:08 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8F62952
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jun 2023 09:19:06 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f8cec6641bso22266925e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jun 2023 09:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1686845945; x=1689437945;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vYWBqB+lSwhG8wORrnHLWYrtimD2ZM+aCUIorOoeBDs=;
        b=JIP18p220Cn8gTeeEDEWZ9vvN6ai5FZmR7HwbHVfknPADASswj8KY8eo3DQqEC6Siw
         tGghDo8+MZoUnUHAjPSsJMsKB4hdKlAkGOCCOCktVDEab/EyyyG3RitjY3HR8eJEpZE0
         k1SnS1gZ18dSfv2+70GLhmcq0wMVzZb1Zf/O71SC2+UNpnmZYQYYCbgim8iJf2AudYuy
         Szg3tPMpM7jh2DCGhCcTBePit8eW1apYDr1SIkmdzpu3ix8NnapBMPK01xaBAhz2apzl
         vnJ4ordrHGym2xfr0DqPjdlOi4towpcVpOpnI/4DELQdDnRNhyR34QDx1MjCObKhf3OW
         oB2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686845945; x=1689437945;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vYWBqB+lSwhG8wORrnHLWYrtimD2ZM+aCUIorOoeBDs=;
        b=BxVF4j9dye1b4xE58xo+lQzRnPQb0Xo6P4pfG6n3ZXQvq5TVgCh+ZuvNUYlUsRTTcp
         OrYsADebDc5SMS6zgwAMaeVhDGgMFlHZh+G86SiW4Ck8/4A6lKNMZ6bta4dMcNZqdemK
         rRwYn9hFbfkSNtRb1uQE37NcfguQTGMLoA3M67r3olHP1w639bTyZ2KGuALkVIjvRHA5
         9AQJwGOMWPAc7TSWuyaQcdaLqt+eBoaNv51xdeTU8JfylGwoHx8iZj1rtDFpX24InTtt
         pP18Rs/I5MIzk9EGj9NUTKbTo+RD5bTeoi/NBIyYk1nbnlLGjbK96Hp1WrecmCNGWyN2
         j7YQ==
X-Gm-Message-State: AC+VfDxf6+mPenyA1r5IOSGEGwFyH5VV7PyClE7XlBz1GchDn4aguOMk
        JDwS+WplsWwOpFDvYKUPHj/Bwe+twLmMdXCOtGs=
X-Google-Smtp-Source: ACHHUZ4xiHr1VKbX5NeyuOBIcDlSOCeMjQQ53SHspLWpdWC6Ufimksq4Zoqgb92AUWRxgzEufS7amg==
X-Received: by 2002:a7b:c84c:0:b0:3f6:76e:604b with SMTP id c12-20020a7bc84c000000b003f6076e604bmr14882510wml.0.1686845944780;
        Thu, 15 Jun 2023 09:19:04 -0700 (PDT)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id ja15-20020a05600c556f00b003f61177faffsm11354104wmb.0.2023.06.15.09.19.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jun 2023 09:19:04 -0700 (PDT)
Message-ID: <6aa4521f-e5d2-ed12-ab49-1132409ab358@arista.com>
Date:   Thu, 15 Jun 2023 17:19:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [v2 PATCH] crypto: api - Add __crypto_alloc_tfmgfp
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org, Bob Gilligan <gilligan@arista.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri05@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        linux-crypto@vger.kernel.org
References: <20230614174643.3836590-1-dima@arista.com>
 <20230614174643.3836590-3-dima@arista.com>
 <ZIrTQ1tN5LMuRB/5@gondor.apana.org.au>
Content-Language: en-US
From:   Dmitry Safonov <dima@arista.com>
In-Reply-To: <ZIrTQ1tN5LMuRB/5@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/15/23 10:00, Herbert Xu wrote:
[..]
> 
> Good catch.  Though I'd rather add the gfp argument to a separate
> function because I'm in the process of replacing ciphers with
> something that uses the new crypto_types API.
> 
> Once that happens ciphers will switch over to the normal cloning
> call and this can be removed.

LGTM, thanks!

> 
> ---8<---
> Use it straight away in crypto_clone_cipher(), as that is not meant to
> sleep.
> 
> Fixes: 51d8d6d0f4be ("crypto: cipher - Add crypto_clone_cipher")
> Signed-off-by: Dmitry Safonov <dima@arista.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/crypto/api.c b/crypto/api.c
[..]

Thanks,
           Dmitry

