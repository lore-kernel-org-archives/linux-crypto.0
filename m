From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1]: Revised CTR mode implementation
Date: Thu, 11 Oct 2007 17:00:27 +0800
Message-ID: <20071011090026.GA16740@gondor.apana.org.au>
References: <200710091944.l99JiedH009971@faith.austin.ibm.com> <20071010151743.GA8337@gondor.apana.org.au> <1192032506.2477.285.camel@faith.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Joy Latten <latten@austin.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2831 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752642AbXJKJAz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Oct 2007 05:00:55 -0400
Content-Disposition: inline
In-Reply-To: <1192032506.2477.285.camel@faith.austin.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 10, 2007 at 11:08:26AM -0500, Joy Latten wrote:
>
> This patch implements CTR mode for IPsec.
> It is based off of RFC 3686.

Thanks! I've just applied it to cryptodev-2.6 and will push it
out soon.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
