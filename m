From: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Subject: Re: [PATCH 03/10] crypto: nx - fix limits to sg lists for AES-CBC
Date: Thu, 29 Aug 2013 11:32:36 -0300
Message-ID: <20130829143235.GA31059@oc8526070481.ibm.com>
References: <1377288074-18998-1-git-send-email-mhcerri@linux.vnet.ibm.com>
 <1377288074-18998-4-git-send-email-mhcerri@linux.vnet.ibm.com>
 <20130829044221.GA25208@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:40703 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab3H2Ocq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 29 Aug 2013 10:32:46 -0400
Received: from /spool/local
	by e24smtp04.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <mhcerri@linux.vnet.ibm.com>;
	Thu, 29 Aug 2013 11:32:44 -0300
Content-Disposition: inline
In-Reply-To: <20130829044221.GA25208@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 29, 2013 at 02:42:22PM +1000, Herbert Xu wrote:
> On Fri, Aug 23, 2013 at 05:01:07PM -0300, Marcelo Cerri wrote:
> > This patch updates the nx-aes-cbc implementation to perform several
> > hyper calls if needed in order to always respect the length limits for
> > scatter/gather lists.
> > 
> > Two different limits are considered:
> > 
> >  - "ibm,max-sg-len": maximum number of bytes of each scatter/gather
> >    list.
> > 
> >  - "ibm,max-sync-cop":
> >     - The total number of bytes that a scatter/gather list can hold.
> >     - The maximum number of elements that a scatter/gather list can have.
> > 
> > Reviewed-by: Joy Latten <jmlatten@linux.vnet.ibm.com>
> > Signed-off-by: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
> 
> This patch does not apply against the current cryptodev tree.
> 
> Please regenerate your pathces.

Sorry for this. I'm sending a v2 series without conflicts.

> 
> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
