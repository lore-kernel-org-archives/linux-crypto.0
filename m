From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: alignmask in the API
Date: Mon, 16 Apr 2007 23:24:00 +0200
Message-ID: <20070416212400.GA30547@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:55973 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030981AbXDPVYC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Apr 2007 17:24:02 -0400
Received: id: bigeasy by Chamillionaire.breakpoint.cc with local
	(easymta 1.00 BETA 1)
	id 1HdYg4-0007xh-MX
	for linux-crypto@vger.kernel.org; Mon, 16 Apr 2007 23:24:00 +0200
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The API allows to set an align mask. This mask is considered on the
allocation of cipher's private ctx and the IV (for block cipher). This
mask is ignored in the setkey function (what is fine with me). 
encrypt() and decrypt() functions get their data through a scatterlist.
Is my understanding correct that I can't assume any alignment of the
input / output data? If so, is it fungible to modify the caller's code
to respect the aligmask?

Sebastian
