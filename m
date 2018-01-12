From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4] crypto: AF_ALG - whitelist mask and type
Date: Fri, 12 Jan 2018 23:23:38 +1100
Message-ID: <20180112122338.GD21636@gondor.apana.org.au>
References: <001a1141c43ad30ccf055efb76ed@google.com>
 <20171222075843.GB27971@gondor.apana.org.au>
 <2019517.bqA8BTu5nT@positron.chronox.de>
 <4952955.He5JCySAi4@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: syzbot
        <bot+b6e703f648ebbbf57a4528d4314e0c2a5c893dc2@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        ebiggers3@gmail.com
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4952955.He5JCySAi4@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jan 02, 2018 at 08:55:25AM +0100, Stephan Müller wrote:
> Hi,
> 
> sorry, I forgot the right tags.
> 
> ---8<---
> 
> The user space interface allows specifying the type and mask field used
> to allocate the cipher. Only a subset of the possible flags are intended
> for user space. Therefore, white-list the allowed flags.
> 
> In case the user space caller uses at least one non-allowed flag, EINVAL
> is returned.
> 
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
