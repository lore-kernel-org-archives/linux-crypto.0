From: Muran Hrun <muuhuu@gmail.com>
Subject: DMA support for mv_cesa
Date: Mon, 28 Jul 2014 15:24:43 +0200
Message-ID: <CADP6xpuU1V0byRQDp7+=VB6Ao3uL-YxjwYd6YK+KWc51fJVDsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vc0-f196.google.com ([209.85.220.196]:48521 "EHLO
	mail-vc0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaG1NYo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Jul 2014 09:24:44 -0400
Received: by mail-vc0-f196.google.com with SMTP id le20so885910vcb.7
        for <linux-crypto@vger.kernel.org>; Mon, 28 Jul 2014 06:24:43 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

What is the status of DMA support for mv_cesa? I tried applying the patches at
git://nwl.cc/~n0-1/linux.git (cesa-dma branch)
on kernel 3.15.6 but the kernel just crashed on my DNS-320, when
accessing an encrypted volume. (Kernel 3.5rc2 in the respository did
not boot at all)

Is DMA support for mv_cesa still developed?

Thanks
