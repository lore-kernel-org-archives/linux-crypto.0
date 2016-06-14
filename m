From: "Benedetto, Salvatore" <salvatore.benedetto@intel.com>
Subject: RE: [PATCH v8 1/3] crypto: Key-agreement Protocol Primitives API
 (KPP)
Date: Tue, 14 Jun 2016 14:36:54 +0000
Message-ID: <309B30E91F5E2846B79BD9AA9711D031933C15@IRSMSX102.ger.corp.intel.com>
References: <1465854948-9084-1-git-send-email-salvatore.benedetto@intel.com>
 <1465854948-9084-2-git-send-email-salvatore.benedetto@intel.com>
 <20160614113430.GA21063@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Benedetto, Salvatore" <salvatore.benedetto@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56313 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbcFNOha convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jun 2016 10:37:30 -0400
In-Reply-To: <20160614113430.GA21063@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


> -----Original Message-----
> From: Herbert Xu [mailto:herbert@gondor.apana.org.au]
> Sent: Tuesday, June 14, 2016 12:35 PM
> To: Benedetto, Salvatore <salvatore.benedetto@intel.com>
> Cc: linux-crypto@vger.kernel.org
> Subject: Re: [PATCH v8 1/3] crypto: Key-agreement Protocol Primitives API
> (KPP)
> 
> On Mon, Jun 13, 2016 at 10:55:46PM +0100, Salvatore Benedetto wrote:
> >
> > +struct kpp_alg {
> > +	int (*set_secret)(struct crypto_kpp *tfm, void *buffer);
> 
> Sorry I think we need to change this.  Leaving this with no type checking
> between the user and the driver is a recipe for disaster.
> 
> I think the easiest solution is to use either BER encoding like rsa.c or netlink
> encoding like authenc.c.
>

My very first patch used PKCS3 and there were some objections to that.
https://patchwork.kernel.org/patch/8311881/
 
Both Bluetooth or keyctl KEYCTL_DH_COMPUTE would have to first pack the
key to whatever format we choose and I don't see that very convinient. We
only want to provide the acceleration here, without bounding the user to a
certain key format.
 
 akcipher is different as PKCS1 is a recognized standard for RSA keys.
 
 Please don't get me wrong, it's not much of an issue for me to respin the
 patchset and change that to PKCS3 for example, but I see no harm in leaving
 it as it is and moving the key check format to whatever upper layer is using us
 (like BT and keyctl). Just more work for who is using the API.
 
 Could you reconsider that?
 
 Thanks,
 Salvatore
