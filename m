From: David Miller <davem@davemloft.net>
Subject: Re: [BUG] SLOB breaks Crypto
Date: Tue, 18 May 2010 12:25:12 -0700 (PDT)
Message-ID: <20100518.122512.73694279.davem@davemloft.net>
References: <1274135869.11603.473.camel@calx>
	<4BF24D1F.6010005@codelabs.ch>
	<20100518102701.GA7293@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: ken@codelabs.ch, mpm@selenic.com, geert@linux-m68k.org,
	michael-dev@fami-braun.de, penberg@cs.helsinki.fi,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	anemo@mba.ocn.ne.jp
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54669
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757791Ab0ERTZG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 May 2010 15:25:06 -0400
In-Reply-To: <20100518102701.GA7293@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 18 May 2010 20:27:01 +1000

> I think the simplest fix is to revert this changeset.

If you revert then you'll break sparc.

Sparc needs long long alignment, so it's SLOB that needs to
change if it isn't providing at least that much alignment
by default.
