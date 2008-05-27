From: "Loc Ho" <lho@amcc.com>
Subject: IPSec ESP Authenc Offload
Date: Tue, 27 May 2008 11:29:22 -0700
Message-ID: <0CA0A16855646F4FA96D25A158E299D604814C4A@SDCEXCHANGE01.ad.amcc.com>
References: <alpine.LFD.1.10.0805250731530.23219@localhost.localdomain> <20080526112058.GA16525@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: <linux-crypto@vger.kernel.org>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail02-ext1.amcc.com ([198.137.200.73]:15094 "EHLO
	sdcmail02.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756775AbYE0S3Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 May 2008 14:29:24 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20080526112058.GA16525@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

For authenc hardware offload outbound, we need to know the whole ESP
header length - IP header + UDP header + ESP header + IV. I am thinking
adding a field in struct aead_givcrypt_request as below:

/**
 *      struct aead_givcrypt_request - AEAD request with IV generation
 *      @seq: Sequence number for IV generation
 *      @giv: Space for generated IV
 *      @areq: The AEAD request itself
 *      @hl: ESP total header length
 */
struct aead_givcrypt_request {
        u64 seq;
        u8 *giv;
        u16 hl;		<===== new ESP total header including IV

        struct aead_request areq;
};


aead_givcrypt_set_giv(req, esph->enc_data,
		      XFRM_SKB_CB(skb)->seq.output,
		      x->props.header_len);

Might be able to use skb_network_offset(skb) instead
x->props.header_len. And of course change function aead_givcrypt_set_giv
to set field hl.

Any other suggest as to how a hardware driver can retrieve this
information besides passing the data packet?

-Loc
