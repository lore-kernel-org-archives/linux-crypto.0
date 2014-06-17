From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 06/24] crypt: return actual error code on pcrypt_init
Date: Tue, 17 Jun 2014 12:24:48 -0700
Message-ID: <20140617192448.GD4628@kroah.com>
References: <53A050AE.2050401@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Jeff Liu <jeff.liu@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:40403 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932657AbaFQTVD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Jun 2014 15:21:03 -0400
Received: from compute1.internal (compute1.nyi.mail.srv.osa [10.202.2.41])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 705722159F
	for <linux-crypto@vger.kernel.org>; Tue, 17 Jun 2014 15:20:57 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <53A050AE.2050401@oracle.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 17, 2014 at 10:29:02PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Return the actual error code if call kset_create_and_add() failed
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller" <davem@davemloft.net>
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  crypto/pcrypt.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Herbert and David, please do not take this patch, it is incorrect.

thanks,

greg k-h
