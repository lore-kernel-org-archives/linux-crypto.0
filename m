From: David Miller <davem@davemloft.net>
Subject: Re: Crypto Fixes for 4.12
Date: Fri, 16 Jun 2017 12:49:53 -0400 (EDT)
Message-ID: <20170616.124953.645541138227532301.davem@davemloft.net>
References: <CA+55aFwU1ZvJZK8x9QQtROjOVHG_ks-H3XpU+hjuf8BTxndN3g@mail.gmail.com>
        <20170615.110118.912361155799259361.davem@davemloft.net>
        <20170616125007.v7t4dlcagy5p3q6u@thunk.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: torvalds@linux-foundation.org, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:33814 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750780AbdFPQtz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Jun 2017 12:49:55 -0400
In-Reply-To: <20170616125007.v7t4dlcagy5p3q6u@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Theodore Ts'o <tytso@mit.edu>
Date: Fri, 16 Jun 2017 08:50:07 -0400

> On Thu, Jun 15, 2017 at 11:01:18AM -0400, David Miller wrote:
>> As a side note, ext4 does something similar with a private
>> implementation, but it doesn't use something the evaluates to an
>> alloca.  Instead it uses a fixed 4-byte size for the shash context
>> value in the on-stack declaration.
> 
> In ext4's case, we're doing it inside an inline function, and then
> using the "return" value from inside the calling function.  Assuming
> that gcc actually inlines the function, are we in danger of tripping
> over the bug?

Again, the bug can only be triggered if you do a dynamically sized
object on the stack.

Which ext4 is not doing, since it uses fixed size elements in the
on-stack shash context.
