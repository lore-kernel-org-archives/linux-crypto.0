Return-Path: <SRS0=/ZR5=OQ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:49042 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725967AbeLGGS5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Dec 2018 01:18:57 -0500
Date: Fri, 7 Dec 2018 14:18:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Atul Gupta <atul.gupta@chelsio.com>
Cc: linux-crypto@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [crypto chcr 1/2] small packet Tx stalls the queue
Message-ID: <20181207061855.w6ecbk5ximp53jad@gondor.apana.org.au>
References: <1543568508-23639-1-git-send-email-atul.gupta@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1543568508-23639-1-git-send-email-atul.gupta@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 30, 2018 at 02:31:48PM +0530, Atul Gupta wrote:
> Immediate packets sent to hardware should include the work
> request length in calculating the flits. WR occupy one flit and
> if not accounted result in invalid request which stalls the HW
> queue.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
> ---
>  drivers/crypto/chelsio/chcr_ipsec.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
