From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: [ANNOUNCE] /dev/random - a new approach (code for 4.11-rc1)
Date: Sat, 18 Mar 2017 09:43:18 -0400
Message-ID: <CAH8yC8nHEQfZCf0j0rcW9KV-DNzkv-Sowch4ROK07HXzT5bFCA@mail.gmail.com>
References: <2785457.pDyvZpZC2q@positron.chronox.de> <CAH8yC8=+K76rwRfYk=92sBE0v9fPEWB=2bUQqF=tyY5C1nrvKQ@mail.gmail.com>
 <4792500.irvFnm0WRl@positron.chronox.de>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4792500.irvFnm0WRl@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

>> > The design and implementation is driven by a set of goals described in [2]
>> > that the LRNG completely implements. Furthermore, [2] includes a
>> > comparison with RNG design suggestions such as SP800-90B, SP800-90C, and
>> > AIS20/31.
>>
>> A quick comment about SP800 and the hardware instructions... RDSEED is
>> 2 to 5 times slower than RDRAND on Intel hardware, depending on the
>> architecture and microarchitecture.
>
> I am not sure how this statement relates to the quote above. RDSEED is the
> CBC-MACed output of the flip-flop providing the raw noise.
>
> RDRAND is the output of the SP800-90A CTR DRBG that is seeded by the CBC-MAC
> that also feeds RDSEED. Thus, RDSEED is as fast as the noise source where
> RDRAND is a pure deterministic RNG that tries to be (re)seeded as often as
> possible.
>
> Both instructions are totally unrelated to the SP800-90A DRBG available to the
> Linux kernel.

SP800-90A requires an entropy source to bootstrap the Hash, HMAC and
CTR generators. That is, the Instantiate and Reseed functions need an
approved source of entropy. Both RDRAND and RDSEED are approved for
Intel chips. See SP800-90A, Section 8.6.5
(http://csrc.nist.gov/publications/nistpubs/800-90A/SP800-90A.pdf).

Jeff
