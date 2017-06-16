From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Crypto Fixes for 4.12
Date: Fri, 16 Jun 2017 08:50:07 -0400
Message-ID: <20170616125007.v7t4dlcagy5p3q6u@thunk.org>
References: <20170608092320.GA6478@gondor.apana.org.au>
 <20170615005443.GA30435@gondor.apana.org.au>
 <CA+55aFwU1ZvJZK8x9QQtROjOVHG_ks-H3XpU+hjuf8BTxndN3g@mail.gmail.com>
 <20170615.110118.912361155799259361.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: torvalds@linux-foundation.org, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170615.110118.912361155799259361.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jun 15, 2017 at 11:01:18AM -0400, David Miller wrote:
> As a side note, ext4 does something similar with a private
> implementation, but it doesn't use something the evaluates to an
> alloca.  Instead it uses a fixed 4-byte size for the shash context
> value in the on-stack declaration.

In ext4's case, we're doing it inside an inline function, and then
using the "return" value from inside the calling function.  Assuming
that gcc actually inlines the function, are we in danger of tripping
over the bug?

						- Ted
