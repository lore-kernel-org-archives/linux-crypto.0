From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: Re: ipsec impact on performance
Date: Tue, 1 Dec 2015 14:01:27 -0500
Message-ID: <20151201190127.GG21252@oracle.com>
References: <20151201175953.GC21252@oracle.com>
 <565DE446.2070609@hpe.com>
 <20151201184504.GF21252@oracle.com>
 <565DEBF7.7040304@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, linux-crypto@vger.kernel.org
To: Rick Jones <rick.jones2@hpe.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40752 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbbLATBe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 Dec 2015 14:01:34 -0500
Content-Disposition: inline
In-Reply-To: <565DEBF7.7040304@hpe.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On (12/01/15 10:50), Rick Jones wrote:
> 
> Something of a longshot, but are you sure you are still getting
> effective CKO/GRO on the receiver?

Good question. With ipsec, GRO (like GSO) gets implicitly disabled.

But when I explictly disable GRO on receiver, leaving only GSO
on sender, I can still get about 6 Gbps for clear traffic.

Thus if I could get closer to 6 Gbps for my patch, I'd at least
know that it was just GRO that was missing.. but I'm only getting 
3 Gbps, which makes me think I missed something else on the sender
itself.

--Sowmini
