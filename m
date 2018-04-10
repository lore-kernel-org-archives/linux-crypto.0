From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: DRBG - guard uninstantion by lock
Date: Tue, 10 Apr 2018 17:35:29 +0200
Message-ID: <2704286.80iLvC0rRL@tauon.chronox.de>
References: <001a114467482dbc4b05692df8f9@google.com> <CACT4Y+aKnKT3AwvbEw_khsYUySLDz4mW7dZ6n7O6McbfPTjd8Q@mail.gmail.com> <CACT4Y+Y+ydyBAL=j2QOWaBnpY8+Bsr_80d80RXth0SwuY0wMuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Matthew Wilcox <willy@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>,
        syzbot <syzbot+75397ee3df5c70164154@syzkaller.appspotmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Al Viro <viro@zeniv.linux.org.uk>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACT4Y+Y+ydyBAL=j2QOWaBnpY8+Bsr_80d80RXth0SwuY0wMuQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Dienstag, 10. April 2018, 17:23:46 CEST schrieb Dmitry Vyukov:

Hi Dmitry,

> Stephan,
> 
> Do you have any hypothesis as to why this is not detected by KASAN and
> causes silent corruptions?
> We generally try to understand such cases and improve KASAN so that it
> catches such cases more reliably and they do not cause splashes of
> random crashes on syzbot.

I do not have any hypothesis at this point. I know that you induce some fault. 
As you mentioned the drbg_kcapi_seed function, I was looking through the error 
code paths to see whether some error handlers trip over each other. But all is 
guesswork so far. And I am not even sure whether the bug is in the DRBG code 
base.

Looking into the trace you sent, I see a NULL pointer dereference. At one 
point there is also the drbg_init_hash_kernel that is called. But nowhere I 
see any smoking gun.

Could you please give me a description of the fault you are inducing?

Ciao
Stephan
