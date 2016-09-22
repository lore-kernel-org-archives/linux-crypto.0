From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: BUG: rsa-pkcs1pad decrypt regression in 4.8
Date: Thu, 22 Sep 2016 08:55:24 -0700 (PDT)
Message-ID: <alpine.OSX.2.20.1609220854181.30782@mjmartin-mac01.local>
References: <alpine.OSX.2.20.1609211630400.14260@mjmartin-mac01.local> <20160922090456.GA5272@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Cc: linux-crypto@vger.kernel.org, smueller@chronox.de
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:44327 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934518AbcIVPz0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Sep 2016 11:55:26 -0400
In-Reply-To: <20160922090456.GA5272@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Herbert -

On Thu, 22 Sep 2016, Herbert Xu wrote:

> On Wed, Sep 21, 2016 at 04:39:30PM -0700, Mat Martineau wrote:
>>
>> There was a regression in pkcs1pad signature verification, related
>> to signature verification, that you fixed in commit 27710b8ea3defcb:
>>
>> https://git.kernel.org/cgit/linux/kernel/git/herbert/crypto-2.6.git/commit/?id=27710b8ea3defcbd7d340dbd0423d911b4eb7c4f
>>
>> There is a very similar problem in the decrypt operation, which was
>> not adjusted for the leading zero changes. See
>> pkcs1pad_decrypt_complete().
>>
>> I haven't had a chance to test a fix yet, but with the final 4.8
>> release coming up very soon I wanted to report the issue.
>
> Thanks.  This patch should fix the problem.
>
> ---8<---
> crypto: rsa-pkcs1pad - Handle leading zero for decryption
>
> As the software RSA implementation now produces fixed-length
> output, we need to eliminate leading zeros in the calling code
> instead.
>
> This patch does just that for pkcs1pad decryption while signature
> verification was fixed in an earlier patch.
>
> Fixes: 9b45b7bba3d2 ("crypto: rsa - Generate fixed-length output")
> Reported-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>

This patch does fix the decrypt problem, my tests are now passing. Thank
you.


--
Mat Martineau
Intel OTC
