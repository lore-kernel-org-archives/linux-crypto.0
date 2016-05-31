From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/7] crypto : stylistic cleanup in sha1-mb
Date: Tue, 31 May 2016 16:13:11 +0800
Message-ID: <20160531081311.GA14591@gondor.apana.org.au>
References: <1463704984-2136-1-git-send-email-megha.dey@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	fenghua.yu@intel.com, Megha Dey <megha.dey@linux.intel.com>
To: Megha Dey <megha.dey@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46768 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457AbcEaINT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 04:13:19 -0400
Content-Disposition: inline
In-Reply-To: <1463704984-2136-1-git-send-email-megha.dey@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 19, 2016 at 05:43:04PM -0700, Megha Dey wrote:
> From: Megha Dey <megha.dey@linux.intel.com>
> 
> Currently there are several checkpatch warnings in the sha1_mb.c file:
> 'WARNING: line over 80 characters' in the sha1_mb.c file. Also, the
> syntax of some multi-line comments are not correct. This patch fixes
> these issues.
> 
> Signed-off-by: Megha Dey <megha.dey@linux.intel.com>

This patch says 1/7 but there is no cover letter and I've only
seen patches 1 and 2.  What's going on?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
