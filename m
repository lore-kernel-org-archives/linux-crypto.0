From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] crypto: ccree: fix iv copying for small buffers
Date: Thu, 21 Jun 2018 16:35:44 +0300
Message-ID: <CAOtvUMcChKswKBCOkN7DGvK3DcotJBh0y=-Xi8232uYK26-xQA@mail.gmail.com>
References: <1528361927-4172-1-git-send-email-gilad@benyossef.com>
 <CAOtvUMcJfJDjnMoithRQ4ife09VC+G-w+__jV-JLwh7M=s7JNQ@mail.gmail.com>
 <20180613063030.bsrq3xmufcw4zi52@gondor.apana.org.au> <CAOtvUMdtafGwXJFD0Tm1tx1q+TxRsB4nwEKxumE7=--_PMCZrQ@mail.gmail.com>
 <20180619142713.dzipyarpb23a7qne@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: "David S. Miller" <davem@davemloft.net>,
        Hadar Gat <hadar.gat@arm.com>, Ofir Drang <ofir.drang@arm.com>,
        stable@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180619142713.dzipyarpb23a7qne@gondor.apana.org.au>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jun 19, 2018 at 5:27 PM, Herbert Xu <herbert@gondor.apana.org.au> w=
rote:
> On Sun, Jun 17, 2018 at 01:06:42PM +0300, Gilad Ben-Yossef wrote:
>>
>> It was ctr(aes). I wrongly assumed that we are supposed to unconditional=
ly
>> copy
>> the cipher-text block post operation and let the caller do with it what =
it
>> wants and so the
>> code now does that for all cipher operations unconditionally.
>
> For CTR it doesn't matter whether the last block is less than a
> block, you should still increment the counter.

OK. got it. Although I am not sure how does one use this to continue
encryption if the plaintext was not block aligned.
>

>> So what is a good description of what we are supposed to provide in that
>> field post operation?
>> The next IV? but as you stated, that is not necessarily useful for all
>> ciphers.
>
> When in doubt, please refer to the generic implementation.  If
> that is still unclear or if it seems wrong, please post to the
> list.


Got it.

So as a sanity check  if I understood correctly I need to:
- Increment counter in IV for CTS
- Copy last ciphertext block for CFB and CBC to output IV (partial
blocks not allowed)

What about OFB? unless I've missed something there is no generic
implementation... ?


Thanks again,
Gilad

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
