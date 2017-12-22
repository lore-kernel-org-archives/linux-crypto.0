From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 02/45] drivers: crypto: remove duplicate includes
Date: Fri, 22 Dec 2017 19:37:31 +1100
Message-ID: <20171222083731.GA30924@gondor.apana.org.au>
References: <1512439057-15443-1-git-send-email-pravin.shedge4linux@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Corentin LABBE <clabbe.montjoie@gmail.com>,
        Steve Lin <steven.lin1@broadcom.com>,
        Rob Rice <rob.rice@broadcom.com>,
        raveendra padasalagi <raveendra.padasalagi@broadcom.com>,
        Colin Ian King <colin.king@canonical.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Srikanth Jampala <Jampala.Srikanth@cavium.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Pravin Shedge <pravin.shedge4linux@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:46260 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751349AbdLVIiC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 03:38:02 -0500
Content-Disposition: inline
In-Reply-To: <1512439057-15443-1-git-send-email-pravin.shedge4linux@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 05, 2017 at 07:27:22AM +0530, Pravin Shedge wrote:
> These duplicate includes have been found with scripts/checkincludes.pl but
> they have been removed manually to avoid removing false positives.
> 
> Signed-off-by: Pravin Shedge <pravin.shedge4linux@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
