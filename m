From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [RFC PATCH v4] IV Generation algorithms for dm-crypt
Date: Mon, 6 Mar 2017 16:38:00 +0200
Message-ID: <CAOtvUMdrQA4okKhiCyVmosQ4Oc2PHO4k4wLrDz-_fCyWB1rWBw@mail.gmail.com>
References: <1486463731-6224-1-git-send-email-binoy.jayan@linaro.org>
	<CAOtvUMcN8s886978vE6T=AE79KkZsLBnXsmhewnb5PB0UyAG3A@mail.gmail.com>
	<CAHv-k_8rgArzV2uQ64h1ZTNRpssX1jMf=RwuPoBmsjQ0FhCsWA@mail.gmail.com>
	<68f70534-a309-46ba-a84d-8acc1e6620e5@gmail.com>
	<CAOtvUMf3c0fUjABmbfMrbs0W4gyhKVZyc_tZH3rQg65zF18YMg@mail.gmail.com>
	<b563eb97-82ba-69d2-c4c5-66bc716a7507@gmail.com>
	<CAOtvUMePYT7OJDKL7i0y3y6Jvqsxyx6Je6g9aGKVq6PLZ_-Z8w@mail.gmail.com>
	<2aef6e54-805f-e09b-ae66-c198f8c05335@gmail.com>
	<c835926e-c2bd-8a52-34db-6c605301bc2b@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Binoy Jayan <binoy.jayan@linaro.org>, Rajendra <rnayak@codeaurora.org>,
        Herbert Xu <herbert@gondor.apana.org.au>, Oded <oded.golombek@arm.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, Mark Brown <broonie@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        Shaohua Li <shli@kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Alasdair Kergon <agk@redhat.com>, Ofir <Ofir.Drang@arm.com>
To: Milan Broz <gmazyland@gmail.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <c835926e-c2bd-8a52-34db-6c605301bc2b@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

On Wed, Mar 1, 2017 at 5:38 PM, Milan Broz <gmazyland@gmail.com> wrote:
>
> On 03/01/2017 02:04 PM, Milan Broz wrote:
>> On 03/01/2017 01:42 PM, Gilad Ben-Yossef wrote:
>> ...
>>
>>> I can certainly understand if you don't wont to take the patch until
>>> we have results with
>>> dm-crypt itself but the difference between 8 separate invocation of
>>> the engine for 512
>>> bytes of XTS and a single invocation for 4KB are pretty big.
>>
>> Yes, I know it. But the same can be achieved if we just implement
>> 4k sector encryption in dmcrypt. It is incompatible with LUKS1
>> (but next LUKS version will support it) but I think this is not
>> a problem for now.
>>
>> If the underlying device supports atomic write of 4k sectors, then
>> there should not be a problem.
>>
>> This is one of the speed-up I would like to compare with the IV approach,
>> because everyone should benefit from 4k sectors in the end.
>> And no crypto API changes are needed here.
>>
>> (I have an old patch for this, so I will try to revive it.)
>
> If anyone interested, simple experimental patch for larger sector size
> (up to the page size) for dmcrypt is in this branch:
>
> http://git.kernel.org/cgit/linux/kernel/git/mbroz/linux.git/log/?h=dm-crypt-4k-sector
>
> It would be nice to check what performance gain could be provided
> by this simple approach.


I gave it a spin on a x86_64 with 8 CPUs with AES-NI using cryptd and
on Arm  using CryptoCell hardware accelerator.

There was no difference in performance between 512 and 4096 bytes
cluster size on the x86_64 (800 MB loop file system)

There was an improvement in latency of 3.2% between 512 and 4096 bytes
cluster size on the Arm. I expect the performance benefits for this
test for Binoy's patch to be the same.

In both cases the very naive test was a simple dd with block size of
4096 bytes or the raw block device.

I do not know what effect having a bigger cluster size would have on
have on other more complex file system operations.
Is there any specific benchmark worth testing with?


Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
