From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH] [crypto] Make crypto core API modular
Date: Sun, 2 Dec 2007 16:09:50 +0100
Message-ID: <20071202150950.GA15213@Chamillionaire.breakpoint.cc>
References: <20071201121910.GA8048@Chamillionaire.breakpoint.cc>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:45512 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751750AbXLBPJx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 2 Dec 2007 10:09:53 -0500
Content-Disposition: inline
In-Reply-To: <20071201121910.GA8048@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Sebastian Siewior | 2007-12-01 13:19:10 [+0100]:

>This patch makes the whole crypto API is modular.
Ups, I forgot to put a MODULE_VERSION("GPL") inside of the module.
Herbert, do you nack that patch due to non-sense or do you think that
this might be usefull and I should send an updated one?

Sebastian
