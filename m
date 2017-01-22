From: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Subject: [PATCH v4 0/4] Update LZ4 compressor module
Date: Sun, 22 Jan 2017 20:35:13 +0100
Message-ID: <1485113717-29261-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
References: <1482259992-16680-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
Cc: bongkyu.kim@lge.com, rsalvaterra@gmail.com,
        sergey.senozhatsky@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        anton@enomsg.org, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com, phillip@squashfs.org.uk
To: akpm@linux-foundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:40048 "EHLO
        mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751047AbdAVTgZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Jan 2017 14:36:25 -0500
In-Reply-To: <1482259992-16680-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


This patchset is for updating the LZ4 compression module to a version based
on LZ4 v1.7.3 allowing to use the fast compression algorithm aka LZ4 fast
which provides an "acceleration" parameter as a tradeoff between
high compression ratio and high compression speed.

We want to use LZ4 fast in order to support compression in lustre
and (mostly, based on that) investigate data reduction techniques in behalf of
storage systems.

Also, it will be useful for other users of LZ4 compression, as with LZ4 fast
it is possible to enable applications to use fast and/or high compression
depending on the usecase.
For instance, ZRAM is offering a LZ4 backend and could benefit from an updated
LZ4 in the kernel.

LZ4 homepage: http://www.lz4.org/
LZ4 source repository: https://github.com/lz4/lz4
Source version: 1.7.3

Benchmark (taken from [1], Core i5-4300U @1.9GHz):
----------------|--------------|----------------|----------
Compressor      | Compression  | Decompression  | Ratio
----------------|--------------|----------------|----------
memcpy          |  4200 MB/s   |  4200 MB/s     | 1.000
LZ4 fast 50     |  1080 MB/s   |  2650 MB/s     | 1.375
LZ4 fast 17     |   680 MB/s   |  2220 MB/s     | 1.607
LZ4 fast 5      |   475 MB/s   |  1920 MB/s     | 1.886
LZ4 default     |   385 MB/s   |  1850 MB/s     | 2.101

[1] http://fastcompression.blogspot.de/2015/04/sampling-or-faster-lz4.html
fs/pstore: fs/squashfs: Change usage of LZ4 to work with new LZ4 version

[PATCH 1/4] lib: Update LZ4 compressor module
[PATCH 2/4] lib/decompress_unlz4: Change module to work with new LZ4 module version
[PATCH 3/4] crypto: Change LZ4 modules to work with new LZ4 module version
[PATCH 4/4] fs/pstore: fs/squashfs: Change usage of LZ4 to work with new LZ4 version

v2:
- Changed order of the patches since in the initial patchset the lz4.h was in the
  last patch but was referenced by the other ones
- Split lib/decompress_unlz4.c in an own patch
- Fixed errors reported by the buildbot
- Further refactorings
- Added more appropriate copyright note to include/linux/lz4.h

v3:
- Adjusted the code to satisfy kernel coding style (checkpatch.pl)
- Made sure the changes to LZ4 in Kernel (overflow checks etc.)
  are included in the new module (they are)
- Removed the second LZ4_compressBound function with related name but
  different return type
- Corrected version number (was LZ4 1.7.3)
- Added missing LZ4 streaming functions

v4:
- Fixed kbuild errors
- Re-added lz4_compressbound as alias for LZ4_compressBound
  to ensure backwards compatibility
- Wrapped LZ4_hash5 with check for LZ4_ARCH64 since it is only used there
  and triggers an unused function warning when false
