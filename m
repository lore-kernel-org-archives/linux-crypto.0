Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB62C43334
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Jun 2022 07:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbiF3HN0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Jun 2022 03:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232006AbiF3HNZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Jun 2022 03:13:25 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8F9192AF
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jun 2022 00:13:23 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id m14-20020a17090a668e00b001ee6ece8368so1982822pjj.3
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jun 2022 00:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=42QsuBdMOwN6Udd80FpizXibD01HiLyDwwPH4Rv+Kd8=;
        b=lmmu9b4QO6WWh8c3uzKGWCVs8gO/zgIVpfIyXMOFuHpORj27V7BOgrwmwfy+oJANlQ
         /i822BdzhLlQQNQXRQvlQfSQZHdAPJcXlTSSFOcRFUmtbMfsjvNT9jtuI46la33GNBvr
         nTy48NStqBYv9O3OPwYXYWP7OtFr40e9Hi0aun4CAYOnUHWss+aojesYJgfVDDu/9aCG
         ybjkZF5Wgj07pQ+BFCKRjJVSPdmKOxoHKoSXOqzyM9ZmR+52f7z/cuFtnQe/zBGCGSmp
         LuQSDZtBMsfyCV4K898ONgbEiq/HFJKatvQjw8c5+szpjJPAQ3wSca4nHuYN1RZwx9qw
         mr0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=42QsuBdMOwN6Udd80FpizXibD01HiLyDwwPH4Rv+Kd8=;
        b=zl5otV+zXDlwTLISM/dq01D4vymbi9RhdFpNBIYTKSllpP1dD870IoCei7ICEXo/Kt
         6hG86TrKogCOVdLAb374jsm6xaGIubeyKQ0s94vfkixNQac9I/fw17txyESCKI+vjoTD
         zolTIinV98lufv7CII41PeJTPFRKJJClrlcncKky8etDU/wzDT3QlIiJP/byc2fE/wZZ
         kmjnXNPBa7AGknUziwe8GWa9VZLRiV1jnnr+Tdw9ihukA4arWzsjfIEsLbKsz9FEbUWR
         R/vURVgO5Xv/XM9qWMk8SuxdPY0gkXerYWdD4bffVL1RY5bhS9+mkEa4xJzU5a/Lez7p
         Fh5w==
X-Gm-Message-State: AJIora9uMGPgw/D5ah1L98Av6SgcNnDHJ7gUa0lNa4/k00ONrxKhdKGV
        hxLzAkej1HlsBUaVJvOFEq0=
X-Google-Smtp-Source: AGRyM1uqIq+hdebGBXEmliTD/e822c/3C3/1D+J1ZuUWgWAvFfqEFZWIiC2nLm/7DA2osMsnVMHH3g==
X-Received: by 2002:a17:902:ecca:b0:16a:6b2e:2a78 with SMTP id a10-20020a170902ecca00b0016a6b2e2a78mr13014166plh.164.1656573202445;
        Thu, 30 Jun 2022 00:13:22 -0700 (PDT)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id c9-20020a170902c2c900b0016a091e993dsm12733955pla.42.2022.06.30.00.13.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 00:13:21 -0700 (PDT)
Message-ID: <50203730-35f1-4bf9-3f3a-ca6cd3b01d4a@gmail.com>
Date:   Thu, 30 Jun 2022 16:13:19 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 0/2] crypto: Introduce ARIA symmetric cipher algorithm
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, davem@davemloft.net
References: <Yr1FBOC8Zi1ltlBi@gondor.apana.org.au>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <Yr1FBOC8Zi1ltlBi@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/30/22 15:39, Herbert Xu wrote:

Hi Herbert,
Thank you so much for your review!

 > Taehee Yoo <ap420073@gmail.com> wrote:
 >> This patchset adds a new ARIA(RFC 5794) symmetric cipher algorithm.
 >>
 >> Like SEED, the ARIA is a standard cipher algorithm in South Korea.
 >> Especially Government and Banking industry have been using this 
algorithm.
 >> So the implementation of ARIA will be useful for them and network 
vendors.
 >>
 >> Usecases of this algorithm are TLS[1], and IPSec.
 >> It would be very useful for them if it implements kTLS for ARIA.
 >
 > You haven't added any glue to use this for IPsec.  Unless there is
 > an in-kernel user we won't add any new algorithms.
 >
 > Thanks,

Unfortunately, IPsec draft[1] is expired so I think adding the 
aria-IPsec feature is not our rule as far as I know even if there are 
already  users in South Korea.
So, my plan is to add the kTLS feature because aria-TLS[2] is now standard.
So, Is it okay to add the aria-kTLS feature into the v2 patch, instead 
of aria-IPsec?

[1] https://datatracker.ietf.org/doc/draft-nsri-ipsecme-aria-ipsec/
[2] https://datatracker.ietf.org/doc/html/rfc6209

Thanks,
Taehee Yoo
