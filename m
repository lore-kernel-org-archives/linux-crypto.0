From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC 0/7] crypto: caam - add Queue Interface (QI) support
Date: Thu, 16 Mar 2017 16:42:49 +0800
Message-ID: <20170316084249.GB11653@gondor.apana.org.au>
References: <1488552733-20806-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Scott Wood <oss@buserror.net>, Roy Pledge <roy.pledge@nxp.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Dan Douglass <dan.douglass@nxp.com>,
        Alexandru Porosanu <alexandru.porosanu@nxp.com>,
        Vakul Garg <vakul@nxp.com>,
        Cristian Stoica <cristian.stoica@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53305 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751492AbdCPInI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Mar 2017 04:43:08 -0400
Content-Disposition: inline
In-Reply-To: <1488552733-20806-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 03, 2017 at 04:52:06PM +0200, Horia Geantă wrote:
> The patchset adds support for CAAM Queue Interface (QI), the additional
> interface (besides job ring) available for submitting jobs to the engine
> on platforms having DPAA (Datapath Acceleration Architecture).
> 
> Patches 1-4 are QMan dependencies.
> I would prefer to take them through the crypto tree,
> but I am open to suggestions.
> 
> Patch 5 adds a missing double inclusion guard in desc_constr.h.
> 
> Patch 6 adds the caam/qi job submission backend.
> 
> Patch 7 adds algorithms (ablkcipher and authenc) that run on top
> of caam/qi. For now, their priority is set lower than caam/jr.

I'm fine with the crypto bits.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
