From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: [PATCH 1/3] random: replace non-blocking pool with a
 Chacha20-based CRNG
Date: Wed, 4 May 2016 12:54:13 -0400
Message-ID: <CAH8yC8m8hcL-gtWA_SbXOKSNRWV+nwzJRHBiEeMKEiz8ZR5M9Q@mail.gmail.com>
References: <1462170413-7164-1-git-send-email-tytso@mit.edu>
	<1462170413-7164-2-git-send-email-tytso@mit.edu>
	<6266306.8u6rsYMSBi@positron.chronox.de>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>, andi@firstfloor.org,
	Sandy Harris <sandyinchina@gmail.com>,
	cryptography@lakedaemon.net, jsd@av8n.com, hpa@zytor.com,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:36037 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbcEDQyO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2016 12:54:14 -0400
In-Reply-To: <6266306.8u6rsYMSBi@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>> +     chacha20_block(&crng->state[0], out);
>> +     if (crng->state[12] == 0)
>> +             crng->state[13]++;
>
> state[12]++? Or why do you increment the nonce?

In Bernstein's Salsa and ChaCha, the counter is 64-bit. It appears
ChaCha-TLS uses a 32-bit counter, and the other 32-bits is given to
the nonce.

Maybe the first question to ask is, what ChaCha is the kernel
providing? If its ChaCha-TLS, then the carry does not make a lot of
sense.

If the generator is limiting the amount of material under a given set
of security parameters (key and nonce), then the generator will likely
re-key itself long before the 256-GB induced wrap. In this case, it
does not matter which ChaCha the kernel is providing and the carry is
superfluous.

Jeff
