From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [1/1] HIFN: preliminary HIFN 795x driver for new async cryptoapi.
Date: Tue, 22 May 2007 17:19:19 +0200
Message-ID: <20070522151919.GB32493@Chamillionaire.breakpoint.cc>
References: <20070522125828.GB8424@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:32887 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934755AbXEVPTX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 May 2007 11:19:23 -0400
Content-Disposition: inline
In-Reply-To: <20070522125828.GB8424@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Evgeniy Polyakov | 2007-05-22 16:58:29 [+0400]:

>Current driver only supports AES ECB encrypt/decrypt, since I do not 
>know how to detect operation mode in runtime (a question).
Take a look on my skeleton driver (posted just a few seconds ago). It
should solve your problem here.

Sebastian
