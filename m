From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: KPP API and Temporary Keys
Date: Fri, 28 Jul 2017 08:02:21 +0200
Message-ID: <8680768.s9vD93Vl1j@tauon.chronox.de>
References: <315eea31-1548-e61d-e355-a523dbcefb7f@bluematt.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, Kyle Rose <krose@krose.org>
To: Matt Corallo <linux@bluematt.me>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60816 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751163AbdG1GCY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jul 2017 02:02:24 -0400
In-Reply-To: <315eea31-1548-e61d-e355-a523dbcefb7f@bluematt.me>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 28. Juli 2017, 02:16:24 CEST schrieb Matt Corallo:

Hi Matt,

> Hi linux-crypto,
> 
> Working on hacking together a tcpcrypt implementation which needs to use
> KPP/ECDH based on new temporary keys for each new connections which uses
> encryption. Sadly, the KPP API seems to be very much targeted at
> long-term keys (likely cause most of the crypto API is used that way -
> bring up an instance of AES for your drive encryption and keep it around
> with the same key forever), and gets rather inefficient if you want to
> use it with short-term keys.
> 
> eg if you were to implement tcpcrypt with the current API, you're going
> to call crypto_alloc_kpp (and, thus, do a locked scan of
> crypto_alg_list, a module_get, etc) on every new TCP connection that
> successfully negotiates encryption, only to free it in a packet or two
> when you've negotiated session keys, and probably keep around an extra
> one always to create a module dependency (or am I missing how something
> works, there?).
> 
> Since I mostly don't know what I'm doing, I figured I should ask what
> people think about tweaking the API somewhat:
> 
> (0) I missed something obvious about the API (or some other part of
> linux-crypto) and should be using it in a much smarter way.

A TFM object holds the key and the request object holds the referenct to the 
data to be processed with the cipher. Every request object is processed with a 
TFM object.

If you want to have multiple keys at the same time, you need as many TFM 
objects.

But it is permissible to reset the key on a TFM object.

Thus, you may want to consider having a pool of allocated TFM objects which 
you re-use for new connections (or what you want it for) and update the key 
for it.
> 
> (1) add some new kpp-like API that lets you get a crypto_alg which
> doesn't store its own private key but lets you do DH with a provided
> private key in the request?

This violates the basic concept of the API. As said, however, you can reuse a 
live TFM.
> 
> (2) Tweak the KPP API to look more like the above (it has rather few
> users in-tree at the moment).
> 
> (3) Do some dirty higher-level hack like keeping a pool of crypto_kpps.

Why should that be a hack?

There are many cases where a pool of "workers" are used.
> 
> I'm happy to work on a patch to do any of the above :).
> 
> Thanks,
> Matt



Ciao
Stephan
