From: jonathan.thieuleux@gmail.com
Subject: Re: Cipher block questions
Date: Tue, 21 Apr 2015 11:52:22 +0200
Message-ID: <20150421095222.GB9043@arch.localdomain>
References: <20150421072734.GA9043@arch.localdomain>
 <55360553.5040102@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Milan Broz <gmazyland@gmail.com>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:35787 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbbDUJw1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Apr 2015 05:52:27 -0400
Received: by widdi4 with SMTP id di4so132198963wid.0
        for <linux-crypto@vger.kernel.org>; Tue, 21 Apr 2015 02:52:25 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <55360553.5040102@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 21, 2015 at 10:07:47AM +0200, Milan Broz wrote:


> First, from the cryptsetup log
>   # Userspace crypto wrapper cannot use gost-xts-plain64 (-2).
> it seems that there is some problem with loading of your gost cipher implementation.
>
I relaunch the command into QEMU and I obtain "Userspace crypto wrapper cannot use
gost-xts-plain64 (-95)", and when I try with an algorithm which work fine I have the same
result "Userspace crypto wrapper cannot use aes-xts-plain64 (-95)". So, I don't
know what's the problem or where it came from. I quickly Googled the problem, but nothing.

> What key size you are using in cryptsetup (default is probably 256bit)?

Yes, the key size is 256-bit.

> LRW and XTS modes requires *two* keys in fact (tweaking+encryption).
>
> GOST should use 256bit key, so if you add --key-size 512 to your cryptsetup command
> does it help?

I already tried it, but that doesn't change anything.

--
Jonathan "Coldshell" Thieuleux
Mail : jonathan.thieuleux@gmail.com
IRC : coldshell [Freenode, OFTC]
Shaarli : https://links.stdcall.me/

"If you write interfaces with more than 4 or 5 function arguments, it's possible that you and I cannot be friends." -- David Miller
