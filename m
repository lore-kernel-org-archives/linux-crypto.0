From: David Howells <dhowells@redhat.com>
Subject: Re: Initcall ordering problem (TTY vs modprobe vs MD5) and cryptomgr problem
Date: Fri, 06 Aug 2010 03:23:30 +0100
Message-ID: <11274.1281061410@redhat.com>
References: <AANLkTi=+-Y2GOZYAZHeaX+op3XB9AY5S85rfJD3jSDvz@mail.gmail.com> <23662.1281056463@redhat.com> <20100806011706.GA21657@gondor.apana.org.au> <20100806014057.GA22395@gondor.apana.org.au>
Cc: dhowells@redhat.com, Herbert Xu <herbert@gondor.hengli.com.au>,
	gregkh@suse.de, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760380Ab0HFCXr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Aug 2010 22:23:47 -0400
In-Reply-To: <AANLkTi=+-Y2GOZYAZHeaX+op3XB9AY5S85rfJD3jSDvz@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> People always think that their magical code is so important. I tell
> you up-front that is absolutely is not. Just remove the crap entirely,
> please.

Even if he does remove it, that still leaves the problem that modprobe can be
invoked and fail before tty_init() gets called:-/

I wonder if tty_init() should be moved up, perhaps to immediately after
chrdev_init().

David
