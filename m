From: Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
Subject: Re: Subject: [PATCH] crypto: add zbewalgo compression algorithm for
 zram
Date: Tue, 30 Jan 2018 20:50:05 +0100
Message-ID: <B7F04881-2975-4C2E-8C17-E70F2E7575AF@informatik.uni-hamburg.de>
References: <450300D8-6A7C-4D63-971A-AB6279C3B3DD@informatik.uni-hamburg.de>
 <2893047.8sTGZPTY3e@tauon.chronox.de>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:60965 "EHLO
        mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751755AbeA3TuI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jan 2018 14:50:08 -0500
In-Reply-To: <2893047.8sTGZPTY3e@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

thanks for your fast response.

> Please run checkpatch.pl on the patch and fix the formatting issues.

I've run checkpatch.pl again and fixed all errors and warnings except the warnings about printk.
Compression does not have it's own subsystem, that is why I used printk(KERN_INFO ...

> In general: I do not think that having larger C functions in header files is a 
> proper coding style. 

How should I solve this?

Option 1:
Move everything in the lib/zbewalgo folder into a single source file.
This way there is no function defined in a header file.
I separated the code into different files because the different partial compression algorithms are independent from each other.

Option 2:
Move each header file in its own *.c file, while keeping the function-declarations in the header.
If the code is scattered in multiple source files each of the partial algorithms would show up as an independent module.
All these modules would load simultaneously with the module zbewalgo_compress
The module zbewalgo_compress requires an array of all partial algorithms.
This would spam the 'lsmod' list with unneccessary details.

I would prefer option 1, since it adds less overhead.

> Also, having static variables header files is also not 
> nice.

I will remove the static modifier for variables in the header files

> Do not redefine code that already exists. For example, MIN/MAX exists: min_t 
> and max_t.

Ok, I will use min_t and max_t

> Why are there __attribute__ ((unused)) function parameters, such as in 
> compress_bitshuffle and others?

The zbewalgo algorithm is a container-algorithm for compression functions with the ability to concatenate multiple algorithms.
To be able to call any compression algorithm the same way, I defined 'struct zbewalgo_alg' as the interface for all those independent compression algorithms.
Some of the partial algorithms do not require all parameters. To silence compiler warnings (if additional warning flags are enabled) I explicitly add the 'unused'-parameter

Best regards,
Benjamin
