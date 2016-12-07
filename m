From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - fix pointer size for AArch64 boot loader,
 AArch32 kernel
Date: Wed, 7 Dec 2016 20:07:46 +0800
Message-ID: <20161207120746.GB20680@gondor.apana.org.au>
References: <1480928818-8166-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Dan Douglass <dan.douglass@nxp.com>,
        Alison Wang <alison.wang@nxp.com>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41082 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752105AbcLGMIw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Dec 2016 07:08:52 -0500
Content-Disposition: inline
In-Reply-To: <1480928818-8166-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 05, 2016 at 11:06:58AM +0200, Horia Geantă wrote:
> Start with a clean slate before dealing with bit 16 (pointer size)
> of Master Configuration Register.
> This fixes the case of AArch64 boot loader + AArch32 kernel, when
> the boot loader might set MCFGR[PS] and kernel would fail to clear it.
> 
> Cc: <stable@vger.kernel.org>
> Reported-by: Alison Wang <alison.wang@nxp.com>
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
