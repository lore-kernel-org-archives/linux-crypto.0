From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: pcrypt - Fix use after free on padata_free
Date: Fri, 26 Nov 2010 16:49:15 +0800
Message-ID: <20101126084915.GA27272@gondor.apana.org.au>
References: <20101126074916.GQ1868@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
	linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:33390 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab0KZItX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Nov 2010 03:49:23 -0500
Content-Disposition: inline
In-Reply-To: <20101126074916.GQ1868@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 26, 2010 at 08:49:17AM +0100, Steffen Klassert wrote:
> kobject_put is called from padata_free for the padata kobject.
> The kobject's release function frees the padata instance,
> so don't call kobject_put for the padata kobject from pcrypt.
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> Tested-by: Randy Dunlap <randy.dunlap@oracle.com>

Linus has already taken this patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
