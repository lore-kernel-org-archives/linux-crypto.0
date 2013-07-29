From: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] drivers/crypto/nx: fix limits to sg lists for SHA-2
Date: Mon, 29 Jul 2013 12:19:12 -0300
Message-ID: <20130729151912.GA4947@oc8526070481.ibm.com>
References: <1374858488-24658-1-git-send-email-mhcerri@linux.vnet.ibm.com>
 <1374858488-24658-3-git-send-email-mhcerri@linux.vnet.ibm.com>
 <1374877892.9200.30.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>,
	Joel Schopp <jschopp@linux.vnet.ibm.com>,
	Joy Latten <jmlatten@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:52765 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757252Ab3G2PT0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 29 Jul 2013 11:19:26 -0400
Received: from /spool/local
	by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <mhcerri@linux.vnet.ibm.com>;
	Mon, 29 Jul 2013 12:19:23 -0300
Content-Disposition: inline
In-Reply-To: <1374877892.9200.30.camel@pasglop>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We think that it's very likely that AES may also be affected by a
similar problem. But we still have to test it and I'd like to provide a
separated patch for it.

Regards,
Marcelo

On Sat, Jul 27, 2013 at 08:31:32AM +1000, Benjamin Herrenschmidt wrote:
> On Fri, 2013-07-26 at 14:08 -0300, Marcelo Cerri wrote:
> > ---
> >  drivers/crypto/nx/nx-sha256.c | 108 +++++++++++++++++++++++-----------------
> >  drivers/crypto/nx/nx-sha512.c | 113 ++++++++++++++++++++++++------------------
> >  2 files changed, 129 insertions(+), 92 deletions(-)
> 
> What about the other nx drivers ? They are not affected ?
> 
> Cheers,
> Ben.
> 
> 
