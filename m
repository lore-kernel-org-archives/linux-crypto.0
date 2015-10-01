From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCHv2 1/1] Disable fips-allowed for authenc() and des()
 ciphers
Date: Thu, 1 Oct 2015 22:01:34 +0800
Message-ID: <20151001140134.GD27726@gondor.apana.org.au>
References: <1443115475-27398-1-git-send-email-john.haxby@oracle.com>
 <1443115475-27398-2-git-send-email-john.haxby@oracle.com>
 <1970269.pETRl5cENR@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: John Haxby <john.haxby@oracle.com>, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52719 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756154AbbJAOBo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 Oct 2015 10:01:44 -0400
Content-Disposition: inline
In-Reply-To: <1970269.pETRl5cENR@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 25, 2015 at 07:58:10AM +0200, Stephan Mueller wrote:
> Am Donnerstag, 24. September 2015, 18:24:35 schrieb John Haxby:
> 
> Hi John,
> 
> >No authenc() ciphers are FIPS approved, nor is ecb(des).
> >After the end of 2015, ansi_cprng will also be non-approved.
> >
> >Signed-off-by: John Haxby <john.haxby@oracle.com>
> 
> Acked-by: Stephan Mueller <smueller@chronox.de>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
