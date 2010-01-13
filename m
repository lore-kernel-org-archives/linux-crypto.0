From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Crypto API
Date: Wed, 13 Jan 2010 08:28:56 +0200
Message-ID: <4B4D6828.9000506@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:40680 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab0AMG3u (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Jan 2010 01:29:50 -0500
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o0D6TKfe007924
	for <linux-crypto@vger.kernel.org>; Wed, 13 Jan 2010 08:29:47 +0200
Received: from [172.21.41.3] (kds.research.nokia.com [172.21.41.3])
	by mgw-da01.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o0D6SuBE002431
	for <linux-crypto@vger.kernel.org>; Wed, 13 Jan 2010 08:28:57 +0200
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I develop some drivers for crypto HW and met some difficulties.
Some algorithm functions are called behind crypto_kmap()

data = crypto_kmap(sg_page(sg), 0);

It will do inc_preempt_count();

I try to use DMA controller to perform memory transfers and try to use
wait_for_completion()

But of course  it gives

BUG: sleeping function called from invalid context at kernel/sched.c:5786

What is the best way to handle such case?

Thanks,
Dmitry


