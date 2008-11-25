From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] crypto: fix error flow of crypto/testmgr.c:test_comp()
Date: Tue, 25 Nov 2008 13:52:31 -0800 (PST)
Message-ID: <20081125.135231.81163255.davem@davemloft.net>
References: <20081125085820.GA11401@elte.hu>
	<20081125152014.GB29096@gondor.apana.org.au>
	<20081125171438.GK22504@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: mingo@elte.hu
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38260
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750816AbYKYVwb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Nov 2008 16:52:31 -0500
In-Reply-To: <20081125171438.GK22504@elte.hu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 25 Nov 2008 18:14:38 +0100

> btw, on a related note, there's a couple of networking related warning 
> fixes/annotations i've got queued up.

I see these now, but they would get properly logged and
tracked at:

	http://patchwork.ozlabs.org/project/netdev/

if you would simply CC: netdev instead of sending them into
the ether by informing lkml and the crypto list about them.
