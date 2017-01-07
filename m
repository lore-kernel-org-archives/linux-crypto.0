From: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Subject: [PATCH v2 0/4] Update LZ4 compressor module
Date: Sat,  7 Jan 2017 17:55:41 +0100
Message-ID: <1483808145-18417-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
References: <1482259992-16680-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
Cc: bongkyu.kim@lge.com, rsalvaterra@gmail.com,
        sergey.senozhatsky@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        anton@enomsg.org, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com, phillip@squashfs.org.uk
To: akpm@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1482259992-16680-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


This patchset is for updating the LZ4 compression module to a version based
on LZ4 v1.7.2 allowing to use the fast compression algorithm aka LZ4 fast
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
Source version: 1.7.2

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

[PATCHv2 1/4] lib: Update LZ4  compressor module based on LZ4 v1.7.2
[PATCHv2 2/4] lib: Update decompress_unlz4 wrapper to work with new LZ4 module
[PATCHv2 3/4] crypto: Change lz4 modules to work with new LZ4 module
[PATCHv2 4/4] fs/pstore: fs/squashfs: Change LZ4 compressor functions to work with new LZ4 module

v2:
- Changed order of the patches since in the initial patchset the lz4.h was in the
  last patch but was referenced by the other ones
- Split lib/decompress_unlz4.c in an own patch
- Fixed errors reported by the buildbot
- Further refactorings
- Added more appropriate copyright note to include/linux/lz4.h
