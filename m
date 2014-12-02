From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH 02/17] crypto: ansi_cprng - Eliminate ctx->last_rand_data
Date: Tue, 2 Dec 2014 09:46:57 -0500
Message-ID: <20141202144657.GD3388@hmsreliant.think-freely.org>
References: <20141202083314.17647.qmail@ns.horizon.com>
 <20141202083550.17918.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	smueller@chronox.de
To: George Spelvin <linux@horizon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41913 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbaLBOrE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 09:47:04 -0500
Content-Disposition: inline
In-Reply-To: <20141202083550.17918.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 02, 2014 at 03:35:50AM -0500, George Spelvin wrote:
> It's simply not necessary.
> 
> Signed-off-by: George Spelvin <linux@horizon.com>
NACK

The assumption that its not needed is incorrect.  In fips mode its explicitly
needed to validate that the rng isn't reproducing identical random data.

Neil
