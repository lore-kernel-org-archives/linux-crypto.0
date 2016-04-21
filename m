From: Horia Ioan Geanta Neag <horia.geanta@nxp.com>
Subject: Re: AEAD in TALITOS SEC1 versus TALITOS SEC2
Date: Thu, 21 Apr 2016 13:31:47 +0000
Message-ID: <AM2PR04MB0673D78968F3409796CDB37D986E0@AM2PR04MB0673.eurprd04.prod.outlook.com>
References: <57177041.4090607@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Christophe Leroy <christophe.leroy@c-s.fr>,
	LABBE Corentin <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"Jonas Eymann" <J.Eymann@gmx.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0087.outbound.protection.outlook.com ([104.47.2.87]:55604
	"EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751647AbcDUNrt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Apr 2016 09:47:49 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 4/20/2016 3:04 PM, Christophe Leroy wrote:
> Today, in Talitos driver crypto alg registration is based on predefined 
> templates with a predefined descriptor type and verification against the 
> descriptors supported by the HW. This works well for ALG that require a 
> unique descriptor. But for IPsec this is slightly different:
> * IPsec can be performed with both DESC_HDR_TYPE_IPSEC_ESP and 
> DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU
> * DESC_HDR_TYPE_IPSEC_ESP is supported only by SEC2
> * DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU is supported by both SEC1 and SEC2
> * DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU is less performant than 
> DESC_HDR_TYPE_IPSEC_ESP
> So it is natural to use DESC_HDR_TYPE_IPSEC_ESP when it is supported and 
> use DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU otherwise ?
> 
> What's the best way to implement the selection of the proper descriptor 
> type ?
> * We can duplicate the templates but it means that when both types are 
> supported the driver with try to register each AEAD alg twice
> * We can "on the fly" change the DESC_HDR_TYPE_IPSEC_ESP type into 
> DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU type ?
> * We can alter the templates at startup when we know we are on a SEC1, 
> changing all templates based on DESC_HDR_TYPE_IPSEC_ESP into templates 
> based on DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU
> 
> What would be the best approach from your point of view ?
> 
I would go with altering the relevant entries in the template array, of
course before the hw_supports() check.

IIUC, the "on the fly" option won't work. There has to be a valid
descriptor type for each template entry before hw_supports().

Regards,
Horia
