Return-Path: <SRS0=WqbL=AT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 199FCC433E3
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 11:22:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E965820772
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 11:22:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tessares-net.20150623.gappssmtp.com header.i=@tessares-net.20150623.gappssmtp.com header.b="KOb2LUhR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbgGHLWj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jul 2020 07:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728739AbgGHLWi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jul 2020 07:22:38 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53094C08C5DC
        for <linux-crypto@vger.kernel.org>; Wed,  8 Jul 2020 04:22:38 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id d16so34727820edz.12
        for <linux-crypto@vger.kernel.org>; Wed, 08 Jul 2020 04:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=h/VDi0L0Er+y9QclCR5p4bjYMCfPyQVnSdjE6u0pVME=;
        b=KOb2LUhR1PzjqmCcFbd3YvNvuCQrSNrQ+bM4m0Kw97utCLXMqh0W0nSJn2eZcLx8bH
         sE5LiiqFE/S5jsfPsp7Vsf5pRrr9eYzUu+W+8cm7YgbkDysxiiJJPrNazochPdBK0BQ0
         obQWewF/eF9NhZ6sI3s7N1r7e6OEzXnswlmVdixYwhhSe5Q1yHLlizho1xey2Z/bmoPj
         6OKmz1BemLHsWFKF5LWpWR+417V5vI4cTuYuZejh24LwIxh/Fzia11HgdorM3xA2EDCf
         lwpNGhb4IrqFbKASBBcc9YXYxZ/qE3vKrh4fdOrS87Q+zDEjFu0k7ib08WId9GuopwfI
         o/oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h/VDi0L0Er+y9QclCR5p4bjYMCfPyQVnSdjE6u0pVME=;
        b=qeI0OlhHN6P2UQYOAr4BhhDNWBfCyfsb3Gk4XzVZHWB93FR1mLJJPfaw2ITSnBtucr
         V1vY1NvuTcyTMYW/8+SFXcL1ch21v9dvCMFd5w5NP7J4AQHWrYVCjmenOJQyfHc+8Ofp
         3zmapO0z5EW26MnnRCntUjWPwEChRnUByGftU6UzahnO/b6fV89T+Typ8Z0aweJxToN0
         4aP2VPPQcxj112vSlhnv7l1SLA6PQOKuNvrJ3icC2NNj1JfEHer5AV77Pasp1B4D2+7P
         ZgcAUHZFWQEMIsMJ0D5q3f8OUBSs6X3Q0bJMBSxYf8cErzwrFFdJ/86CxEZBD/YYNHRB
         ebmQ==
X-Gm-Message-State: AOAM533Ta/5X5CbAobSIalgw2/hvP0E4Gfjtv6TA/8819u/z9PYlRLVV
        OQVBbtnxDTufZs3BdC312WhbhFWuwdbsRw==
X-Google-Smtp-Source: ABdhPJxPKT5AlZ5E6geliL4zRlpJ07D1oZ+2Cv+mEKGPOO/mzcI/tb6aRKZi5x0wyBCm3k32FR10xA==
X-Received: by 2002:a50:bf09:: with SMTP id f9mr6963961edk.249.1594207357033;
        Wed, 08 Jul 2020 04:22:37 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([81.246.10.41])
        by smtp.gmail.com with ESMTPSA id p18sm1845132ejm.55.2020.07.08.04.22.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 04:22:36 -0700 (PDT)
Subject: Re: [PATCH 3/4] mptcp: use sha256() instead of open coding
To:     Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
References: <20200707185818.80177-1-ebiggers@kernel.org>
 <20200707185818.80177-4-ebiggers@kernel.org>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <b69102bb-47a0-567b-0e02-b572a9b1bbbf@tessares.net>
Date:   Wed, 8 Jul 2020 13:22:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200707185818.80177-4-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

On 07/07/2020 20:58, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Now that there's a function that calculates the SHA-256 digest of a
> buffer in one step, use it instead of sha256_init() + sha256_update() +
> sha256_final().
> 
> Cc: mptcp@lists.01.org
> Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Cc: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thank you for this simplification and update MPTCP code, it's clearer!

Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
