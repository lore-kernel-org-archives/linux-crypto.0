From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: HIFN+IPsec crashes in current -git
Date: Thu, 21 Feb 2008 12:10:12 +0300
Message-ID: <20080221091012.GA21291@2ka.mipt.ru>
References: <E1JRLsx-0003Yz-00@gondolin.me.apana.org.au> <47BB036D.7090701@trash.net> <20080220005329.GA21565@gondor.apana.org.au> <47BC1E12.9050201@trash.net> <20080220172620.GE27726@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:48694 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbYBUJK6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Feb 2008 04:10:58 -0500
Content-Disposition: inline
In-Reply-To: <20080220172620.GE27726@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 21, 2008 at 01:26:20AM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> On Wed, Feb 20, 2008 at 01:33:22PM +0100, Patrick McHardy wrote:
> >
> > I saw the discrepancy between the elen value used
> > for aead_request_set_crypt() in esp_input() and the
> > req->nbytes value seen in hifn_setup_session().
> 
> OK that is normal.  esp_input is now using the AEAD interface
> so the size for the request includes the ICV.  By the time the
> request gets to hifn it no longer has the ICV so it would be
> 12 bytes elss.

But req->nbytes should or should not correspond to number of bytes to be
encrypted? HIFN driver assumes so, it can be changed to run through
scatterlists (btw, how will it determine how many of them were
provided?) and get full size of the request from them, but I suspected
that req->nbytes should always be equal to number of bytes to be
encrypted by the driver, otherwise where to get that info from?

-- 
	Evgeniy Polyakov
