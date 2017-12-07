From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [crypto 6/8] chtls: TCB and Key program
Date: Thu, 07 Dec 2017 15:42:52 +0100
Message-ID: <2305475.IxNZ3AiDlf@tauon.chronox.de>
References: <1512474029-6775-1-git-send-email-atul.gupta@chelsio.com> <2083625.RdNrO0bCEz@tauon.chronox.de> <MWHPR1201MB02382E04C3603A5B5F531CB897330@MWHPR1201MB0238.namprd12.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "davejwatson@fb.com" <davejwatson@fb.com>,
        Ganesh GR <ganeshgr@chelsio.com>,
        Harsh Jain <Harsh@chelsio.com>
To: Atul Gupta <atul.gupta@chelsio.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42858 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753263AbdLGOm7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Dec 2017 09:42:59 -0500
In-Reply-To: <MWHPR1201MB02382E04C3603A5B5F531CB897330@MWHPR1201MB0238.namprd12.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 7. Dezember 2017, 15:21:03 CET schrieb Atul Gupta:

Hi Atul,

> 
> memzero_explicit(key)?
> [Atul] may not be required as entire info of size keylen and AEAD_H_SIZE is
> copied onto kctx->key. Key data is received from user, while ghash is
> memset and locally generated

Sure, but wouldn't it make sense to zap all instances where key material was 
stored?

> 
> As far as I see, the key is part of the skb (via kctx). This skb is released
> after being processed. The release calls kfree_skb which does not zeroize
> the key. Wouldn't it make sense to clear the memory of the key when the skb
> is released? [Atul] we should perhaps memset the info received from user so
> that driver has no info on key once its written on chip memory.
> memset(gcm_ctx->key, 0, keylen);

Are you saying that the skb (via kctx) above does not obtain a copy of the 
key? If not, what is done in chtls_key_info?


Ciao
Stephan
