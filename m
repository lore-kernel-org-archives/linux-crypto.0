From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH v7 0/5] Update LZ4 compressor module
Date: Wed, 8 Feb 2017 16:24:36 -0800
Message-ID: <20170209002436.GA103792@gmail.com>
References: <1482259992-16680-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <1486321748-19085-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <20170208233121.GA16728@bbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>,
        akpm@linux-foundation.org, bongkyu.kim@lge.com,
        rsalvaterra@gmail.com, sergey.senozhatsky@gmail.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, anton@enomsg.org, ccross@android.com,
        keescook@chromium.org, tony.luck@intel.com
To: Minchan Kim <minchan@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33781 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752002AbdBIAYj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Feb 2017 19:24:39 -0500
Content-Disposition: inline
In-Reply-To: <20170208233121.GA16728@bbox>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 09, 2017 at 08:31:21AM +0900, Minchan Kim wrote:
> 
> Today, I did zram-lz4 performance test with fio in current mmotm and
> found it makes regression about 20%.
> 

This may or may not be the cause of the specific regression you're observing,
but I just noticed that the proposed patch drops a lot of FORCEINLINE
annotations from upstream LZ4.  The FORCEINLINE's are there for a reason,
especially for the main decompression and compression functions which are
basically "templates" that take in different sets of constant parameters, and
should be left in.  We should #define FORCEINLINE to __always_inline somewhere,
or just do a s/FORCEINLINE/__always_inline/g.

Note that the upstream LZ4 code is very carefully optimized, so we should not,
in general, be changing things like when functions are force-inlined, what the
hash table size is, etc.

[Also, for some reason linux-crypto is apparently still not receiving patch 1/5
in the series.  It's missing from the linux-crypto archive at
http://www.spinics.net/lists/linux-crypto/, so it's not just me.]

Thanks!

Eric
