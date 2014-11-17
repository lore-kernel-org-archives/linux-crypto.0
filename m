From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 0/2] crypto: qat - Fix for invalid dma mapping and numa
Date: Mon, 17 Nov 2014 10:33:51 -0800
Message-ID: <20141117183351.GA12343@kroah.com>
References: <20141014012251.742.5500.stgit@tstruk-mobl1>
 <543E4DFF.9000101@redhat.com>
 <543E59B9.6060804@redhat.com>
 <20141024144521.GA20889@gondor.apana.org.au>
 <546A178C.6070908@intel.com>
 <20141117165916.GA5744@kroah.com>
 <546A2E62.3020401@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Prarit Bhargava <prarit@redhat.com>,
	Nikolay Aleksandrov <nikolay@redhat.com>,
	bruce.w.allan@intel.com, qat-linux@intel.com, naleksan@redhat.com,
	linux-crypto@vger.kernel.org, davem@davemloft.net
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49796 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbaKQSdw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Nov 2014 13:33:52 -0500
Content-Disposition: inline
In-Reply-To: <546A2E62.3020401@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 17, 2014 at 09:20:34AM -0800, Tadeusz Struk wrote:
> On 11/17/2014 08:59 AM, Greg KH wrote:
> > Because it showed up in Linus's tree _after_ 3.17.3-rc1 was released?
> > How can I go back in time?
> 
> I thought it was already possible, no? :)
> So will it be in 3.17.4?

Possibly, if I get around to it, relax please...

greg "burried in patches" k-h
