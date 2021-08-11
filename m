Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36EE6C4320A
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Aug 2021 13:46:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11BBF60FDA
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Aug 2021 13:46:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbhHKNrF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Aug 2021 09:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbhHKNrA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Aug 2021 09:47:00 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA02C0613D5;
        Wed, 11 Aug 2021 06:46:36 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id y18so4650945oiv.3;
        Wed, 11 Aug 2021 06:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=F37GbdbG8x6zZxW7E2S3oSydVR8XSIKpd+BuclgvdbI=;
        b=SkxDevPBNuYsMKmuMYu+kEpJ6cqAOdNJ0RImVUlmKNthWkAlhNILqnn8DXAGrBDWdQ
         JBGGhw2htCUCV1BuDdFbj17o/+tR863Z+UvemckllRTjiq1Pe2H/yr0k/3ySZGFIYTqw
         /aIt9FurFbCfbF+M2fRVp0ge9TWScvH980EUvc48AINQhF0ZuFjPCaQKCZV18ddmMjT6
         1pfSmIgtTjhxFmqZYmW7Y5vUiSEYCD5aiqZm3L67bArHXYfgyvczcXgJkn/yUcLRn3kd
         93wlloy6NjfhpDHRfX+KPQ7aakBn0urF0rF0bq5zaBsB4Jyz3CbYsj4RIszCZU5zbiiX
         rUIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F37GbdbG8x6zZxW7E2S3oSydVR8XSIKpd+BuclgvdbI=;
        b=eGTWVw6KiyuuUFdOOBsaJ+pu8kqLcR7Z2EmtIhznHHIwEBC9kkxmF4mo2DQClw/64F
         0oBV3iHO+97V+4J4EPft86S0hY8pwklHzN6p2551jXGGJ0csu2vdSQwmguBVVWoYxSc+
         txvn29GZG5cWgV8rvCXGlnaCNOYkYEs1sd3fwu8ssDTUxO/nPoQVQQdeYDk78qVn08JG
         i3XBdCOWTXleavIb85e6BZWCUjmfuEdj6+Arxk/6ukumfVJ5T5uWvfFBaIL9vXLg5pnM
         PdYPqQv5GEpVgsf4iDPSdjvED2Mf9jpyJ3mHUZgaAC61FKRbdTljFcLgIeBr6edOn6rz
         srzQ==
X-Gm-Message-State: AOAM530sgjBohIFntuj35ArLezOLssMwgnlXGNq0BR5GTnkA03PUQXoZ
        M60Sr8kVF9eOCMxymz/Di8yub8hoVj4=
X-Google-Smtp-Source: ABdhPJwNaWgAjCJvhVgTSEpjECrVL7hm2bY6OJrVg/EXEj+tg2XnvneMZyOL2PK/LpennKz9IFj1Cw==
X-Received: by 2002:a05:6808:c4:: with SMTP id t4mr10938837oic.150.1628689595631;
        Wed, 11 Aug 2021 06:46:35 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id q13sm3993576oov.6.2021.08.11.06.46.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 06:46:35 -0700 (PDT)
Subject: Re: [RFCv2 9/9] selftests: Initial TCP-AO support for fcnal-test
To:     Leonard Crestez <cdleonard@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        David Ahern <dsahern@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org
References: <cover.1628544649.git.cdleonard@gmail.com>
 <3f6d654c1c36f489b471e2892c9231d6fa8fad7a.1628544649.git.cdleonard@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <57493709-02c0-d77b-0b82-121894b58a49@gmail.com>
Date:   Wed, 11 Aug 2021 07:46:33 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <3f6d654c1c36f489b471e2892c9231d6fa8fad7a.1628544649.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 8/9/21 3:35 PM, Leonard Crestez wrote:
> Just test that a correct password is required.
> 

This test suite needs to be comprehensive that the UAPI works as
designed and fails when it should - cleanly and with an extack message
as to why some config option fails. Tests should cover the datapath -
that it works properly when it should and fails cleanly when it should
not. If addresses are involved in the configuration, then the tests need
to be written for non VRFs, with VRFs and default VRF since addresses
are relative.

Also, in tree test suites are best for the maintenance of this code
going forward.


