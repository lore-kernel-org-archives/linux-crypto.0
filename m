From: David Miller <davem@davemloft.net>
Subject: Re: Crypto Fixes for 4.12
Date: Thu, 15 Jun 2017 11:02:02 -0400 (EDT)
Message-ID: <20170615.110202.2304410513992498772.davem@davemloft.net>
References: <20170615005443.GA30435@gondor.apana.org.au>
        <CA+55aFwU1ZvJZK8x9QQtROjOVHG_ks-H3XpU+hjuf8BTxndN3g@mail.gmail.com>
        <20170615094210.GA32322@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:54066 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752683AbdFOPCE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jun 2017 11:02:04 -0400
In-Reply-To: <20170615094210.GA32322@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Thu, 15 Jun 2017 17:42:10 +0800

> On Thu, Jun 15, 2017 at 06:04:44PM +0900, Linus Torvalds wrote:
>> There's a fair number of SHASH_DESC_ON_STACK users, are all the others
>> safe for some random reason that just happens to be about code
>> generation? Did people actually verify that?
> 
> If I understand this correctly this is only an issue if you directly
> return a value from the shash_desc struct allocated on the stack.
> This is usually rare as normally you'd return an error code and the
> hash result would be written directly to some memory passed in from
> the caller.

Correct.
