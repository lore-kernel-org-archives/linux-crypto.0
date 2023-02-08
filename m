Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDABBC05027
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Feb 2023 19:04:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbjBHTEQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Feb 2023 14:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbjBHTEQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Feb 2023 14:04:16 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CBD0552B8
        for <linux-crypto@vger.kernel.org>; Wed,  8 Feb 2023 11:03:44 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id bk16so17783643wrb.11
        for <linux-crypto@vger.kernel.org>; Wed, 08 Feb 2023 11:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YcFa+o0o/HGPVfh9CAEExeraGr3RyMHQ6+ferc/dsVA=;
        b=oPXL2Ez2tQFZ1E1PrSalxrbCbV9FZ5VrcNskl9/zL1ReaZI+lyRJabtUE59h/F64xJ
         BAnFITM34JSJnThNSuFjPte8FVi6Irv83Fe2uQicP/gQnAuU2BVBUOIXkR3+byLvhamC
         03s4zgjPrjVMAy/z30UAlVW+8pG8H9LKh5g+SG6O7R4fdPNY5Of69GzPdsr+dtD2XnC7
         /c3mPvZpgzqunndMqHue58WoQ1mRFxs0Cl8shLil8dpy4PKgUfyFI9Q5f2q7FeqKoFPy
         ybcnqz6vKYyCnnZ/UPIGSnU/l8hyaUbjE2Bmoryzvy3ZgBgfZhtoVSwyBmxjH3tXoCBM
         JQmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YcFa+o0o/HGPVfh9CAEExeraGr3RyMHQ6+ferc/dsVA=;
        b=YmI19vf9cIEwU+j+OMWASMx4M/v8cXZOB7tNizW8UoQdnUyvDv/fQvy43c0oaR7RPa
         VGzvhsOg0R8S194v2jJp8Cti8GX+7ZszSZEhQQLXeBLEiwh2pSF3oNiXakOwCcxhxt3B
         Y3n73gZy+butXpokNb69vIWywxRDcA8hY54xHiNhxtzN9ImRS7r2ecaemcMp2FtN7kKv
         pnuRdzkOZMOVr6qKTuH7+H2vNCmbw7YbRd4rKPkwd9qiny5idNpPJJ+B04h8NyxlslCz
         O0Fdbzx8DNxV+YnK5SZubc0m7VknK5e6B2RbtmUpy6trnutvoFAiMunkLK4IWdGa+NZ6
         5GKA==
X-Gm-Message-State: AO0yUKX0m+9PsQ/uBFrsHc+F4oSi/qAqX/flrJ1UNXJL8QTcmRcETCyi
        BhTii6o570AFsBwoOQRdNS8tH8OSpgA=
X-Google-Smtp-Source: AK7set9lJQg5HLxM5eYzL+HANk/ZxpcT99x9r4cBKYPjhpmmscBKRD92rfgjhgqOiBu5CVZmRhhO1Q==
X-Received: by 2002:a5d:595f:0:b0:2c3:9851:e644 with SMTP id e31-20020a5d595f000000b002c39851e644mr7359832wri.63.1675883018641;
        Wed, 08 Feb 2023 11:03:38 -0800 (PST)
Received: from shift (pd9e294ad.dip0.t-ipconnect.de. [217.226.148.173])
        by smtp.gmail.com with ESMTPSA id t15-20020adfdc0f000000b002c3f81c51b6sm4009822wri.90.2023.02.08.11.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 11:03:38 -0800 (PST)
Received: from localhost ([127.0.0.1])
        by shift with esmtp (Exim 4.96)
        (envelope-from <chunkeey@gmail.com>)
        id 1pPpgj-001IcD-1f;
        Wed, 08 Feb 2023 20:03:37 +0100
Message-ID: <cf60caa6-a540-c09a-e34b-4fdf30fd0d39@gmail.com>
Date:   Wed, 8 Feb 2023 20:03:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] crypto: crypto4xx - Call dma_unmap_page when done
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
References: <Y+CX0WWNtrURdr5g@gondor.apana.org.au>
Content-Language: de-DE, en-US
From:   Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <Y+CX0WWNtrURdr5g@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/6/23 07:01, Herbert Xu wrote:
> In crypto4xx_cipher_done, we should be unmapping the dst page, not
> mapping it.
> 
> This was flagged by a sparse warning about the unused addr variable.
> While we're at it, also fix a sparse warning regarding the unused
> ctx variable in crypto4xx_ahash_done (by actually using it).
> 
> Fixes: 049359d65527 ("crypto: amcc - Add crypt4xx driver")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Tested this on the MyBook Live. Internal cryptmgr_test pass with:

[    2.888784] alg: No test for stdrng (crypto4xx_rng)
[    7.519740] "cryptomgr_test" (102) uses obsolete ecb(arc4) skcipher
(but all crypto4xx entries in /proc/crypto say that the selftest pass)

as well as libkcapi kcapi-enc-test.sh passes.

The ahash portion is a bit "underused". Currently the driver doesn't
register any hashes (this is because in testing I found the getting
the crypto-hardware to do those is so much slower than letting the
CPU do these).

Anyway:

Tested-by: Christian Lamparter <chunkeey@gmail.com>

Thanks!

