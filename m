From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH] Documentation: hw_random: Fix issue related to feeding
 entropy pool
Date: Fri, 22 Sep 2017 14:59:25 +0530
Message-ID: <CANc+2y7yDGo7bKMeu7Mo3de2UhjK6_C2oaiCsqpoqpU0cDp-Qg@mail.gmail.com>
References: <20170822161544.24958-1-prasannatsmkumar@gmail.com> <20170922091749.GA15902@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Jonathan Corbet <corbet@lwn.net>, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20170922091749.GA15902@gondor.apana.org.au>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

On 22 September 2017 at 14:47, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com> wrote:
>> There is no need to use rng-tools for feeding random data into kernel
>> entropy pool as hw_random core handles it. Documentation suggested that
>> rng-tools is required which is incorrect. So remove it.
>>
>> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
>
> Hmm, the tool still exists and can still be used to feed /dev/random.
>
> Feeding /dev/random directly from the kernel is just one way of
> using hwrng.

But it is the default way.

> So rather than removing it perhaps you can modify it to state that
> the kernel can now feed /dev/random as an option.

As it is not required I think stating it is going to create confusion.
Users may not know whether rng-tools is optional or necessary for
feeding kernel entropy pool.

Thanks,
PrasannaKumar
