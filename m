Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90D10EB64DB
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jun 2023 19:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjFTThF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Jun 2023 15:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjFTThE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jun 2023 15:37:04 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86681704
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jun 2023 12:37:03 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1b5018cb4dcso24415905ad.2
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jun 2023 12:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1687289823; x=1689881823;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w6ZvEIvPRbw9YNSa9BHGX9FrNyDby/XoggIiNhXPl28=;
        b=SdApUZ2IPk+Z6mxD9bFN0GFN1iJ7suUDIehCiJCdXHL8ldfd46S6J1UZsAE7iR7ZJU
         izpY2GNrrEI44t9EM/b20YnXDICrn/D8moO/8NEpzGwCAY1agUTJl+UdfJ5+8QpelNv+
         9K/j1tdea6Hu4niHWHT+P8KJGXmymypUFKnvQArKlpy2ea/+WMjZj3Ctz0BTjm2jg1va
         4gY93UCcuTq5K+M+NtQze22SfMEpp5TbyWWC0mQWc2knBTZqQ+3Ee2rqVJ4UXLO7/jNO
         04A2GOWTyfq0DDKKxvkII7dNF0kzyLukffby9J16G3VyQBOmXNpHq+pUsgDuRm2dqE6G
         Gv8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687289823; x=1689881823;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w6ZvEIvPRbw9YNSa9BHGX9FrNyDby/XoggIiNhXPl28=;
        b=Zce3gEoA0ItKxEnc7N9s+h2WyObG6G9sKfUSU1VeYRsyfSPByjsKivWb8j9bdVrEbz
         /AlV6/OaiIHsF61bVMNkxG73lr1Gsksa8idN9IfJ5WUBGCp6sAylw4aGS7fCU20Zjoe+
         /cK1+/xuGVh7RywpZudUqtMxo4NCleq2LVyu+qiobLuhG2D7OXWnmzSn1Z7ZzVb3F02w
         UfiiZh9rweHKLXjMj3dCTTDMNbVqoN/8DMmG5Vvc7d7H4DlEP0dElxzdYhdGuKwVnc/W
         qwOlbUhZQb/lZ6CwVpoxVy9buMfd0cmmz5UQcrzlxkxpJXziadMDWcbd75EMr7c1mlT/
         ZpEg==
X-Gm-Message-State: AC+VfDzQEv7Aqd59eoCzQIB8E/v43gG4ZbEJ90rw6m0cX0q3Muv5vLtE
        5X0pYeiHKWIll0opE3suvNZDsg==
X-Google-Smtp-Source: ACHHUZ4CTI6udmmYo/7mpA0VeK/ywfX4bUnFBYVGoDxs8EypawA8sKHygWNb2fbGKEDNZGXmOY1Gqw==
X-Received: by 2002:a17:902:f7d2:b0:1b5:450a:4b5e with SMTP id h18-20020a170902f7d200b001b5450a4b5emr3161005plw.17.1687289823442;
        Tue, 20 Jun 2023 12:37:03 -0700 (PDT)
Received: from [172.31.0.109] ([136.36.130.248])
        by smtp.gmail.com with ESMTPSA id i14-20020a170902c94e00b001ae2b94701fsm1996816pla.21.2023.06.20.12.37.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jun 2023 12:37:03 -0700 (PDT)
Message-ID: <75cf8335-af1f-e06c-c770-b2b540e812ed@ventanamicro.com>
Date:   Tue, 20 Jun 2023 13:37:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v5 1/4] RISC-V: add Zbc extension detection
Content-Language: en-US
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Conor Dooley <conor@kernel.org>
Cc:     heiko@sntech.de, Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, herbert@gondor.apana.org.au,
        davem@davemloft.net, Conor Dooley <conor.dooley@microchip.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, christoph.muellner@vrull.eu,
        heiko.stuebner@vrull.eu
References: <mhng-919a6ed5-c8b0-4311-9a8f-8c204b81a8e0@palmer-ri-x1c9a>
From:   Jeff Law <jlaw@ventanamicro.com>
In-Reply-To: <mhng-919a6ed5-c8b0-4311-9a8f-8c204b81a8e0@palmer-ri-x1c9a>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 6/20/23 13:09, Palmer Dabbelt wrote:
> On Mon, 12 Jun 2023 14:31:14 PDT (-0700), Conor Dooley wrote:
>> Hey Heiko,
>>
>> On Mon, Jun 12, 2023 at 11:04:39PM +0200, Heiko Stuebner wrote:
>>> From: Heiko Stuebner <heiko.stuebner@vrull.eu>
>>>
>>> Add handling for Zbc extension.
>>>
>>> Zbc provides instruction for carry-less multiplication.
>>>
>>> Signed-off-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
>>> ---
>>>  arch/riscv/Kconfig             | 22 ++++++++++++++++++++++
>>>  arch/riscv/include/asm/hwcap.h |  1 +
>>>  arch/riscv/kernel/cpu.c        |  1 +
>>>  arch/riscv/kernel/cpufeature.c |  1 +
>>>  4 files changed, 25 insertions(+)
>>
>> Plumbing into the hwprobe stuff would be nice, but that's not a
>> requirement for getting stuff merged :)
> 
> IIRC we talked about this on IRC, but IMO we shouldn't require something 
> be user visible for it to be merged in the kernel.
Note that exposing Zbc is potentially useful.  We've got GCC and LLVM 
code that can detect and rewrite a bitwise CRC into clmul.

Jeff
