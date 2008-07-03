From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH 0/2] RNG: Add Pseudo Random Number Generator to kernel
Date: Thu, 3 Jul 2008 22:39:55 +0200
Message-ID: <20080703203955.GA13654@Chamillionaire.breakpoint.cc>
References: <20080703201924.GA5237@hmsendeavour.rdu.redhat.com>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:41539 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752978AbYGCUj6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Jul 2008 16:39:58 -0400
Content-Disposition: inline
In-Reply-To: <20080703201924.GA5237@hmsendeavour.rdu.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Neil Horman | 2008-07-03 16:19:24 [-0400]:

>This patchset add a pseudo random number generator to the kernel crypto library.
>Usefull in assisting with the implementation of various FIPS compliant ipsec
>algorithms.  Based on the suggestions provided in ANSI X9.31 Appendix A.2.4.
>Tested successfully by myself.  Set consists of two parts:

Anything wrong with get_random_bytes()?
Whats the advantage over get_random_bytes()?

>
>Regards
>Neil

Sebastian
