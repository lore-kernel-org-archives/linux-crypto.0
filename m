Return-Path: <SRS0=SmAa=EF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF4B1C4363A
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Oct 2020 10:33:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50F12221EB
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Oct 2020 10:33:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oazpO/Hc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgJ3Kde (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Oct 2020 06:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbgJ3Kde (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Oct 2020 06:33:34 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE24FC0613CF;
        Fri, 30 Oct 2020 03:33:33 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id k10so4542964wrw.13;
        Fri, 30 Oct 2020 03:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cilZ+udfA8JnGi8jWqanKiLiFvzSWTw4Z1ASaR4ui20=;
        b=oazpO/HcgVzOwukg6DMxBqAdxdcz6Chre5fBs3HcgHOHrcwP+QnjgYVIl9Iik2vJe4
         DNOQSk9/PQmw5q9ofMtYcZ5tleMr26nJo42/LSDHSIyJ2MRwbCn4k92sQM1zCq1gpRnW
         trTAJCiz0GrYMwzslop6T7dDS2coD3G9bqgaszDe1Umfk+BrBFpHwYxdm/cIj4NeXEjS
         1UpxRNcIQWLcIMFRPMGEZgsKhJHxq5DsUoxdnpTLUKSTZNyBm0KVryaH6BMoYRHJnMEi
         V9QKDUPF+uhGIO28l1xLSCF2Ka4FsamO4C8fWmbrvWHFHjJEnCIGEr0N1YmCIAs54b2m
         VYTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cilZ+udfA8JnGi8jWqanKiLiFvzSWTw4Z1ASaR4ui20=;
        b=fe6DjyARBKmG1Uf6JQZ6yHVNsKO9jooR6MHVfg/UKdmWKzmtqpvmng9slU4q+0+Bp+
         4MzOBEczxqnMF5oSx9p1BQNijrQ2KAu81qleGvryJErx7uOpG4sDGobtdW+WNP8bEIL0
         b1E2aNMpS61FTMhj+iAvB5hymIVaQK1/Rha5Jr/iLziS+tOUeyJILQ8sCwu4q6y5rTOF
         Ac+wi0vw20j+rMOIwGGdTZytzVqgYlwmlnPAwbOo7rQP0DzoEYL4u3a7I5CTJzKjq2Bh
         tF8zKPKaWO0q2T7CmQJn5tyW2Q8IlSi+nMlgjuxUIpW9UXlo7EZUQnFgEB+0mTwu0git
         2tsw==
X-Gm-Message-State: AOAM533Kl7MWw65VQEyewc6zLIcRrWjnB8s92b5KgDKEXdoEY2bD+rio
        0e01bF2WfrXcK6T7hmtLwaVEv+jSd/4=
X-Google-Smtp-Source: ABdhPJwOA2WNkf2VuwSDmM8C2HAwpPF2FvWE7mqh3rpIOcZnF4uB8wWXxzxHmZnUkkMa5u/9iJH5oQ==
X-Received: by 2002:a5d:4612:: with SMTP id t18mr2205623wrq.307.1604054012411;
        Fri, 30 Oct 2020 03:33:32 -0700 (PDT)
Received: from [192.168.2.27] (39.35.broadband4.iol.cz. [85.71.35.39])
        by smtp.gmail.com with ESMTPSA id d20sm10565162wra.38.2020.10.30.03.33.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2020 03:33:31 -0700 (PDT)
Subject: Re: [PATCH v3 1/4] crypto: add eboiv as a crypto API template
To:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc:     Ofir Drang <ofir.drang@arm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201029100546.28686-1-gilad@benyossef.com>
 <20201029100546.28686-2-gilad@benyossef.com>
From:   Milan Broz <gmazyland@gmail.com>
Message-ID: <3a4804a5-5d5c-1216-1503-c241cc24f3c2@gmail.com>
Date:   Fri, 30 Oct 2020 11:33:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201029100546.28686-2-gilad@benyossef.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 29/10/2020 11:05, Gilad Ben-Yossef wrote:
>  
> +config CRYPTO_EBOIV
> +	tristate "EBOIV support for block encryption"
> +	default DM_CRYPT
> +	select CRYPTO_CBC
> +	help
> +	  Encrypted byte-offset initialization vector (EBOIV) is an IV
> +	  generation method that is used in some cases by dm-crypt for
> +	  supporting the BitLocker volume encryption used by Windows 8
> +	  and onwards as a backwards compatible version in lieu of XTS
> +	  support.
> +
> +	  It uses the block encryption key as the symmetric key for a
> +	  block encryption pass applied to the sector offset of the block.
> +	  Additional details can be found at
> +	  https://www.jedec.org/sites/default/files/docs/JESD223C.pdf

This page is not available. Are you sure this is the proper documentation?

I think the only description we used (for dm-crypt) was original Ferguson's Bitlocker doc:
https://download.microsoft.com/download/0/2/3/0238acaf-d3bf-4a6d-b3d6-0a0be4bbb36e/bitlockercipher200608.pdf

IIRC EBOIV was a shortcut I added to dm-crypt because we found no official terminology for this IV.
And after lunchtime, nobody invented anything better, so it stayed as it is now :-)

Milan
