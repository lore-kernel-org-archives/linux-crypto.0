From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] crypto: use __devexit not __exit in n2_unregister_algs
Date: Wed, 05 Jan 2011 13:38:58 -0800 (PST)
Message-ID: <20110105.133858.102556381.davem@davemloft.net>
References: <1294263387-8984-1-git-send-email-dgilmore@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondoa.apana.org.au,
	dennis@daedalus.ausil.us
To: dgilmore@redhat.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52009
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751296Ab1AEVi1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Jan 2011 16:38:27 -0500
In-Reply-To: <1294263387-8984-1-git-send-email-dgilmore@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Dennis Gilmore <dgilmore@redhat.com>
Date: Wed,  5 Jan 2011 15:36:27 -0600

> From: dennis <dennis@daedalus.ausil.us>
> 
> fixes fedora sparc build failure, thanks to kylem for helping with debugging
> 
> Signed-off-by: Dennis Gilmore <dgilmore@redhat.com>

Acked-by: David S. Miller <davem@davemloft.net>
