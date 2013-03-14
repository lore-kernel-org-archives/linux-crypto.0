From: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
Subject: RE: potential bug in GMAC implementation. not work in ESN mode
Date: Thu, 14 Mar 2013 19:57:52 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D07C588C8@RockMX01.rock.corp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.ultra-3eti.com ([173.13.207.162]:37850 "EHLO
	mail.ultra-3eti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab3CNT55 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Mar 2013 15:57:57 -0400
Received: from webmail.3eti.com (rockmx01.rock.corp [192.168.200.4]) by mail.ultra-3eti.com with ESMTP id srcFnLnujSFiAfjC (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-crypto@vger.kernel.org>; Thu, 14 Mar 2013 15:57:54 -0400 (EDT)
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Ping.... Is there anyone looking at this potential bug??


-----Original Message-----
From: Chaoxing Lin 
Sent: Friday, March 08, 2013 11:38 AM
To: 'linux-crypto@vger.kernel.org'
Subject: potential bug in GMAC implementation. not work in ESN mode

I was testing ipsec with GMAC and found that the rfc4543 GMAC implementation in kernel software crypto work in "esp=aes256gmac-noesn!" mode.
It does not work in in "esp=aes256gmac-esn!" mode. The tunnel was established but no data traffic is possible.

Looking at source code, I found this piece of code is suspicious.
Line 1146~1147 tries to put req->assoc to assoc[1]. But I think this way only works when req->assoc has only one segment. In ESN mode, req->assoc contains 3 segments (SPI, SN-hi, SN-low). Line 1146~1147 will only attach SPI segment(with total length) in assoc.

Please let me know whether I understand it right.
Thanks,

Chaoxing


Source from kernel 3.8.2
path: root/crypto/gcm.c

1136: /* construct the aad */
1137:	dstp = sg_page(dst);
	vdst = PageHighMem(dstp) ? NULL : page_address(dstp) + dst->offset;

	sg_init_table(payload, 2);
	sg_set_buf(payload, req->iv, 8);
	scatterwalk_crypto_chain(payload, dst, vdst == req->iv + 8, 2);
	assoclen += 8 + req->cryptlen - (enc ? 0 : authsize);

	sg_init_table(assoc, 2);
1146:	sg_set_page(assoc, sg_page(req->assoc), req->assoc->length,
1147:		    req->assoc->offset);
	scatterwalk_crypto_chain(assoc, payload, 0, 2);

	aead_request_set_tfm(subreq, ctx->child);
	aead_request_set_callback(subreq, req->base.flags, req->base.complete,
				  req->base.data);
	aead_request_set_crypt(subreq, cipher, cipher, enc ? 0 : authsize, iv);
1154:	aead_request_set_assoc(subreq, assoc, assoclen);
