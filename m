From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: Re: [RFC PATCH v3] crypto: Add IV generation algorithms
Date: Thu, 19 Jan 2017 20:33:50 +0530
Message-ID: <CAHv-k_85e8d3_O50-DEynw=AXSfuFXfj4LT2cqVv2zqwMnG+Pw@mail.gmail.com>
References: <1484732425-10319-1-git-send-email-binoy.jayan@linaro.org>
 <1484732425-10319-2-git-send-email-binoy.jayan@linaro.org>
 <CAOtvUMfhethgZ8TarKGDumL1W5fgjwy1Hi7f88mmCCD6vJ_hLg@mail.gmail.com>
 <CAHv-k_-7m_oiVgzB5a3_=R9+fouxUc6fyxSchGtxfUKP00eM4w@mail.gmail.com> <CAOtvUMenhgAuZXcsUPpOd5RfQh8XE9krve5YsFF3h-gK8KfDYQ@mail.gmail.com>
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
In-Reply-To: <CAOtvUMenhgAuZXcsUPpOd5RfQh8XE9krve5YsFF3h-gK8KfDYQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Gilad,

On 19 January 2017 at 15:17, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> I tried adding sg_init_table() where I thought it was appropriate and
> it didn't resolve the issue.
>
> For what it's worth, my guess is that the difference between our
> setups is not related to Arm but to other options or the storage I'm
> using.

I was able to reproduce this again on my qemu setup with a 1GB virtual
disk. That is the same thing I do with the x86 setup as well.

> Are you using cryptd?

You mean config CRYPTO_CRYPTD?

-Binoy
