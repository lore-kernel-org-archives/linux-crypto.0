From: George Joseph <george.joseph@fairview5.com>
Subject: FSL CAAM for imx6
Date: Tue, 17 Mar 2015 19:00:22 -0600
Message-ID: <CAHKv19DoNiVPTO-C5ukenGakeq+0u_jeZWfr9gHooyeBhte1ug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Cristian Stoica <cristian.stoica@freescale.com>,
	Catalin Vasile <catalin.vasile@freescale.com>,
	Alex Porosanu <alexandru.porosanu@freescale.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:33604 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbbCRBAX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Mar 2015 21:00:23 -0400
Received: by qgfa8 with SMTP id a8so24914512qgf.0
        for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2015 18:00:23 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Freescale has a 3.10 implementation of CAAM for imx6 that was never
mainlined or ported forward.  I've ported it into 3.18
drivers/crypto/caam and although it still needs a lot of cleanup, it
works well with openssl via cryptodev or af_alg.  Freescale pushed a
lot of changes to 3.19 caam though and merging the imx6 stuff was a
lot more work and not entirely reliable.

So..questions...
Anyone know why the imx6 version wasn't mainlined?
Is anyone working on it?
If I work on it, is it better to continue to merge the imx6 into the
original mips (i think) version or create a separate caam-imx?  The
former would make it easier to make common changes, the latter would
make it easier to test since you wouldn't need to have both platforms
available to test.  I'm also not sure exactly how compatible the imx6
and mips soc implementations really are so that might be another
reason to separate them.

Thoughts?
