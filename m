From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: Re: [RFC PATCH v4] IV Generation algorithms for dm-crypt
Date: Wed, 22 Feb 2017 11:42:28 +0530
Message-ID: <CAHv-k_8rgArzV2uQ64h1ZTNRpssX1jMf=RwuPoBmsjQ0FhCsWA@mail.gmail.com>
References: <1486463731-6224-1-git-send-email-binoy.jayan@linaro.org> <CAOtvUMcN8s886978vE6T=AE79KkZsLBnXsmhewnb5PB0UyAG3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Oded <oded.golombek@arm.com>, Ofir <Ofir.Drang@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org,
        Rajendra <rnayak@codeaurora.org>,
        Milan Broz <gmazyland@gmail.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOtvUMcN8s886978vE6T=AE79KkZsLBnXsmhewnb5PB0UyAG3A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

On 8 February 2017 at 13:02, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> On Tue, Feb 7, 2017 at 12:35 PM, Binoy Jayan <binoy.jayan@linaro.org> wrote:
>> ===============================================================================
>> dm-crypt optimization for larger block sizes
>> ===============================================================================
>>
>> Currently, the iv generation algorithms are implemented in dm-crypt.c. The goal
>> is to move these algorithms from the dm layer to the kernel crypto layer by
>> implementing them as template ciphers so they can be used in relation with
>> algorithms like aes, and with multiple modes like cbc, ecb etc. As part of this
>> patchset, the iv-generation code is moved from the dm layer to the crypto layer
>> and adapt the dm-layer to send a whole 'bio' (as defined in the block layer)
>> at a time. Each bio contains the in memory representation of physically
>> contiguous disk blocks. Since the bio itself may not be contiguous in main
>> memory, the dm layer sets up a chained scatterlist of these blocks split into
>> physically contiguous segments in memory so that DMA can be performed.

> Ran Bonnie++ on it last night  (Luks mode, plain64, Qemu Virt platform
> Arm64) and it works just fine.
>
> Tested-by: Gilad Ben-Yossef <gilad@benyossef.com>

I was wondering if this is near to be ready for submission (apart from
the testmgr.c
changes) or I need to make some changes to make it similar to the IPSec offload?

Thanks,
Binoy
