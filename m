From: rsnel@cube.dyndns.org
Subject: Re: [PATCH] an XTS blockcipher mode implementation without partial blocks
Date: Fri, 7 Sep 2007 21:23:34 +0200
Message-ID: <20070907192334.GA9862@cube.dyndns.org>
References: <11888559161619-git-send-email-rsnel@cube.dyndns.org> <20070905002906.GA6930@Chamillionaire.breakpoint.cc> <20070906145726.GA30421@cube.dyndns.org> <20070907183832.GA23067@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org, christoph.sievers@gmail.com,
	herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3085 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbXIGTZG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Sep 2007 15:25:06 -0400
Content-Disposition: inline
In-Reply-To: <20070907183832.GA23067@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello,

On Fri, Sep 07, 2007 at 08:38:32PM +0200, Sebastian Siewior wrote:
> [...]
>
> >Christoph encountered a deadlock after a few hours and 16GB of data (on
> >an aes-xts-plain partition). Assuming there is an error in xts.c, is
> >there an obvious way of finding it?
> 
> Haven't seen any locks in your code, so your part may be fine. How do I
> use this? 
> 
> cryptsetup -c aes-xts 
> 
> or?

for example: 
cryptsetup --hash sha256 -s 256 -c aes-xts-plain create test /dev/some_partition

The 'plain'-iv should give an on-disk format compatible with the
requirements of IEEE1619/D16. Internally the 256-bit key is split in two
128-bit AES keys. Other allowed key sizes for aes-xts-* are 2*192=384
bit and 2*256=512 bit. (you may want to use a hash with more bits (I don't know
what cryptsetup does if the hash gives less than keysize bits))

Christoph, is your testing machine stable if you run the same test with
aes-lrw-plain and the same keysize?

Greetings,

Rik.

-- 
Nothing is ever a total loss; it can always serve as a bad example.
