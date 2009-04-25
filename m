From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [RFC] [PATCH v2 0/4] Parallel IPsec
Date: Sat, 25 Apr 2009 12:38:49 +0400
Message-ID: <20090425083849.GD26070@ioremap.net>
References: <20090424102451.GB12680@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from matrixpower.ru ([195.178.208.66]:46928 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316AbZDYIi7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 25 Apr 2009 04:38:59 -0400
Content-Disposition: inline
In-Reply-To: <20090424102451.GB12680@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.

On Fri, Apr 24, 2009 at 12:24:51PM +0200, Steffen Klassert (steffen.klassert@secunet.com) wrote:
> This patchset adds the 'pcrypt' parallel crypto template. With this template it
> is possible to process the crypto requests of a transform in parallel without
> getting request reorder. This is in particular interesting for IPsec.

Why can't it be used by default for all crypto operations instead of
synchronous one?

-- 
	Evgeniy Polyakov
