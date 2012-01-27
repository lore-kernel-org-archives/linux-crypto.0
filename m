From: Mushki <mushki5@yahoo.com>
Subject: SHA algorithm
Date: Fri, 27 Jan 2012 03:46:20 +0000 (UTC)
Message-ID: <loom.20120127T043803-809@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:59199 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257Ab2A0DzI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Jan 2012 22:55:08 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkc-linux-crypto@m.gmane.org>)
	id 1Rqcu3-0003qs-0G
	for linux-crypto@vger.kernel.org; Fri, 27 Jan 2012 04:55:07 +0100
Received: from 216.31.219.19 ([216.31.219.19])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-crypto@vger.kernel.org>; Fri, 27 Jan 2012 04:55:06 +0100
Received: from mushki5 by 216.31.219.19 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-crypto@vger.kernel.org>; Fri, 27 Jan 2012 04:55:06 +0100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I am trying to write a driver for HW accelerator for SHA1.
I have set the "shash_alg" structure properly. I am noticing the following
sequence of call back function calls

- my init function gets called
- my update function gets called (with data and size)
- my finup function gets called (u8 *in_data, int in_data_size, u8 * out_data)

Typically I would expect messages to stop here, however I see second finup
message with data size 20. Is this correct? What is it supposed to be used for?

The total size of actual data is size of data in update + size of data in first
finup, so what is this extra 20 bytes?

Also do I need to define export and import functions. I haven't.

Your help is highly appreciated. Thanks,

Mushki.
