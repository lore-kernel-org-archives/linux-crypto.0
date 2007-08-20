From: Joy Latten <latten@austin.ibm.com>
Subject: Re: combined mode algorithms
Date: Mon, 20 Aug 2007 18:12:23 -0500
Message-ID: <200708202312.l7KNCNBA015041@faith.austin.ibm.com>
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:54837 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758462AbXHTXPN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Aug 2007 19:15:13 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l7KNFCFQ029356
	for <linux-crypto@vger.kernel.org>; Mon, 20 Aug 2007 19:15:12 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l7KNFCLR270650
	for <linux-crypto@vger.kernel.org>; Mon, 20 Aug 2007 17:15:12 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7KNFCCg002650
	for <linux-crypto@vger.kernel.org>; Mon, 20 Aug 2007 17:15:12 -0600
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

>
>The salt will just come from the key field.  So instead of having
>an 128-bit key for example, you'd have 152 bits.

ok, quick question, this 152 bits key will be part
of input to setkey()? 
The reason I am asking is because setkey in ablkcipher and
blkcipher check key length for min and max size.  
Thus for example, aes, when using a 256 bit key, would
pass in 288 bits or 36 octet key. max is 32 bits, so would
result in error. 

If not passed into setkey, then I assume the salt/nonce
would be parsed from key when ipsec daemon passes keys 
into kernel...

Joy
