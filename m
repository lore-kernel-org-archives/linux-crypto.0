From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] crypto: qat - avoid an uninitialized variable warning
Date: Mon, 26 Jun 2017 09:03:26 +0200
Message-ID: <20170626070326.GA10544@lst.de>
References: <20170622123604.505337-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Salvatore Benedetto <salvatore.benedetto@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>,
        Corentin LABBE <clabbe.montjoie@gmail.com>,
        qat-linux@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:36777 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751232AbdFZHD2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Jun 2017 03:03:28 -0400
Content-Disposition: inline
In-Reply-To: <20170622123604.505337-1-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Thanks Arnd,

added to the dma-mapping tree.
