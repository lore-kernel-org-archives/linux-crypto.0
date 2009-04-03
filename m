From: Jared Hulbert <jaredeh@gmail.com>
Subject: Re: [PATCH 5/5] squashfs: Make SquashFS 4 use the new pcomp crypto
	interface
Date: Thu, 2 Apr 2009 23:00:36 -0700
Message-ID: <6934efce0904022300if85bc59ue2945dc1674902c1@mail.gmail.com>
References: <1234972402-24298-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1234972402-24298-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1234972402-24298-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1234972402-24298-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1234972402-24298-5-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1234972402-24298-6-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <6934efce0902181624q57f3423dm50cda218781e4399@mail.gmail.com>
	 <alpine.LRH.2.00.0902191415220.14749@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Phillip Lougher <phillip@lougher.demon.co.uk>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:37404 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbZDCGAj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 Apr 2009 02:00:39 -0400
In-Reply-To: <alpine.LRH.2.00.0902191415220.14749@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Sorry I just saw this email.  My kernel hacking time has been rudely
interrupted by other important work.

> How's AXFS going?

It's doing pretty well, we just haven't had time to push hard enough
to get it out.  It's been fairly stable for us for a while.

Now I'm anxious to get it more widely tested.  I've got two vexing bug
reports.  1) a mips consumer platform where the main app can't operate
in XIP, but everything else can.  2) Just yesterday we found Android
APK's don't like to be XIP.  These look more like flaws in the
filemap_xip.c than AXFS bugs.  Fortunately there was bug fix that went
out just a couple days ago.  I'm hoping it will fix our problems.

We've automated a great deal of the busy work associated with testing
and deploying it, so now I just need to find a couple days a week for
a few weeks.

Our flagship customer went a different direction, so it's been hard to
justify time to work on it.

> BTW, you probably want to read the full patch series, including the
> introduction :-)

Yes, I saw that shortly after I clicked "send". :)
