From: Christoph Hellwig <hch@lst.de>
Subject: alg: cipher: Test 1 failed on encryption for aes-asm
Date: Fri, 19 Dec 2008 21:26:03 +0100
Message-ID: <20081219202603.GA31265@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:43460 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbYLSU0H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Dec 2008 15:26:07 -0500
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id mBJKQ4IF031359
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2008 21:26:04 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id mBJKQ4N0031357
	for linux-crypto@vger.kernel.org; Fri, 19 Dec 2008 21:26:04 +0100
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On my new thinkpad with a Intel Core2 Duo T9600 I reproducibly get
this message during boot:

[    0.657034] alg: cipher: Test 1 failed on encryption for aes-asm
[    0.657111] 00000000: 00 01 02 03 04 05 06 07 08 08 08 08 08 08 08 08 

I'd assume it's not a hardware but, so my the assembly code doesn't
like the debian toolchain?  It's

	binutils 2.18.1~cvs20080103-7
	gcc 4.3.2-1

(all the Debian package versions)
