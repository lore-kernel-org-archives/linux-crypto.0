From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Subject: Re: [PATCH v2] crypto: ctr - avoid VLA use
Date: Sat, 24 Mar 2018 14:21:53 +0100
Message-ID: <CAJHCu1K-gFnt2mR6LkP=BH-eB-cHUoPyWWGCgPNe7B1B4no8Sg@mail.gmail.com>
References: <1521112738-13250-1-git-send-email-s.mesoraca16@gmail.com> <20180323153652.GA1760@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-kernel@vger.kernel.org,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Kees Cook <keescook@chromium.org>,
        Eric Biggers <ebiggers3@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180323153652.GA1760@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

2018-03-23 16:36 GMT+01:00 Herbert Xu <herbert@gondor.apana.org.au>:
> On Thu, Mar 15, 2018 at 12:18:58PM +0100, Salvatore Mesoraca wrote:
>>
>> +#define MAX_BLOCKSIZE 16
>> +
>> +#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>> +#define MAX_ALIGNMASK 15
>> +#else
>> +#define MAX_ALIGNMASK 0
>> +#endif
>> +
>
> Hmm, this won't work.  Just because you have efficient unaligned
> access in general doesn't mean that every implementation can live
> with unaligned access.  In particular, on x86 there are quite a
> few implementations that require alignment or they will fault.
>
> So please just make it 15 unconditionally.

Oh, thank you for pointing it out. I'll fix this in v3.

Salvatore
