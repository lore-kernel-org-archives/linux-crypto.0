From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH RFC 0/3] get_random_bytes seed blocking
Date: Sat,  3 Jun 2017 04:32:01 +0200
Message-ID: <20170603023204.30933-1-Jason@zx2c4.com>
References: <CAHmME9oLHP85ENr5aZgKsTSrxiUWoQ_pfv7C6XYxmcoxPfq3Ew@mail.gmail.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Theodore Ts'o <tytso@mit.edu>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-hardening@lists.openwall.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:57039 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751142AbdFCCcS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Jun 2017 22:32:18 -0400
In-Reply-To: <CAHmME9oLHP85ENr5aZgKsTSrxiUWoQ_pfv7C6XYxmcoxPfq3Ew@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Per the other thread on this mailing list, here's an initial
stab at what we discussed -- adding a blocking API for the RNG,
and adding a default-on dmesg Kconfig value for when things go
wrong.

Let me know what you think of this general implementation strategy,
and if you like it, I'll move forward with polish and with integrating
it into a fix for a few currently buggy get_random_bytes use cases.

Jason A. Donenfeld (3):
  random: add synchronous API for the urandom pool
  random: add get_random_{bytes,u32,u64,int,long}_wait family
  random: warn when kernel uses unseeded randomness

 drivers/char/random.c  | 49 +++++++++++++++++++++++++++++++++++++++++++++----
 include/linux/random.h | 31 +++++++++++++++++++++++++++++++
 lib/Kconfig.debug      | 15 +++++++++++++++
 3 files changed, 91 insertions(+), 4 deletions(-)

-- 
2.13.0
