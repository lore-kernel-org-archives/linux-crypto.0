From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/10] crypto: caam - shared descriptor generation
 refactoring
Date: Mon, 28 Nov 2016 21:29:41 +0800
Message-ID: <20161128132941.GC2757@gondor.apana.org.au>
References: <1479822252-23833-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Dan Douglass <dan.douglass@nxp.com>,
        Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
        Alexandru Porosanu <alexandru.porosanu@nxp.com>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48849 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932127AbcK1N3x (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Nov 2016 08:29:53 -0500
Content-Disposition: inline
In-Reply-To: <1479822252-23833-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 22, 2016 at 03:44:02PM +0200, Horia Geantă wrote:
> In preparation for the caam/qi (Queue Interface) driver, the generation
> of the shared descriptors is abstracted and exported.
> This way the existing caam/jr (Job Ring) and caam/qi drivers will have
> a common base of descriptors.

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
