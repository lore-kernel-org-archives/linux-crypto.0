From: Jari Ruusu <jariruusu@users.sourceforge.net>
Subject: Re: loop-aes: It is not longer possible to create a filesystem on an
 encrypted DVD-RAM
Date: Mon, 28 Mar 2011 09:56:52 +0300
Message-ID: <4D903134.CFFC7ACF@users.sourceforge.net>
References: <134368.68091.qm@web114114.mail.gq1.yahoo.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Thomas Siedlich <thomas.siedlich@yahoo.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.tnnet.fi ([217.112.240.26]:39735 "EHLO mail.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732Ab1C1G4z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Mar 2011 02:56:55 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Thomas Siedlich wrote:
> I try to format a loop-aes encrypted DVD-RAM in /dev/sr0 with mke2fs.

What loop-AES version are you using?

What kernel version are you using?

> ,----[/var/log/syslog]
> | Mar 27 15:29:27 eagle kernel: loop2: loop_end_io_transfer err=-95 bi_rw=0x461

Backing device returned EOPNOTSUPP (Operation not supported on transport
endpoint) error for a write. Interpreting rest of bi_rw bits depends on
kernel version. For 2.6.38 kernel bi_rw means: "metadata io request",
"request to discard sectors", and "This bio has already been subjected to
throttling rules. Don't do it again"

> | Mar 27 15:29:27 eagle kernel: Buffer I/O error on device loop2, logical block 0
> | Mar 27 15:29:27 eagle kernel: lost page write due to I/O error on loop2

Somehow EOPNOTSUPP error got interpreted as I/O error and/or write was not
retried with bi_rw bits cleared that backing device do not support.

> | Mar 27 15:29:27 eagle kernel: loop2: loop_end_io_transfer err=-95 bi_rw=0x20
> | Mar 27 15:29:27 eagle kernel: Buffer I/O error on device loop2, logical block 0

Backing device returned EOPNOTSUPP error for a read. Interpreting rest of
bi_rw bits depends on kernel version. For 2.6.38 kernel bi_rw means:
"metadata io request".

> It just works fine but unencrypted :-(.

As a temporary workaround, you can create unencrypted file system and then
encrypt it in-place using aespipe tool.

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
