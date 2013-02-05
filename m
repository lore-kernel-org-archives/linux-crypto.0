From: Mathias Krause <minipli@googlemail.com>
Subject: Re: [PATCH 2/2] crypto: user - fix empty string test in report API
Date: Tue, 5 Feb 2013 09:35:31 +0100
Message-ID: <CA+rthh8Pq4EPXoHS1GtdNBM8w1fdJuCmxjptgaftRBhfjSkUpA@mail.gmail.com>
References: <1359889741-23335-1-git-send-email-minipli@googlemail.com>
	<1359889741-23335-3-git-send-email-minipli@googlemail.com>
	<20130204131552.GA21584@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "David S. Miller" <davem@davemloft.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:59424 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab3BEIfc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Feb 2013 03:35:32 -0500
Received: by mail-lb0-f172.google.com with SMTP id n8so11509lbj.17
        for <linux-crypto@vger.kernel.org>; Tue, 05 Feb 2013 00:35:31 -0800 (PST)
In-Reply-To: <20130204131552.GA21584@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 4, 2013 at 2:15 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Sun, Feb 03, 2013 at 12:09:01PM +0100, Mathias Krause wrote:
>> The current test for empty strings fails because it is testing the
>> address of a field, not a pointer. So the test will always be true.
>> Test for the string length instead.
>>
>> Signed-off-by: Mathias Krause <minipli@googlemail.com>
>> Cc: Steffen Klassert <steffen.klassert@secunet.com>
>
> Good catch.  However, what if cru_driver_name isn't NUL-terminated?

Your objection is totally valid, sure. And my initial idea wouldn't
have that problem as it would just test for the first character to be
'\0', i.e. do something like that:

-       if (!p->cru_driver_name)
+       if (!p->cru_driver_name[0])

But then I looked how the other code in the crypto user API does refer
to string lengths related to cru_driver_name and switched to strlen().
So the other code is (potentially) vulnerable to non-NUL-terminated
strings, too.

So, I think we need another patch that adds sanity checks for
non-NUL-terminated strings. I can do this, maybe this evening, and
send out a new version of the patch series if you like me to.

Regards,
Mathias
