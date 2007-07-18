From: Joy Latten <latten@austin.ibm.com>
Subject: Re: combined mode algorithms
Date: Wed, 18 Jul 2007 17:32:53 -0500
Message-ID: <1184797973.15699.310.camel@faith.austin.ibm.com>
References: <1182809638.15699.221.camel@faith.austin.ibm.com>
	 <20070626090956.GA5833@2ka.mipt.ru>
	 <1182870156.15699.230.camel@faith.austin.ibm.com>
	 <20070718044612.GA14232@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36694 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470AbXGRWev (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Jul 2007 18:34:51 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6IMYowo017905
	for <linux-crypto@vger.kernel.org>; Wed, 18 Jul 2007 18:34:50 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l6IMYoLY522044
	for <linux-crypto@vger.kernel.org>; Wed, 18 Jul 2007 18:34:50 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6IMYovX019571
	for <linux-crypto@vger.kernel.org>; Wed, 18 Jul 2007 18:34:50 -0400
In-Reply-To: <20070718044612.GA14232@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 2007-07-18 at 12:46 +0800, Herbert Xu wrote:
> On Tue, Jun 26, 2007 at 10:02:36AM -0500, Joy Latten wrote:
> >
> > Ok, thanks. This helps. I can code up the infrastructure for this. I 
> > am thinking I will eventually need one of the algorithms to test and
> > complete it though. RFCs 4309 and 4106 specify ESP working with AES-CCM
> > and AES-GCM.
> 
> Any progress on this Joy?
> 
> I'm about to start working on this myself in the next couple of
> days.
> 
Great! I have been distracted with some other things, but will also
start this in the next day or two. 

Regards,
Joy 
