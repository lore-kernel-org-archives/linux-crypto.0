From: Matt Corallo <linux@bluematt.me>
Subject: Re: KPP API and Temporary Keys
Date: Fri, 28 Jul 2017 16:00:54 -0400
Message-ID: <9394e0ca-b45b-1a87-e638-0e3d76e3cd22@bluematt.me>
References: <315eea31-1548-e61d-e355-a523dbcefb7f@bluematt.me>
 <8680768.s9vD93Vl1j@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, Kyle Rose <krose@krose.org>
To: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.bluematt.me ([192.241.179.72]:41332 "EHLO mail.bluematt.me"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752877AbdG1UA7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jul 2017 16:00:59 -0400
In-Reply-To: <8680768.s9vD93Vl1j@tauon.chronox.de>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Yea, and while I understand this API is very useful for hardware
accelerated (and, more often, secured) crypto and generally being very
neatly pluggable, its, IMO, significantly less useful for many key
agreement uses-cases.

At least in the ever-more-used pattern of doing temporary key agreement
for forward secrecy as a part of a larger protocol, using secure
hardware which generates and keeps the keys in hardware is probably not
what you want (you're about to throw them away anyway, and so the only
thing an attacker might actually care about is the *result* of the key
agreement, which you're almost certainly gonna pull out of any secure
hardware and pass into AES after some hashing).

Thus, while hardware-accelerated key agreement is nice, hardware-secured
(which if nothing else will likely add latency) key agreement is
probably exactly not what you want for such forward-secrecy temporary
key agreement stuff, in which case the key-per-tfm instead of
key-per-request limitation doesn't match requirements of the driver,
only the API to keep it compatible with secure hardware which you're
unlikely to want to use.

Even worse, when I'm looking at tcpcrypt, not adding undue complication,
or, really, overhead, is a pretty important goal for something in the
tcp stack (especially for someone who doesn't know the TCP stack, and
avoiding complexity is a good target for avoiding breaking things), and
while a pool of "workers" should work fine, spending time optimizing
that to ensure it properly frees workers if load decreases (or memory
load increases) while avoiding hitting the slowpath all the time strikes
me as non-ideal complexity.

I get that some of the arguments are based on my lack of knowledge,
making them mostly invalid, so for now I'll look at making a tcp pool
manager for KPP, but if its appropriate, I'd prefer to put it in cryoto/
to encourage someone to eventually get pissed off at it and clean it up
to use backend drivers directly when they support it :p.

Thanks,
Matt

On 07/28/17 02:02, Stephan Müller wrote:
> Am Freitag, 28. Juli 2017, 02:16:24 CEST schrieb Matt Corallo:
> 
> Hi Matt,
> 
>> Hi linux-crypto,
>>
>> Working on hacking together a tcpcrypt implementation which needs to use
>> KPP/ECDH based on new temporary keys for each new connections which uses
>> encryption. Sadly, the KPP API seems to be very much targeted at
>> long-term keys (likely cause most of the crypto API is used that way -
>> bring up an instance of AES for your drive encryption and keep it around
>> with the same key forever), and gets rather inefficient if you want to
>> use it with short-term keys.
>>
>> eg if you were to implement tcpcrypt with the current API, you're going
>> to call crypto_alloc_kpp (and, thus, do a locked scan of
>> crypto_alg_list, a module_get, etc) on every new TCP connection that
>> successfully negotiates encryption, only to free it in a packet or two
>> when you've negotiated session keys, and probably keep around an extra
>> one always to create a module dependency (or am I missing how something
>> works, there?).
>>
>> Since I mostly don't know what I'm doing, I figured I should ask what
>> people think about tweaking the API somewhat:
>>
>> (0) I missed something obvious about the API (or some other part of
>> linux-crypto) and should be using it in a much smarter way.
> 
> A TFM object holds the key and the request object holds the referenct to the 
> data to be processed with the cipher. Every request object is processed with a 
> TFM object.
> 
> If you want to have multiple keys at the same time, you need as many TFM 
> objects.
> 
> But it is permissible to reset the key on a TFM object.
> 
> Thus, you may want to consider having a pool of allocated TFM objects which 
> you re-use for new connections (or what you want it for) and update the key 
> for it.
>>
>> (1) add some new kpp-like API that lets you get a crypto_alg which
>> doesn't store its own private key but lets you do DH with a provided
>> private key in the request?
> 
> This violates the basic concept of the API. As said, however, you can reuse a 
> live TFM.
>>
>> (2) Tweak the KPP API to look more like the above (it has rather few
>> users in-tree at the moment).
>>
>> (3) Do some dirty higher-level hack like keeping a pool of crypto_kpps.
> 
> Why should that be a hack?
> 
> There are many cases where a pool of "workers" are used.
>>
>> I'm happy to work on a patch to do any of the above :).
>>
>> Thanks,
>> Matt
> 
> 
> 
> Ciao
> Stephan
> 
