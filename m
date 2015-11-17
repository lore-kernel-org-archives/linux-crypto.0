From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - remove superfluous check from adf_probe
Date: Tue, 17 Nov 2015 22:07:51 +0800
Message-ID: <20151117140751.GE9546@gondor.apana.org.au>
References: <1445523792-28389-1-git-send-email-salvatore.benedetto@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49892 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbbKQOHx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Nov 2015 09:07:53 -0500
Content-Disposition: inline
In-Reply-To: <1445523792-28389-1-git-send-email-salvatore.benedetto@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 22, 2015 at 03:23:12PM +0100, Salvatore Benedetto wrote:
>  - ent->device is already checked at the beginning of the function
>    against the same value. This check is a duplicate.
> 
> Signed-off-by: Salvatore Benedetto <salvatore.benedetto@intel.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
