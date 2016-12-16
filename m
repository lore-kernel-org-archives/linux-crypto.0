From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: Re: [RFC PATCH v2] crypto: Add IV generation algorithms
Date: Fri, 16 Dec 2016 11:25:16 +0530
Message-ID: <CAHv-k_997mzCDih46psH_m4URLFYJzE0mtk8ciLSAHFeZyVtZg@mail.gmail.com>
References: <1481618949-20086-1-git-send-email-binoy.jayan@linaro.org>
 <1481618949-20086-2-git-send-email-binoy.jayan@linaro.org> <d6d92865-98fa-4d02-035f-9080bc265c35@gmail.com>
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
        Rajendra <rnayak@codeaurora.org>
To: Milan Broz <gmazyland@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d6d92865-98fa-4d02-035f-9080bc265c35@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Milan,

On 13 December 2016 at 15:31, Milan Broz <gmazyland@gmail.com> wrote:

> I think that IV generators should not modify or read encrypted data directly,
> it should only generate IV.

I was trying to find more information about what you said and how a
iv generator should be written. I saw two examples of IV generators
too used with AEAD ciphers (crypto/seqiv.c and crypto/echainiv.c)

Excerpt from crypto api doc:
http://www.chronox.de/crypto-API/crypto/architecture.html#crypto-api-cipher-references-and-priority

2. Now, SEQIV uses the AEAD API function calls to invoke the associated
AEAD cipher. In our case, during the instantiation of SEQIV, the cipher
handle for GCM is provided to SEQIV. This means that SEQIV invokes
AEAD cipher operations with the GCM cipher handle.

Here, it says seqiv invokes cipher operations. However the code crypto/seqiv.c
does not look similar to how the modes are implemented which is confusing. I
was looking for an example of an IV generator used with a regular block cipher
and not a AEAD cipher. Could you point me out to some?

Thanks,
Binoy
