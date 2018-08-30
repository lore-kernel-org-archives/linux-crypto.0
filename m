From: Stephan Mueller <smueller@chronox.de>
Subject: Re: Locking for HW crypto accelerators
Date: Thu, 30 Aug 2018 15:19:09 +0200
Message-ID: <2002208.sm9qV7UXju@tauon.chronox.de>
References: <CAJKOXPfVXnazraHq-NCCM+h26FFi1U6Z3OSYOX17XH3bj-UDLQ@mail.gmail.com> <3053033.se6UkFii4W@tauon.chronox.de> <CAJKOXPd7JdzM2_PiHkS1ix1yU9hZmMbGDZaL07vbON0XzORH=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJKOXPd7JdzM2_PiHkS1ix1yU9hZmMbGDZaL07vbON0XzORH=w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Donnerstag, 30. August 2018, 15:09:05 CEST schrieb Krzysztof Kozlowski:

Hi Krzysztof,

> Thanks Stephan for hints. Let's assume the each of init, update and
> final are atomic... but how about the relation between update and
> final? I have two concurrent users in user-space but only one HW:
> 
> Process A:             Process B:
> init() and set_key()
>                        init() and different key
> update(some_data)
>                        update(different_data)
> final()
>                        final()
> 
> The final() from process A will now produce the result of hashing/CRC
> of some_data and different_data (and even maybe mixed with init() for
> different key). All because in the meantime process B added its own
> data to the HW.

The question is where is the state of the cipher operation kept that is 
produced with each of the init/update/final calls. Your answer implies that 
this state is kept in hardware.

But commonly the state is kept in software. Look at ahash_request for example, 
the __ctx pointer is intended to point to the memory the driver needs to store 
its state.

Pick a random driver implementation and search for ahash_request_ctx, for 
example.
> 
> Best regards,
> Krzysztof



Ciao
Stephan
