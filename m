From: "George Spelvin" <linux@horizon.com>
Subject: Re: [PATCH 11/17] crypto: ansi_cprng - unroll _get_more_prng_bytes
Date: 2 Dec 2014 16:54:03 -0500
Message-ID: <20141202215403.23476.qmail@ns.horizon.com>
References: <20141202085452.19204.qmail@ns.horizon.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux@horizon.com, smueller@chronox.de
To: nhorman@tuxdriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:21970 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751289AbaLBVyF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 16:54:05 -0500
In-Reply-To: <20141202085452.19204.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The order of the v1 patches is somewhat in order of "increasing scale",
reflecting my learning about the code.  But if this unroll is okay,
it would probably make the most sense to reorder things so it's
first and then other changes can be made on top of the simpler code.

Given the unusual implementation choice of a loop and a switch, it's
obviously a deliberate one, so I assume there's a reason for it that
I'm just not seeing.
