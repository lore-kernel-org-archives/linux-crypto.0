From: Jorgen Lundman <lundman@lundman.net>
Subject: Re: Crypto causes panic in scatterwalk_done with large/multiple buffers
Date: Sun, 18 Nov 2012 11:10:39 +0900
Message-ID: <50A8439F.4060201@lundman.net>
References: <50A4AFEE.9030206@lundman.net> <20121117024220.12381ph1ph0fu3q8@www.dalek.fi> <20121117103901.664145ijlv5r29wk@www.dalek.fi> <50A82BD1.4000505@lundman.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.lundman.net ([210.157.1.114]:48299 "EHLO mail.lundman.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab2KRCKo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 Nov 2012 21:10:44 -0500
Received: from localhost (solaris11 [127.0.0.1])
	by mail.lundman.net (Postfix) with ESMTP id 6AB37689C6
	for <linux-crypto@vger.kernel.org>; Sun, 18 Nov 2012 11:10:43 +0900 (JST)
Received: from mail.lundman.net ([127.0.0.1])
	by localhost (mail.lundman.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id j+6culKAGfIv for <linux-crypto@vger.kernel.org>;
	Sun, 18 Nov 2012 11:10:42 +0900 (JST)
Received: from [192.168.0.10] (st0547.nas951.k-tokyo.nttpc.ne.jp [119.245.192.67])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.lundman.net (Postfix) with ESMTPSA id BA11B689B8
	for <linux-crypto@vger.kernel.org>; Sun, 18 Nov 2012 11:10:42 +0900 (JST)
In-Reply-To: <50A82BD1.4000505@lundman.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Specifically, the crash I get is finally in here:


static void Xscatterwalk_pagedone(struct scatter_walk *walk, int out,
                                  unsigned int more)
{
     if (out) {
         struct page *page;

         page = sg_page(walk->sg) + ((walk->offset - 1) >> PAGE_SHIFT);

         printk("**** PageSlab: page %p offset 0x%04lx\n",
                page, walk->offset);

         if (!PageSlab(page)) {    // <===== here

kernel: [   62.650590] **** PageSlab: page ffffeb04000b7e40 offset 0x1000


Commenting out the call to PageSlab and flush_dcache_page(page); 
surprisingly makes it work a little better. But presumably it comes with 
a cost that I can not yet see.
