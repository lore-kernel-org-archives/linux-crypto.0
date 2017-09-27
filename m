From: Christophe LEROY <christophe.leroy@c-s.fr>
Subject: Re: Question about ahash export and import
Date: Wed, 27 Sep 2017 16:59:56 +0200
Message-ID: <0fbf816a-5a0a-b9fc-3441-171116fe4c1c@c-s.fr>
References: <0e54df51-7b4c-a01e-2054-3cdf204a429e@c-s.fr>
 <CGME20170926103514epcas1p4494e6502b2b6835c732201a4aeff60b1@epcas1p4.samsung.com>
 <CAOtvUMeHF8PZAEaniK+oGYVOF5rbD_kZKuGC3j5XXkF-w2pPDA@mail.gmail.com>
 <be29fd42-2e64-5ca8-546c-e7f68a2d0da7@partner.samsung.com>
 <20170927090802.GA1547@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:41223 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752157AbdI0O77 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Sep 2017 10:59:59 -0400
In-Reply-To: <20170927090802.GA1547@gondor.apana.org.au>
Content-Language: fr
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



Le 27/09/2017 à 11:08, Herbert Xu a écrit :
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
> 
>> init(), update() 0 or more times, export(),
>> save exported data to pernament storage
>> reboot machine
>> load crypto driver, import() saved state ?
> 
> Yes this must be supported.
> 
> Basically after any update call is complete (you've called the
> completion function), you should be able to call export and
> completely extract the partial (as opposed to finalised) hash
> state.

Can we consider that once an export has been done, no new update call 
will be performed prior to doing an init or an import ? Or should it be 
possible to continue with an update or a final/finup call after an export ?

> 
> Remember we need to support an arbitrarily large number of
> concurrent hashing operations.  So you cannot keep a hash state
> in hardware indefinitely just because the user has not called
> finalize on it.
> 
> Cheers,
> 

Christophe
