From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH net-next v5 00/20] WireGuard: Secure Network Tunnel
Date: Wed, 19 Sep 2018 10:21:21 -0700
Message-ID: <CAKv+Gu9T16fJJz4S3O-SG_+vkWdwdUp5vymSPn-xvAOtRc=3xA@mail.gmail.com>
References: <20180918161646.19105-1-Jason@zx2c4.com> <CAKv+Gu8doWS+BYzqoT7499CJX0hLm1jBSMfVxJoG3wsWFO7t1w@mail.gmail.com>
 <20180918210120.GA29812@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180918210120.GA29812@zx2c4.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 18 September 2018 at 14:01, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> Hi Ard,
>
> On Tue, Sep 18, 2018 at 11:28:50AM -0700, Ard Biesheuvel wrote:
>> On 18 September 2018 at 09:16, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>> >   - While I initially wasn't going to do this for the initial
>> >     patchset, it was just so simple to do: now there's a nosimd
>> >     module parameter that can be used to disable simd instructions
>> >     for debugging and testing, or on weird systems.
>> >
>>
>> I was going to respond in the other thread but it is probably better
>> to move the discussion here.
>>
>> My concern about the monolithic nature of each algo module is not only
>> about SIMD, and it has nothing to do with weird systems. It has to do
>> with micro-architectural differences which are more common on ARM than
>> on other architectures *, I suppose. But generalizing from that, it
>> has to do with policy which is currently owned by userland and not by
>> the kernel. This will also be important for choosing between the time
>> variant but less safe table based scalar AES and the much slower time
>> invariant version (which is substantially slower, especially on
>> decryption) once we move AES into this library.
>>
>> So a command line option for the kernel is not the solution here. If
>> we can't have separate modules, could we at least have per-module
>> options that put the policy decisions back into userland?
>>
>> * as an example, the SHA256 NEON code I collaborated on with Andy
>> Polyakov 2 years ago is significantly faster on some cores and not on
>> others
>
> Interesting concern. There are micro-architectural quirks on x86 too
> that the current code actually already considers. Notably, we use an
> AVX-512VL path for Skylake-X but an AVX-512F path for Knights Landing
> and Coffee Lake and others, due to thermal throttling when touching the
> zmm registers on Skylake-X. So, in the code, we have it automatically
> select the right thing based on the micro-architecture.
>
> Is the same thing not possible with ARM? Do you not have access to this
> information already, such that the module can just always do the right
> thing and not require any user intervention?
>

That depends on what the right thing is. 'Fastest' does not
necessarily mean 'optimal', and I guess the thermal throttling on
Skylake-X may still result in the most power efficient implementation,
which may be the preferred one in some contexts.

The point is that this is a policy decision, and those belong in
userland not in the kernel.

> If so, that would be ideal. If not (and I'm curious to learn why not
> exactly), then indeed we could add some runtime nobs in /sys/module/
> {algo}/parameters/{nob}, or the like. This would be super easy to do,
> should we ever encounter a situation where we're unable to auto-detect
> the correct thing.
>
> Regards,
> Jason
