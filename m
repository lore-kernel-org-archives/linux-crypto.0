From: David Binderman <dcb314@hotmail.com>
Subject: linux-4.1-rc3/drivers/crypto/caam/caamhash.c:1183: memory leak ?
Date: Mon, 11 May 2015 13:12:36 +0000
Message-ID: <DUB128-W37B0CA05DDEA3010482D6E9CDB0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"avem@davemloft.net" <avem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from dub004-omc4s31.hotmail.com ([157.55.2.106]:52639 "EHLO
	DUB004-OMC4S31.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753685AbbEKNRj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 09:17:39 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello there,

[linux-4.1-rc3/drivers/crypto/caam/caamhash.c:1183]: (error) Memory lea=
k: edesc

=A0=A0=A0 if (dma_mapping_error(jrdev, state->buf_dma)) {
=A0=A0=A0=A0=A0=A0=A0 dev_err(jrdev, "unable to map src\n");
=A0=A0=A0=A0=A0=A0=A0 return -ENOMEM;
=A0=A0=A0 }

Suggest add call to kfree(edesc) inside the if.

Regards

David Binderman

 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
