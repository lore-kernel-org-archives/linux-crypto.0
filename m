From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [RFC] padlock aes, unification of setkey()
Date: Sun, 24 Feb 2008 13:51:17 +0100
Message-ID: <20080224125117.GA17076@Chamillionaire.breakpoint.cc>
References: <1203850864-16681-1-git-send-email-sebastian@breakpoint.cc> <47C15AEC.5040705@the2masters.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Stefan Hellermann <stefan@the2masters.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:40030 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754673AbYBXMvT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 24 Feb 2008 07:51:19 -0500
Content-Disposition: inline
In-Reply-To: <47C15AEC.5040705@the2masters.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Stefan Hellermann | 2008-02-24 12:54:20 [+0100]:

>Hello,
Hello,

>I'm got my Via Epia SN Board a few days ago and could test everything related to the
>padlock engine, I'm especially interested in the aes-{lrw,xts} combo, this doesn't work at
Cool,

>the moment (last tested with 2.6.25-rc1).
Could you be a little more specific on "it doesn't work"?
Do you pass the tcrypt test at least?
Does it* work without the HW acceleration?

>Cheers,
>Stefan

*: it means a dm-crypt encrypted partition I guess.

Sebastian
