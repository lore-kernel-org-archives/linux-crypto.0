From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: KASAN: slab-out-of-bounds Write in sha3_final
Date: Tue, 28 Nov 2017 11:13:08 -0800
Message-ID: <20171128191308.GD45321@gmail.com>
References: <001a11440c809be89b055f0aeea5@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+264771bd693024ccca21958c9ccaacfc20852fe8@syzkaller.appspotmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <001a11440c809be89b055f0aeea5@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Nov 28, 2017 at 05:24:01AM -0800, syzbot wrote:
> Hello,
> 
> syzkaller hit the following crash on
> 6fc478f80f6809cc4b1a4230f47a62d3b7378dc0
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> C reproducer is attached
> syzkaller reproducer is attached. See https://goo.gl/kgGztJ
> for information about syzkaller reproducers
> 
> 
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in memset include/linux/string.h:326 [inline]
> BUG: KASAN: slab-out-of-bounds in sha3_final+0xeb/0x2e0
> crypto/sha3_generic.c:173
> Write of size 4294967223 at addr ffff8801cc23a759 by task
> syzkaller163089/3049

#syz dup: KASAN: stack-out-of-bounds Write in sha3_update
