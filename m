Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7798C4338F
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Jul 2021 10:13:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BED78608FE
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Jul 2021 10:13:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbhGWJdT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Jul 2021 05:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbhGWJdT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jul 2021 05:33:19 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00C6C061575
        for <linux-crypto@vger.kernel.org>; Fri, 23 Jul 2021 03:13:52 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id c18so884669qke.2
        for <linux-crypto@vger.kernel.org>; Fri, 23 Jul 2021 03:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=ztFrdeKS6YAJ7D5SqhTw5S3JxKf0OcDAtcpZaltM+o0=;
        b=hDS150YQ3YzkQE0H637H8Vj2dF0gS6QCZ4yWYcdgAz8zjextcal9EM0ZkBjlPrxURh
         C0xYftJzVFPjt6YLSGuU5VSgOxQvYOsm9tdzDHtEYG84NNNTUUASDf1/hmBR/0HA/H1/
         eqCUJz9uQOfFYLoHh61biklPp39RwrJt0Dmj+jfBxr8g9DDF1dm+tZ5Qf1wZdgm+/yD3
         iuGQfWCv5ZOHNVwQPQ/r/ViKWSBB0Zk9hvPOWrTHiF7z04aeuPO7/vCbkYw9LOyZVQKV
         7qLrjaIfXQUHO6kyL1I4OOdxoc+kUpGXezSjgbyYPnPhMer5IGp/4T2Efsfer37WsAWO
         zubQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ztFrdeKS6YAJ7D5SqhTw5S3JxKf0OcDAtcpZaltM+o0=;
        b=Xgq61f914kA+0zt6mtNrAJT2DxtoBt7unoaU5EmvqMymvXQgk8EzT5PFIM7wi135Gx
         2vekgKLOdhx7ImqzIEn/aihuMGGroIYEMBmMIKTJL9dMkYnYfH9xm7f/yUM/cCetPCzG
         1Zs50oT0gK0MSaSRkU6xlkeYyJ4pSi6aD0kIYMQeQWwjyl9xidAhuF/7tol0Eg1L8tEt
         YUwpdv+GijldfImrTttF6JTFbAc3Hq54GkiEpcB0BidhZ1dPz0AqF4hPOhXNI4U+Z4uT
         WsROdWDx/2uUKvIkTcwlC/5kXtzaOkR7myq2KWiIAgQ3la2jYmkUmTbsOKAjIv05u8fX
         evyQ==
X-Gm-Message-State: AOAM532NLChni5riiy1dsIbz8mJJ78ynC/KpOcrgofo5BO2KQAfnfLXo
        JX3aoP5RjJJ4ZrJqjq8llkCbeYwmgXDD6A==
X-Google-Smtp-Source: ABdhPJzjJTSnf85huoYr/fMTApdyV3Lf0fPe5s3iLztcBGUtOCKHVJVrg5+OWDdTPPlHoy0ByILSsQ==
X-Received: by 2002:a05:620a:49e:: with SMTP id 30mr3807494qkr.230.1627035231542;
        Fri, 23 Jul 2021 03:13:51 -0700 (PDT)
Received: from [192.168.1.93] (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.gmail.com with ESMTPSA id w185sm14281806qkd.30.2021.07.23.03.13.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jul 2021 03:13:51 -0700 (PDT)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Extending CRYPTO_ALG_OPTIONAL_KEY for cipher algorithms
Message-ID: <f04c8f1d-db85-c9e1-1717-4ca98b7c8c35@linaro.org>
Date:   Fri, 23 Jul 2021 06:13:50 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi

I have a requirement where the keys for the crypto cipher algorithms are 
already programmed in the h/w pipes/channels and thus the ->encrypt()
and ->decrypt() can be called without set_key being called first.
I see that CRYPTO_ALG_OPTIONAL_KEY has been added to take care of
such requirements for CRC-32. My question is can the usage of this flag
be extended for cipher and other crypto algorithms as well. Can setting 
of this flag indicate that the algorithm can be used without calling 
set_key first and then the individual drivers can handle cases where
both h/w keys and s/w keys need to be supported.



-- 
Warm Regards
Thara (She/Her/Hers)
