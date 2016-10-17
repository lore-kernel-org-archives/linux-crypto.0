From: Jani Nikula <jani.nikula@linux.intel.com>
Subject: Re: [PATCH 4/7] crypto: doc - fix separation of cipher / req API
Date: Mon, 17 Oct 2016 16:20:06 +0300
Message-ID: <877f97t8mx.fsf@intel.com>
References: <2721226.4nLlHD9uQ6@positron.chronox.de> <5908263.2TLWr89bHl@positron.chronox.de> <87h98btexd.fsf@intel.com> <2825279.IxJ3MjTap5@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:32724 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754561AbcJQNUJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Oct 2016 09:20:09 -0400
In-Reply-To: <2825279.IxJ3MjTap5@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 17 Oct 2016, Stephan Mueller <smueller@chronox.de> wrote:
> Am Montag, 17. Oktober 2016, 14:04:14 CEST schrieb Jani Nikula:
>
> Hi Jani,
>
>> The directive parameter is plural functions for a reason - you can
>> specify multiple functions in the same directive. Splitting this to
>> multiple directives causes the header file to be parsed again for each
>> directive.
>> 
>> IMO this can be fixed in a follow-up patch. Same for other patches in
>> this series.
>
> Thank you very much for the hint. I followed the path what the DocBook
> to Sphinx converter generated. I will change it in my patchset, but
> may I suggest that the converter tool (tmplcvt) should be fixed, too?

I don't think it's worth the trouble.

Now it's a straightforward docproc directive to Sphinx kernel-doc
directive extension conversion, with one-to-one mapping. It would be
quite a bit more complicated to gather all of the consecutive directives
together, in a rather quickly hacked up tool which we'll throw away once
all DocBooks have been converted over.

And as I said, I think you can fix this up afterwards too. It's not
broken, it's just a bit slower.

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
