From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v5] DH support: add KDF handling support
Date: Mon, 03 Apr 2017 23:28:10 +0100
Message-ID: <6703.1491258490@warthog.procyon.org.uk>
References: <7815450.KhQaSIWsFB@positron.chronox.de> <1571629.ErTDR5PMQO@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, mathew.j.martineau@linux.intel.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        keyrings@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54680 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751282AbdDCW2N (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Apr 2017 18:28:13 -0400
In-Reply-To: <7815450.KhQaSIWsFB@positron.chronox.de>
Content-ID: <6702.1491258490.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Stephan Mueller <smueller@chronox.de> wrote:

> this patch changes the documentation, the naming of the variables
> and the test case to refer to the variable name of a hashname
> instead of kdfname to match the current kernel implementation.

It's also needs an update to man1/keyctl.1.

David
