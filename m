From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 4/7] crypto: doc - fix separation of cipher / req API
Date: Mon, 17 Oct 2016 14:35:52 +0200
Message-ID: <2825279.IxJ3MjTap5@positron.chronox.de>
References: <2721226.4nLlHD9uQ6@positron.chronox.de> <5908263.2TLWr89bHl@positron.chronox.de> <87h98btexd.fsf@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org
To: Jani Nikula <jani.nikula@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:53572 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932911AbcJQMgB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Oct 2016 08:36:01 -0400
In-Reply-To: <87h98btexd.fsf@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 17. Oktober 2016, 14:04:14 CEST schrieb Jani Nikula:

Hi Jani,

> The directive parameter is plural functions for a reason - you can
> specify multiple functions in the same directive. Splitting this to
> multiple directives causes the header file to be parsed again for each
> directive.
> 
> IMO this can be fixed in a follow-up patch. Same for other patches in
> this series.

Thank you very much for the hint. I followed the path what the DocBook to 
Sphinx converter generated. I will change it in my patchset, but may I suggest 
that the converter tool (tmplcvt) should be fixed, too?

Ciao
Stephan
