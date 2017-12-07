From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [crypto 6/8] chtls: TCB and Key program
Date: Thu, 07 Dec 2017 16:27:39 +0100
Message-ID: <2747471.DjaIqLtZ2I@tauon.chronox.de>
References: <1512474029-6775-1-git-send-email-atul.gupta@chelsio.com> <2305475.IxNZ3AiDlf@tauon.chronox.de> <MWHPR1201MB0238C75889F4E986F338B05297330@MWHPR1201MB0238.namprd12.prod.outlook.com>
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
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <MWHPR1201MB0238C75889F4E986F338B05297330@MWHPR1201MB0238.namprd12.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Donnerstag, 7. Dezember 2017, 16:08:04 CET schrieb Atul Gupta:

Hi Atul,

> > As far as I see, the key is part of the skb (via kctx). This skb is
> > released after being processed. The release calls kfree_skb which does
> > not zeroize the key. Wouldn't it make sense to clear the memory of the
> > key when the skb is released? [Atul] we should perhaps memset the info
> > received from user so that driver has no info on key once its written on
> > chip memory. memset(gcm_ctx->key, 0, keylen);
> 
> Are you saying that the skb (via kctx) above does not obtain a copy of the
> key? If not, what is done in chtls_key_info? It does have a key copy, I was
> not sure how key info is accessed once skb is released.

All I am saying is that this key copy should be zapped when the memory is 
released. Thus, if the skb has a copy of the key, at least at the time of 
free() of the skb, a memset() of the key memory should be done (or before).
> 
> 
> Ciao
> Stephan
> 
> Thanks
> Atul



Ciao
Stephan
