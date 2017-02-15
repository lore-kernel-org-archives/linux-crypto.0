From: Christoph Hellwig <hch@lst.de>
Subject: crypto/cavium MSI-X fixups
Date: Wed, 15 Feb 2017 08:18:40 +0100
Message-ID: <20170215071843.30108-1-hch@lst.de>
Cc: David Daney <david.daney@cavium.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: George Cherian <george.cherian@cavium.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41763 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750816AbdBOHSs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Feb 2017 02:18:48 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi George,

your commit "crypto: cavium - Add Support for Octeon-tx CPT Engine"
add a new caller to pci_enable_msix.  This API has long been deprecated
so this series switches it to use pci_alloc_irq_vectors instead.

Can you please test it and make sure it goes in before the end of the
merge window so that no more users of the old API hit mainline?
