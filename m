From: David Miller <davem@davemloft.net>
Subject: Re: hifn_795x in Linux-2.6.27-rc7
Date: Tue, 23 Sep 2008 20:05:48 -0700 (PDT)
Message-ID: <20080923.200548.159582673.davem@davemloft.net>
References: <20080923181840.GA24982@2ka.mipt.ru>
	<20080923.145515.34843004.davem@davemloft.net>
	<20080924025308.GA27398@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: max@psycast.de, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au
To: johnpol@2ka.mipt.ru
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52193
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751538AbYIXDGA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Sep 2008 23:06:00 -0400
In-Reply-To: <20080924025308.GA27398@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Date: Wed, 24 Sep 2008 06:53:08 +0400

> Maybe, we need to check, since allocation of multiple smaller pages from
> 4 gb area, copy data between them, hardware crypto, backward copy and
> page freeing can be slower than software crypto. Although we can
> preallocate buffers for several common sizes, although this will not
> help dm-crypto which can submit up to 31 pages in single request on top
> of ext3 in the common case.

I think you will need to preallocate a pool of pages.
