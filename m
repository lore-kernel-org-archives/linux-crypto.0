From: Jason <linux_crypto@lakedaemon.net>
Subject: Re: [WIP] crypto: add support for Orion5X crypto engine
Date: Tue, 03 Mar 2009 12:49:37 -0500
Message-ID: <49AD6DB1.4020805@lakedaemon.net>
References: <20090302221058.GA11493@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Sebastian Andrzej Siewior <arm-kernel@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:62219 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbZCCRtp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Mar 2009 12:49:45 -0500
In-Reply-To: <20090302221058.GA11493@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Sebastian Andrzej Siewior wrote:
> From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> 
> This is my current status of an async crypto driver for the Orion5X crypto
> unit. The driver uses the crypto accelerator. 

Is this the same security engine found in the new SheevaPlug Devkit [1]?  It's has the Marvell 88F6281 (Kirkwood) processor in it.  This diagram [2] shows a "Security Engine", but doesn't give any detail...

I found the nuts and bolts starting at page 174 of [3], with registers listed starting on page 634.

thx,

Jason.

[1] - http://www.marvell.com/products/embedded_processors/developer/kirkwood/sheevaplug.jsp
[2] - http://www.marvell.com/products/embedded_processors/kirkwood/index.jsp
[3] - http://www.marvell.com/files/products/embedded_processors/kirkwood/FS_88F6180_9x_6281_OpenSource.pdf
