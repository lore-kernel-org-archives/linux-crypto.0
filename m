From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: Re: [RFC PATCH v2] crypto: Add IV generation algorithms
Date: Thu, 22 Dec 2016 16:25:12 +0530
Message-ID: <CAHv-k_-EKq2g=Wb+YkPVp9gCXTDEyrxZhQpT5JMSw=WtZ1OC9w@mail.gmail.com>
References: <1481618949-20086-1-git-send-email-binoy.jayan@linaro.org>
 <1481618949-20086-2-git-send-email-binoy.jayan@linaro.org>
 <d6d92865-98fa-4d02-035f-9080bc265c35@gmail.com> <20161222085509.GA2160@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Milan Broz <gmazyland@gmail.com>, Oded <oded.golombek@arm.com>,
        Ofir <Ofir.Drang@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org,
        Rajendra <rnayak@codeaurora.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161222085509.GA2160@gondor.apana.org.au>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

On 22 December 2016 at 14:25, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Dec 13, 2016 at 11:01:08AM +0100, Milan Broz wrote:
>>
>> By the move everything to cryptoAPI we are basically introducing some strange mix
>> of IV and modes there, I wonder how this is going to be maintained.
>> Anyway, Herbert should say if it is ok...
>
> Well there is precedent in how do the IPsec IV generation.  In
> that case the IV generators too are completely specific to that
> application, i.e., IPsec.  However, the way structured it allowed
> us to have one single entry path from the IPsec stack into the
> crypto layer regardless of whether you are using AEAD or traditional
> encryption/hashing algorithms.
>
> For IPsec we make the IV generators behave like normal AEAD
> algorithms, except that they take the sequence number as the IV.
>
> The goal here are obviously different.  However, by employing
> the same method as we do in IPsec, it appears to me that you
> can effectively process multiple blocks at once instead of having
> to supply one block at a time due to the IV generation issue.

Thank you for clarifying that part.:)
So, I hope we can consider algorithms like lmk and tcw too as IV generation
algorithms, even though they manipulate encrypted data directly?

>> I really do not think the disk encryption key management should be moved
>> outside of dm-crypt. We cannot then change key structure later easily.

I agree with this too, only problem with this is when multiple keys are involved
(where the master key is split into 2 or more), and the key selection is made
with a modular division of the (512-byte) sector number by the number of keys.

> It doesn't have to live outside of dm-crypt.  You can register
> these IV generators from there if you really want.

Sorry, but I didn't understand this part.

Thanks,
Binoy
