From: Michael Richardson <mcr@sandelman.ca>
Subject: Re: Asynchronus crypto API
Date: Wed, 21 Feb 2007 12:27:33 -0500
Message-ID: <erhvfe$uun$1@sea.gmane.org>
References: <20070209110800.GB25171@amd.com> <20070209113108.GA11467@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:49406 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030309AbXBZQZO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Feb 2007 11:25:14 -0500
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1HLies-0008T7-7Y
	for linux-crypto@vger.kernel.org; Mon, 26 Feb 2007 17:25:02 +0100
Received: from desk.marajade.sandelman.ca ([205.150.200.247])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-crypto@vger.kernel.org>; Mon, 26 Feb 2007 17:25:02 +0100
Received: from mcr by desk.marajade.sandelman.ca with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-crypto@vger.kernel.org>; Mon, 26 Feb 2007 17:25:02 +0100
In-Reply-To: <20070209113108.GA11467@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Evgeniy Polyakov wrote:
> 2. ocf
> http://ocf-linux.sourceforge.net/

Please note that much more recent code is now at:
    git clone http://hifn.xelerance.com/scm/klips/

There is one remaining bug that has been hard to reproduce which
seems to be at the IPsec layer, but the OCF and hardware drivers
are very stable.  For software crypto, it uses cryptoapi, and can
invoke them asynchronously if you like.
The code does not apply to >=2.6.19 due the recent changes, and we
will catch it up to the new cryptoapi interface in the next week
or so.
