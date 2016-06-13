From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 1/3] crypto: Key-agreement Protocol Primitives API
 (KPP)
Date: Mon, 13 Jun 2016 16:59:39 +0800
Message-ID: <20160613085939.GA7420@gondor.apana.org.au>
References: <1462830041-7582-1-git-send-email-salvatore.benedetto@intel.com>
 <1462830041-7582-2-git-send-email-salvatore.benedetto@intel.com>
 <20160531064210.GA13948@gondor.apana.org.au>
 <309B30E91F5E2846B79BD9AA9711D031930814@IRSMSX102.ger.corp.intel.com>
 <20160608025451.GB12283@gondor.apana.org.au>
 <20160608114547.GA26661@sbenedet-virtual-machine>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49022 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933300AbcFMI7n (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jun 2016 04:59:43 -0400
Content-Disposition: inline
In-Reply-To: <20160608114547.GA26661@sbenedet-virtual-machine>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 08, 2016 at 12:45:47PM +0100, Salvatore Benedetto wrote:
>
> Having said that, are you OK with as far as the interface goes
> to only merge set_param and set_key, and keeping the rest as it is?
> For the implementation of DH and ECDH I'll merge the two operations
> functions into one as you suggested. If so, I'll send a new version.

Yes you're right.  We can always just share the code underneath.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
