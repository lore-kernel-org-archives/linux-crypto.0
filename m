From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH v3] AF_ALG: Initialize sg_num_bytes in error code path
Date: Fri, 6 Jul 2018 14:57:51 -0700
Message-ID: <20180706215751.GB109361@gmail.com>
References: <00000000000092ad87056950ef9e@google.com>
 <1616306.R4SzcgHSdy@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: syzbot <syzbot+9c251bdd09f83b92ba95@syzkaller.appspotmail.com>,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1616306.R4SzcgHSdy@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jul 06, 2018 at 09:50:55AM +0200, Stephan Müller wrote:
> Changes v3:
> * Fix syz testing line
> 
> Changes v2:
> * Addition of syz testing line
> 
> ---8<---
> 
> The RX SGL in processing is already registered with the RX SGL tracking
> list to support proper cleanup. The cleanup code path uses the
> sg_num_bytes variable which must therefore be always initialized, even
> in the error code path.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> Reported-by: syzbot+9c251bdd09f83b92ba95@syzkaller.appspotmail.com
> #syz test: https://github.com/google/kmsan.git master

Can you add Fixes: and Cc: stable?

- Eric
