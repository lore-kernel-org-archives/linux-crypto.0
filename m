From: George Cherian <gcherian@caviumnetworks.com>
Subject: Re: [PATCH v4 2/3] drivers: crypto: Add the Virtual Function driver
 for CPT
Date: Thu, 12 Jan 2017 16:50:58 +0530
Message-ID: <5877669A.3070101@caviumnetworks.com>
References: <1484132211-917-1-git-send-email-george.cherian@cavium.com>
 <1522639.tMShRcNLPc@positron.chronox.de>
 <58776428.1060308@caviumnetworks.com>
 <1970611.axXSiX4HVh@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8bit
Cc: George Cherian <george.cherian@cavium.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <david.daney@cavium.com>, <clabbe.montjoie@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
To: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn3nam01on0044.outbound.protection.outlook.com ([104.47.33.44]:25187
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750819AbdALLVj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 06:21:39 -0500
In-Reply-To: <1970611.axXSiX4HVh@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

Thank you for the clarification.

Regards,
-George

On 01/12/2017 04:49 PM, Stephan Müller wrote:
> Am Donnerstag, 12. Januar 2017, 16:40:32 CET schrieb George Cherian:
>
> Hi George,
>
>>>
>>> Sure, please do not forget to invoke xts_verify_key.
>>
>> Should I be using xts_check_key or xts_verify_key?
>
> Both are identical except for the input parameter -- the one requires
> crypto_skcipher, the other crypto_tfm. Depending what pointer you have handy
> in your setkey function, you would use the most appropriate one.
>
> Ciao
> Stephan
>
