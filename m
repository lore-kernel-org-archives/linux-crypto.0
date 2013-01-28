From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [patch] padata: test correct variable in ->store function
Date: Mon, 28 Jan 2013 10:48:35 +0100
Message-ID: <20130128094835.GO9147@secunet.com>
References: <20130126074946.GC14365@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Kruchinin <dkruchinin@acm.org>, linux-crypto@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:58520 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035Ab3A1Jsl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Jan 2013 04:48:41 -0500
Content-Disposition: inline
In-Reply-To: <20130126074946.GC14365@elgon.mountain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jan 26, 2013 at 10:49:46AM +0300, Dan Carpenter wrote:
> It's testing for ->show but calling ->store().
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Looks like a copy and paste error.

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

Herbert, are you going to take this one?

Thanks!
