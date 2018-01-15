From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [RFC] AF_ALG AIO and IV
Date: Mon, 15 Jan 2018 10:39:09 +0100
Message-ID: <20492971.8083OyLHVd@tauon.chronox.de>
References: <2118226.LQArbCsRu5@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, harsh@chelsio.com,
        jonathan.cameron@huawei.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58282 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751768AbeAOJjS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jan 2018 04:39:18 -0500
In-Reply-To: <2118226.LQArbCsRu5@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 12. Januar 2018, 14:21:15 CET schrieb Stephan Mueller:

Hi,
> 
> 1. Require that the cipher implementations serialize any AIO requests that
> have dependencies. I.e. for CBC, requests need to be serialized by the
> driver. For, say, ECB or XTS no serialization is necessary.
> 
> 2. Change AF_ALG to require a per-request IV. This could be implemented by
> moving the IV submission via CMSG from sendmsg to recvmsg. I.e. the recvmsg
> code path would obtain the IV.

With the released patch, I found a third way that seems to be much less 
intrusive: adding inline IV handling where the IV is sent as part of the data 
to be processed.

In the libkcapi source code tree, I added a branch [1] that contains support 
for the inline IV handling. It also has received numerous tests [2] verifying 
that the inline IV kernel patch works.

[1] https://github.com/smuellerDD/libkcapi/tree/iiv
[2] https://github.com/smuellerDD/libkcapi/commit/
f56991ff2f975caf1aa6cb75f2b6fc104cc72f9c

Ciao
Stephan
