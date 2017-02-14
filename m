From: Mahipal Challa <mahipalreddy2006@gmail.com>
Subject: [RFC PATCH v1 0/1] mm: zswap - crypto acomp/scomp support
Date: Tue, 14 Feb 2017 21:10:20 +0530
Message-ID: <1487086821-5880-1-git-send-email-Mahipal.Challa@cavium.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, pathreya@cavium.com, vnair@cavium.com,
        Mahipal Challa <Mahipal.Challa@cavium.com>
To: herbert@gondor.apana.org.au, sjenning@redhat.com,
        davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:34512 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751682AbdBNPky (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Feb 2017 10:40:54 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Seth, Herbert,

This series adds support for kernel's new crypto acomp/scomp compression &
decompression framework to zswap. We verified these changes using the 
kernel's crypto deflate-scomp, lzo-scomp modules and Cavium's ThunderX
ZIP driver (We will post the Cavium's ThunderX ZIP driver v2 patches with
acomp/scomp support soon).

Patch is on top of 'crypto-2.6' branch.

please provide your comments.

Regards,
Mahipal

Mahipal Challa (1):
  mm: zswap - Add crypto acomp/scomp framework support

 mm/zswap.c | 129 +++++++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 99 insertions(+), 30 deletions(-)

-- 
1.8.3.1
