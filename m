From: David Miller <davem@davemloft.net>
Subject: [PATCH 0/5] sparc64: AES driver improvements
Date: Thu, 30 Aug 2012 11:45:55 -0400 (EDT)
Message-ID: <20120830.114555.1966388095294836244.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: sparclinux@vger.kernel.org
Return-path: <sparclinux-owner@vger.kernel.org>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


This patch series adds CTR mode support to the sparc64 AES driver
and then unrolls the loops that we can to get better performance.

Signed-off-by: David S. Miller <davem@davemloft.net>
