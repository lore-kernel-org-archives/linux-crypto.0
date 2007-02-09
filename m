From: "Joerg Roedel" <joerg.roedel@amd.com>
Subject: Re: Asynchronus crypto API
Date: Fri, 9 Feb 2007 13:16:02 +0100
Message-ID: <20070209121602.GC25171@amd.com>
References: <20070209110800.GB25171@amd.com>
 <20070209113108.GA11467@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:58494 "EHLO
	outbound2-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946402AbXBIMQY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Feb 2007 07:16:24 -0500
In-Reply-To: <20070209113108.GA11467@2ka.mipt.ru>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello Evgeniy,

On Fri, Feb 09, 2007 at 02:31:11PM +0300, Evgeniy Polyakov wrote:
> On Fri, Feb 09, 2007 at 12:08:00PM +0100, Joerg Roedel (joerg.roedel@amd.com) wrote:
> > Background: I recently bought a HIFN crypto card and would like to use
> > it under Linux without the need to use some external patchsets :)
> 
> Not for now - either use acrypto [1] or ocf [2].

Yes, these two I meant with "external patchsets" :-)
It would be nice to have an asynchronous API in the mainstream kernel.
An the documentation says it is under development, therefore I ask :)

Joerg

-- 
Joerg Roedel
Operating System Research Center
AMD Saxony LLC & Co. KG
