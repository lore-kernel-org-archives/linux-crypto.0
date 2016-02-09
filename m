From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: add asynchronous compression api
Date: Tue, 9 Feb 2016 11:53:55 +0100
Message-ID: <20160209105355.GA10652@gondor.apana.org.au>
References: <1454947803-30644-1-git-send-email-giovanni.cabiddu@intel.com>
 <1454947803-30644-2-git-send-email-giovanni.cabiddu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47070 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964808AbcBIKyC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2016 05:54:02 -0500
Content-Disposition: inline
In-Reply-To: <1454947803-30644-2-git-send-email-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 08, 2016 at 04:10:02PM +0000, Giovanni Cabiddu wrote:
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

This is missing the noctx support.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
