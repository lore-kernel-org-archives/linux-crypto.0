From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: KASAN: use-after-free Read in crypto_chacha20_crypt
Date: Wed, 29 Nov 2017 00:57:47 -0800
Message-ID: <20171129085747.GA20992@zzz.localdomain>
References: <94eb2c111b8c32eea2055f0c983c@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+257f413f0ea433750ffaa72b2748289380957904@syzkaller.appspotmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <94eb2c111b8c32eea2055f0c983c@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Nov 28, 2017 at 07:23:01AM -0800, syzbot wrote:
> Hello,
> 
> syzkaller hit the following crash on
> 1ea8d039f9edcfefb20d8ddfe136930f6e551529
> git://git.cmpxchg.org/linux-mmots.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> C reproducer is attached
> syzkaller reproducer is attached. See https://goo.gl/kgGztJ
> for information about syzkaller reproducers
> 
> 
> ==================================================================
> BUG: KASAN: use-after-free in __le32_to_cpup
> include/uapi/linux/byteorder/little_endian.h:58 [inline]
> BUG: KASAN: use-after-free in le32_to_cpuvp crypto/chacha20_generic.c:19
> [inline]
> BUG: KASAN: use-after-free in crypto_chacha20_init
> crypto/chacha20_generic.c:58 [inline]
> BUG: KASAN: use-after-free in crypto_chacha20_crypt+0xaf1/0xbd0
> crypto/chacha20_generic.c:91
> Read of size 4 at addr ffff880100000006 by task syzkaller030711/3690
> 

#syz dup: general protection fault in crypto_chacha20_crypt
