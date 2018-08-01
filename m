From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v1 2/3] zinc: Introduce minimal cryptography library
Date: Wed, 1 Aug 2018 10:02:21 -0700
Message-ID: <CALCETrXD_VyoyW5C1U34o-ySJ4nFcO6PQ+ZNBVYxCpJ-f65CHw@mail.gmail.com>
References: <20180801072246.GA15677@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        "D . J . Bernstein" <djb@cr.yp.to>,
        Tanja Lange <tanja@hyperelliptic.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Karthikeyan Bhargavan <karthik.bhargavan@gmail.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180801072246.GA15677@sol.localdomain>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[I reordered the snippets below for readability.]

> On Aug 1, 2018, at 12:22 AM, Eric Biggers <ebiggers3@gmail.com> wrote:
> In general this is great work, and I'm very excited for WireGuard to be
> upstreamed!  But for the new crypto code, I think a few things are on
> the wrong track, for example treating it is a special library.  Even the
> name is contradicting itself: Zinc is "not crypto/", yet as you stated
> it's intended that the "Zinc" algorithms will be exposed through the
> crypto API -- just like how most of the existing crypto code in lib/ is
> also exposed through the crypto API.  So, I think that what you're doing
> isn't actually *that* different from what already exists in some cases;
> and pretending that it is very different is just going to cause
> problems.  Rather, the actual truly new thing seems to be that the
> dispatch to architecture specific implementations is done at the lib/
> level instead of handled by the crypto API priority numbers.

...

>
>
> I think the above changes would also naturally lead to a much saner
> patch series where each algorithm is added by its own patch, rather than
> one monster patch that adds many algorithms and 24000 lines of code.
>

Yes, please.


>
> As for doing the architecture-specific dispatch in lib/ rather than
> through the crypto API, there definitely are some arguments in favor of
> it.  The main problem, though, is that your code is a mess due to all
> the #ifdefs, and it will only get worse as people add more
> architectures.  You may think you already added all the architectures
> that matter, but tomorrow people will come and want to add PowerPC,
> RISC-V, etc.  I really think you should consider splitting up
> implementations by architecture; this would *not*, however, preclude the
> implementations from still being accessed through a single top-level
> "glue" function.  For example chacha20() could look like:
>
> void chacha20(struct chacha20_ctx *state, u8 *dst, const u8 *src, u32 len,
>          bool have_simd)
> {
>    if (chacha20_arch(dst, src, len, state->key, state->counter, have_simd))
>        goto out;
>
>    chacha20_generic(dst, src, len, state->key, state->counter);
>
> out:
>    state->counter[0] += (len + 63) / 64;
> }

I like this a *lot*.  (But why are you passing have_simd?  Shouldn't
that check live in chacha20_arch?  If there's some init code needed,
then chacha20_arch() should just return false before the init code
runs.  Once the arch does whatever feature detection it needs, it can
make chacha20_arch() start returning true.)

As I see it, there there are two truly new thing in the zinc patchset:
the direct (in the direct call sense) arch dispatch, and the fact that
the functions can be called directly, without allocating contexts,
using function pointers, etc.

In fact, I had a previous patch set that added such an interface for SHA256.

https://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git/commit/?h=crypto/sha256_bpf&id=8c59a4dd8b7ba4f2e5a6461132bbd16c83ff7c1f

https://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git/commit/?h=crypto/sha256_bpf&id=7e5fbc02972b03727b71bc71f84175c36cbf01f5

>
> Your patch description is also missing any mention of crypto accelerator
> hardware.  Quite a bit of the complexity in the crypto API, such as
> scatterlist support and asynchronous execution, exists because it
> supports crypto accelerators.  AFAICS your new APIs cannot support
> crypto accelerators, as your APIs are synchronous and operate on virtual
> addresses.  I assume your justification is that "djb algorithms" like
> ChaCha and Poly1305 don't need crypto accelerators as they are fast in
> software.  But you never explicitly stated this and discussed the
> tradeoffs.  Since this is basically the foundation for the design you've
> chosen, it really needs to be addressed.

I see this as an advantage, not a disadvantage.  A very large majority
of in-kernel crypto users (by number of call sites under a *very*
brief survey, not by number of CPU cycles) just want to do some
synchronous crypto on a buffer that is addressed by a regular pointer.
Most of these users would be slowed down if they used any form of
async crypto, since the CPU can complete the whole operation faster
than it could plausibly initiate and complete anything asynchronous.
And, right now, they suffer the full overhead of allocating a context
(often with alloca!), looking up (or caching) some crypto API data
structures, dispatching the operation, and cleaning up.

So I think the right way to do it is to have directly callable
functions like zinc uses and to have the fancy crypto API layer on top
of them.  So if you actually want async accelerated crypto with
scatterlists or whatever, you can call into the fancy API, and the
fancy API can dispatch to hardware or it can dispatch to the normal
static API.

In fact, this is exactly what my patch above did.  But Jason's work is
more complete than mine, and mine wasn't really done because it had
some configury issues.

All that being said, for algorithms where the crypto API already has a
reasonable implementation, I think the patch series should first
restructure the code (so the actual software implementation is moved
away from the crypto API wrappers) and then, if needed, replace the
implementation with something better.  The latter should be its own
patch with its own justification.
