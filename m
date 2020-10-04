Return-Path: <SRS0=YnP8=DL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E75FC4363C
	for <linux-crypto@archiver.kernel.org>; Sun,  4 Oct 2020 22:05:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F00A2078D
	for <linux-crypto@archiver.kernel.org>; Sun,  4 Oct 2020 22:05:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="toLrE7tM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgJDWFP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 4 Oct 2020 18:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726398AbgJDWFP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Oct 2020 18:05:15 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4EEC0613CE
        for <linux-crypto@vger.kernel.org>; Sun,  4 Oct 2020 15:05:15 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id n14so5298916pff.6
        for <linux-crypto@vger.kernel.org>; Sun, 04 Oct 2020 15:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=togLxEJv9rgoT2+f7/C3sCaigxFzV/7IORCr2allek8=;
        b=toLrE7tMLOAn+F3vN6MtRBZfQf2ECnlgVH2SePhj3VuKlw2mUh50WMONvUhR3Kbz2l
         ote01RqoFiqaef4v/aFTGlJAztjiPPHWSMFfT5tXaoys3Zn1o4HODnh9JdsFQdE3tyBP
         dJB2RkF06r44e5XVa0ZzeGEEXyk77XNTckz4v5Lz7ES478BSeSTh/nmqNm/PJ0sylfLG
         nPfS1CFSqA51s9RPYaT0uG9ZR3hC9vJi1/65aa0deLdSRc4MdunlO/94ixYeBEelHV1d
         4/8LEO84qzvJ9C3e23MSnP2LvcMPplucvhk1am6tlHg9Ta8bHFca6PbhAWuEo/R3apFP
         vsjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=togLxEJv9rgoT2+f7/C3sCaigxFzV/7IORCr2allek8=;
        b=fn21yCycMqH4Y0288XqdgJAnqkpoiTscCFvdaklgOOOEtTummlX1G3DhXQ/4CQlcxG
         nGzURR0Ff1Ezvj0/8LWJl3zyDmCfO7pE0GOgnRrusK8P6hABhjEdsdavl3PyoUJff72i
         YB4CXxMFxogQcL1WSDZbVb/CIVRIJIEJCgfyINichfsLybXezldw9QF33DaUH/j57vCM
         z1M2mDlAY5ITlJeok+AI84AizV9t7Aia+aVQkIfSqcDrOOcvC2AyzciICnFmM8lnosaJ
         9TYzU14rALWTOMHmJn4YjJRyUGwAByMPfP8n4eA8vAJgG52AjUf61uLOL7ymRFAmUjGc
         4ifA==
X-Gm-Message-State: AOAM531SWrkDnZGwTdE95dVClKtD+e/3ljBIxozm7izTb+J2TFQ1fSL6
        fgYrGOkj1VhdITqSLv0KEWxKE9q0RF1vuQ==
X-Google-Smtp-Source: ABdhPJwe+g0CsWIua0snBi6JmcX3/vEBTskQ11z/rDiv2ozn9h8ZAdUm4heqXRi1xzSr0TXMdeHT0Q==
X-Received: by 2002:a62:1951:0:b029:152:6669:ac74 with SMTP id 78-20020a6219510000b02901526669ac74mr3588479pfz.36.1601849114787;
        Sun, 04 Oct 2020 15:05:14 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id c9sm8367537pgl.92.2020.10.04.15.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2020 15:05:14 -0700 (PDT)
Date:   Sun, 04 Oct 2020 15:05:14 -0700 (PDT)
X-Google-Original-Date: Sun, 04 Oct 2020 15:05:12 PDT (-0700)
Subject:     Re: [PATCH] crypto: jitterentropy - bind statically into kernel
In-Reply-To: <CAMj1kXEnOh4MBiVVgkhd4P81eRPCVi3+y6JcD58jL45-eh324A@mail.gmail.com>
CC:     smueller@chronox.de, Christoph Hellwig <hch@infradead.org>,
        linux-riscv@lists.infradead.org, kernel-team@android.com,
        lkp@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   Palmer Dabbelt <palmerdabbelt@google.com>
To:     ardb@kernel.org
Message-ID: <mhng-bfca22db-02c7-4e71-9b83-00367c9a6bfb@palmerdabbelt-glaptop1>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 04 Oct 2020 14:16:10 PDT (-0700), ardb@kernel.org wrote:
> On Sun, 4 Oct 2020 at 20:48, Stephan Müller <smueller@chronox.de> wrote:
>>
>> The RISC-V architecture is about to implement the callback
>> random_get_entropy with a function that is not exported to modules.
>
> Why is that? Wouldn't it be better to export the symbol instead?

It's static inline (in our timex.h), so I thought we didn't need to export the
symbol?  Did this just arise because clint_time_val wasn't exported?  That was
fixed before the random_get_entropy() change landed in Linus' tree, so as far
as I know we should be OK here.

If I broke something here it seem better to fix this in the RISC-V port than by
just banning modular compilation of jitterentropy, as that seems like a useful
feature to me.

>> Thus, the Jitter RNG is changed to be only bound statically into the
>> kernel removing the option to compile it as module.
>>
>> Reported-by: Christoph Hellwig <hch@infradead.org>
>> Signed-off-by: Stephan Mueller <smueller@chronox.de>
>> ---
>>  crypto/Kconfig | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/crypto/Kconfig b/crypto/Kconfig
>> index 094ef56ab7b4..5b20087b117f 100644
>> --- a/crypto/Kconfig
>> +++ b/crypto/Kconfig
>> @@ -1853,7 +1853,7 @@ config CRYPTO_DRBG
>>  endif  # if CRYPTO_DRBG_MENU
>>
>>  config CRYPTO_JITTERENTROPY
>> -       tristate "Jitterentropy Non-Deterministic Random Number Generator"
>> +       bool "Jitterentropy Non-Deterministic Random Number Generator"
>>         select CRYPTO_RNG
>>         help
>>           The Jitterentropy RNG is a noise that is intended
>> --
>> 2.26.2
>>
>>
>>
>>
