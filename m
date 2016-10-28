From: Eric Biggers <ebiggers@google.com>
Subject: Alignment of shash input buffers?
Date: Fri, 28 Oct 2016 10:28:40 -0700
Message-ID: <20161028172840.GB53757@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:34706 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966067AbcJ1R2o (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Oct 2016 13:28:44 -0400
Received: by mail-pf0-f170.google.com with SMTP id n85so40563118pfi.1
        for <linux-crypto@vger.kernel.org>; Fri, 28 Oct 2016 10:28:44 -0700 (PDT)
Received: from google.com ([2620:0:1008:13:8169:74b1:51db:d6b1])
        by smtp.gmail.com with ESMTPSA id j63sm20241397pfj.70.2016.10.28.10.28.42
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Fri, 28 Oct 2016 10:28:42 -0700 (PDT)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I'm having trouble understanding how alignment of shash input buffers is
supposed to work.  If you pass crypto_shash_update() a buffer that is not
aligned to the shash algorithm's alignmask, it will call the underlying
->update() function twice, once with a temporary aligned buffer and once with
the aligned remainder of the original input buffer.  So far so good.

The problem is that some (many?) hash algorithms actually deal with fixed size
blocks, and the lengths of buffers which users might pass to
crypto_shash_update() are not necessarily multiples of the block size.  This can
cause the input buffer to fall out of alignment.  

Let's use cmac(aes) as an example.  It will copy up to 16 bytes to a temporary
buffer, process (xor into the state and encrypt) that block if full, then
directly process 16-byte blocks from the input buffer, then save any remainder.
The middle step uses crypto_xor() directly on the input buffer, which assumes
4-byte alignment.  However this alignment is not guaranteed.  For example, if I
pass two aligned buffers, one of length 15 and one of length 17 to
crypto_shash_update(), crypto_xor() is called on a misaligned pointer.

ghash is another example of an algorithm that has this problem, although that
one seems even more broken since it doesn't even set an alignmask at all (?).

I am wondering, is this intentional?  If it's broken, do shash algorithms need
to be fixed to assume no alignment, e.g. by using the get_unaligned_*() macros
or by memcpy()-ing each block into a temporary buffer?  Is there a better
solution?

Thanks,

Eric
