From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH v2] crypto: rmd128: make it work on my prefered
	architecture
Date: Sat, 17 May 2008 10:27:54 +0200
Message-ID: <20080517082754.GC19540@Chamillionaire.breakpoint.cc>
References: <20080515200706.GA3081@Chamillionaire.breakpoint.cc> <20080517081003.GA19540@Chamillionaire.breakpoint.cc> <20080517.012235.82078077.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	rueegsegger@swiss-it.ch
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:33453 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751941AbYEQI16 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 May 2008 04:27:58 -0400
Content-Disposition: inline
In-Reply-To: <20080517.012235.82078077.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* David Miller | 2008-05-17 01:22:35 [-0700]:

>From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
>Date: Sat, 17 May 2008 10:10:03 +0200
>
>> +	ROUND(aa, bb, cc, dd, F1, K1, le32_to_cpu(in[ 0]),  11);
>
>Not to nitpick, but if you use le32_to_cpup() this will allow the
>use of little-endian load instructions on powerpc and sparc.

I know that. Please see my follow up mail with some tiny numbers.
gcc-4.1.1 was used on a mpc8544.

Sebastian
