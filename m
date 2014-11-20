From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] bfin_crc: don't include linux/unaligned/access_ok.h
Date: Thu, 20 Nov 2014 22:43:31 +0800
Message-ID: <20141120144331.GB32061@gondor.apana.org.au>
References: <1416428164-9874-1-git-send-email-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:58498 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195AbaKTOnf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Nov 2014 09:43:35 -0500
Content-Disposition: inline
In-Reply-To: <1416428164-9874-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 19, 2014 at 09:16:04PM +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> This is a specific implementation, <asm/unaligned.h> is the
> multiplexer that has the arch-specific knowledge of which
> of the implementations needs to be used, so include that.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
