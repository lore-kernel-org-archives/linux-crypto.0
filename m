From: Daniel Borkmann <dborkman@redhat.com>
Subject: Re: [PATCH v2] crypto: memzero_explicit - make sure to clear out
 sensitive data
Date: Thu, 25 Sep 2014 22:23:40 +0200
Message-ID: <542479CC.1080602@redhat.com>
References: <1410125018-27277-1-git-send-email-dborkman@redhat.com> <20140915115239.GA5057@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	hannes@stressinduktion.org, linux-crypto@vger.kernel.org,
	gmazyland@gmail.com, Julia Lawall <julia.lawall@lip6.fr>
To: tytso@mit.edu
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbaIYUYB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Sep 2014 16:24:01 -0400
In-Reply-To: <20140915115239.GA5057@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Ted,

On 09/15/2014 01:52 PM, Herbert Xu wrote:
> On Sun, Sep 07, 2014 at 11:23:38PM +0200, Daniel Borkmann wrote:
>> Recently, in commit 13aa93c70e71 ("random: add and use memzero_explicit()
>> for clearing data"), we have found that GCC may optimize some memset()
>> cases away when it detects a stack variable is not being used anymore
>> and going out of scope. This can happen, for example, in cases when we
>> are clearing out sensitive information such as keying material or any
>> e.g. intermediate results from crypto computations, etc.
>>
>> With the help of Coccinelle, we can figure out and fix such occurences
>> in the crypto subsytem as well. Julia Lawall provided the following
>> Coccinelle program:
>>
>>    @@
>>    type T;
>>    identifier x;
>>    @@
>>
>>    T x;
>>    ... when exists
>>        when any
>>    -memset
>>    +memzero_explicit
>>       (&x,
>>    -0,
>>       ...)
>>    ... when != x
>>        when strict
>>
>>    @@
>>    type T;
>>    identifier x;
>>    @@
>>
>>    T x[...];
>>    ... when exists
>>        when any
>>    -memset
>>    +memzero_explicit
>>       (x,
>>    -0,
>>       ...)
>>    ... when != x
>>        when strict
>>
>> Therefore, make use of the drop-in replacement memzero_explicit() for
>> exactly such cases instead of using memset().
>>
>> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
>> Cc: Julia Lawall <julia.lawall@lip6.fr>
>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>> Cc: Theodore Ts'o <tytso@mit.edu>
>> Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> Thanks,

Sorry for the noise, but given Herbert acked the patch and in the random
tree the infrastructure is at current present to fix this security issue,
could you take it through random tree as originally proposed between the
"---" and diffstat line of this patch [1]?

Thanks a lot,

Daniel

  [1] http://www.spinics.net/lists/linux-crypto/msg11965.html
