From: Atul Gupta <atul.gupta@chelsio.com>
Subject: RE: [crypto 6/8] chtls: TCB and Key program
Date: Thu, 7 Dec 2017 15:08:04 +0000
Message-ID: <MWHPR1201MB0238C75889F4E986F338B05297330@MWHPR1201MB0238.namprd12.prod.outlook.com>
References: <1512474029-6775-1-git-send-email-atul.gupta@chelsio.com>
 <2083625.RdNrO0bCEz@tauon.chronox.de>
 <MWHPR1201MB02382E04C3603A5B5F531CB897330@MWHPR1201MB0238.namprd12.prod.outlook.com>
 <2305475.IxNZ3AiDlf@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "davejwatson@fb.com" <davejwatson@fb.com>,
        Ganesh GR <ganeshgr@chelsio.com>,
        "Harsh Jain" <Harsh@chelsio.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <2305475.IxNZ3AiDlf@tauon.chronox.de>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



-----Original Message-----
From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-owner@vger.ke=
rnel.org] On Behalf Of Stephan Mueller
Sent: Thursday, December 7, 2017 8:13 PM
To: Atul Gupta <atul.gupta@chelsio.com>
Cc: herbert@gondor.apana.org.au; linux-crypto@vger.kernel.org; netdev@vger.=
kernel.org; davem@davemloft.net; davejwatson@fb.com; Ganesh GR <ganeshgr@ch=
elsio.com>; Harsh Jain <Harsh@chelsio.com>
Subject: Re: [crypto 6/8] chtls: TCB and Key program

Am Donnerstag, 7. Dezember 2017, 15:21:03 CET schrieb Atul Gupta:

Hi Atul,

>=20
> memzero_explicit(key)?
> [Atul] may not be required as entire info of size keylen and=20
> AEAD_H_SIZE is copied onto kctx->key. Key data is received from user,=20
> while ghash is memset and locally generated

Sure, but wouldn't it make sense to zap all instances where key material wa=
s stored?
Agree, Its safe to memset where keylen is variable, perhaps in future where=
 we support different keylen. In current case key len is same as buffer siz=
e hence may not cause issue.=20

>=20
> As far as I see, the key is part of the skb (via kctx). This skb is=20
> released after being processed. The release calls kfree_skb which does=20
> not zeroize the key. Wouldn't it make sense to clear the memory of the=20
> key when the skb is released? [Atul] we should perhaps memset the info=20
> received from user so that driver has no info on key once its written on =
chip memory.
> memset(gcm_ctx->key, 0, keylen);

Are you saying that the skb (via kctx) above does not obtain a copy of the =
key? If not, what is done in chtls_key_info?
It does have a key copy, I was not sure how key info is accessed once skb i=
s released.


Ciao
Stephan

Thanks
Atul
