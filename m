From: Zain Wang <wzz@rock-chips.com>
Subject: Re: encrypt_done called from interrupt context on rk3288 crypto
 driver
Date: Mon, 26 Jun 2017 09:14:08 +0800
Message-ID: <c9e41040-adf6-7280-ce63-2540500c174c@rock-chips.com>
References: <CAELSAVav4OQD1eTqtOey8_oZQPCBieO-HQQg1CaC23VmfD4KWQ@mail.gmail.com>
 <20170623083717.GA30234@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Zain Wang <zain.wang@rock-chips.com>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Emil Karlson <jekarlson@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.133]:45293 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751429AbdFZBOg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 25 Jun 2017 21:14:36 -0400
In-Reply-To: <20170623083717.GA30234@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


ÔÚ 2017/6/23 16:37, Herbert Xu Ð´µÀ:
> On Thu, May 25, 2017 at 10:38:13PM +0300, Emil Karlson wrote:
>> Greetings
>>
>> It seems to me that rk3288 crypto driver calls encrypt_done from
>> interrupt context which causes runtime tests to fail.
> Zain, can you please take a look at this?
>
> It is illegal to call the completion function from hardirq context.
>
> Thanks,
Thanks for your email, I will fix it next.

Thanks,
Zain
