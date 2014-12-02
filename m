From: "George Spelvin" <linux@horizon.com>
Subject: Re: [PATCH 02/17] crypto: ansi_cprng - Eliminate ctx->last_rand_data
Date: 2 Dec 2014 14:45:56 -0500
Message-ID: <20141202194556.11560.qmail@ns.horizon.com>
References: <20141202144657.GD3388@hmsreliant.think-freely.org>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	smueller@chronox.de
To: linux@horizon.com, nhorman@tuxdriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:34007 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932746AbaLBTp6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 14:45:58 -0500
In-Reply-To: <20141202144657.GD3388@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> NACK
>
> The assumption that its not needed is incorrect.  In fips mode its explicitly
> needed to validate that the rng isn't reproducing identical random data.

Please take a second look.  The validation is still there; I fully
understand that and preserved that.  (Well, I broke it later getting
over-eager looking for places to put memzero_explicit, but already
sent a follow-on message about that.)

Only the *buffer* is unnecessary and was deleted.
