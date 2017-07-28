From: Matt Corallo <linux@bluematt.me>
Subject: KPP API and Temporary Keys
Date: Thu, 27 Jul 2017 20:16:24 -0400
Message-ID: <315eea31-1548-e61d-e355-a523dbcefb7f@bluematt.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Kyle Rose <krose@krose.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.bluematt.me ([192.241.179.72]:41316 "EHLO mail.bluematt.me"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751551AbdG1AYt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jul 2017 20:24:49 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi linux-crypto,

Working on hacking together a tcpcrypt implementation which needs to use
KPP/ECDH based on new temporary keys for each new connections which uses
encryption. Sadly, the KPP API seems to be very much targeted at
long-term keys (likely cause most of the crypto API is used that way -
bring up an instance of AES for your drive encryption and keep it around
with the same key forever), and gets rather inefficient if you want to
use it with short-term keys.

eg if you were to implement tcpcrypt with the current API, you're going
to call crypto_alloc_kpp (and, thus, do a locked scan of
crypto_alg_list, a module_get, etc) on every new TCP connection that
successfully negotiates encryption, only to free it in a packet or two
when you've negotiated session keys, and probably keep around an extra
one always to create a module dependency (or am I missing how something
works, there?).

Since I mostly don't know what I'm doing, I figured I should ask what
people think about tweaking the API somewhat:

(0) I missed something obvious about the API (or some other part of
linux-crypto) and should be using it in a much smarter way.

(1) add some new kpp-like API that lets you get a crypto_alg which
doesn't store its own private key but lets you do DH with a provided
private key in the request?

(2) Tweak the KPP API to look more like the above (it has rather few
users in-tree at the moment).

(3) Do some dirty higher-level hack like keeping a pool of crypto_kpps.

I'm happy to work on a patch to do any of the above :).

Thanks,
Matt
