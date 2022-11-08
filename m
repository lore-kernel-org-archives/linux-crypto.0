Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 862FBC433FE
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Nov 2022 18:57:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiKHS5i (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Nov 2022 13:57:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiKHS5g (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Nov 2022 13:57:36 -0500
X-Greylist: delayed 387 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Nov 2022 10:57:34 PST
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEE36A683
        for <linux-crypto@vger.kernel.org>; Tue,  8 Nov 2022 10:57:34 -0800 (PST)
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id AD9102C5FE
        for <linux-crypto@vger.kernel.org>; Tue,  8 Nov 2022 18:51:07 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.67.124])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 83D7720080;
        Tue,  8 Nov 2022 18:51:05 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 6171E94009D;
        Tue,  8 Nov 2022 18:51:02 +0000 (UTC)
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id C932213C2B0;
        Tue,  8 Nov 2022 10:50:54 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com C932213C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1667933460;
        bh=iPXGVA4XCeTNbPkF3b8QZPfk08CneBXGyQ9rP4FoofM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=dk8YdZ9bo3Vbp7HyhzWOS6NV5wrE7sTG88ddXP6sdlGC2nuHGfg7zYhiEb0lQud7p
         KzATD0DYmkqlE4qmPv4ftSeNtUN2ZpWPXDrN0xdL3a7beDRYHkCQulf93QG26yXGD/
         aqCVBdev3FmRufzOwThVKkUfHEHySHQA8v4gHJ9Y=
Subject: Re: [PATCH v2] crypto: aesni - add ccm(aes) algorithm implementation
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
References: <20201201231158.GA32274@gondor.apana.org.au>
 <CAMj1kXHwD5ktJTUrh8sndMY7P0kSFhgkGT66YJN1-ONUaU05-g@mail.gmail.com>
 <20201210024342.GA26428@gondor.apana.org.au>
 <e02fe07e-8cb6-f889-3228-60e4fabf4e40@candelatech.com>
 <CAMj1kXF05XZtyakdpLixpP9Lroy0D3_gEcY2SFbSshD8ERUU7w@mail.gmail.com>
 <20201210111427.GA28014@gondor.apana.org.au>
 <CAMj1kXG39GgsTeNBbX7_oaK+f-awPyL8NxJ7R+fyOBjL4c5xMw@mail.gmail.com>
 <20201210121627.GB28441@gondor.apana.org.au>
 <CAMj1kXE-+35tfO87024xB274ZVOu7HTHqDa8o-hjoxDasd8p7g@mail.gmail.com>
 <CAMj1kXH5LPib2vPgLkdzHX4gSawDSE=ij451s106_xTuT19YmA@mail.gmail.com>
 <20201215091902.GA21455@gondor.apana.org.au>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <062a2258-fad4-2c6f-0054-b0f41786ff85@candelatech.com>
Date:   Tue, 8 Nov 2022 10:50:48 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20201215091902.GA21455@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-MDID: 1667933466-ZwuT9EPdt7Az
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/15/20 1:19 AM, Herbert Xu wrote:
> On Tue, Dec 15, 2020 at 09:55:37AM +0100, Ard Biesheuvel wrote:
>>
>> So the question is then how granular these kernel mode SIMD regions
>> need to be to avoid excessive latencies in softirq handling.
> 
> Can you get some real world numbers on what the latency is like?
> 
> Then we could take it to the scheduler folks and see if they're
> OK with it.
> 
> Thanks,
> 

Hello,

While rebasing my patches onto 6.1-rc4, I noticed my aesni for ccm(aes) patch didn't apply cleanly,
and I found this patch described below is applied now.  Does this upstream patch mean that aesni is already
supported upstream now?  Or is it specific to whatever xctr is?  If so,
any chance the patch is wanted upstream now?

commit fd94fcf09957a75e25941f7dbfc84d30a63817ac
Author: Nathan Huckleberry <nhuck@google.com>
Date:   Fri May 20 18:14:56 2022 +0000

     crypto: x86/aesni-xctr - Add accelerated implementation of XCTR

     Add hardware accelerated version of XCTR for x86-64 CPUs with AESNI
     support.

     More information on XCTR can be found in the HCTR2 paper:
     "Length-preserving encryption with HCTR2":
     https://eprint.iacr.org/2021/1441.pdf

     Signed-off-by: Nathan Huckleberry <nhuck@google.com>
     Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
     Reviewed-by: Eric Biggers <ebiggers@google.com>
     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

