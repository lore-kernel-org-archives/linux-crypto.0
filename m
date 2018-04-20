From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: drbg - set freed buffers to NULL
Date: Sat, 21 Apr 2018 00:54:55 +0800
Message-ID: <20180420165455.4kmmphyexqyd3kp3@gondor.apana.org.au>
References: <001a114467482dbc4b05692df8f9@google.com>
 <2186798.qrgUIDAn9S@positron.chronox.de>
 <20316956.hJt0ZTxKTH@positron.chronox.de>
 <2295196.9WStPcntd3@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Dmitry Vyukov <dvyukov@google.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Matthew Wilcox <willy@infradead.org>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>,
        syzbot <syzbot+75397ee3df5c70164154@syzkaller.appspotmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Al Viro <viro@zeniv.linux.org.uk>
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2295196.9WStPcntd3@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Apr 12, 2018 at 08:40:55AM +0200, Stephan Müller wrote:
> Add the Fixes, CC stable tags.
> 
> ---8<---
> 
> During freeing of the internal buffers used by the DRBG, set the pointer
> to NULL. It is possible that the context with the freed buffers is
> reused. In case of an error during initialization where the pointers
> do not yet point to allocated memory, the NULL value prevents a double
> free.
> 
> Cc: stable@vger.kernel.org
> Fixes: 3cfc3b9721123 ("crypto: drbg - use aligned buffers")
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> Reported-by: syzbot+75397ee3df5c70164154@syzkaller.appspotmail.com

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
