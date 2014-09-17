From: Mathias Krause <minipli@googlemail.com>
Subject: Re: v3.17-rc5: alg: skcipher: Test 4 failed on encryption for ctr-aes-aesni
Date: Wed, 17 Sep 2014 22:17:02 +0200
Message-ID: <CA+rthh9P7EKi7ShwSuXqYFoeXx2R87sA1=MTZ-WaAw9WF-k+2w@mail.gmail.com>
References: <87sijti8kh.fsf@kima.orebokech.com>
	<87fvfr2v3w.fsf@kima.orebokech.com>
	<CA+rthh9cO5WsThL4SwO-1Avxhp4RDvvGQZQtYpQULa2oEg0NYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Chandramouli Narayanan <mouli@linux.intel.com>
To: Romain Francoise <romain@orebokech.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:43198 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207AbaIQURE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Sep 2014 16:17:04 -0400
Received: by mail-la0-f43.google.com with SMTP id gi9so2616175lab.16
        for <linux-crypto@vger.kernel.org>; Wed, 17 Sep 2014 13:17:02 -0700 (PDT)
In-Reply-To: <CA+rthh9cO5WsThL4SwO-1Avxhp4RDvvGQZQtYpQULa2oEg0NYw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 17 September 2014 22:10, Mathias Krause <minipli@googlemail.com> wrote:
> On 16 September 2014 22:01, Romain Francoise <romain@orebokech.com> wrote:
>> On Mon, Sep 15, 2014 at 10:36:46AM +0200, Romain Francoise wrote:
>>> I upgraded from v3.16 to v3.17-rc5 and the ctr-aes-aesni encryption test
>>> fails, which makes my IPsec tunnels unhappy (see trace below). Before I
>>> start bisecting (2cddcc7df8fd3 is probably my first guess), is this
>>> already known?
>>
>>> Sep 15 08:07:56 silenus kernel: [   35.137145] alg: skcipher: Test 4 failed on encryption for ctr-aes-aesni [...]
>
> I do not get the above message on a SandyBridge i7-2620M, even though
> the module makes use of the "by8" variant on my system, too:
>

Never mind! Playing a little with crconf to instantiate 'ctr(aes)' and
I can see the failing test now too.

Thanks,
Mathias
