From: Dimitrios Siganos <dimitris@siganos.org>
Subject: ABLKCIPHER
Date: Fri, 12 Mar 2010 13:36:35 +0000
Message-ID: <4B9A4363.1080706@siganos.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lvps94-136-60-187.vps.webfusion.co.uk ([94.136.60.187]:56874
	"EHLO siganos.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab0CLNgm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Mar 2010 08:36:42 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I am trying to write an ABLKCIPHER algorithm for my hardware crypto 
engine and I have a few questions:

1) In struct ablkcipher_alg, what do these fields do? I see some 
implementations use them and some not. Do I need to implement them?
    int (*givencrypt)(struct skcipher_givcrypt_request *req);
    int (*givdecrypt)(struct skcipher_givcrypt_request *req);
    const char *geniv;

2) What is a CRYPTO_ALG_TYPE_GIVCIPHER? What does it do and how does it 
interface to other algorithms?

In case, it is important; we are using linux-2.6.28 but we will soon 
move to linux-2.6.31. The ultimate goal is to accelerate 
authenc(cbc(aes),hmac(sha1)) and I am currently implementing the simpler 
algorithms as a learning exercise.

Regards,
Dimitris
