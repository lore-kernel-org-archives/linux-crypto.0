From: Anatoly Pugachev <matorola@gmail.com>
Subject: [PATCH 0/2] n2rng: Attach on T5/M5, T7/M7 SPARC CPUs
Date: Thu, 14 Jan 2016 00:43:18 +0300
Message-ID: <20160113214318.GB32766@yogzotot>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sparclinux@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch adds support for recent oracle hardware (T5/M5, T7/M7 SPARC CPUs),
so n2_rng driver would work on them.

1. n2rng: Attach on T5/M5, T7/M7 SPARC CPUs
2. n2rng: documentation, add DT bindings, vendor prefixes

PS: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=809815#32

Signed-off-by: Anatoly Pugachev <matorola@gmail.com>

---

 .../bindings/rng/sparc_sun_oracle_rng.txt          | 31 ++++++++++++++++++++++
 .../devicetree/bindings/vendor-prefixes.txt        |  2 ++
 {a => b}/drivers/char/hw_random/n2-drv.c           | 10 +++++++
 3 files changed, 43 insertions(+)
