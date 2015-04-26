From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] Fixing NX data alignment with nx_sg list
Date: Sun, 26 Apr 2015 14:51:33 +0800
Message-ID: <20150426065132.GB13536@gondor.apana.org.au>
References: <20150423204024.GA11036@bluepex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33461 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbbDZGvh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 26 Apr 2015 02:51:37 -0400
Content-Disposition: inline
In-Reply-To: <20150423204024.GA11036@bluepex.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 23, 2015 at 05:40:30PM -0300, Leonidas S. Barbosa wrote:
> In NX we need to pass always a 16 multiple size nx_sg_list to
> co processor. Trim function handle with this assuring all nx_sg_lists
> are 16 multiple size, although data was not being considerated when
> crop was done. It was causing an unalignment between size of the list
> and data, corrupting csbcpb fields returning a -23 H_ST_PARM error, or
> invalid operation.
> 
> This patch fix this recalculating how much data should be put back
> in to_process variable what assures the size of sg_list will be
> correct with size of the data.
> 
> Signed-off-by: Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>

Both patches applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
