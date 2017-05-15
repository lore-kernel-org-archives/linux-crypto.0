From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v11 4/5] LRNG - enable compile (fwd)
Date: Mon, 15 May 2017 18:54:38 +0800 (SGT)
Message-ID: <alpine.DEB.2.20.1705151852591.4315@hadrien>
Mime-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323329-1568682745-1494845683=:4315"
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, kbuild-all@01.org
To: =?ISO-8859-15?Q?Stephan_M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:35182
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932268AbdEOKyp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 May 2017 06:54:45 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1568682745-1494845683=:4315
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

Hello,

I received the following report from kbuild about some coccinelle detected
errors.  I wasn't sure what to look at at the URL to check them.  I
already forwarded the patch for the last case.

julia

---------- Forwarded message ----------
Date: Mon, 15 May 2017 14:09:39 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: kbuild@01.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v11 4/5] LRNG - enable compile

CC: kbuild-all@01.org
In-Reply-To: <2619717.M11260EEPi@positron.chronox.de>
TO: "Stephan Müller" <smueller@chronox.de>
CC: linux-kernel@vger.kernel.org
CC: linux-crypto@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>

Hi Stephan,

[auto build test WARNING on char-misc/char-misc-testing]
[also build test WARNING on v4.12-rc1 next-20170512]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Stephan-M-ller/dev-random-a-new-approach/20170514-223633
:::::: branch date: 16 hours ago
:::::: commit date: 16 hours ago

>> drivers/char/lrng_base.c:2243:5-25: duplicated argument to && or ||
--
>> drivers/char/lrng_base.c:1245:7-11: ERROR: iterator variable bound on line 1236 cannot be NULL
--
>> drivers/char/lrng_base.c:1509:19-24: ERROR: reference preceded by free on line 1453
--
>> drivers/char/lrng_base.c:1461:1-11: alloc with no test, possible model on line 1466
--8323329-1568682745-1494845683=:4315--
