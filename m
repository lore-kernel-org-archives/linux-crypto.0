From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v1 2/3] zinc: Introduce minimal cryptography library
Date: Fri, 3 Aug 2018 04:48:36 +0200
Message-ID: <CAHmME9oThR-dE3gTW0UyqAGZO80qu19ktG4YTb4iL6CNpzNNaw@mail.gmail.com>
References: <20180801072246.GA15677@sol.localdomain> <CALCETrXD_VyoyW5C1U34o-ySJ4nFcO6PQ+ZNBVYxCpJ-f65CHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Eric Biggers <ebiggers3@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Lutomirski <luto@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        "Daniel J . Bernstein" <djb@cr.yp.to>,
        Tanja Lange <tanja@hyperelliptic.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Karthikeyan Bhargavan <karthik.bhargavan@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrXD_VyoyW5C1U34o-ySJ4nFcO6PQ+ZNBVYxCpJ-f65CHw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hey Andy,

Thanks too for the feedback. Responses below:

On Wed, Aug 1, 2018 at 7:09 PM Andy Lutomirski <luto@amacapital.net> wrote:
> > I think the above changes would also naturally lead to a much saner
> > patch series where each algorithm is added by its own patch, rather than
> > one monster patch that adds many algorithms and 24000 lines of code.
> >
>
> Yes, please.

Ack, will be in v2.


> I like this a *lot*.  (But why are you passing have_simd?  Shouldn't
> that check live in chacha20_arch?  If there's some init code needed,
> then chacha20_arch() should just return false before the init code
> runs.  Once the arch does whatever feature detection it needs, it can
> make chacha20_arch() start returning true.)

The have_simd stuff is so that the FPU state can be amortized across
several calls to the crypto functions. Here's a snippet from
WireGuard's send.c:

void packet_encrypt_worker(struct work_struct *work)
{
    struct crypt_queue *queue = container_of(work, struct
multicore_worker, work)->ptr;
    struct sk_buff *first, *skb, *next;
    bool have_simd = simd_get();

    while ((first = ptr_ring_consume_bh(&queue->ring)) != NULL) {
        enum packet_state state = PACKET_STATE_CRYPTED;

        skb_walk_null_queue_safe(first, skb, next) {
            if (likely(skb_encrypt(skb, PACKET_CB(first)->keypair, have_simd)))
                skb_reset(skb);
            else {
                state = PACKET_STATE_DEAD;
                break;
            }
        }
        queue_enqueue_per_peer(&PACKET_PEER(first)->tx_queue, first, state);

        have_simd = simd_relax(have_simd);
    }
    simd_put(have_simd);
}

simd_get() and simd_put() do the usual irq_fpu_usable/kernel_fpu_begin
dance and return/take a boolean accordingly. simd_relax(on) is:

static inline bool simd_relax(bool was_on)
{
#ifdef CONFIG_PREEMPT
    if (was_on && need_resched()) {
        simd_put(true);
        return simd_get();
    }
#endif
    return was_on;
}

With this, we most of the time get the FPU amortization, while still
doing the right thing for the preemption case (since kernel_fpu_begin
disables preemption). This is a quite important performance
optimization. However, I'd prefer the lazy FPU restoration proposal
discussed a few months ago, but it looks like that hasn't progressed,
hence the need for FPU call amortization:

https://lore.kernel.org/lkml/CALCETrU+2mBPDfkBz1i_GT1EOJau+mzj4yOK8N0UnT2pGjiUWQ@mail.gmail.com/

>
> As I see it, there there are two truly new thing in the zinc patchset:
> the direct (in the direct call sense) arch dispatch, and the fact that
> the functions can be called directly, without allocating contexts,
> using function pointers, etc.
>
> In fact, I had a previous patch set that added such an interface for SHA256.
>
> https://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git/commit/?h=crypto/sha256_bpf&id=8c59a4dd8b7ba4f2e5a6461132bbd16c83ff7c1f
>
> https://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git/commit/?h=crypto/sha256_bpf&id=7e5fbc02972b03727b71bc71f84175c36cbf01f5

Seems like SHA256 will be a natural next candidate for Zinc, given the demand.


> > Your patch description is also missing any mention of crypto accelerator
> > hardware.  Quite a bit of the complexity in the crypto API, such as
> > scatterlist support and asynchronous execution, exists because it
> > supports crypto accelerators.  AFAICS your new APIs cannot support
> > crypto accelerators, as your APIs are synchronous and operate on virtual
> > addresses.  I assume your justification is that "djb algorithms" like
> > ChaCha and Poly1305 don't need crypto accelerators as they are fast in
> > software.  But you never explicitly stated this and discussed the
> > tradeoffs.  Since this is basically the foundation for the design you've
> > chosen, it really needs to be addressed.
>
> I see this as an advantage, not a disadvantage.  A very large majority
> of in-kernel crypto users (by number of call sites under a *very*
> brief survey, not by number of CPU cycles) just want to do some
> synchronous crypto on a buffer that is addressed by a regular pointer.
> Most of these users would be slowed down if they used any form of
> async crypto, since the CPU can complete the whole operation faster
> than it could plausibly initiate and complete anything asynchronous.
> And, right now, they suffer the full overhead of allocating a context
> (often with alloca!), looking up (or caching) some crypto API data
> structures, dispatching the operation, and cleaning up.
>
> So I think the right way to do it is to have directly callable
> functions like zinc uses and to have the fancy crypto API layer on top
> of them.  So if you actually want async accelerated crypto with
> scatterlists or whatever, you can call into the fancy API, and the
> fancy API can dispatch to hardware or it can dispatch to the normal
> static API.

Yes, exactly this.

Regards,
Jason
