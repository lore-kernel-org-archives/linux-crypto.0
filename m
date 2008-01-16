From: Joy Latten <latten@austin.ibm.com>
Subject: Re: AES with CTS Mode
Date: Wed, 16 Jan 2008 16:13:57 -0600
Message-ID: <1200521637.13706.9.camel@faith.austin.ibm.com>
References: <4d569c330801151228o1cf32b2dn6f6e49922b1036e9@mail.gmail.com>
	 <1200517999.13706.6.camel@faith.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Kevin Coffman <kwc@citi.umich.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:51447 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474AbYAPWPs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Jan 2008 17:15:48 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m0GMFkeI027913
	for <linux-crypto@vger.kernel.org>; Wed, 16 Jan 2008 17:15:46 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0GMFhYY099812
	for <linux-crypto@vger.kernel.org>; Wed, 16 Jan 2008 15:15:45 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0GMFhI1004553
	for <linux-crypto@vger.kernel.org>; Wed, 16 Jan 2008 15:15:43 -0700
In-Reply-To: <1200517999.13706.6.camel@faith.austin.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2008-01-16 at 15:13 -0600, Joy Latten wrote:
> On Tue, 2008-01-15 at 15:28 -0500, Kevin Coffman wrote:
> > Hello,
> > I need to implement AES with CTS mode for NFSv4 (rfc3962 & rfc4121).
> > 
> > I have implemented CTS starting with a copy of CBC (crypto/cbc.c),
> > since CTS is the same as CBC except for the last two blocks.
> > 

> I am not sure I understand, but couldn't you use the CTS in cryptoapi?
> 
Oops!! I was thinking of CTR!! My apologies for any confusion. :-)

Joy
