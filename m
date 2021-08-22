Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9584EC4338F
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Aug 2021 05:20:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67B386124D
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Aug 2021 05:20:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbhHVFUz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Aug 2021 01:20:55 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:37839 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229611AbhHVFUw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Aug 2021 01:20:52 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0UktxewK_1629609606;
Received: from 30.27.241.54(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0UktxewK_1629609606)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 22 Aug 2021 13:20:08 +0800
Subject: Re: [PATCH 0/2] add AES-NI/AVX2/x86_64 implementation
To:     David Laight <David.Laight@ACULAB.COM>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Vitaly Chikunov <vt@altlinux.org>,
        Eric Biggers <ebiggers@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Markku-Juhani O . Saarinen" <mjos@iki.fi>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jia Zhang <zhang.jia@linux.alibaba.com>,
        "YiLin . Li" <YiLin.Li@linux.alibaba.com>
References: <20210818033117.91717-1-tianjia.zhang@linux.alibaba.com>
 <f7684dd9dc5e4c6081ba8e51f53e0844@AcuMS.aculab.com>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <ea63cb91-dba8-9ac6-9ca7-967355e6236f@linux.alibaba.com>
Date:   Sun, 22 Aug 2021 13:20:06 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <f7684dd9dc5e4c6081ba8e51f53e0844@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi David,

On 8/20/21 6:03 PM, David Laight wrote:
> From: Tianjia Zhang
>> Sent: 18 August 2021 04:31
>>
>> This patchsets exported some of the common functions implemented by
>> the SM4 AESNI/AVX algorithm, and reused these functions to achieve
>> the acceleration of AESNI/AVX2 implementation.
> 
> These functions need bracketing by kernel_fpu_enable()
> (or whatever it is called.)
> That will significantly affect the performance.
> 
> Also the functions look pretty big (I don't know how big
> the generic ones are) and will take time to load into the I$
> and will displace other code.
> 
> So while a hot-cache benchmark might show improvements
> for repeated calls is isn't obvious that any significant
> gain will be made for real-life calls which could easily
> be of single buffers.
> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 

Yes, the functions bracketed by kernel_fpu_begin() do affect 
performance. It seems that the kernel can only do this, so by processing 
as much data as possible in a kernel_fpu_begin/end() operation to 
improve performance. actually do it now.

Best regards,
Tianjia
