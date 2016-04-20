From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: AEAD in TALITOS SEC1 versus TALITOS SEC2
Date: Wed, 20 Apr 2016 14:04:17 +0200
Message-ID: <57177041.4090607@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: LABBE Corentin <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Horia Geant? <horia.geanta@freescale.com>,
	Jonas Eymann <J.Eymann@gmx.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:51826 "EHLO pegase1.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932253AbcDTMUj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Apr 2016 08:20:39 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Today, in Talitos driver crypto alg registration is based on predefined 
templates with a predefined descriptor type and verification against the 
descriptors supported by the HW. This works well for ALG that require a 
unique descriptor. But for IPsec this is slightly different:
* IPsec can be performed with both DESC_HDR_TYPE_IPSEC_ESP and 
DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU
* DESC_HDR_TYPE_IPSEC_ESP is supported only by SEC2
* DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU is supported by both SEC1 and SEC2
* DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU is less performant than 
DESC_HDR_TYPE_IPSEC_ESP
So it is natural to use DESC_HDR_TYPE_IPSEC_ESP when it is supported and 
use DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU otherwise ?

What's the best way to implement the selection of the proper descriptor 
type ?
* We can duplicate the templates but it means that when both types are 
supported the driver with try to register each AEAD alg twice
* We can "on the fly" change the DESC_HDR_TYPE_IPSEC_ESP type into 
DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU type ?
* We can alter the templates at startup when we know we are on a SEC1, 
changing all templates based on DESC_HDR_TYPE_IPSEC_ESP into templates 
based on DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU

What would be the best approach from your point of view ?

Christophe
