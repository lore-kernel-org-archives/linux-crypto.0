Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4E3AC6FA86
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Sep 2022 12:25:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiIPMZJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Sep 2022 08:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbiIPMZF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Sep 2022 08:25:05 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FA165D1
        for <linux-crypto@vger.kernel.org>; Fri, 16 Sep 2022 05:25:03 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id l10so21267862plb.10
        for <linux-crypto@vger.kernel.org>; Fri, 16 Sep 2022 05:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=8i595ScVfvbPbu+LaEm3qc6ZURJIa2TlR/vIE/ojjYs=;
        b=WqIipNu6gIrLKUKWbkptd71bGt7yxg8P3DQ0cdxEpJsyjDr/pyPxjjc+5MCLreh9OY
         TZyeDapU4nQsSrQIy44ZK5LaZ7xhmxujETC/J0kheM9LxuIf9c9q+WE1LWKZCk1/bfNj
         TLSxlSkzN5/PFYjwVB0t8uLLk/bpoTN0PoiQqBq4IbSystfWI7fbniXedQQwfZ2PgOd/
         YhzFeRa0bDqWQ/0Vt0tKUX6M+g+EOCisXgHyCPsh77VkIpKzil/FhK17MPxbeqoKZujd
         sNiuOWbsoAvxt7d4jf9KDo7XFhnVHQMyCUWazxzOqHPkD/71Ue3R9uA2K92hnUzl3AIp
         1s5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=8i595ScVfvbPbu+LaEm3qc6ZURJIa2TlR/vIE/ojjYs=;
        b=3qv0VLA9MErbPs6sOw8Q1ZcZc/eFBBIGTqHG9yr0etGNaycUxq83LuA0AKjMWUe+Rr
         fY+nsupEVGQBowRqtAWBILJADgyu5u015uhJRO1C/VOiKef91mssUXjKsb0UJLxuI/gX
         UvcefH7gOEDjBr2wfBQ1UikCZetblhl/KP0lpcqr/BEmAXc30Jp1OfOfSrjJ4+XiTVub
         v+b60x6Kljd/8nQX8EgBWWquvZ37Rx/eGIsxE1RlOO+eIslQumCm4nIc1uHeXfJJPEGv
         is1Wy3fTNm/MZ4ENN3e3B1yoI8FZE3WKUW6xyFuV3SX6hW2VjEWpiT05IQzV96piWNqa
         m2iQ==
X-Gm-Message-State: ACrzQf1n1h9zfsMIr8LZK24af4iDtqer1r5aS43338tfI9oVxixFB4Kj
        E//Mi2+dNkA83clirgL2wes=
X-Google-Smtp-Source: AMsMyM6NVH0MdybqbKu/VNc0hI8hZdyS30qiR4RbrgIaMBV1YDaQdonY3Gqru3BYijHhgH2xNCuGnQ==
X-Received: by 2002:a17:903:244b:b0:178:1c88:4a4c with SMTP id l11-20020a170903244b00b001781c884a4cmr4592535pls.95.1663331102499;
        Fri, 16 Sep 2022 05:25:02 -0700 (PDT)
Received: from [192.168.123.100] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id a20-20020aa794b4000000b00537a8d2c2easm14459430pfl.80.2022.09.16.05.24.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Sep 2022 05:25:01 -0700 (PDT)
Message-ID: <9347e2c1-d6c3-eb68-e3a6-d8d8dd22cc8f@gmail.com>
Date:   Fri, 16 Sep 2022 21:24:56 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v3 2/3] crypto: aria-avx: add AES-NI/AVX/x86_64/GFNI
 assembler implementation of aria cipher
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, jussi.kivilinna@iki.fi, elliott@hpe.com
References: <20220905094503.25651-1-ap420073@gmail.com>
 <20220905094503.25651-3-ap420073@gmail.com>
 <YyRVeS5h2GxZn04g@hirez.programming.kicks-ass.net>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <YyRVeS5h2GxZn04g@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Peter,

Thanks for your review!

2022. 9. 16. 오후 7:52에 Peter Zijlstra 이(가) 쓴 글:
 > On Mon, Sep 05, 2022 at 09:45:02AM +0000, Taehee Yoo wrote:
 >
 >> +.align 8
 >> +SYM_FUNC_START_LOCAL(__aria_aesni_avx_crypt_16way)
 >
 >    https://lkml.kernel.org/r/20220915111144.248229966@infradead.org
 >
 > Please remove all these random .align statements (for text).
 >

I will remove .align statements in the v4 patch.

Thanks a lot!
Taehee Yoo
