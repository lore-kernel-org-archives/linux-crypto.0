From: Joy Latten <latten@austin.ibm.com>
Subject: Re: AES with CTS Mode
Date: Wed, 16 Jan 2008 15:13:19 -0600
Message-ID: <1200517999.13706.6.camel@faith.austin.ibm.com>
References: <4d569c330801151228o1cf32b2dn6f6e49922b1036e9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Kevin Coffman <kwc@citi.umich.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:34886 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbYAPVPH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Jan 2008 16:15:07 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m0GLF5Q3032382
	for <linux-crypto@vger.kernel.org>; Wed, 16 Jan 2008 16:15:05 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0GLF6wC178968
	for <linux-crypto@vger.kernel.org>; Wed, 16 Jan 2008 16:15:06 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0GLF5hb009094
	for <linux-crypto@vger.kernel.org>; Wed, 16 Jan 2008 16:15:05 -0500
In-Reply-To: <4d569c330801151228o1cf32b2dn6f6e49922b1036e9@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2008-01-15 at 15:28 -0500, Kevin Coffman wrote:
> Hello,
> I need to implement AES with CTS mode for NFSv4 (rfc3962 & rfc4121).
> 
> I have implemented CTS starting with a copy of CBC (crypto/cbc.c),
> since CTS is the same as CBC except for the last two blocks.
> 

I am not sure I understand, but couldn't you use the CTS in cryptoapi?

regards,
Joy
