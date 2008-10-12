From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: hifn_795x in Linux-2.6.27-rc7
Date: Sun, 12 Oct 2008 20:14:55 +0800
Message-ID: <20081012121455.GA14141@gondor.apana.org.au>
References: <48D7D84B.9020507@psycast.de> <20080923165521.GA26513@2ka.mipt.ru> <48D93028.20903@psycast.de> <20080923181840.GA24982@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dimitri Puzin <max@psycast.de>, linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:43716 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751573AbYJLMPf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 12 Oct 2008 08:15:35 -0400
Content-Disposition: inline
In-Reply-To: <20080923181840.GA24982@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 23, 2008 at 10:18:42PM +0400, Evgeniy Polyakov wrote:
> 
> Attached patch should not allow HIFN to be registered on 64-bit arch, so
> crypto layer will fallback to the software algorithms.
> 
> Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

Patch applied.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
