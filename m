From: Dean Jenkins <djenkins@mvista.com>
Subject: kernel BUG at crypto/scatterwalk.c:37! when using modified tcrypt for HMAC testing
Date: Mon, 12 Jan 2009 13:53:42 +0000
Message-ID: <200901121353.42705.djenkins@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gateway-1237.mvista.com ([63.81.120.158]:64605 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801AbZALNxp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Jan 2009 08:53:45 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I'm trying to test AEAD based HMAC (sha1-96) with NULL encryption using a 
modified tcrypt module.

I'm using a 2.6.27.4 kernel on an armv5te platform.

I hit a BUG() at crypto/scatterwalk.c:37 that indicates that the scatterlist 
length is zero.

I've traced this back to crypto/authenc.c function crypto_authenc_genicv()...

There is a call to authenc_chain(cipher, dst, vdst == iv + ivsize);

It seems the test vdst == iv + ivsize fails. Does anyone know the purpose of 
the test ? I think it is trying to check that the end of the IV field matches 
something in the reg->dst scatterlist ?

authenc_chain() is...

static void authenc_chain(struct scatterlist *head, struct scatterlist *sg,
			  int chain)
{
	if (chain) {
		head->length += sg->length;
		sg = scatterwalk_sg_next(sg);
	}

	if (sg)
		scatterwalk_sg_chain(head, 2, sg);
	else
		sg_mark_end(head);
}

Therefore the value of chain is 0 and this causes authenc_chain() to not 
update the length in head eg. chiper[0] scatterlist.

Can anyone please tell me what authenc_chain() is trying to do ?

Is there a "special" relationship to create the IV buffer with respect to the 
dst scatterlist within tcrypt so that chain = 1 ? If I use ESP4 in IPsec 
instead of tcrypt, then chain does equal 1.

Thanks for any info ?

Regards,

Dean Jenkins
MontaVista Software

