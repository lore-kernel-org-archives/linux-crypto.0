From: Sebastian Siewior <cbe-oss-dev@ml.breakpoint.cc>
Subject: [patch 00/10] KSPU API + AES offloaded to SPU + testing module
Date: Thu, 16 Aug 2007 22:01:05 +0200
Message-ID: <20070816200105.735608000@ml.breakpoint.cc>
Cc: <herbert@gondor.apana.org.au>, <arnd@arndb.de>, <jk@ozlabs.org>,
	linux-crypto@vger.kernel.org
To: cbe-oss-dev@ozlabs.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60603 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753508AbXHPUF5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Aug 2007 16:05:57 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This is a complete submission of $subject against current git.
Content:
 1 - required casting to retrieve private struct out of crypto API
 2 - function to retrieve private crypto struct. Herbert queued this
    already for 2.6.24.
 3 - KSPU doc
 4 - KSPU skeleton
 5 - exporting required symbols within spufs.ko
 6 - allocation of KSPU context
 7 - KSPU, PPU side implementation
 8 - KSPU, SPE side implementation
 9 - AES as KSPU & Crypto user. Providing ECB+CBC block mode
10 - testing module for AES crypto.

Herbert, I've put you on CC to consider patch 1 for inclusion. As I noticed
earlier, KSPU is a general purpose interface so it is not clever to use
crypto's infrastructure since KSPU may be used for non-crypto related
tasks. However, I included a soft limit.

Figure [1] shows performance of aes-spu in ECB mode with a transfer size
of 16 KiBb. Generic is crypto/aes.c compiled for SPU, sync means it is there
is no queue process just copy data and start the SPU, async is what is
provided by the patch series. 
Figure [2] shows the performance with different DMA transfer sizes
(smaller chunks = more transfers). Async benefits from double buffering
and more requests at a time but slower at 16 KiB due to more communication.

The pdfs are 4.6 KiB each but scalable :)

[1] http://download.breakpoint.cc/spu/spu_code_async.pdf
[2] http://download.breakpoint.cc/spu/spu_async_blocksize_aligned.pdf

sleepy Sebastian
-- 
