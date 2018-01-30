From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: Subject: [PATCH] crypto: add zbewalgo compression algorithm for zram
Date: Tue, 30 Jan 2018 22:26:46 +0100
Message-ID: <11497171.7hPfTiqTsK@positron.chronox.de>
References: <450300D8-6A7C-4D63-971A-AB6279C3B3DD@informatik.uni-hamburg.de> <2893047.8sTGZPTY3e@tauon.chronox.de> <C1EF6641-08EB-436C-AD2A-F2581A5BE3FE@informatik.uni-hamburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59064 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751373AbeA3V11 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jan 2018 16:27:27 -0500
In-Reply-To: <C1EF6641-08EB-436C-AD2A-F2581A5BE3FE@informatik.uni-hamburg.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 30. Januar 2018, 20:49:00 CET schrieb Benjamin Warnke:

Hi Benjamin,

> > In general: I do not think that having larger C functions in header files
> > is a proper coding style.
> 
> How should I solve this?
> 
> Option 1:
> Move everything in the lib/zbewalgo folder into a single source file.
> This way there is no function defined in a header file.
> I separated the code into different files because the different partial
> compression algorithms are independent from each other.
> 
> Option 2:
> Move each header file in its own *.c file, while keeping the
> function-declarations in the header. If the code is scattered in multiple
> source files each of the partial algorithms would show up as an independent
> module. All these modules would load simultaneously with the module
> zbewalgo_compress The module zbewalgo_compress requires an array of all
> partial algorithms. This would spam the 'lsmod' list with unneccessary
> details.

A module may be compiled from multiple C files. So, moving the code into 
separate C files and link them into one object / KO should be considered.

> 
> > Why are there __attribute__ ((unused)) function parameters, such as in
> > compress_bitshuffle and others?
> 
> The zbewalgo algorithm is a container-algorithm for compression functions
> with the ability to concatenate multiple algorithms. To be able to call any
> compression algorithm the same way, I defined 'struct zbewalgo_alg' as the
> interface for all those independent compression algorithms. Some of the
> partial algorithms do not require all parameters. To silence compiler
> warnings (if additional warning flags are enabled) I explicitly add the
> 'unused'-parameter

Linux does not enable the compiler warning about unused parameters.

Ciao
Stephan
