From: Michel Machado <michel@digirati.com.br>
Subject: RSA
Date: Thu, 11 Aug 2011 14:30:53 -0400
Message-ID: <1313087453.2239.28.camel@Thor>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mta63.f1.k8.com.br ([187.16.23.95]:34148 "EHLO
	mta63.f1.k8.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab1HKSrq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Aug 2011 14:47:46 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtpl.f1.k8.com.br (Postfix) with ESMTP id 57418200A422
	for <linux-crypto@vger.kernel.org>; Thu, 11 Aug 2011 18:30:56 +0000 (GMT)
Received: from smtpl.f1.k8.com.br ([127.0.0.1])
	by localhost (mta63.f1.k8.com.br [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id b1dlJvtyLRSP for <linux-crypto@vger.kernel.org>;
	Thu, 11 Aug 2011 18:30:56 +0000 (GMT)
Received: from [192.168.10.104] (c-76-127-142-250.hsd1.ma.comcast.net [76.127.142.250])
	by smtpl.f1.k8.com.br (Postfix) with ESMTPA id A7420200A0EE
	for <linux-crypto@vger.kernel.org>; Thu, 11 Aug 2011 18:30:55 +0000 (GMT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi there,

   I'm implementing a new network stack in Linux's kernel [1], and I
need a RSA implementation to keep the guarantees of the design [2].

   Searching the archive of Linux's mailing lists, I've found that
adding RSA to the kernel has been already tried, but it was left out
because the uses were not convincing then.

   I intend to submit my work [3, 4] when I get a reasonable working
version. Until there, could anyone point me to a working patch to add
RSA to the kernel? The old patch [5] doesn't integrate with the current
Crypto API.

   Is there hope to have RSA added to Linux? If not for a ready use,
it'd help to experiment with things that are still in the making.

[1] http://www.cs.cmu.edu/~xia/
[2] http://reports-archive.adm.cs.cmu.edu/anon/2011/CMU-CS-11-100.pdf
[3] git://github.com/AltraMayor/XIA-for-Linux.git
[4] git://github.com/AltraMayor/xiaconf.git
[5] http://lwn.net/Articles/228892/

-- 
[ ]'s
Michel Machado
