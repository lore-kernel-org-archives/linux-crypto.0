From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [RFC PATCH v4] IV Generation algorithms for dm-crypt
Date: Wed, 8 Feb 2017 09:32:42 +0200
Message-ID: <CAOtvUMcN8s886978vE6T=AE79KkZsLBnXsmhewnb5PB0UyAG3A@mail.gmail.com>
References: <1486463731-6224-1-git-send-email-binoy.jayan@linaro.org>
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
To: Binoy Jayan <binoy.jayan@linaro.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1486463731-6224-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Feb 7, 2017 at 12:35 PM, Binoy Jayan <binoy.jayan@linaro.org> wrote:
> ===============================================================================
> dm-crypt optimization for larger block sizes
> ===============================================================================
>
> Currently, the iv generation algorithms are implemented in dm-crypt.c. The goal
> is to move these algorithms from the dm layer to the kernel crypto layer by
> implementing them as template ciphers so they can be used in relation with
> algorithms like aes, and with multiple modes like cbc, ecb etc. As part of this
> patchset, the iv-generation code is moved from the dm layer to the crypto layer
> and adapt the dm-layer to send a whole 'bio' (as defined in the block layer)
> at a time. Each bio contains the in memory representation of physically
> contiguous disk blocks. Since the bio itself may not be contiguous in main
> memory, the dm layer sets up a chained scatterlist of these blocks split into
> physically contiguous segments in memory so that DMA can be performed.
...
> Binoy Jayan (1):
>   crypto: Add IV generation algorithms
>
>  drivers/md/dm-crypt.c  | 1894 ++++++++++++++++++++++++++++++++++--------------
>  include/crypto/geniv.h |   47 ++
>  2 files changed, 1402 insertions(+), 539 deletions(-)
>  create mode 100644 include/crypto/geniv.h

Ran Bonnie++ on it last night  (Luks mode, plain64, Qemu Virt platform
Arm64) and it works just fine.

Tested-by: Gilad Ben-Yossef <gilad@benyossef.com>

Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
