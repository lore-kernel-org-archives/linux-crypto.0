From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [RFC PATCH v4] IV Generation algorithms for dm-crypt
Date: Wed, 1 Mar 2017 16:38:09 +0100
Message-ID: <c835926e-c2bd-8a52-34db-6c605301bc2b@gmail.com>
References: <1486463731-6224-1-git-send-email-binoy.jayan@linaro.org>
 <CAOtvUMcN8s886978vE6T=AE79KkZsLBnXsmhewnb5PB0UyAG3A@mail.gmail.com>
 <CAHv-k_8rgArzV2uQ64h1ZTNRpssX1jMf=RwuPoBmsjQ0FhCsWA@mail.gmail.com>
 <68f70534-a309-46ba-a84d-8acc1e6620e5@gmail.com>
 <CAOtvUMf3c0fUjABmbfMrbs0W4gyhKVZyc_tZH3rQg65zF18YMg@mail.gmail.com>
 <b563eb97-82ba-69d2-c4c5-66bc716a7507@gmail.com>
 <CAOtvUMePYT7OJDKL7i0y3y6Jvqsxyx6Je6g9aGKVq6PLZ_-Z8w@mail.gmail.com>
 <2aef6e54-805f-e09b-ae66-c198f8c05335@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Binoy Jayan <binoy.jayan@linaro.org>, Oded <oded.golombek@arm.com>,
        Ofir <Ofir.Drang@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org,
        Rajendra <rnayak@codeaurora.org>,
        Ondrej Mosnacek <omosnace@redhat.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2aef6e54-805f-e09b-ae66-c198f8c05335@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


On 03/01/2017 02:04 PM, Milan Broz wrote:
> On 03/01/2017 01:42 PM, Gilad Ben-Yossef wrote:
> ...
> 
>> I can certainly understand if you don't wont to take the patch until
>> we have results with
>> dm-crypt itself but the difference between 8 separate invocation of
>> the engine for 512
>> bytes of XTS and a single invocation for 4KB are pretty big.
> 
> Yes, I know it. But the same can be achieved if we just implement
> 4k sector encryption in dmcrypt. It is incompatible with LUKS1
> (but next LUKS version will support it) but I think this is not
> a problem for now.
> 
> If the underlying device supports atomic write of 4k sectors, then
> there should not be a problem.
> 
> This is one of the speed-up I would like to compare with the IV approach,
> because everyone should benefit from 4k sectors in the end.
> And no crypto API changes are needed here.
> 
> (I have an old patch for this, so I will try to revive it.)

If anyone interested, simple experimental patch for larger sector size
(up to the page size) for dmcrypt is in this branch:

http://git.kernel.org/cgit/linux/kernel/git/mbroz/linux.git/log/?h=dm-crypt-4k-sector

It would be nice to check what performance gain could be provided
by this simple approach.

Milan
