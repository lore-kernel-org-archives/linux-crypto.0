From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v7 0/5] Update LZ4 compressor module
Date: Thu, 09 Feb 2017 22:57:15 -0500 (EST)
Message-ID: <20170209.225715.34351834998363822.davem@davemloft.net>
References: <20170209002436.GA103792@gmail.com>
        <20170209110211.GB3575@bierbaron.springfield.local>
        <20170209182914.GB92711@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: 4sschmid@informatik.uni-hamburg.de, minchan@kernel.org,
        akpm@linux-foundation.org, bongkyu.kim@lge.com,
        rsalvaterra@gmail.com, sergey.senozhatsky@gmail.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        anton@enomsg.org, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com
To: ebiggers3@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:58586 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751077AbdBJEVB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Feb 2017 23:21:01 -0500
In-Reply-To: <20170209182914.GB92711@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers3@gmail.com>
Date: Thu, 9 Feb 2017 10:29:14 -0800

> On Thu, Feb 09, 2017 at 12:02:11PM +0100, Sven Schmidt wrote:
>> > 
>> > [Also, for some reason linux-crypto is apparently still not receiving patch 1/5
>> > in the series.  It's missing from the linux-crypto archive at
>> > http://www.spinics.net/lists/linux-crypto/, so it's not just me.]
>> > 
>> 
>> I don't really know what to do about this. I think the matter is the size of the E-Mail.
>> Are there filters or something like that? Since in linux-kernel the patch seems to get delivered.
>> I could otherwise CC you if you wish.
>> 
> 
> If I'm not mistaken, David Miller is the admin of the mail server on
> vger.kernel.org, and he already happens to be Cc'ed on this thread, so maybe he
> can answer as to why linux-crypto may be configured differently?
> 
> Anyway, since the patch did make it to linux-kernel anyone can still download it
> from patchwork if they know where to look:
> https://patchwork.kernel.org/patch/9556271/

I've increased the maxlength parameter for linux-cryto so this doesn't
happen again.
