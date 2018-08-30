From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: Locking for HW crypto accelerators
Date: Thu, 30 Aug 2018 15:27:31 +0200
Message-ID: <20180830132732eucas1p12b941ed065276c0cbed6e7b1e01a30dc~PrH1zJtnY2603926039eucas1p1b@eucas1p1.samsung.com>
References: <CAJKOXPfVXnazraHq-NCCM+h26FFi1U6Z3OSYOX17XH3bj-UDLQ@mail.gmail.com>
        <3053033.se6UkFii4W@tauon.chronox.de>
        <CGME20180830130922epcas1p35b0395da64de59107a805c6b99d770c2@epcas1p3.samsung.com>
        <CAJKOXPd7JdzM2_PiHkS1ix1yU9hZmMbGDZaL07vbON0XzORH=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Krzysztof Kozlowski <krzk@kernel.org>, smueller@chronox.de
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJKOXPd7JdzM2_PiHkS1ix1yU9hZmMbGDZaL07vbON0XzORH=w@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 30.08.2018 15:09, Krzysztof Kozlowski wrote:
> [...]
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
> 
> Best regards,
> Krzysztof
Can your hardware do export/import ?

If yes, you can use workqueue and guard HW with spinlock,
as in exynos hash in s5p-sss.c (or see other drivers).

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland
