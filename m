Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E869C4332F
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Nov 2022 17:35:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbiKARfq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Nov 2022 13:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbiKARfp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Nov 2022 13:35:45 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AFB6354
        for <linux-crypto@vger.kernel.org>; Tue,  1 Nov 2022 10:35:42 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id o4so21145450wrq.6
        for <linux-crypto@vger.kernel.org>; Tue, 01 Nov 2022 10:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C78g1dyE8bjnWPnzl6S8kDNN8PhTwEKUokt9KJdMECI=;
        b=eMke/7lc/pqWu2ljT+MX01FQ0JIQ8b5E5agnLqc0KsI5u90IyBIa2N+iY/CJlVL1wy
         eiqu2GD8Ez2RvAgutiGeuVRmn+efM5//unR88M80F/iAjRII13HvCIV2V+H2WYV7vZZX
         WpzkSg+4sL24Z7qN1Toxn7U3AwNLRabUivWQsLFDaqdoAGovpc0C6c+tYsPq2whqMaXt
         4mgD6BsQ3k4cZD5p2EYk6VzcBu1mZboNN/l/dDD6KXGhTUIRSwaWXkKCJc0CjBWO7dpO
         KYRgMElPdsVnhTfVOYJdrPxLqUrdUrPozy3nH0NI7pUY6CoWOup6vvlER1zwpBcQaoWK
         AbLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C78g1dyE8bjnWPnzl6S8kDNN8PhTwEKUokt9KJdMECI=;
        b=gtyj9X9rlAg2f7BQyRT0qUBNNTeMzNJpOTfA12peMhmszkLOmx7Zz369z94L3idNJr
         UcNacT/Dkfk6CQIiGhioe1BhRX18n94naRtk5i4w7ZzQH4sLmlM/WSZ/WbLaALNhUbN8
         xuEfU4hwFgaZu0Rc3VMDz7JnJ16zN3jdZZBb1WYXTlSFPkP/UhdxwolCp1QiQdkhrCAE
         27ZeljHKwu6tjU+nsUArzN6hQBUH2a0g4B3TxegGeFVmA727SPAqGrYKuMhkEgABvaw8
         4ZS7hSJhHOlOVJdK0SW3P+/2VcCGGDSM9ovukJs2DLpZ0tRrhupMpDPpjgZBzpO1Rssh
         SoGg==
X-Gm-Message-State: ACrzQf1sREd9T5fBpvADR1dG1WdEZ7+irA45ijbD11TncdMsETtb7OYH
        cCD5N67UdzwRQOBP9obGaoT+TQ==
X-Google-Smtp-Source: AMsMyM4VDT7qWGP0Sg5b84gM2Bq786aWgi7tLXL6MQblBKadK7u986GU6Qfn9F0ol+vIPRkOfQOCqg==
X-Received: by 2002:a05:6000:504:b0:236:5fe9:883e with SMTP id a4-20020a056000050400b002365fe9883emr12523706wrf.65.1667324141107;
        Tue, 01 Nov 2022 10:35:41 -0700 (PDT)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id c192-20020a1c35c9000000b003c6f3f6675bsm11297413wma.26.2022.11.01.10.35.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Nov 2022 10:35:40 -0700 (PDT)
Message-ID: <5618b5e8-4ada-7d08-b7af-178a862f452b@arista.com>
Date:   Tue, 1 Nov 2022 17:35:41 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH v3 00/36] net/tcp: Add TCP-AO support
Content-Language: en-US
To:     David Ahern <dsahern@kernel.org>, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
References: <20221027204347.529913-1-dima@arista.com>
 <c0b6c5f1-9b4f-2d3d-69fd-533daa023e09@kernel.org>
From:   Dmitry Safonov <dima@arista.com>
In-Reply-To: <c0b6c5f1-9b4f-2d3d-69fd-533daa023e09@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi David,

On 11/1/22 02:22, David Ahern wrote:
> Thinking about how to move the TCP-AO intent forward: clearly a 36-patch
> set is a bit much. The first 6 patches are prep work, and we know there
> is a use case for those.
> 
> We could handle patches 3 and 4 as a stand alone set first.
> 
> Once merged, deal with the crypto API and users until those maintainers
> are good. That would be patches 1, 2, 5 and 6.
> 
> Once those are merged it drops down to just networking patches with
> selftests. Those can be split into AO (19) and selftests (11) making it
> 4 total sets of manageable size.
> 
> The AO patches can be reviewed until convergence on a good starting point.
> 
> Sound reasonable?

That sounds reasonable to me.
I'll submit patches 3 & 4 for review and then, once merged, 1, 2, 5 and
6. And later (re)-base TCP-AO on linux-next.

Thanks,
          Dmitry

