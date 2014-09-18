From: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>
Subject: tcrypt rfc4309 ccm test keys size issue
Date: Thu, 18 Sep 2014 15:43:02 -0300
Message-ID: <20140918184302.GA19143@bluepex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: mhcerri@linux.vnet.ibm.com
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:53992 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352AbaIRSnI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Sep 2014 14:43:08 -0400
Received: from /spool/local
	by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <leosilva@linux.vnet.ibm.com>;
	Thu, 18 Sep 2014 15:43:06 -0300
Received: from d24relay02.br.ibm.com (d24relay02.br.ibm.com [9.13.184.26])
	by d24dlp01.br.ibm.com (Postfix) with ESMTP id AB3873520059
	for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2014 14:42:56 -0400 (EDT)
Received: from d24av04.br.ibm.com (d24av04.br.ibm.com [9.8.31.97])
	by d24relay02.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id s8IIft9a30408846
	for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2014 15:41:55 -0300
Received: from d24av04.br.ibm.com (localhost [127.0.0.1])
	by d24av04.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s8IIh3qR029377
	for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2014 15:43:03 -0300
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I'm facing an issue running tcrypt with  rfc4309-aes-ccm.
My hardware and drive only implements support to key size 128, what is
specify in the documentation (http://tools.ietf.org/html/rfc4309) as a
'MUST' support, but does not support the other sizes. However tcrypt
tests
not only 128, but also 192 and 256bits size, which in ietf documentation
are 'MAY' also support.

The issue is if I run my machines with FIPS enable it won't work
at all, since tcrypt will try to the other key sizes and so fails making
my system crash in  a kernel panic.

I wondering if this tcrypt to 192 and 256 are correct since it's not
a 'MUST' support size. Either if have any option to disable tcrypt to
test with this other key sizes. And once more, since they are not a must
support, what is the history about this test?

A workround for us in the moment is to disable ccm in FIPs mode.


Best regards,
Leonidas.)
