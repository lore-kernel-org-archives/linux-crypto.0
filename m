From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH v2 0/2] CESA: Fixes for STD ahash requests
Date: Mon,  5 Dec 2016 09:56:37 +0100
Message-ID: <20161205085639.21034-1-romain.perier@free-electrons.com>
Cc: linux-crypto@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        stable@vger.kernel.org, Nadav Haklai <nadavh@marvell.com>,
        Ofer Heifetz <oferh@marvell.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:43501 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751241AbcLEJMr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Dec 2016 04:12:47 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


This set of patches fixes two issues for STD ahash requests. The first
one is that the operation template is copied twice to the SRAM from the
step function, it is not needed. The second one is also contained in the
step function which copies creq->state to the engine for all type of
requests, even if this one is a fragment of the initial req and is
re-launched. This might corrupt the context of the request in some cases.

Romain Perier (2):
  crypto: marvell - Don't copy hash operation twice into the SRAM
  crypto: marvell - Don't corrupt state of an STD req for re-stepped
    ahash

 drivers/crypto/marvell/hash.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

-- 

v1: https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg22113.html

Changes in v2:
 - Rephrased commit message for PATCH 2/2
 - Added Cc: stable for both commits
 - Fixed coding style issue in PATCH 2/2
 - Rephased the cover letter

2.9.3
