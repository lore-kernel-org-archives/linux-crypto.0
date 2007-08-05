From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: status of async crypto
Date: Sun, 5 Aug 2007 19:15:46 +0400
Message-ID: <20070805151546.GC32132@2ka.mipt.ru>
References: <B9FFC3F97441D04093A504CEA31B7C4101AA34D2@msilexch01.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Ronen Shitrit <rshitrit@marvell.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:45502 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296AbXHEPQD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 5 Aug 2007 11:16:03 -0400
Content-Disposition: inline
In-Reply-To: <B9FFC3F97441D04093A504CEA31B7C4101AA34D2@msilexch01.marvell.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Aug 05, 2007 at 01:50:48PM +0300, Ronen Shitrit (rshitrit@marvell.com) wrote:
> I saw that the current code support async crypto for the dm-crypt, does
> it
> also support async crypto for the klips?
> Is there any support for using the async crypto from the OpenSSL engine
> library?
> I saw that the async crypto support block cipher, does it also support
> digest operations?
> Can it support encryption + authentication (lets say AES-SHA1) as one
> operation?
> Is there any Documentation available? (I guess not)

No for all above.

> What is the todo list for further development of the async crypto
> support?

New drivers and extending functionality if required. Some work is being
done in this area, although not that fast.

-- 
	Evgeniy Polyakov
