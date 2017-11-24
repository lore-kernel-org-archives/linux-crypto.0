From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: Question about ahash export and import
Date: Fri, 24 Nov 2017 14:35:04 +0100
Message-ID: <e7eaa2a4-dc44-8542-c2a2-702d8ac7256c@partner.samsung.com>
References: <0e54df51-7b4c-a01e-2054-3cdf204a429e@c-s.fr>
        <CGME20170926103514epcas1p4494e6502b2b6835c732201a4aeff60b1@epcas1p4.samsung.com>
        <CAOtvUMeHF8PZAEaniK+oGYVOF5rbD_kZKuGC3j5XXkF-w2pPDA@mail.gmail.com>
        <be29fd42-2e64-5ca8-546c-e7f68a2d0da7@partner.samsung.com>
        <20170927090802.GA1547@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Christophe LEROY <christophe.leroy@c-s.fr>,
        =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:39652 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752681AbdKXNfO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Nov 2017 08:35:14 -0500
In-reply-to: <20170927090802.GA1547@gondor.apana.org.au>
Content-language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 27.09.2017 11:08, Herbert Xu wrote:
> On Tue, Sep 26, 2017 at 01:09:05PM +0200, Kamil Konieczny wrote:
>>
>> Can import() be called without _any_ init(), for example
>> after reboot of machine ? Is following scenario valid:
> 
> Of course it can.  import must restore the state of the request
> to that at the time when export was called.
> 
> import does not need to be called after init.  init simply resets
> the hash state for new update/final calls.
> [...]

I have more questions, this time about HMAC export/import.
In doc, there is stated that key can be copied into context transformation.

Should .export copy request context _and_ key used ? Or not ?

When processing requests, can I assume the key in transformation is const until .final ?

Is is possible to have okey derived from different key then ikey ? I think not.

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland
