Return-Path: <SRS0=cBFQ=O4=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47449 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728714AbeLSOlG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Dec 2018 09:41:06 -0500
Date: Wed, 19 Dec 2018 15:41:05 +0100
From: Christoph Hellwig <hch@lst.de>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Christoph Hellwig <hch@lst.de>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-imx@nxp.com
Subject: Re: [PATCH] crypto: caam - fix zero-length buffer DMA mapping
Message-ID: <20181219144105.GA23389@lst.de>
References: <20181219143644.22089-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181219143644.22089-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Yes, we should never do zero-length dma mappings, so this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
