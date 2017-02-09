From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: Re: [RFC PATCH v4] IV Generation algorithms for dm-crypt
Date: Thu, 9 Feb 2017 14:00:36 +0530
Message-ID: <CAHv-k__7ks245eB8ZvnTjni_+25bf_hZjCn67_h970nC2ndYQQ@mail.gmail.com>
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

On 8 February 2017 at 13:02, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>
> Ran Bonnie++ on it last night  (Luks mode, plain64, Qemu Virt platform
> Arm64) and it works just fine.
>
> Tested-by: Gilad Ben-Yossef <gilad@benyossef.com>
>

Hi Gilad,

Thank you for testing it. Do you have access to a device having crypto
hardware with IV generation capability and associated drivers for let
say, aes with cbc or any another mode? I was wondering if I can customize
it to work with dm-crypt by generating IVs automatically. Please let
me know your thoughts.

Thanks,
Binoy
