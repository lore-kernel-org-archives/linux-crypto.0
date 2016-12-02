From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH 0/2] CESA: Fixes for STD ahash requests
Date: Fri,  2 Dec 2016 17:05:49 +0100
Message-ID: <20161202160551.9940-1-romain.perier@free-electrons.com>
Cc: linux-crypto@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        stable@vger.kernel.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Arnaud Ebalard <arno@natisbad.org>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This set of patches fixes two issues for STD ahash requests.
The first one is that the operation template is copied twice to the SRAM
from the step function, it is not needed. The second one is also
contained in the step function which  copies creq->state to the engine for
all type of requests , even if this one is re-launched. This might corrupt 
the context of the request in some cases.

Romain Perier (2):
  crypto: marvell - Don't copy hash operation twice into the SRAM
  crypto: marvell - Don't corrupt state of an STD req for re-stepped
    ahash

 drivers/crypto/marvell/hash.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

-- 
2.9.3
