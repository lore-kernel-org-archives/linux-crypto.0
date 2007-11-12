From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH] HIFN: make Kconfig option depend on PCI
Date: Mon, 12 Nov 2007 16:24:57 +0300
Message-ID: <20071112132457.GB31134@2ka.mipt.ru>
References: <1194874310.5656.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Jan Glauber <jang@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:53912 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758697AbXKLNdr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Nov 2007 08:33:47 -0500
Content-Disposition: inline
In-Reply-To: <1194874310.5656.10.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Nov 12, 2007 at 01:31:49PM +0000, Jan Glauber (jang@linux.vnet.ibm.com) wrote:
> The HIFN driver is currently selectable on s390 but wont compile.
> Since it looks like HIFN needs PCI make the Kconfig dependent on PCI,
> which is not available on s390.

Ugh, correct of course.
Thanks Jan.

ACK.

-- 
	Evgeniy Polyakov
