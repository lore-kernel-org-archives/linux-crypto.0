From: Andi Kleen <ak@suse.de>
Subject: Re: {twofish,aes}-{x86_64,i586} versus C implementations
Date: Tue, 4 Sep 2007 14:58:56 +0100
Message-ID: <200709041458.56774.ak@suse.de>
References: <200708200234.25620.ak@suse.de> <20070820130639.GN16680@bingen.suse.de> <20070902224226.GA22869@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:36487 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068AbXIDPC0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Sep 2007 11:02:26 -0400
In-Reply-To: <20070902224226.GA22869@Chamillionaire.breakpoint.cc>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


> What about:

Looks good.
-Andi

>
> [crypto] do not use generic AES on i386 and x86_64
