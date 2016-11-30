From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] crypto: arm/aesbs - fix brokenness after skcipher conversion
Date: Wed, 30 Nov 2016 13:36:02 +0000
Message-ID: <53AA8DFA-2420-40D6-A9C2-90B184344819@linaro.org>
References: <1480440216-341-1-git-send-email-ard.biesheuvel@linaro.org> <20161130131921.GD4126@gondor.apana.org.au>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wj0-f177.google.com ([209.85.210.177]:35454 "EHLO
        mail-wj0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756512AbcK3NgH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Nov 2016 08:36:07 -0500
Received: by mail-wj0-f177.google.com with SMTP id v7so173951570wjy.2
        for <linux-crypto@vger.kernel.org>; Wed, 30 Nov 2016 05:36:06 -0800 (PST)
In-Reply-To: <20161130131921.GD4126@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



> On 30 Nov 2016, at 13:19, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> 
>> On Tue, Nov 29, 2016 at 05:23:36PM +0000, Ard Biesheuvel wrote:
>> The CBC encryption routine should use the encryption round keys, not
>> the decryption round keys.
>> 
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> Patch applied.  Thanks.
> 
>> Another fix for the queued changes, this time for 32-bit ARM.
>> 
>> I must say, I'm not impressed with the level of testing that has been
>> carried out after applying these changes. If you had cc'd me on these
>> patches, I would have been happy to test/review.
> 
> Sorry.  I'll make sure you're CCed for ARM patches in future.

Cheers,
Ard.
