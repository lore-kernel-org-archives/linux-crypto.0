Return-Path: <SRS0=TZua=WD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A6BC32751
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Aug 2019 11:19:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EFDA21922
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Aug 2019 11:19:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dZ7Wt6AE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbfHGLTr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Aug 2019 07:19:47 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36973 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbfHGLTr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Aug 2019 07:19:47 -0400
Received: by mail-wm1-f67.google.com with SMTP id f17so79582906wme.2
        for <linux-crypto@vger.kernel.org>; Wed, 07 Aug 2019 04:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z138HsuLxFqQ0Syhv0z3Bfgt5EWHsSF8yWfiK3+BXZg=;
        b=dZ7Wt6AEryG8RdlEfSOvtPcAMJ8IzXhBQsEQjP9aqiU62R9vLUiZzjVrXcCfNczcQg
         ePLqwaSmIvkG92drSJulNP90G1Z8ActClWWFfie6PmoDQk+JjgpQk9o/LDr1UkHdWxt6
         L5I55idVZofaz5EQ4Fc78Si6h1BROzwCp73rTO599j2vhcNIjT1EoyE+egTfYFOiPshE
         zv+IA6vMQRl5d6jkUAHmtGexV0VSNqE1A75FA93wzYyUxY2WAM29DR7OPNeatdaGBjEP
         IRM18T3pl1fQH+276N3afCVouX6AE5W8Bt89w3kXU0bu31abmYGj3BFB3w7fdRnJIhgt
         5lmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z138HsuLxFqQ0Syhv0z3Bfgt5EWHsSF8yWfiK3+BXZg=;
        b=mNzEnq0+FEJDk9cZP5nNCu7tfFD5Qxum9piQwBOS+FaA2rbVOb2T4iPRiYDiW2pq5/
         C3b2rb5YM2dRLB3k5H3K1qguFENZphiPPefAYLL7aHJRHWUmThfEMt6ro2dGoXaqY6M1
         bjivE/Fx/uaGzCrGm56SWcTMKYLaBVhYUQ5peAsA+MXnfJaxPAb4CTCOnm605ayGPgt3
         ykVc4z3rpD3PxcijNzoFGlo9hxeflSejFTYHLYOiAwo9X+x8paCglZzMZoK7/mLpFXgU
         Knz5KezA/jMEX7mppXCuCzUJLcJJ3xDi/9hvR8MetkbFXXeJ8ahwd87wrAvsdCvk6/zX
         N5eQ==
X-Gm-Message-State: APjAAAXyc/m1tpDFxd9VOzTU+9/JRdefawhuKXfJmbsM36Qe9AEERgLw
        o6E9yGKpJ5Oq2b8mNYfE2AI=
X-Google-Smtp-Source: APXvYqyokOJHckMfeWw+TI6YX5De4ZgqEk+KzYpyBuAGgab13DVqAfb4E7sc95nCAuhCik0mCAG0TQ==
X-Received: by 2002:a7b:c745:: with SMTP id w5mr10077977wmk.21.1565176785118;
        Wed, 07 Aug 2019 04:19:45 -0700 (PDT)
Received: from [10.43.17.10] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id x6sm3763170wmf.6.2019.08.07.04.19.43
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 04:19:44 -0700 (PDT)
Subject: Re: [PATCH] crypto: xts - Add support for Cipher Text Stealing
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Cc:     "rsnel@cube.dyndns.org" <rsnel@cube.dyndns.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <1565074510-8480-1-git-send-email-pvanleeuwen@verimatrix.com>
 <5bf9d0be-3ba4-8903-f1b9-93aa32106274@gmail.com>
 <MN2PR20MB29734CFE2795639436C3CC91CAD50@MN2PR20MB2973.namprd20.prod.outlook.com>
 <MN2PR20MB2973A38A300804281CA6A109CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <a0e3ce44-3e47-b8d9-2152-3fd8ba99f09a@gmail.com>
Date:   Wed, 7 Aug 2019 13:19:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <MN2PR20MB2973A38A300804281CA6A109CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On 07/08/2019 10:15, Pascal Van Leeuwen wrote:
> I went through the code a couple of times, but I cannot spot any mistakes in
> the lengths I'm using. Is it possible that your application is supplying a
> buffer that is just not large enough?

Seems there is no mistake in your code, it is some bug in aesni_intel implementation.
If I disable this module, it works as expected (with aes generic and aes_i586).

Seems something is rewritten in call
  crypto_skcipher_encrypt(subreq);

(after that call, I see rctx->rem_bytes set to 32, that does not make sense...)

I'll check that, but not sure that understand that optimized code :)

Milan
