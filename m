From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 2/4] crypto: drbg wait for crypto op not signal safe
Date: Thu, 18 May 2017 12:23:08 +0300
Message-ID: <CAOtvUMdNS_hQhqmiQp9N=72u4DL+tjy1ANzZyhSCkEe8FOargw@mail.gmail.com>
References: <1494503626-15877-1-git-send-email-gilad@benyossef.com>
 <1494503626-15877-3-git-send-email-gilad@benyossef.com> <20170518050933.GA32409@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        David Howells <dhowells@redhat.com>,
        Ofir Drang <ofir.drang@arm.com>,
        Gilad Ben-Yossef <gilad.benyossef@arm.com>,
        Eric Biggers <ebiggers3@gmail.com>, stable@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        keyrings@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20170518050933.GA32409@gondor.apana.org.au>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, May 18, 2017 at 8:09 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Thu, May 11, 2017 at 02:53:43PM +0300, Gilad Ben-Yossef wrote:
>> drbg_kcapi_sym_ctr() was using wait_for_completion_interruptible() to
>> wait for completion of async crypto op but if a signal occurs it
>> may return before DMA ops of HW crypto provider finish, thus
>> corrupting the output buffer.
>>
>> Resolve this by using wait_for_completion() instead.
>>
>> Reported-by: Eric Biggers <ebiggers3@gmail.com>
>> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
>> CC: stable@vger.kernel.org
>
> This patch doesn't even compile.  Please test your work first.

Sigh... I've noticed it, fixed it, compiled it and than went ahead and
squashed the fix with the next patch in series instead of this one
like an idiot.

Please accept my apologies for wasting your time. I'll send a fixed version.

Gilad

>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt



-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
