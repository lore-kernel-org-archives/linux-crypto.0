From: Dan Streetman <ddstreet@ieee.org>
Subject: algif for compression?
Date: Fri, 14 Mar 2014 14:05:01 -0400
Message-ID: <CALZtONBFtCqQEfOgjNs_MqLm0xXP+9QK47a1t_HE4DuUBkxpsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:64065 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622AbaCNSFW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Mar 2014 14:05:22 -0400
Received: by mail-we0-f174.google.com with SMTP id t60so2422026wes.19
        for <linux-crypto@vger.kernel.org>; Fri, 14 Mar 2014 11:05:21 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I see the algif_hash and algif_blkcipher implementations to allow
userspace AF_ALG socket access to kernel blkcipher and hash
algorithms, but has anyone done a algif_compression to allow userspace
access to compression algs?  I'm asking specifically wrt the 842
crypto module, which uses the hardware compression coprocessors on
newer powerpc systems.

If not, is there any reason against adding a algif_compression to
provide the access?

Thanks!
