From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto : sha1-mb : Add missing args_digest offset
Date: Wed, 27 Jan 2016 22:16:33 +0800
Message-ID: <20160127141633.GA1601@gondor.apana.org.au>
References: <1453769169-27479-1-git-send-email-megha.dey@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux=kernel@vger.kernel.org,
	Megha Dey <megha.dey@linux.intel.com>
To: Megha Dey <megha.dey@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40650 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932737AbcA0OQx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Jan 2016 09:16:53 -0500
Content-Disposition: inline
In-Reply-To: <1453769169-27479-1-git-send-email-megha.dey@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 25, 2016 at 04:46:09PM -0800, Megha Dey wrote:
> From: Megha Dey <megha.dey@linux.intel.com>
> 
> The _args_digest is defined as _args+_digest, both of which are the first
> members of 2 separate structures, effectively yielding _args_digest to have
> a value of zero. Thus, no errors have spawned yet due to this. To ensure
> sanity, adding the missing _args_digest offset to the sha1_mb_mgr_submit.S.
> 
> Signed-off-by: Megha Dey <megha.dey@linux.intel.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
