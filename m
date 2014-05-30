From: Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH] RSA: Don't select non-existent symbol
Date: Fri, 30 May 2014 12:50:33 +0200
Message-ID: <20140530125033.49ee1f84@endymion.delvare>
References: <20140522182515.626f0728@endymion.delvare>
	<20140530091853.GA12760@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	David Howells <dhowells@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60606 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbaE3Kur (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 May 2014 06:50:47 -0400
In-Reply-To: <20140530091853.GA12760@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On Fri, 30 May 2014 17:18:54 +0800, Herbert Xu wrote:
> On Thu, May 22, 2014 at 06:25:15PM +0200, Jean Delvare wrote:
> > You can select MPILIB_EXTRA all you want, it doesn't exist ;-)
> > 
> > Surprised kconfig doesn't complain about that...
> > 
> > Signed-off-by: Jean Delvare <jdelvare@suse.de>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: "David S. Miller" <davem@davemloft.net>
> 
> This patch should go to David Howells <dhowells@redhat.com>

Why? How could I find out? scripts/get_maintainer.pl says David Miller
and you. If David Howells really wants to handle this, he should add an
appropriate entry in MAINTAINERS.

-- 
Jean Delvare
SUSE L3 Support
