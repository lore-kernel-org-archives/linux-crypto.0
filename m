From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/7] staging: ccree: remove ccree from staging tree
Date: Sat, 13 Jan 2018 14:21:00 +0100
Message-ID: <20180113132100.GC17515@kroah.com>
References: <1515662239-1714-1-git-send-email-gilad@benyossef.com>
 <1515662239-1714-2-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37992 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754987AbeAMNVA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 13 Jan 2018 08:21:00 -0500
Content-Disposition: inline
In-Reply-To: <1515662239-1714-2-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 11, 2018 at 09:17:08AM +0000, Gilad Ben-Yossef wrote:
> Remove the ccree driver from the staging tree in preparation to
> introducing it in the crypto tree.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>

Heh, no, just make a patch series that adds the driver to the correct
location in the crypto tree.

If that gets accepted, we can then delete the staging driver with a
separate patch, after the fact.  No need for it to be in this patch
series.

thanks,

greg k-h
