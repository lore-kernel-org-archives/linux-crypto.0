From: Joy Latten <latten@austin.ibm.com>
Subject: Re: combined mode algorithms
Date: Tue, 26 Jun 2007 10:02:36 -0500
Message-ID: <1182870156.15699.230.camel@faith.austin.ibm.com>
References: <1182809638.15699.221.camel@faith.austin.ibm.com>
	 <20070626090956.GA5833@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:47828 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756589AbXFZPEJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jun 2007 11:04:09 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5QF43IJ027831
	for <linux-crypto@vger.kernel.org>; Tue, 26 Jun 2007 11:04:03 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5QF3xA4216058
	for <linux-crypto@vger.kernel.org>; Tue, 26 Jun 2007 09:04:01 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5QF3wW7007151
	for <linux-crypto@vger.kernel.org>; Tue, 26 Jun 2007 09:03:59 -0600
In-Reply-To: <20070626090956.GA5833@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 2007-06-26 at 13:09 +0400, Evgeniy Polyakov wrote:
> On Mon, Jun 25, 2007 at 05:13:58PM -0500, Joy Latten (latten@austin.ibm.com) wrote:
> > I have been reading IP Encapsulating Payload-(ESP) RFC4303 where use of
> > combined mode algorithms are mentioned and accommodated for. 
> > In trying to determine how I should handle this, I examined the
> > crypto code and could not readily recognize any combined mode
> > algorithms. Are there any current plans to implement combined mode
> > algorithms?  
> 
> I think it should be first supported by ipsec stack at least with state,
> where SA cold be configured, integrity check for the data/header is not 
> a problem after that changes are stable. sha1/encryption is a poor man's
> combined algo after all with hash data being ICV :)
> 

Ok, thanks. This helps. I can code up the infrastructure for this. I 
am thinking I will eventually need one of the algorithms to test and
complete it though. RFCs 4309 and 4106 specify ESP working with AES-CCM
and AES-GCM.

Regards,
Joy
