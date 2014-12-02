From: "George Spelvin" <linux@horizon.com>
Subject: Re: [PATCH 13/17] crypto: ansi_cprng - If DT is not provided, use a fresh timestamp
Date: 2 Dec 2014 04:11:53 -0500
Message-ID: <20141202091153.20604.qmail@ns.horizon.com>
References: <20141202085703.19443.qmail@ns.horizon.com>
Cc: linux-crypto@vger.kernel.org, smueller@chronox.de
To: herbert@gondor.apana.org.au, linux@horizon.com,
	nhorman@tuxdriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:35464 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750927AbaLBJLy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 04:11:54 -0500
In-Reply-To: <20141202085703.19443.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I just realized that the memzero_explicit of ctx->rand_data_bytes[]
(a late addition, done just a few minutes before posting), while
it prevents backtracking, also totally breaks FIPS anti-repetition
checking.

So ignore that line (171 of the modified file).  Sorry.
