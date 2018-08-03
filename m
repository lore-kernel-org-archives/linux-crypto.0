From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v1 2/3] zinc: Introduce minimal cryptography library
Date: Fri, 3 Aug 2018 14:29:01 -0700
Message-ID: <CALCETrVziUpAU4nTaZ=t5ct=1jsWswWOy7KDNxXGPD1L=tMTGQ@mail.gmail.com>
References: <20180801072246.GA15677@sol.localdomain> <CALCETrXD_VyoyW5C1U34o-ySJ4nFcO6PQ+ZNBVYxCpJ-f65CHw@mail.gmail.com>
 <CAHmME9oThR-dE3gTW0UyqAGZO80qu19ktG4YTb4iL6CNpzNNaw@mail.gmail.com>
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
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHmME9oThR-dE3gTW0UyqAGZO80qu19ktG4YTb4iL6CNpzNNaw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 2, 2018 at 7:48 PM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> Hey Andy,
>
> Thanks too for the feedback. Responses below:
>
> On Wed, Aug 1, 2018 at 7:09 PM Andy Lutomirski <luto@amacapital.net> wrote:
>> > I think the above changes would also naturally lead to a much saner
>> > patch series where each algorithm is added by its own patch, rather than
>> > one monster patch that adds many algorithms and 24000 lines of code.
>> >
>>
>> Yes, please.
>
> Ack, will be in v2.
>
>
>> I like this a *lot*.  (But why are you passing have_simd?  Shouldn't
>> that check live in chacha20_arch?  If there's some init code needed,
>> then chacha20_arch() should just return false before the init code
>> runs.  Once the arch does whatever feature detection it needs, it can
>> make chacha20_arch() start returning true.)
>
> The have_simd stuff is so that the FPU state can be amortized across
> several calls to the crypto functions. Here's a snippet from
> WireGuard's send.c:
>
> void packet_encrypt_worker(struct work_struct *work)
> {
>     struct crypt_queue *queue = container_of(work, struct
> multicore_worker, work)->ptr;
>     struct sk_buff *first, *skb, *next;
>     bool have_simd = simd_get();

Gotcha.  That was very hidden in the 24k lines.  Please make this (and
any similar goodies) be their own patches.

Also, please consider spelling it differently:

simd_context_t simd_context = simd_get();

Because we'll feel very silly the first time some architecture has
more than one possible state.  (It wouldn't be entirely insane for x86
to distinguish between "no SIMD", "XMM only", and "go to town!", for
example.)
