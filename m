From: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: question about sha1 driver
Date: Wed, 7 Oct 2009 20:35:30 +0200
Message-ID: <20091007183529.GA6095@Chamillionaire.breakpoint.cc>
References: <311e0d1f0909210158k5feca8b9gc3b9d187e13ba6ff@mail.gmail.com>
 <20090922031705.GA27429@gondor.apana.org.au>
 <311e0d1f0909220617r66cc96b3s52ee3ab99bcbd6e3@mail.gmail.com>
 <20090922142059.GC694@gondor.apana.org.au>
 <311e0d1f0909280831j5e12671na709db1eaed5e393@mail.gmail.com>
 <311e0d1f0909300028n4e53d11ep985f7179684146d8@mail.gmail.com>
Reply-To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: avital sela <avitalsela95@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:54057 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934367AbZJGSgI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 Oct 2009 14:36:08 -0400
Content-Disposition: inline
In-Reply-To: <311e0d1f0909300028n4e53d11ep985f7179684146d8@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* avital sela | 2009-09-30 09:28:01 [+0200]:

>On Mon, Sep 28, 2009 at 5:31 PM, avital sela <avitalsela95@gmail.com> wrote:
>> Attached below is the source code for the sha driver.? Like I said previously, if I add printk-s or delays in testmgr then the test passes and all subsequent sha1 crypto operations are successful.

This isn't the complete source code. I have no idea what hides behind
SHA_DATA_BUFFER.
Anyway if it works with delays and you are making a HW driver than I
would say that you forgot to flush the data from cache to physical
memory after / before your memcpy().

>>
>> Thanks for your help,
>> Avital

Sebastian
