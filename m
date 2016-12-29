From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: Re: [RFC PATCH v2] crypto: Add IV generation algorithms
Date: Thu, 29 Dec 2016 14:53:25 +0530
Message-ID: <CAHv-k_9SynECq7qDbrW59=LsV_WNj+9Ffa=6tATyNKOt36he6Q@mail.gmail.com>
References: <1481618949-20086-1-git-send-email-binoy.jayan@linaro.org>
 <1481618949-20086-2-git-send-email-binoy.jayan@linaro.org>
 <d6d92865-98fa-4d02-035f-9080bc265c35@gmail.com> <20161222085509.GA2160@gondor.apana.org.au>
 <CAHv-k_-EKq2g=Wb+YkPVp9gCXTDEyrxZhQpT5JMSw=WtZ1OC9w@mail.gmail.com> <20161223075114.GA3580@gondor.apana.org.au>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161223075114.GA3580@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

Sorry for the delayed response, I was busy with testing dm-crypt
with bonnie++ for regressions. I tried to find some alternative
way to keep the IV algorithms' registration in the dm-crypt.
Also there were some changes done in dm-crypt keys structure too
recently.

c538f6e dm crypt: add ability to use keys from the kernel key retention service

On Thu, Dec 22, 2016 at 04:25:12PM +0530, Binoy Jayan wrote:
>
> > It doesn't have to live outside of dm-crypt.  You can register
> > these IV generators from there if you really want.
>
> Sorry, but I didn't understand this part.

What I mean is that moving the IV generators into the crypto API
does not mean the dm-crypt team giving up control over them.  You
could continue to keep them within the dm-crypt code base and
still register them through the normal crypto API mechanism

When we keep these in dm-crypt and if more than one key is used
(it is actually more than one parts of the original key),
there are more than one cipher instance created - one for each
unique part of the key. Since the crypto requests are modelled
to go through the template ciphers in the order:

"essiv -> cbc -> aes"

a particular cipher instance of the IV (essiv in this example) is
responsible to encrypt an entire bigger block. If this bigger block
is to be later split into 512 bytes blocks and then encrypted using
the other cipher instance depending on the following formula:

key_index = sector & (key_count - 1)

it is not possible as the cipher instances do not have access to
each other's instances. So, number of keys used is crucial while
performing encryption.

If there was only a single key, it should not have been a problem.
But if there are more than one key, then encrypting a bigger block
with a single key would cause backward incompatibility.
I was wondering if this is acceptable.

bigger block: What I mean by bigger block here is the set of 512-byte
blocks that dm-crypt can be optimized to process at once.

Thanks,
Binoy
