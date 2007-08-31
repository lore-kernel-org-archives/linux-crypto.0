From: Markus Huehnerbein <silencer@gmx.ch>
Subject: Re: Problem using dm-crypt with geode LX800 AES-Engine
Date: Fri, 31 Aug 2007 19:20:09 +0200
Message-ID: <46D84DC9.9040909@gmx.ch>
References: <E1IQvJK-0006We-00@gondolin.me.apana.org.au> <46D80C50.3090402@gmx.ch> <20070831145554.GB31508@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@ml.breakpoint.cc, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54306 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965387AbXHaRUM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 31 Aug 2007 13:20:12 -0400
In-Reply-To: <20070831145554.GB31508@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

> OK.  Could you please write 4K zeros to the device with dd and
> then read them back out using od -x?

Hope I did it right:

dd if=/dev/zero of=/dev/mapper/devdmcrypt bs=4k count=1
1+0 records in
1+0 records out
4096 bytes (4.1 kB) copied, 0.0353821 seconds, 116 kB/s

od -x /dev/mapper/devdmcrypt
0000000 0000 0000 0000 0000 0000 0000 0000 0000
*
15720240 ab28 c716 3349 75e2 9c3d 2bcd 01ca 5216
(...)

cheers,
Markus
