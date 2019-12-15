Return-Path: <SRS0=cN8K=2F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC967C43603
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Dec 2019 17:13:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90C4C206C3
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Dec 2019 17:13:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbfLORNY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 15 Dec 2019 12:13:24 -0500
Received: from opentls.org ([194.97.150.230]:35703 "EHLO mta.openssl.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbfLORNY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 15 Dec 2019 12:13:24 -0500
X-Greylist: delayed 553 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Dec 2019 12:13:23 EST
Received: from [127.0.0.1] (localhost [IPv6:::1])
        by mta.openssl.org (Postfix) with ESMTP id 22BDBE4F2E;
        Sun, 15 Dec 2019 17:04:08 +0000 (UTC)
Subject: Re: [PATCH crypto-next v2 2/3] crypto: x86_64/poly1305 - add faster
 implementations
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Martin Willi <martin@strongswan.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Samuel Neves <sneves@dei.uc.pt>
References: <20191211170936.385572-1-Jason@zx2c4.com>
 <20191212093008.217086-1-Jason@zx2c4.com>
 <20191212093008.217086-2-Jason@zx2c4.com>
 <ab103a1e20889d6f4d1a68991e29ae542c85c83c.camel@strongswan.org>
 <CAHmME9qTsQN5-k+Rjgh2C1r6jhBDFSio+qyzUW8b5imOGQdi1A@mail.gmail.com>
From:   Andy Polyakov <appro@openssl.org>
Openpgp: preference=signencrypt
Autocrypt: addr=appro@openssl.org; prefer-encrypt=mutual; keydata=
 mQENBFNZdigBCADYvjID0luCLvtTWwNoaFK4HQJyYYPS3b5C+y8T8vZG5kJUSNat7jG2AFNa
 oDqmqBBj9CnHl7NHO9dGU8g9RQhWOFLmsCUGe/rHCnDcdyYfsIQqKzfFnFjw5dIbki9PaBja
 2/OYMRBeHTT/YKfTUQuZLMqmwB+XcpFuS5ta3dwCwDaB2GW0nPcJWIo4hO40PPJwup3fWei5
 09qlmHpiNGbvQUt542+nMNyFzsny0AFNUrwF3xFbyDsOhI3h7usbcwdcJTwB7h4dJR/OxMGU
 6EBXLDCbY8dqgykcKo733VZ0O/C1w8e9az9cat3bEm2sbu3MSe1SS36xw0GpyNz9DFZHABEB
 AAG0IUFuZHkgUG9seWFrb3YgPGFwcHJvQG9wZW5zc2wub3JnPokBQgQTAQIALAIbIwUJCWYB
 gAcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheABQJTWXkRAhkBAAoJELps2kYf6OAjg4QH/ieP
 1IlLtXMU/Ug8jMsgMjzypzJoFsbKy5orYyIO1F+KGWcBCKKHPwoObsLke+reMxXNq+z0zuOm
 E3TvCDD2ILqJ6xpnCfN1HHjFKRm4MvBHK0lHGyQRkZs+LxTA828owCHbySERybHsa9dVfw6m
 U+0hDBakForRmhoAwGbJQOAgU3n38L6FAGObS47LLpUhA1mBObHlQxInBDAUhLh0M8yhwOxZ
 xubYRHR3OAkzU8zRl6KB5xuhdJlYuKmogMoHuwAI0blLLaGz8ZgYr+NtOFWbxG4QJxBLblQM
 6GtXOqVy+ILpOrg0M+6SMqm2vnlz2ngJ2KC0sdF6dltmbtS5Puc=
Message-ID: <b98b4e27-3e13-23bc-c07e-54661e4d88ed@openssl.org>
Date:   Sun, 15 Dec 2019 18:04:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAHmME9qTsQN5-k+Rjgh2C1r6jhBDFSio+qyzUW8b5imOGQdi1A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

>>  * It removes the existing SSE2 code path. Most likely not that much of
>>    an issue due to the new AVX variant.
> 
> It's not clear that that sse2 code is even faster than the x86_64
> scalar code in the new implementation, actually. Either way,
> regardless of that, in spite of the previous sentence, I don't think
> it really matters, based on the chips we care about targeting.

There is remark in commentary section. SSE2 was faster on P4 and and
early Core processors, but for non-Intel and contemporary
non-AVX-capable processors, most notably from Atom family, scalar x86_64
*is* fastest option. As for scalar performance on legacy Intel
processors, for me omitting SSE2 meant ~33% loss for oldest P4 and less
for not as old ones. [Just in case, situation is naturally different on
32-bit systems. From coverage vs. performance viewpoint SSE2+AVX2 is
arguably more suitable mix in 32-bit case, AVX makes lesser sense,
because gain is not impressive enough in comparison to SSE2.]

Cheers.
