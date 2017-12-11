From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: general protection fault in crypto_chacha20_crypt
Date: Mon, 11 Dec 2017 11:06:09 -0800
Message-ID: <20171211190609.GC62691@gmail.com>
References: <001a113fae28149757055f0bbe00@google.com>
 <20171129092438.GC20992@zzz.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+fa2ed481fed0c7ace1571b88a89dfd49ffd89cb6@syzkaller.appspotmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171129092438.GC20992@zzz.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 29, 2017 at 01:24:38AM -0800, Eric Biggers wrote:
> 
> The bug is that the skcipher_walk API doesn't set the IV for zero-length inputs,
> while some algorithms (e.g. ChaCha20) access the IV even if the input is
> zero-length.  So it was dereferencing a pointer which came from uninitialized
> stack memory.  I've sent out a fix:
> 
> "crypto: skcipher - set walk.iv for zero-length inputs"
> 

#syz fix: crypto: skcipher - set walk.iv for zero-length inputs
