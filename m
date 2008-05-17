From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2] crypto: rmd128: make it work on my prefered
 architecture
Date: Sat, 17 May 2008 01:22:35 -0700 (PDT)
Message-ID: <20080517.012235.82078077.davem@davemloft.net>
References: <20080515200706.GA3081@Chamillionaire.breakpoint.cc>
	<20080517081003.GA19540@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	rueegsegger@swiss-it.ch
To: linux-crypto@ml.breakpoint.cc
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43980
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752099AbYEQIWl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 May 2008 04:22:41 -0400
In-Reply-To: <20080517081003.GA19540@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Date: Sat, 17 May 2008 10:10:03 +0200

> +	ROUND(aa, bb, cc, dd, F1, K1, le32_to_cpu(in[ 0]),  11);

Not to nitpick, but if you use le32_to_cpup() this will allow the
use of little-endian load instructions on powerpc and sparc.
