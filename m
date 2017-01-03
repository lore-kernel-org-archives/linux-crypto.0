From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [RFC PATCH v2] crypto: Add IV generation algorithms
Date: Tue, 3 Jan 2017 16:23:10 +0200
Message-ID: <CAOtvUMc_X1DUuR8NTvOLjW7h-p=X14tFHFqe_dB8t08-nYBPcw@mail.gmail.com>
References: <1481618949-20086-1-git-send-email-binoy.jayan@linaro.org> <1481618949-20086-2-git-send-email-binoy.jayan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Oded <oded.golombek@arm.com>, Ofir <Ofir.Drang@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org,
        Rajendra <rnayak@codeaurora.org>, gilad.benyossef@arm.com
To: Binoy Jayan <binoy.jayan@linaro.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1481618949-20086-2-git-send-email-binoy.jayan@linaro.org>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Binoy,

On Tue, Dec 13, 2016 at 02:19:09PM +0530, Binoy Jayan wrote:
> Currently, the iv generation algorithms are implemented in dm-crypt.c.
> The goal is to move these algorithms from the dm layer to the kernel
> crypto layer by implementing them as template ciphers so they can be
> implemented in hardware for performance. As part of this patchset, the
> iv-generation code is moved from the dm layer to the crypto layer and
> adapt the dm-layer to send a whole 'bio' (as defined in the block layer)
> at a time. Each bio contains the in memory representation of physically
> contiguous disk blocks. The dm layer sets up a chained scatterlist of
> these blocks split into physically contiguous segments in memory so that
> DMA can be performed. The iv generation algorithms implemented in geniv.c
> include plain, plain64, essiv, benbi, null, lmk and tcw.
>

Good idea. I wanted to test the patch but alas it does not apply cleanly.
You seem to have a blank line at the end of files and other small
transgressions that makes checkpatch grumpy.

<snip>

Also...

>
> Not-signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>


What is Not-signed-off-by ? :-)

Thanks,
Gilad Ben-Yossef
