Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7CBEC433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Mar 2022 11:50:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiCALvB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Mar 2022 06:51:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiCALvB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Mar 2022 06:51:01 -0500
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F121A81180;
        Tue,  1 Mar 2022 03:50:19 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0V5yl0n-_1646135412;
Received: from 30.240.100.72(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0V5yl0n-_1646135412)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 01 Mar 2022 19:50:15 +0800
Message-ID: <52be961d-a00d-785d-8fb1-15b1a17bd74e@linux.alibaba.com>
Date:   Tue, 1 Mar 2022 19:50:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH 1/3] crypto: sm4 - create SM4 library based on sm4 generic
 code
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "Markku-Juhani O . Saarinen" <mjos@iki.fi>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20210610134459.28541-1-tianjia.zhang@linux.alibaba.com>
 <20210610134459.28541-2-tianjia.zhang@linux.alibaba.com>
 <Yh32tEhUgGeSXf/A@zx2c4.com>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
In-Reply-To: <Yh32tEhUgGeSXf/A@zx2c4.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Jason,

On 3/1/22 6:34 PM, Jason A. Donenfeld wrote:
>>   lib/crypto/Kconfig   |   3 +
>>   lib/crypto/Makefile  |   3 +
>>   lib/crypto/sm4.c     | 184 +++++++++++++++++++++++++++++++++++++++++++
> 
> If this is only used by the crypto API, it does not belong in
> lib/crypto. I understand you want fallback generic code for the SIMD
> implementation, but we've generally done that in crypto/ when the use
> case is only the crypto API. Can you move this to the right place?

This is not only used by the crypto API, but also used for SIMD
acceleration under the x86 and arm architectures, mainly for processing
the remaining blocks after SIMD acceleration. In general, the
performance of SIMD processing a single block is not as good as that of
general software implementations.

Kind regards,
Tianjia
