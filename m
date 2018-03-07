From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [RESEND PATCH v3] crypto: add zBeWalgo compression for zram
Date: Wed, 7 Mar 2018 11:12:52 +0900
Message-ID: <20180307021252.GA802@jagdpanzerIV>
References: <8CFBD60E-6A2B-4766-B6F9-09A98DEA26CB@informatik.uni-hamburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, minchan@kernel.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com
To: Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8CFBD60E-6A2B-4766-B6F9-09A98DEA26CB@informatik.uni-hamburg.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello,

On (03/06/18 20:59), Benjamin Warnke wrote:
>    Currently ZRAM uses compression-algorithms from the crypto-api. ZRAM
>    compresses each page individually. As a result the compression algorithm
>    is
>    forced to use a very small sliding window. None of the available
>    compression
>    algorithms is designed to achieve high compression ratios with small
>    inputs.

I think you first need to merge zBeWalgo (looks like a long way to go)
And then add ZRAM support, as a separate patch.

>    - 'ecoham' (100 MiB) This dataset is one of the input files for the
>    scientific
>    application ECOHAM which runs an ocean simulation. This dataset contains a
>    lot of zeros. Where the data is not zero there are arrays of floating
>    point
>    values, adjacent float values are likely to be similar to each other,
>    allowing for high compression ratios.
> 
>    algorithm | ratio   | compression    | decompression
>    zbewalgo  |   12.94 |  294.10 MBit/s | 1242.59 MBit/s
>    deflate   |   12.54 |   75.51 MBit/s |  736.39 MBit/s
>    842       |   12.26 |  182.59 MBit/s |  683.61 MBit/s
>    lz4hc     |   12.00 |   51.23 MBit/s | 1524.73 MBit/s
>    lz4       |   10.68 | 1334.37 MBit/s | 1603.54 MBit/s
>    lzo       |    9.79 | 1333.76 MBit/s | 1534.63 MBit/s
> 
>    - 'source-code' (800 MiB) This dataset is a tarball of the source-code
>    from a
>    linux-kernel.
> 
>    algorithm | ratio   | compression    | decompression
>    deflate   |    3.27 |   42.48 MBit/s |  250.36 MBit/s
>    lz4hc     |    2.40 |  104.14 MBit/s | 1150.53 MBit/s
>    lzo       |    2.27 |  444.77 MBit/s |  886.97 MBit/s
>    lz4       |    2.18 |  453.08 MBit/s | 1101.45 MBit/s
>    842       |    1.65 |   64.10 MBit/s |  158.40 MBit/s
>    zbewalgo  |    1.19 |   52.89 MBit/s |  197.58 MBit/s
> 
>    - 'hpcg' (8 GiB) This dataset is a (partial) memory-snapshot of the
>    running hpcg-benchmark. At the time of the snapshot, that application
>    performed a sparse matrix - vector multiplication.
> 
>    algorithm | ratio   | compression    | decompression
>    zbewalgo  |   16.16 |  179.97 MBit/s |  468.36 MBit/s
>    deflate   |    9.52 |   65.11 MBit/s |  632.69 MBit/s
>    lz4hc     |    4.96 |  193.33 MBit/s | 1607.12 MBit/s
>    842       |    4.20 |  150.99 MBit/s |  316.22 MBit/s
>    lzo       |    4.14 |  922.74 MBit/s |  865.32 MBit/s
>    lz4       |    3.79 |  908.39 MBit/s | 1375.33 MBit/s
> 
>    - 'partdiff' (8 GiB) Array of double values. Adjacent doubles are similar,
>    but
>    not equal. This array is produced by a partial differential equation
>    solver
>    using a Jakobi-implementation.
> 
>    algorithm | ratio   | compression    | decompression
>    zbewalgo  |    1.30 |  203.30 MBit/s |  530.87 MBit/s
>    deflate   |    1.02 |   37.06 MBit/s | 1131.88 MBit/s
>    lzo       |    1.00 | 1741.46 MBit/s | 2012.78 MBit/s
>    lz4       |    1.00 | 1458.08 MBit/s | 2013.88 MBit/s
>    lz4hc     |    1.00 |  173.19 MBit/s | 2012.37 MBit/s
>    842       |    1.00 |   64.10 MBit/s | 2013.64 MBit/s

Hm, mixed feelings.

	-ss
