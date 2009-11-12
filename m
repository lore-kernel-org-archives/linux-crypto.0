From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: Bug in geode-aes.c ?
Date: Thu, 12 Nov 2009 10:13:27 +0100
Message-ID: <20091112091327.GB22434@Chamillionaire.breakpoint.cc>
References: <aa09d86e0911100600x79617b85je8e4bd52df37b0a3@mail.gmail.com>
 <20091111220832.GC18452@Chamillionaire.breakpoint.cc>
 <aa09d86e0911120036h5bad1505t6c13aa61b49510d6@mail.gmail.com>
 <aa09d86e0911120043y4da7379dwef4a613f840df8ca@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Sergey Mironov <ierton@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:54448 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751103AbZKLJNW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Nov 2009 04:13:22 -0500
Content-Disposition: inline
In-Reply-To: <aa09d86e0911120043y4da7379dwef4a613f840df8ca@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Sergey Mironov | 2009-11-12 11:43:20 [+0300]:

>I can't find any "s390" reference in my tree. Probably, i have not got
>this branch in my local copy.

If you want to fix this please look at arch/s390/crypto/aes_s390.c. That
is broken and I mixed it up in fallback_init_cip() as well :)

Sebastian
