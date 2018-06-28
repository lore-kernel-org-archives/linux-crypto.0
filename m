From: Timur Tabi <timur@kernel.org>
Subject: Re: [PATCH 3/3] hwrng: msm - Add support for prng v2
Date: Thu, 28 Jun 2018 17:04:30 -0500
Message-ID: <CAOZdJXVO-0JDvX4OdJMNCmY_BXrEenXpoWBf=Ww5uFBtXKN86A@mail.gmail.com>
References: <20180618141259.23141-1-vkoul@kernel.org> <20180618141259.23141-4-vkoul@kernel.org>
 <20180619142853.wgi5easw4zv6ttrb@gondor.apana.org.au> <966e9cd4-70a3-8d54-df0f-16df3df45fb5@linaro.org>
 <20180621101506.rnklbtapvfdev4xb@gondor.apana.org.au> <e39deb02-8fa4-84ac-b33e-d692402189a1@linaro.org>
 <20180621115312.rfmbitrhqi44wu5w@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Vinod Koul <vinod.koul@linaro.org>,
        linux-crypto@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, Vinod Koul <vkoul@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180621115312.rfmbitrhqi44wu5w@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jun 21, 2018 at 6:53 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Thu, Jun 21, 2018 at 02:27:10PM +0300, Stanimir Varbanov wrote:

> So does it generate one bit of output for each bit of hardware-
> generated entropy like /dev/random? Or does it use a hardware-
> generated seed to power a PRNG?

I have some information to answer this question, although I'm not sure
I can give a strict "yes/no" answer.

There are a couple relevant documents:

https://www.qualcomm.com/news/onq/2014/11/07/cryptographic-module-snapdragon-805-fips-140-2-certified
https://csrc.nist.gov/CSRC/media/projects/cryptographic-module-validation-program/documents/security-policies/140sp2944.pdf

I also got response from a Qualcomm employee:

"The Qualcomm random number generator used in Snapdragon chips
consists of an entropy source coupled with the HASH-DRBG deterministic
random bit generator from NIST Special Publication 800-90A, using
SHA-256 as the hash function.

The entropy source is based on sampled ring oscillators.  Four ring
oscillators are used to provide high assurance of adequate entropy.
The entropy from the ring oscillators is conditioned using the
'derivation function' specified by NIST Special Publication 800-90A.
The conditioned entropy is essentially perfect fully entropic data.
It is used both to seed and to periodically reseed the DRGB."

My understanding is that the PRNG is a real entropy source with some
logic used to normalize the values.  To quote: "No RNG uses data
directly from the entropy source; bits in the output are likely
correlated and unlikely to occur with 50% probability. The entropy
post-processing is designed to turn dirty data in clean data."

Based on the above, it seems to me that the Qualcomm PRNG qualifies as
a real hardware RNG and porting to algif_rng is not the correct path.
