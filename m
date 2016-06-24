From: "Benedetto, Salvatore" <salvatore.benedetto@intel.com>
Subject: RE: [cryptodev:master 79/79] (.text+0x330de0): multiple definition
 of `ecdh_shared_secret'
Date: Fri, 24 Jun 2016 12:57:25 +0000
Message-ID: <309B30E91F5E2846B79BD9AA9711D031937DB6@IRSMSX102.ger.corp.intel.com>
References: <201606240302.rtIGIxRf%fengguang.wu@intel.com>
 <20160624060649.GA21165@localhost>
 <20160624061012.GA16850@gondor.apana.org.au>
 <20160624062316.GA16985@gondor.apana.org.au>
 <20160624063644.GA21443@localhost>
 <20160624064506.GA17229@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Wu, Fengguang" <fengguang.wu@intel.com>,
	"linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
	"Benedetto, Salvatore" <salvatore.benedetto@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:29274 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbcFXM53 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jun 2016 08:57:29 -0400
In-Reply-To: <20160624064506.GA17229@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



> -----Original Message-----
> From: Herbert Xu [mailto:herbert@gondor.apana.org.au]
> Sent: Friday, June 24, 2016 7:45 AM
> To: Benedetto, Salvatore <salvatore.benedetto@intel.com>
> Cc: linux-crypto@vger.kernel.org; Wu, Fengguang
> <fengguang.wu@intel.com>; linux-bluetooth@vger.kernel.org
> Subject: Re: [cryptodev:master 79/79] (.text+0x330de0): multiple definition
> of `ecdh_shared_secret'
> 
> On Fri, Jun 24, 2016 at 07:36:44AM +0100, Salvatore Benedetto wrote:
> >
> >
> > The patch was based on the current tree. I just pulled.
> > There is not point in moving to lib because bluetooth is about to be
> > converted to kpp.
> > That patch I believe will go up the bluetooth tree, so my suggestion
> > is to simply accept that I fail to properly name that symbol.
> >
> > Renaming the symbol in net/bluetooth/ecc which I think will conflict
> > with the patch where I remove it completely which, again, I believe
> > will go up the BT tree.
> 
> OK I will have no option but to revert your patches then.

Please revert the last one only and I'll resend it with the symbol
name fixed. I don't see why you should revert all of them.

I also just sent the BT patch which was changing the symbol name
anyway.

Regards,
Salvatore 
