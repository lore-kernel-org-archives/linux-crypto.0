From: "Kevin Coffman" <kwc@citi.umich.edu>
Subject: Re: CTS (cipher text stealing mode) and short packets
Date: Mon, 29 Sep 2008 21:50:01 -0400
Message-ID: <4d569c330809291850h1865593coa400748a35908c3e@mail.gmail.com>
References: <f9d2a5e10809291518l5de2c8c1i3b7750c0e50076bb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: "Russ Dill" <russ.dill@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:61536 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbYI3BuD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 29 Sep 2008 21:50:03 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2424392wfd.4
        for <linux-crypto@vger.kernel.org>; Mon, 29 Sep 2008 18:50:01 -0700 (PDT)
In-Reply-To: <f9d2a5e10809291518l5de2c8c1i3b7750c0e50076bb@mail.gmail.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Sep 29, 2008 at 6:18 PM, Russ Dill <russ.dill@gmail.com> wrote:
> crypto/cts.c currently implements RFC 3962. It deviates from the basic
> CTS algorithm in two ways. The first is that it does not support
> encrypting data blocks smaller than the underlying block size. Reading
> and writing past the end of buffers will occur if it is attempted.
>
> Second, when the length of data to be encrypted is exactly one block,
> it is encrypted with plain CBC.
>
> Normally, when packets are of size less than or equal to the block
> size, the algorithm uses the IV as the "previous block" and swaps bits
> with that data instead.
>
> What would be the best way to implement these slightly two different
> behaviors? The primary difference between the two CTS methods seems to
> be what to do when the input size is equal to the block size.

I'm not sure of the proper way to handle this.  My code depending on
this has not made it upstream yet, so I would not be opposed to
renaming this implementation to cts-rfc3962 (or any other conventional
name).  Assuming that noone else is already using this elsewhere.

Hopefully Herbert can give some experienced advice...

K.C.

p.s. I don't have a lot of time to devote to making changes myself right now...
