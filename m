Return-Path: <SRS0=FgZY=WM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F85EC3A59C
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 07:29:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2179F20644
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 07:29:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RjWBTg/M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbfHPH3o (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Aug 2019 03:29:44 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40102 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfHPH3o (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Aug 2019 03:29:44 -0400
Received: by mail-wm1-f67.google.com with SMTP id v19so3265429wmj.5;
        Fri, 16 Aug 2019 00:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6T0bWUoTVdcz2Y9O6ErDfWcGr4YZCTpQWIAXvrd/4WI=;
        b=RjWBTg/MXGdeu2r68x7GP0ppDHCxGdyk5T7+NGyr9Lk1QRpaY6xtEdYpdARwa3b6mf
         CcE3rMWREZKcB8MJoZTimYSG4g+u7kSFdG8KZWpxcYfU79ipV6IpGxIRc2m8lY78bPUR
         BJ57EQ4YoaJDJr6xXYNcuVguojvoqh4ixCIJYl+3tBw02N/71HLyOnMwuNoR8+G8dD+4
         VblSwAIkzf318BOJZJFTMMZnwf6aUXPxi01VQV2+KH7NuFXP2r0boG+sn/VuZpFNlAGG
         CPaWGosn+NxCrUYZQ4O8PUd9Pug1Lru/QPjNI+oUeO49dCwtyUhnQA9JyWReIo5U3rlL
         2AWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6T0bWUoTVdcz2Y9O6ErDfWcGr4YZCTpQWIAXvrd/4WI=;
        b=XtaZjAoprxxqzD4mIir9oF7coZIfiVCfHhNbTa/HFIW1x/jRlaXnStnxH68WzCWHRR
         yj22IEqXIS4joF5MzI+wHHoDwRcD/VT/JP4MiD1eiet2Hg1lOIdAy1ola8WE1SjNtxT/
         oApswKkgJpA8RkD/VNWdUQES3cGaT4ArRTWDVYD7/BSnFZxXxzRr6HP7J7wGA5C4H9jA
         R0Au0Rw5HEfKkAMXGCKlGr41+C/GPHbVsrCo6uWVVh77klQuq1zD8tIMlZDFkgRAy+h9
         GFI1ISGWqi/gZrSISuoRqOah6Jyy+qrVTTo/gEjHtf57XCig7aEgwqE08RBu66tTLrW4
         Vsww==
X-Gm-Message-State: APjAAAVemIxbP8nA1JnxXRd7T8PhQ2QcdtJgLqYVlcugjn5MqQMTrTtm
        L+w4IOT+zk0u8xtvzQsXf6Q=
X-Google-Smtp-Source: APXvYqwqyHlF+r6k9fpQM9dw1ygdJigLxpg8QcYq+qo6jtZ/6245MFxa7bsGW/51Ktd+URByGAuK+g==
X-Received: by 2002:a7b:c08f:: with SMTP id r15mr6030116wmh.90.1565940581702;
        Fri, 16 Aug 2019 00:29:41 -0700 (PDT)
Received: from [192.168.2.27] (39.35.broadband4.iol.cz. [85.71.35.39])
        by smtp.gmail.com with ESMTPSA id f134sm4345319wmg.20.2019.08.16.00.29.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Aug 2019 00:29:41 -0700 (PDT)
Subject: Re: [PATCH v12 0/4] crypto: switch to crypto API for ESSIV generation
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>
References: <20190815192858.28125-1-ard.biesheuvel@linaro.org>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <1463bca3-77dc-42be-7624-e8eaf5cfbf32@gmail.com>
Date:   Fri, 16 Aug 2019 09:29:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190815192858.28125-1-ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ard,

On 15/08/2019 21:28, Ard Biesheuvel wrote:
> Changes since v10:
> - Drop patches against fscrypt and dm-crypt - these will be routed via the
>   respective maintainer trees during the next cycle

I tested the previous dm-crypt patches (I also try to keep them in my kernel.org tree),
it works and looks fine to me (and I like the final cleanup :)

Once all maintainers are happy with the current state, I think it should go to
the next release (5.4; IMO both ESSIV API and dm-crypt changes).
Maybe you could keep sending dm-crypt patches in the end of the series (to help testing it)?

(Just for for now I am completely distracted by other urgent unrelated issues.)

Milan
