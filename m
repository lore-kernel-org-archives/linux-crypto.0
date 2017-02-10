From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v7 0/5] Update LZ4 compressor module
Date: Fri, 10 Feb 2017 09:13:11 +0900
Message-ID: <20170210001311.GA25078@bbox>
References: <1482259992-16680-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <1486321748-19085-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <20170208233121.GA16728@bbox>
 <20170209105617.GA3575@bierbaron.springfield.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: <akpm@linux-foundation.org>, <bongkyu.kim@lge.com>,
        <rsalvaterra@gmail.com>, <sergey.senozhatsky@gmail.com>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <anton@enomsg.org>,
        <ccross@android.com>, <keescook@chromium.org>,
        <tony.luck@intel.com>
To: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from LGEAMRELO13.lge.com ([156.147.23.53]:37446 "EHLO
        lgeamrelo13.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751071AbdBJA6P (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Feb 2017 19:58:15 -0500
In-Reply-To: <20170209105617.GA3575@bierbaron.springfield.local>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Sven,

On Thu, Feb 09, 2017 at 11:56:17AM +0100, Sven Schmidt wrote:
> Hey Minchan,
> 
> On Thu, Feb 09, 2017 at 08:31:21AM +0900, Minchan Kim wrote:
> > Hello Sven,
> > 
> > On Sun, Feb 05, 2017 at 08:09:03PM +0100, Sven Schmidt wrote:
> > > 
> > > This patchset is for updating the LZ4 compression module to a version based
> > > on LZ4 v1.7.3 allowing to use the fast compression algorithm aka LZ4 fast
> > > which provides an "acceleration" parameter as a tradeoff between
> > > high compression ratio and high compression speed.
> > > 
> > > We want to use LZ4 fast in order to support compression in lustre
> > > and (mostly, based on that) investigate data reduction techniques in behalf of
> > > storage systems.
> > > 
> > > Also, it will be useful for other users of LZ4 compression, as with LZ4 fast
> > > it is possible to enable applications to use fast and/or high compression
> > > depending on the usecase.
> > > For instance, ZRAM is offering a LZ4 backend and could benefit from an updated
> > > LZ4 in the kernel.
> > > 
> > > LZ4 homepage: http://www.lz4.org/
> > > LZ4 source repository: https://github.com/lz4/lz4
> > > Source version: 1.7.3
> > > 
> > > Benchmark (taken from [1], Core i5-4300U @1.9GHz):
> > > ----------------|--------------|----------------|----------
> > > Compressor      | Compression  | Decompression  | Ratio
> > > ----------------|--------------|----------------|----------
> > > memcpy          |  4200 MB/s   |  4200 MB/s     | 1.000
> > > LZ4 fast 50     |  1080 MB/s   |  2650 MB/s     | 1.375
> > > LZ4 fast 17     |   680 MB/s   |  2220 MB/s     | 1.607
> > > LZ4 fast 5      |   475 MB/s   |  1920 MB/s     | 1.886
> > > LZ4 default     |   385 MB/s   |  1850 MB/s     | 2.101
> > > 
> > > [1] http://fastcompression.blogspot.de/2015/04/sampling-or-faster-lz4.html
> > > 
> > > [PATCH 1/5] lib: Update LZ4 compressor module
> > > [PATCH 2/5] lib/decompress_unlz4: Change module to work with new LZ4 module version
> > > [PATCH 3/5] crypto: Change LZ4 modules to work with new LZ4 module version
> > > [PATCH 4/5] fs/pstore: fs/squashfs: Change usage of LZ4 to work with new LZ4 version
> > > [PATCH 5/5] lib/lz4: Remove back-compat wrappers
> > 
> > Today, I did zram-lz4 performance test with fio in current mmotm and
> > found it makes regression about 20%.
> > 
> > "lz4-update" means current mmots(git://git.cmpxchg.org/linux-mmots.git) so
> > applied your 5 patches. (But now sure current mmots has recent uptodate
> > patches)
> > "revert" means I reverted your 5 patches in current mmots.
> > 
> >                      revert    lz4-update
> > 
> >       seq-write       1547       1339      86.55%
> >      rand-write      22775      19381      85.10%
> >        seq-read       7035       5589      79.45%
> >       rand-read      78556      68479      87.17%
> >    mixed-seq(R)       1305       1066      81.69%
> >    mixed-seq(W)       1205        984      81.66%
> >   mixed-rand(R)      17421      14993      86.06%
> >   mixed-rand(W)      17391      14968      86.07%
> 
> which parts of the output (as well as units) are these values exactly?
> I did not work with fio until now, so I think I might ask before misinterpreting my results.

It is IOPS.

>  
> > My fio description file
> > 
> > [global]
> > bs=4k
> > ioengine=sync
> > size=100m
> > numjobs=1
> > group_reporting
> > buffer_compress_percentage=30
> > scramble_buffers=0
> > filename=/dev/zram0
> > loops=10
> > fsync_on_close=1
> > 
> > [seq-write]
> > bs=64k
> > rw=write
> > stonewall
> > 
> > [rand-write]
> > rw=randwrite
> > stonewall
> > 
> > [seq-read]
> > bs=64k
> > rw=read
> > stonewall
> > 
> > [rand-read]
> > rw=randread
> > stonewall
> > 
> > [mixed-seq]
> > bs=64k
> > rw=rw
> > stonewall
> > 
> > [mixed-rand]
> > rw=randrw
> > stonewall
> > 
> 
> Great, this makes it easy for me to reproduce your test.

If you have trouble to reproduce, feel free to ask me. I'm happy to test it. :)

Thanks!
