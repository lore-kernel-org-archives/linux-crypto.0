From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3] crypto: omap-sham: Map SG pages if they are HIGHMEM
 before accessing
Date: Mon, 10 Mar 2014 20:23:31 +0800
Message-ID: <20140310122331.GK10556@gondor.apana.org.au>
References: <1394209726-6746-1-git-send-email-joelf@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org,
	lokeshvutla@ti.com
To: Joel Fernandes <joelf@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:57250 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaCJMXd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Mar 2014 08:23:33 -0400
Content-Disposition: inline
In-Reply-To: <1394209726-6746-1-git-send-email-joelf@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 07, 2014 at 10:28:46AM -0600, Joel Fernandes wrote:
> HIGHMEM pages may not be mapped so we must kmap them before accessing.
> This resolves a random OOPs error that was showing up during OpenSSL SHA tests.
> 
> Signed-off-by: Joel Fernandes <joelf@ti.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
