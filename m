From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v4 13/14] rxrpc: Prepare to remove VLA usage for SKCIPHER_REQUEST_ON_STACK
Date: Thu, 12 Jul 2018 23:15:51 +0200
Message-ID: <CAK8P3a3zvmAtkmqHhNO4788WQ8kbunSW8Jp-nA+hYHc2YmziEg@mail.gmail.com>
References: <20180711203619.1020-1-keescook@chromium.org> <20180711203619.1020-14-keescook@chromium.org>
 <CAK8P3a1k+cy9wAVNQMWE4tdA4aV8tiu6K3haLc+kMPt0iiUQ9Q@mail.gmail.com>
 <CAGXu5jLUME9cjntUUed9EYukzEaODDzqRmtGht=uu7YVAG2WWg@mail.gmail.com> <CAGXu5jK7iRv1HE7JgW95vTgg5vhye4dxjfoQyN3G7HZzp7nZhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Eric Biggers <ebiggers@google.com>,
        Alasdair Kergon <agk@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Lars Persson <larper@axis.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, qat-linux@intel.com,
        dm-devel@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jK7iRv1HE7JgW95vTgg5vhye4dxjfoQyN3G7HZzp7nZhA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jul 12, 2018 at 10:30 PM, Kees Cook <keescook@chromium.org> wrote:
> On Thu, Jul 12, 2018 at 1:23 PM, Kees Cook <keescook@chromium.org> wrote:
>> On Thu, Jul 12, 2018 at 8:11 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>>> On Wed, Jul 11, 2018 at 10:36 PM, Kees Cook <keescook@chromium.org> wrote:
>>>> Two uses of SKCIPHER_REQUEST_ON_STACK() will trigger FRAME_WARN warnings
>>>> (when less than 2048) once the VLA is no longer hidden from the check:
>>>>
>>>> net/rxrpc/rxkad.c:398:1: warning: the frame size of 1152 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>>>> net/rxrpc/rxkad.c:242:1: warning: the frame size of 1152 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>>>>
>>>> This bumps the affected objects by 20% to silence the warnings while
>>>> still providing coverage is anything grows even more.
>>>>
>>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>>
>>> (adding David Howells to cc)
>>>
>>> I don't think these are in a fast path, it should be possible to just use
>>> skcipher_alloc_req() instead of SKCIPHER_REQUEST_ON_STACK() here.
>>> From what I can tell, neither of the two are called in atomic context, so
>>> you should be able to use a GFP_KERNEL allocation.
>>
>> Sure, I can do that instead.
>
> Actually, I think this can actually be adjusted to just re-use the
> stack allocation, since rxkad_verify_packet() finishes one before
> doing another in rxkad_verify_packet_1():

That looks very nice, yes. The same thing is needed in
rxkad_secure_packet(), right?

       Arnd
