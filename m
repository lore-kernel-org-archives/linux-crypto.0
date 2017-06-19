From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH V2] crypto: ccp - Add debugfs entries for CCP information
Date: Mon, 19 Jun 2017 14:38:51 +0800
Message-ID: <20170619063851.GA13651@gondor.apana.org.au>
References: <20170502223220.6039.25937.stgit@taos.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
        davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:59632 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750895AbdFSGjN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jun 2017 02:39:13 -0400
Content-Disposition: inline
In-Reply-To: <20170502223220.6039.25937.stgit@taos.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 02, 2017 at 05:33:40PM -0500, Gary R Hook wrote:
> Expose some data about the configuration and operation of the CCP
> through debugfs entries: device name, capabilities, configuration,
> statistics.
> 
> Allow the user to reset the counters to zero by writing (any value)
> to the 'stats' file. This can be done per queue or per device.
> 
> Changes from V1:
>  - Correct polarity of test when destroying devices at module unload
> 
> Signed-off-by: Gary R Hook <gary.hook@amd.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
