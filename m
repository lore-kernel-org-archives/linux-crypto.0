From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] crypto: pcrypt - Fix use after free on padata_free
Date: Fri, 26 Nov 2010 09:54:12 +0100
Message-ID: <20101126085412.GA4178@secunet.com>
References: <20101126074916.GQ1868@secunet.com>
 <20101126084915.GA27272@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:58602 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753739Ab0KZIyO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Nov 2010 03:54:14 -0500
Content-Disposition: inline
In-Reply-To: <20101126084915.GA27272@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 26, 2010 at 04:49:15PM +0800, Herbert Xu wrote:
> On Fri, Nov 26, 2010 at 08:49:17AM +0100, Steffen Klassert wrote:
> > kobject_put is called from padata_free for the padata kobject.
> > The kobject's release function frees the padata instance,
> > so don't call kobject_put for the padata kobject from pcrypt.
> > 
> > Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> > Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> > Tested-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Linus has already taken this patch.
> 

Ok, I applied it on top of crypto-2.6. So I did not notice that it
is already in Linus tree.

Steffen
