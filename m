From: Stephan Mueller <smueller@chronox.de>
Subject: Re: Subject: [PATCH] crypto: add zbewalgo compression algorithm for zram
Date: Tue, 30 Jan 2018 18:59:17 +0100
Message-ID: <2893047.8sTGZPTY3e@tauon.chronox.de>
References: <450300D8-6A7C-4D63-971A-AB6279C3B3DD@informatik.uni-hamburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59052 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751584AbeA3R7T (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jan 2018 12:59:19 -0500
In-Reply-To: <450300D8-6A7C-4D63-971A-AB6279C3B3DD@informatik.uni-hamburg.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 30. Januar 2018, 16:08:57 CET schrieb Benjamin Warnke:

Hi Benjamin,

Please run checkpatch.pl on the patch and fix the formatting issues.

In general: I do not think that having larger C functions in header files is a 
proper coding style. Also, having static variables header files is also not 
nice.

Do not redefine code that already exists. For example, MIN/MAX exists: min_t 
and max_t.

Why are there __attribute__ ((unused)) function parameters, such as in 
compress_bitshuffle and others?

Ciao
Stephan
