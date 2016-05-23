From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v6 0/3] Key-agreement Protocol Primitives (KPP) API
Date: Mon, 23 May 2016 20:44:27 +0200
Message-ID: <8688641.Yei9vfB8rY@positron.chronox.de>
References: <1462951563-50042-1-git-send-email-salvatore.benedetto@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:39816 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436AbcEWSoa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 May 2016 14:44:30 -0400
In-Reply-To: <1462951563-50042-1-git-send-email-salvatore.benedetto@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 11. Mai 2016, 08:26:00 schrieb Salvatore Benedetto:

Hi Salvatore,

> Hi Herb,
> 
> the following patchset introduces a new API for abstracting key-agreement
> protocols such as DH and ECDH. It provides the primitives required for
> implementing the protocol, thus the name KPP (Key-agreement Protocol
> Primitives).

I just saw that in Linus' tree, a DH implementation popped up at 
security/keys/dh.c

Note, the implementation is also from an Intel developer.

Would it make sense that both implementations are synced so that we only have 
one and that we need to worry about side channels only once?

Ciao
Stephan
