From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: crypto: out-of-bounds write in pre_crypt
Date: Thu, 23 Mar 2017 13:39:21 -0700
Message-ID: <20170323203921.GB92809@gmail.com>
References: <CACT4Y+ZnQq9x7gXTpaRxnMSh_2Uk461J9CWnoq3i5KQBY-nLGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        syzkaller <syzkaller@googlegroups.com>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34108 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933577AbdCWUjZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Mar 2017 16:39:25 -0400
Content-Disposition: inline
In-Reply-To: <CACT4Y+ZnQq9x7gXTpaRxnMSh_2Uk461J9CWnoq3i5KQBY-nLGw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Dmitry,

On Thu, Mar 23, 2017 at 11:51:30AM +0100, Dmitry Vyukov wrote:
> Hello,
> 
> I've got the following report while running syzkaller fuzzer.
> init_crypt ignores kmalloc failure, which later leads to out-of-bounds
> writes in ptr_crypt. On commit
> 093b995e3b55a0ae0670226ddfcb05bfbf0099ae.
> 

Thanks for finding this!  Nice to see that the crypto code is getting tested...

This bug was introduced in v4.10 and affects the generic XTS and LRW drivers.
They are supposed to work in the event of a kmalloc failure, but evidently it's
broken.  I'm sending a patch shortly.

- Eric
