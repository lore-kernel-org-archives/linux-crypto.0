From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: blokcipher interface to geode-aes
Date: Sat, 5 Apr 2008 16:52:20 +0200
Message-ID: <20080405145220.GA9821@Chamillionaire.breakpoint.cc>
References: <ff203bd00804012346w60a70967jc6f08feb3d170acb@mail.gmail.com> <ff203bd00804020017h7c9e076dgd6077fe4e8405190@mail.gmail.com>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Vasile Marii <vascim@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:46056 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751890AbYDEOwW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 5 Apr 2008 10:52:22 -0400
Content-Disposition: inline
In-Reply-To: <ff203bd00804020017h7c9e076dgd6077fe4e8405190@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Vasile Marii | 2008-04-02 10:17:59 [+0300]:

>>Are you using the in kernel module or your own?
>>Which kernel version do you use?
>it is the geode-aes driver from kernel 2.6.24.2 but modified, meaning
That kernel should have a working version. So in theoory it should work
without your modifications.

>OK i'll do this right now, but the next question is:
>after all, in blockcipher mode, the src, and dst addresses filled by
>blkcipher_walk... are the real plaintext source and destination? No
>other operations are made on that data?
Yes. The data is not modified by the crypto stack. Dump the data on the
the entre of the function and you will see it. Keep in mind that it is a
kernel address and the geode expects a physical address.
>>--
>>Vasile Marii
>
Sebastian
