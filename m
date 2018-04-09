From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: DRBG - guard uninstantion by lock
Date: Mon, 09 Apr 2018 07:40:55 +0200
Message-ID: <58589900.TM7ux0T285@tauon.chronox.de>
References: <001a114467482dbc4b05692df8f9@google.com> <6541596.TtyMCBNA0Q@positron.chronox.de> <20180408224603.GA32004@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Dmitry Vyukov <dvyukov@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>,
        syzbot <syzbot+75397ee3df5c70164154@syzkaller.appspotmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com, Al Viro <viro@zeniv.linux.org.uk>
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180408224603.GA32004@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Montag, 9. April 2018, 00:46:03 CEST schrieb Theodore Y. Ts'o:

Hi Theodore,
> 
> So the syzbot will run while the patch goes through the normal e-mail
> review process, which is kind of neat.  :-)

Thank you very much for the hint. That is a neat feature indeed.

As I came late to the party and I missed the original mails, I am wondering 
about which GIT repo was used and which branch of it. With that, I would be 
happy to resubmit with the test line.

Ciao
Stephan
