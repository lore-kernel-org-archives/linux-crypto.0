From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: [QUESTION] How is the backlog supposed to be used?
Date: Mon, 1 Dec 2014 14:12:55 +0100
Message-ID: <20141201131255.GG6184@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kernel@pengutronix.de
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40068 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbaLANM5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Dec 2014 08:12:57 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi all!

I have a question regarding the use of the backlog in a driver
using the crypto API.
In my driver ("crypto: sahara - SHA support") I had a problem with
using the backlog when I am using more than one thread to enqueue
the requests and have a queue depth of 1. What happens is, that I
run into the backlog and then complete the request twice, if I do
it like all the other drivers. Random example:

	backlog = crypto_get_backlog(&sdcp->queue[chan]);
	arq = crypto_dequeue_request(&sdcp->queue[chan]);

	if (backlog)
		backlog->complete(backlog, -EINPROGRESS);

Everything works fine if I do not complete the request from the
backlog, but instead complete the request when it is due.
Alternative: make the queue deeper like some drivers have it.
If the queue is deeper than I have threads, it works, because
the requests never get onto the backlog.
So, how is the queue intended to be used? What is a correct max_depth?
Do I need to complete the requests from the backlog or not?

Thanks,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
