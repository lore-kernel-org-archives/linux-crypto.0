From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: correct 842 decompress for 32 bit
Date: Wed, 13 May 2015 11:20:24 +0800
Message-ID: <20150513032024.GD24980@gondor.apana.org.au>
References: <1431384816-21606-1-git-send-email-ddstreet@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Fengguang Wu <fengguang.wu@intel.com>
To: Dan Streetman <ddstreet@ieee.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33315 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934004AbbEMDU0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 May 2015 23:20:26 -0400
Content-Disposition: inline
In-Reply-To: <1431384816-21606-1-git-send-email-ddstreet@ieee.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 11, 2015 at 06:53:36PM -0400, Dan Streetman wrote:
> Avoid 64 bit mod operation, which won't work on 32 bit systems.
> Simple subtraction can be used instead in this case.
> 
> Reported-By: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Dan Streetman <ddstreet@ieee.org>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
