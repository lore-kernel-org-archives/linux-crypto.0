From: David Miller <davem@davemloft.net>
Subject: Re: Crypto Fixes for 4.12
Date: Thu, 15 Jun 2017 11:01:18 -0400 (EDT)
Message-ID: <20170615.110118.912361155799259361.davem@davemloft.net>
References: <20170608092320.GA6478@gondor.apana.org.au>
        <20170615005443.GA30435@gondor.apana.org.au>
        <CA+55aFwU1ZvJZK8x9QQtROjOVHG_ks-H3XpU+hjuf8BTxndN3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:54058 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752927AbdFOPBU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jun 2017 11:01:20 -0400
In-Reply-To: <CA+55aFwU1ZvJZK8x9QQtROjOVHG_ks-H3XpU+hjuf8BTxndN3g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 15 Jun 2017 18:04:44 +0900

> There's a fair number of SHASH_DESC_ON_STACK users, are all the others
> safe for some random reason that just happens to be about code
> generation? Did people actually verify that?

I looked at the code generated in every case.

As a side note, ext4 does something similar with a private
implementation, but it doesn't use something the evaluates to an
alloca.  Instead it uses a fixed 4-byte size for the shash context
value in the on-stack declaration.

We can tidy it up with abstraction macros as a follow-up, thanks
for the suggestion.  I'll look into it.
