From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: Subject: [PATCH] crypto: add zbewalgo compression algorithm for
 zram
Date: Tue, 30 Jan 2018 12:24:39 -0800
Message-ID: <20180130202439.gjnly72x3ebbtxf4@gmail.com>
References: <450300D8-6A7C-4D63-971A-AB6279C3B3DD@informatik.uni-hamburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:43067 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751755AbeA3UYm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jan 2018 15:24:42 -0500
Received: by mail-io0-f174.google.com with SMTP id 72so12836320iom.10
        for <linux-crypto@vger.kernel.org>; Tue, 30 Jan 2018 12:24:42 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <450300D8-6A7C-4D63-971A-AB6279C3B3DD@informatik.uni-hamburg.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Benjamin,

On Tue, Jan 30, 2018 at 04:08:57PM +0100, Benjamin Warnke wrote:
> Currently ZRAM uses the compression-algorithms from the crypto-api.
> None of the current compression-algorithms in the crypto-api is designed
> to compress 4KiB chunks of data efficiently.
> This patch adds a new compression-algorithm especially designed for ZRAM,
> to compress small pieces of data more efficiently.
> 

This is some interesting work, and I like the idea of doing transforms
specialized for in-memory data.  However, where can I find more information
about this new compression algorithm?  What does "zbewalgo" even stand for /
mean?  Googling it turns up nothing.

You are going to have to be much more specific what you mean by "efficiently".
Efficiency usually implies speed, yet even by your own numbers LZ4 is much
faster than "zbewalgo", both for compression and decompression.

If the goal is to provide an algorithm more tuned for compression ratio than
speed in comparison to LZ4, then the omission of Zstandard from your benchmarks
is strange, especially given that Zstandard is available in the kernel now.

The proposed "zbewalgo" decompressor also doesn't handle invalid inputs, which
means it cannot be used on untrusted data.  This isn't acceptable without
justification (since people may use it on untrusted data, creating security
vulnerabilities), and it also makes it not really a fair comparison with LZ4
since the LZ4 decompressor does handle invalid inputs, at least in the mode
exposed through the crypto API.

Eric
