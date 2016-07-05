From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: qat - Switch to new rsa_helper functions
Date: Tue, 5 Jul 2016 23:14:40 +0800
Message-ID: <20160705151439.GB8117@gondor.apana.org.au>
References: <1467625768-2266-1-git-send-email-salvatore.benedetto@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60435 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006AbcGEPPG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Jul 2016 11:15:06 -0400
Content-Disposition: inline
In-Reply-To: <1467625768-2266-1-git-send-email-salvatore.benedetto@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 04, 2016 at 10:49:28AM +0100, Salvatore Benedetto wrote:
> Drop all asn1 related code and use the new rsa_helper
> functions rsa_parse_[pub|priv]_key for parsing the key
> 
> Signed-off-by: Salvatore Benedetto <salvatore.benedetto@intel.com>
> ---
> 
> changes from v1:
>  - Remove testmgr unrelated changes
>  - Rebased on latest cryptodev-2.6

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
