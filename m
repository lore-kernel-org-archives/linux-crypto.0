From: Leo Yan <leoy@marvell.com>
Subject: Questions For Linux Crypto API
Date: Wed, 14 Oct 2009 00:51:00 -0700
Message-ID: <EC64E4604C8024438259B683BB2514E1077BB35162@SC-VEXCH1.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:45164 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261AbZJNH7C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2009 03:59:02 -0400
Received: from maili.marvell.com (maili.marvell.com [10.68.76.51])
	by dakia2.marvell.com (Spam & Virus Firewall) with ESMTP id 871C150837
	for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2009 00:58:26 -0700 (PDT)
Received: from maili.marvell.com (maili.marvell.com [10.68.76.51]) by dakia2.marvell.com with ESMTP id AHHCA9bmmkIHFb4a for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2009 00:58:26 -0700 (PDT)
Received: from MSI-MTA.marvell.com (msi-mta.marvell.com [10.68.76.91])
	by maili.marvell.com (Postfix) with ESMTP id 63FDD7D0A4
	for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2009 00:58:26 -0700 (PDT)
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Hi, all

I am a newbie for Linux crypto.
Recently I am warming up on Linux Crypto APIs and have some questions.
Would you kindly give me some hints about it J ?

1. Does Linux Crypto API now support user space or not? 
I have googled the mailing list, and find some guys have committed some patches for it.
But so far, in the Linux mainline (2.6.31) do not merge it. 
So Linux Crypto API will support user space or not?

2. OCF has been ported to Linux, so will OCF integrate with Linux Crypto API or not?
If Linux Crypto API will support the user space and provide the user space APIs, then OpenBSD Cryptographics Framework
will directly use the Linux Crypto APIs or not? Otherwise 

Thanks a lot.

Best Regards,

Leo Yan
