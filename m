From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v5] DH support: add KDF handling support
Date: Tue, 04 Apr 2017 01:18:49 +0200
Message-ID: <6629801.pZXVuDXS08@positron.chronox.de>
References: <7815450.KhQaSIWsFB@positron.chronox.de> <1571629.ErTDR5PMQO@positron.chronox.de> <6447.1491258148@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: mathew.j.martineau@linux.intel.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, keyrings@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58788 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751564AbdDCXTQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Apr 2017 19:19:16 -0400
In-Reply-To: <6447.1491258148@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 4. April 2017, 00:22:28 CEST schrieb David Howells:

Hi David,

> Stephan Mueller <smueller@chronox.de> wrote:
> > +	struct keyctl_dh_params params = { .private = private,
> 
> That doesn't compile.  I think you meant ".priv".

I think some code has been changed since I prepared the patch. Allow me to 
port the patch to the current code tree.

I will also update the keyctl.1 man page.


Ciao
Stephan
