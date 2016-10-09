From: Sami Farin <s@mifar.in>
Subject: chacha counters in random.c
Date: Sun, 9 Oct 2016 20:16:27 +0300
Message-ID: <20161009171627.cr7eunq4h2rnj5s4@m.mifar.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mifar.in ([46.101.129.31]:60614 "EHLO mifar.in"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751882AbcJIRYG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Oct 2016 13:24:06 -0400
Received: from mifar.in (host-109-204-153-196.tp-fne.tampereenpuhelin.net [109.204.153.196])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mifar.in", Issuer "mifar.in" (verified OK))
        by mifar.in (Postfix) with ESMTPS id B9B205FF00
        for <linux-crypto@vger.kernel.org>; Sun,  9 Oct 2016 20:16:28 +0300 (EEST)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

commit e192be9d9a30555aae2ca1dc3aad37cba484cd4a

+       chacha20_block(&crng->state[0], out);
+       if (crng->state[12] == 0)
+               crng->state[13]++;

Did you mean 
+       if (++crng->state[12] == 0)

?

-- 
Do what you love because life is too short for anything else.
https://samifar.in/
