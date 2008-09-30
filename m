From: "Russ Dill" <russ.dill@gmail.com>
Subject: Re: CTS (cipher text stealing mode) and short packets
Date: Mon, 29 Sep 2008 20:08:10 -0700
Message-ID: <f9d2a5e10809292008i48e66474hbde8c7723b848c50@mail.gmail.com>
References: <f9d2a5e10809291518l5de2c8c1i3b7750c0e50076bb@mail.gmail.com>
	 <4d569c330809291850h1865593coa400748a35908c3e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: "Kevin Coffman" <kwc@citi.umich.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:23097 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbYI3DIL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 29 Sep 2008 23:08:11 -0400
Received: by wa-out-1112.google.com with SMTP id v27so1150795wah.21
        for <linux-crypto@vger.kernel.org>; Mon, 29 Sep 2008 20:08:10 -0700 (PDT)
In-Reply-To: <4d569c330809291850h1865593coa400748a35908c3e@mail.gmail.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Sep 29, 2008 at 6:50 PM, Kevin Coffman <kwc@citi.umich.edu> wrote:
> On Mon, Sep 29, 2008 at 6:18 PM, Russ Dill <russ.dill@gmail.com> wrote:
>> crypto/cts.c currently implements RFC 3962. It deviates from the basic
>> CTS algorithm in two ways. The first is that it does not support
>> encrypting data blocks smaller than the underlying block size. Reading
>> and writing past the end of buffers will occur if it is attempted.
>>
>> Second, when the length of data to be encrypted is exactly one block,
>> it is encrypted with plain CBC.
>>
>> Normally, when packets are of size less than or equal to the block
>> size, the algorithm uses the IV as the "previous block" and swaps bits
>> with that data instead.
>>
>> What would be the best way to implement these slightly two different
>> behaviors? The primary difference between the two CTS methods seems to
>> be what to do when the input size is equal to the block size.
>
> I'm not sure of the proper way to handle this.  My code depending on
> this has not made it upstream yet, so I would not be opposed to
> renaming this implementation to cts-rfc3962 (or any other conventional
> name).  Assuming that noone else is already using this elsewhere.
>
> Hopefully Herbert can give some experienced advice...
>

I worked with this a bit, and since the IV has to be modified, it was
just easier to check for nbytes less than or equal to block size in my
own code and then back up src/dest pointers by iv_size and increase
the size by iv_size. (My IV is prepended to my data). On decryption I
do something similar by adding a buffer for the output of the IV.
