From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH 6/8] crypto: caam - Convert GCM to new AEAD interface
Date: Mon, 15 Jun 2015 15:33:20 +0300
Message-ID: <557EC610.9070309@freescale.com>
References: <20150615080716.GA30753@gondor.apana.org.au>
 <E1Z4PSj-00084W-6B@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>,
	<ruchika.gupta@freescale.com>, <cristian.stoica@freescale.com>,
	<NiteshNarayanLal@freescale.com>, <jinyanjiang@gmail.com>,
	Tudor Ambarus <tudor.ambarus@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0116.outbound.protection.outlook.com ([157.56.111.116]:22633
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753842AbbFOMdl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 08:33:41 -0400
In-Reply-To: <E1Z4PSj-00084W-6B@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 6/15/2015 11:09 AM, Herbert Xu wrote:
> This patch converts the caam GCM implementations to the new AEAD
> interface.  This is compile-tested only.
> 
> Note that all IV generation for GCM algorithms have been removed.
> The reason is that the current generation uses purely random IVs
> which is not appropriate for counter-based algorithms where we
> first and foremost require uniqueness.
> 
> Of course there is no reason why you couldn't implement seqiv or
> seqniv within caam since all they do is xor the sequence number
> with a salt, but since I can't test this on actual hardware I'll
> leave it alone for now.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---

Testing on P2041RDB I see the following failures:

caam_jr ffe301000.jr: 40000f10: DECO: desc idx 15: Invalid Sequence
Command. A SEQ IN PTR OR SEQ OUT PTR Command is invalid or a SEQ KEY,
SEQ LOAD, SEQ FIFO LOAD, or SEQ FIFO STORE decremented the input or
output sequence length below 0. This error may result if a built-in
PROTOCOL Command has encountered a malformed PDU.
alg: aead: encryption failed on test 1 for rfc4106-gcm-aes-caam:
ret=-1073745680

caam_jr ffe301000.jr: 40000e10: DECO: desc idx 14: Invalid Sequence
Command. A SEQ IN PTR OR SEQ OUT PTR Command is invalid or a SEQ KEY,
SEQ LOAD, SEQ FIFO LOAD, or SEQ FIFO STORE decremented the input or
output sequence length below 0. This error may result if a built-in
PROTOCOL Command has encountered a malformed PDU.
alg: aead: encryption failed on test 1 for rfc4543-gcm-aes-caam:
ret=-1073745424

alg: aead: Test 2 failed on encryption for gcm-aes-caam
00000000: ab 6e 47 d4 2c ec 13 bd f5 3a 67 b2 12 57 bd df
00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

I'll check why this is happening.

Regards,
Horia
