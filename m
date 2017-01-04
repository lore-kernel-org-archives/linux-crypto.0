From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: Re: [RFC PATCH v2] crypto: Add IV generation algorithms
Date: Wed, 4 Jan 2017 10:50:38 +0530
Message-ID: <CAHv-k_-n4sT_SqgpTfZwnyn-QsfEQBpjo43w-r+CHD=fYS7PKA@mail.gmail.com>
References: <1481618949-20086-1-git-send-email-binoy.jayan@linaro.org>
 <1481618949-20086-2-git-send-email-binoy.jayan@linaro.org> <CAOtvUMc_X1DUuR8NTvOLjW7h-p=X14tFHFqe_dB8t08-nYBPcw@mail.gmail.com>
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
        Rajendra <rnayak@codeaurora.org>, gilad.benyossef@arm.com
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOtvUMc_X1DUuR8NTvOLjW7h-p=X14tFHFqe_dB8t08-nYBPcw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Gilad,

On 3 January 2017 at 19:53, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> Good idea. I wanted to test the patch but alas it does not apply cleanly.
> You seem to have a blank line at the end of files and other small
> transgressions that makes checkpatch grumpy.

I think that is because there were some key structure changes in dm-crypt
after I sent out v2. I have resolved them while working on v3. Please wait for
the next version of the patchset. I'll send it probably by next week.
I wanted to incorporate a few changes suggested by Herbert before sending them.

> What is Not-signed-off-by ? :-)

It was just an RFC patch, not ready for merging.

Thanks,
Binoy
