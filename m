From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v4 13/14] rxrpc: Prepare to remove VLA usage for SKCIPHER_REQUEST_ON_STACK
Date: Thu, 12 Jul 2018 14:34:45 -0700
Message-ID: <CAGXu5jLFEN4cTGGPy_i+-MksCafCwQvU_e3mTvtusyyyXfnrNA@mail.gmail.com>
References: <20180711203619.1020-1-keescook@chromium.org> <20180711203619.1020-14-keescook@chromium.org>
 <CAK8P3a1k+cy9wAVNQMWE4tdA4aV8tiu6K3haLc+kMPt0iiUQ9Q@mail.gmail.com> <18355.1531430916@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
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
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: David Howells <dhowells@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <18355.1531430916@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi David,

On Thu, Jul 12, 2018 at 2:28 PM, David Howells <dhowells@redhat.com> wrote:
> Can I get a cc on the original patch?

I'll add you to CC for future revisions. Here was the start of this thread:
https://lkml.kernel.org/r/20180711203619.1020-14-keescook@chromium.org

-Kees

-- 
Kees Cook
Pixel Security
