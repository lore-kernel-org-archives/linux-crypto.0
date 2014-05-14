From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: ahash vs. shash
Date: Wed, 14 May 2014 09:39:40 +0800
Message-ID: <20140514013940.GA29183@gondor.apana.org.au>
References: <CACE9dm-6kTZ91Ha8sMS=Zviqg-Dx6tzeTRVJtsGHKxwwP+TRzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:51544 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbaENBjn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 May 2014 21:39:43 -0400
Content-Disposition: inline
In-Reply-To: <CACE9dm-6kTZ91Ha8sMS=Zviqg-Dx6tzeTRVJtsGHKxwwP+TRzQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dmitry Kasatkin <dmitry.kasatkin@gmail.com> wrote:
> Hi,
> 
> ahash allows to use HW acceleration, but usually it comes at a cost of
> additional HW related configuration overhead, such as configuring hash
> module, DMA, etc. For that reason hashing small chucks of data is
> faster doing it with shash (CPU) rather than HW acceleration.
> 
> I measured long time ago on omap-sham driver but cannot recall any data.
> 
> Does anyone have any experience under what data size it is still
> better to use shash?

It's going to be hardware-specific.  It'll also depend on whether
you're coming from user-space or not as that would entail a bigger
per-request overhead, meaning that you need more data to break
even.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
