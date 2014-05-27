From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] crypto: lzo: try kmalloc() before vmalloc()
Date: Tue, 27 May 2014 10:38:40 -0700
Message-ID: <1401212320.5367.258.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1401211735.5367.254.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20140527173050.GA18214@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Seth Jennings <sjennings@variantweb.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:62273 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaE0Ril (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 May 2014 13:38:41 -0400
In-Reply-To: <20140527173050.GA18214@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2014-05-28 at 01:30 +0800, Herbert Xu wrote:

> Looks good to me.  This would seem like something that could be
> generalised to other vmalloc users, no?
> 

Yep, we have some spots where this is done, and we had attempts in the
past to get a generic allocator / deallocator but this went nowhere,
after a lot of time trying to get this right.

I guess we need to reach some threshold to convince Andrew Morton ;)

$ git grep -n is_vmalloc_addr | wc -l
85
