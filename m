From: David Miller <davem@davemloft.net>
Subject: Re: hifn_795x in Linux-2.6.27-rc7
Date: Tue, 23 Sep 2008 14:55:15 -0700 (PDT)
Message-ID: <20080923.145515.34843004.davem@davemloft.net>
References: <20080923165521.GA26513@2ka.mipt.ru>
	<48D93028.20903@psycast.de>
	<20080923181840.GA24982@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: max@psycast.de, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au
To: johnpol@2ka.mipt.ru
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39722
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752444AbYIWVz1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Sep 2008 17:55:27 -0400
In-Reply-To: <20080923181840.GA24982@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Date: Tue, 23 Sep 2008 22:18:42 +0400

> On Tue, Sep 23, 2008 at 08:06:32PM +0200, Dimitri Puzin (max@psycast.de) wrote:
> > With this patch applied it still doesn't work as expected. The overflow
> > messages are gone however syslog shows
> > [  120.924266] hifn0: abort: c: 0, s: 1, d: 0, r: 0.
> > when doing cryptsetup luksFormat as in original e-mail. At this point
> > cryptsetup hangs and can't be killed with -SIGKILL. I've attached
> > SysRq-t dump of this condition.
> 
> Yes, I was wrong with the patch: HIFN does not support 64-bit addresses
> afaics.
> 
> Attached patch should not allow HIFN to be registered on 64-bit arch, so
> crypto layer will fallback to the software algorithms.
> 
> Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

Well, it will disallow HIFN on 32-bit systems using highmem too. :-)

In the end, you will need to use bouncebuffers or similar, it seems.
