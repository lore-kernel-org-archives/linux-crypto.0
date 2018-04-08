From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] crypto: DRBG - guard uninstantion by lock
Date: Sun, 8 Apr 2018 18:46:03 -0400
Message-ID: <20180408224603.GA32004@thunk.org>
References: <001a114467482dbc4b05692df8f9@google.com>
 <4564679.HlOejCIXXz@positron.chronox.de>
 <CACT4Y+Y7hdm6LX5-PZu9zXFSmAKMP_jCYY7Z7g6a0xd_XCEYhA@mail.gmail.com>
 <6541596.TtyMCBNA0Q@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Dmitry Vyukov <dvyukov@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>,
        syzbot <syzbot+75397ee3df5c70164154@syzkaller.appspotmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com, Al Viro <viro@zeniv.linux.org.uk>
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6541596.TtyMCBNA0Q@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Apr 08, 2018 at 09:07:03PM +0200, Stephan Müller wrote:
> Can you please check whether the attached patch fixes the issue?
> 

Stephan,

FYI, if you incude in your e-mail "#syz test <GIT URL> <BRANCH>" as
the first line of your patch and the syzbot e-mail is cc'ed, the
syzbot will automatically apply the patch in the e-mail against the
git tree/branch specified in the "#syz test" line, and then try to see
if the problem it discovered still reproduces --- and then send you
e-mail one way or another.

So the syzbot will run while the patch goes through the normal e-mail
review process, which is kind of neat.  :-)

Cheers,

					- Ted
