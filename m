From: Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH V2 00/21] staging: add skein/threefish crypto algos
Date: Mon, 24 Mar 2014 01:48:57 +0000
Message-ID: <cover.1395625123.git.jason@lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
Cc: devel@driverdev.osuosl.org, linux-crypto@vger.kernel.org,
	Jason Cooper <jason@lakedaemon.net>
To: Greg KH <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:32864 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750993AbaCXBtg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 23 Mar 2014 21:49:36 -0400
In-Reply-To: <cover.1394570067.git.jason@lakedaemon.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Greg, all,

Changes from RFC:

 - dropped scripts/objdiff patch to be submitted separately

 - rebased onto staging-next and resolved conflicts

-- updated original text to reflect the above --

Attached is a series I've sat on for the past month and a half.

I'm hoping that by posting it in it's incomplete state, it will either a)
motivate me to finish hooking into the crypto API, or b) motivate someone else
to pitch in. ;-)

>From patch 2, all commits build successfully.  In addition, using the script
I've submitted separately (objdiff), I can confirm that no object code was
harmed in this process.

I'm under no time crunch with this, and I add to it as I find time.  If Greg
wants to take it for v3.15, great.  Otherwise is fine as well.

Barring a few false-positives, this series makes the code checkpatch-clean, but
it is not ready for mainline as yet.  In particular, I really don't like the
adhoc macro definitions, nor the camelCase.

The plan is to get skein and threefish registered into the crypto API, build as
modules, and then move it to crypto/.

thx,

Jason.


Jason Cooper (21):
  staging: crypto: skein: import code from Skein3Fish.git
  staging: crypto: skein: allow building statically
  staging: crypto: skein: remove brg_*.h includes
  staging: crypto: skein: remove skein_port.h
  staging: crypto: skein: remove __cplusplus and an unneeded stddef.h
  staging: crypto: skein: remove unneeded typedefs
  staging: crypto: skein: remove all typedef {struct,enum}
  staging: crypto: skein: use u8, u64 vice uint*_t
  staging: crypto: skein: fixup pointer whitespace
  staging: crypto: skein: cleanup whitespace around operators/punc.
  staging: crypto: skein: dos2unix, remove executable perms
  staging: crypto: skein: fix leading whitespace
  staging: crypto: skein: remove trailing whitespace
  staging: crypto: skein: cleanup >80 character lines
  staging: crypto: skein: fix do/while brace formatting
  staging: crypto: skein: fix brace placement errors
  staging: crypto: skein: wrap multi-line macros in do-while loops
  staging: crypto: skein: remove externs from .c files
  staging: crypto: skein: remove braces from single-statement block
  staging: crypto: skein: remove unnecessary line continuation
  staging: crypto: skein: add TODO file

 drivers/staging/Kconfig                      |    2 +
 drivers/staging/Makefile                     |    1 +
 drivers/staging/skein/Kconfig                |   32 +
 drivers/staging/skein/Makefile               |   13 +
 drivers/staging/skein/TODO                   |   11 +
 drivers/staging/skein/include/skein.h        |  344 ++
 drivers/staging/skein/include/skeinApi.h     |  230 ++
 drivers/staging/skein/include/skein_block.h  |   22 +
 drivers/staging/skein/include/skein_iv.h     |  186 +
 drivers/staging/skein/include/threefishApi.h |  164 +
 drivers/staging/skein/skein.c                |  880 +++++
 drivers/staging/skein/skeinApi.c             |  237 ++
 drivers/staging/skein/skeinBlockNo3F.c       |  175 +
 drivers/staging/skein/skein_block.c          |  770 ++++
 drivers/staging/skein/threefish1024Block.c   | 4900 ++++++++++++++++++++++++++
 drivers/staging/skein/threefish256Block.c    | 1137 ++++++
 drivers/staging/skein/threefish512Block.c    | 2223 ++++++++++++
 drivers/staging/skein/threefishApi.c         |   79 +
 18 files changed, 11406 insertions(+)
 create mode 100644 drivers/staging/skein/Kconfig
 create mode 100644 drivers/staging/skein/Makefile
 create mode 100644 drivers/staging/skein/TODO
 create mode 100644 drivers/staging/skein/include/skein.h
 create mode 100644 drivers/staging/skein/include/skeinApi.h
 create mode 100644 drivers/staging/skein/include/skein_block.h
 create mode 100644 drivers/staging/skein/include/skein_iv.h
 create mode 100644 drivers/staging/skein/include/threefishApi.h
 create mode 100644 drivers/staging/skein/skein.c
 create mode 100644 drivers/staging/skein/skeinApi.c
 create mode 100644 drivers/staging/skein/skeinBlockNo3F.c
 create mode 100644 drivers/staging/skein/skein_block.c
 create mode 100644 drivers/staging/skein/threefish1024Block.c
 create mode 100644 drivers/staging/skein/threefish256Block.c
 create mode 100644 drivers/staging/skein/threefish512Block.c
 create mode 100644 drivers/staging/skein/threefishApi.c

-- 
1.9.1
