From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v5] DH support: add KDF handling support
Date: Mon, 03 Apr 2017 23:22:28 +0100
Message-ID: <6447.1491258148@warthog.procyon.org.uk>
References: <7815450.KhQaSIWsFB@positron.chronox.de> <1571629.ErTDR5PMQO@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, mathew.j.martineau@linux.intel.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        keyrings@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51346 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751342AbdDCWWb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Apr 2017 18:22:31 -0400
In-Reply-To: <7815450.KhQaSIWsFB@positron.chronox.de>
Content-ID: <6446.1491258148.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Stephan Mueller <smueller@chronox.de> wrote:

> +	struct keyctl_dh_params params = { .private = private,

That doesn't compile.  I think you meant ".priv".

David
