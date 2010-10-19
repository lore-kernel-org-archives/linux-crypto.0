From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2.6.36-rc7] crypto: use cancel_delayed_work_sync() in
	hifn_795x
Date: Tue, 19 Oct 2010 20:50:43 +0800
Message-ID: <20101019125043.GB12898@gondor.apana.org.au>
References: <4CB8445C.1060109@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:45589 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab0JSMut (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Oct 2010 08:50:49 -0400
Content-Disposition: inline
In-Reply-To: <4CB8445C.1060109@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 15, 2010 at 02:09:00PM +0200, Tejun Heo wrote:
> Make hifn_795x::hifn_remove() call cancel_delayed_work_sync() instead
> of calling cancel_delayed_work() followed by flush_scheduled_work().
> 
> This is to prepare for the deprecation and removal of
> flush_scheduled_work().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Patch applied.  Thanks Tejun!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
