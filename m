From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] crypto: xts,lrw - fix out-of-bounds write after
 kmalloc failure
Date: Thu, 23 Mar 2017 14:05:14 -0700 (PDT)
Message-ID: <20170323.140514.85099184426140784.davem@davemloft.net>
References: <CACT4Y+ZnQq9x7gXTpaRxnMSh_2Uk461J9CWnoq3i5KQBY-nLGw@mail.gmail.com>
        <20170323203946.11242-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org, dvyukov@google.com,
        syzkaller@googlegroups.com, ebiggers@google.com,
        stable@vger.kernel.org
To: ebiggers3@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170323203946.11242-1-ebiggers3@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Eric Biggers <ebiggers3@gmail.com>
Date: Thu, 23 Mar 2017 13:39:46 -0700

> From: Eric Biggers <ebiggers@google.com>
> 
> In the generic XTS and LRW algorithms, for input data > 128 bytes, a
> temporary buffer is allocated to hold the values to be XOR'ed with the
> data before and after encryption or decryption.  If the allocation
> fails, the fixed-size buffer embedded in the request buffer is meant to
> be used as a fallback --- resulting in more calls to the ECB algorithm,
> but still producing the correct result.  However, we weren't correctly
> limiting subreq->cryptlen in this case, resulting in pre_crypt()
> overrunning the embedded buffer.  Fix this by setting subreq->cryptlen
> correctly.
> 
> Fixes: f1c131b45410 ("crypto: xts - Convert to skcipher")
> Fixes: 700cb3f5fe75 ("crypto: lrw - Convert to skcipher")
> Cc: stable@vger.kernel.org # v4.10+
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: David S. Miller <davem@davemloft.net>
