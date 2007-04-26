From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: Testing the geode-aes driver with the tcrypt module completely freezes the machine
Date: Thu, 26 Apr 2007 13:05:22 +0200
Message-ID: <20070426110522.GB31648@Chamillionaire.breakpoint.cc>
References: <000601c787e1$e169ff00$1a04010a@V505CP>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Martin Schiller <mschiller@tdt.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:41719 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932368AbXDZLFX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Apr 2007 07:05:23 -0400
Content-Disposition: inline
In-Reply-To: <000601c787e1$e169ff00$1a04010a@V505CP>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Martin Schiller | 2007-04-26 11:04:21 [+0200]:

>- When the geode_aes module is loaded and I am loading the tcrypt module,
>  the machine freezes completely.

could you modify the tcrpto module to test only ecb(aes) enc/dec with
keysize = 16 (1 instead of AES_ENC_TEST_VECTORS) and see if it is still
freezing?

Sebastian
