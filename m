From: Jari Ruusu <jariruusu@users.sourceforge.net>
Subject: Re: loop-aes: It is not longer possible to create a filesystem on an  
 encrypted DVD-RAM
Date: Tue, 29 Mar 2011 07:07:03 +0300
Message-ID: <4D915AE7.BA4444B9@users.sourceforge.net>
References: <610509.93400.qm@web114106.mail.gq1.yahoo.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Thomas Siedlich <thomas.siedlich@yahoo.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.tnnet.fi ([217.112.240.26]:43640 "EHLO mail.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774Ab1C2EHJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 29 Mar 2011 00:07:09 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Thomas Siedlich wrote:
> For my kernel it should mean (if I interpret
> /usr/src/linux/include/linux/bio.h right):
> "Tell the IO scheduler not to wait for more requests after this
>         one has been submitted, even if it is a SYNC request."
> "synchronous I/O hint."
> "barrier"
> "write"

"barrier" bit is the one that triggered EOPNOTSUPP error from backing device.

> Here:
> "barrier"
> and
> "read"

Same here.

> So "barrier" is the same in both messages. But why does it work
> without loop? The backing device should be the same, shouldn't it?

Because loop-AES-v3.3a has a bug in barrier request handling that triggers
when a barrier request is sent to backing device that can't handle barrier
request. This is what happens:

1) Block layer kernel code above loop driver issues empty barrier request to
   loop driver.
2) Loop driver does not pass that empty barrier request to backing device.
   Instead it sets a flag to indicate "mark next request as barrier".
3) Next request arrives at loop driver, loop driver marks that one as
   barrier request, and eventually sends it to backing device.
4) Backing device driver decides that it doesn't do barriers at all, and
   aborts processing that request.

In short: due to loop driver bug, backing device driver aborted wrong
request with EOPNOTSUPP error code.

This bug is fixed in loop-AES-v3.6b (it got fixed as part of queue code
removal/rewrite). If you can reproduce this error with loop-AES-v3.6b, then
I definitely want to know about it.

Seeing small amount of EOPNOTSUPP errors (loop_end_io_transfer err=-95 ...)
in syslog is normal. This can happen when a file system is probing and/or
learning that backing device under loop device driver does not support
barriers.

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
