From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v4 13/14] rxrpc: Prepare to remove VLA usage for SKCIPHER_REQUEST_ON_STACK
Date: Thu, 12 Jul 2018 14:38:37 -0700
Message-ID: <CAGXu5j+ckXWYmPodbp5WW91HayRF8E4-DGk1fVsXmL8k0BmefA@mail.gmail.com>
References: <20180711203619.1020-1-keescook@chromium.org> <20180711203619.1020-14-keescook@chromium.org>
 <CAK8P3a1k+cy9wAVNQMWE4tdA4aV8tiu6K3haLc+kMPt0iiUQ9Q@mail.gmail.com>
 <CAGXu5jLUME9cjntUUed9EYukzEaODDzqRmtGht=uu7YVAG2WWg@mail.gmail.com>
 <CAGXu5jK7iRv1HE7JgW95vTgg5vhye4dxjfoQyN3G7HZzp7nZhA@mail.gmail.com> <CAK8P3a3zvmAtkmqHhNO4788WQ8kbunSW8Jp-nA+hYHc2YmziEg@mail.gmail.com>
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
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a3zvmAtkmqHhNO4788WQ8kbunSW8Jp-nA+hYHc2YmziEg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jul 12, 2018 at 2:15 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thu, Jul 12, 2018 at 10:30 PM, Kees Cook <keescook@chromium.org> wrote:
>> Actually, I think this can actually be adjusted to just re-use the
>> stack allocation, since rxkad_verify_packet() finishes one before
>> doing another in rxkad_verify_packet_1():
>
> That looks very nice, yes. The same thing is needed in
> rxkad_secure_packet(), right?

Yup. 4 leaf functions and the 2 callers.

-Kees

-- 
Kees Cook
Pixel Security
