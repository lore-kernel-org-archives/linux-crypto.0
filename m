From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] [RFC] mm/page_ref, crypto/async_pq: don't put_page from __exit
Date: Mon, 29 Feb 2016 10:32:39 +0100
Message-ID: <2604022.UWS8hJ6Ygv@wuerfel>
References: <1456696663-2340682-1-git-send-email-arnd@arndb.de> <CAAmzW4N0YJc_O9ArC8e7Q5y4rmbHjj6-Q1yfvZ5LvORvG764cg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Joonsoo Kim <js1304@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Dan Williams <dan.j.williams@intel.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Michal Nazarewicz <mina86@mina86.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	linux-crypto@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:55206 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbcB2Jds (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 29 Feb 2016 04:33:48 -0500
In-Reply-To: <CAAmzW4N0YJc_O9ArC8e7Q5y4rmbHjj6-Q1yfvZ5LvORvG764cg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Monday 29 February 2016 16:40:02 Joonsoo Kim wrote:
> 
> Hello, Arnd.
> 
> I think that we can avoid this error by using __free_page().
> It would not be inlined so calling it would have no problem.
> 
> Could you test it, please?

Yes, I suspect the driver should have done that anyway, new patch
under way.

	Arnd
