From: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
Subject: authencesn compatibility problemn between software crypto and
 talitos driver
Date: Fri, 8 Mar 2013 15:27:48 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D07C583E5@RockMX01.rock.corp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.ultra-3eti.com ([173.13.207.162]:59783 "EHLO
	mail.ultra-3eti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933096Ab3CHPqO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Mar 2013 10:46:14 -0500
Received: from webmail.3eti.com (rockmx01.rock.corp [192.168.200.4]) by mail.ultra-3eti.com with ESMTP id 7xmKvq5cUcRAlleE (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-crypto@vger.kernel.org>; Fri, 08 Mar 2013 10:27:49 -0500 (EST)
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

1. Can any one point me which RFC describe how exactly authencesn should work?

2. I test Ipsec with "esp=aes256-sha512-esn!" options and found compatibility issue between kernel software crypto and talitos driver.
Talitos <---->talitos				Good
Soft crypto<---->soft crypto			Good
Soft crypto<---->talitos			link established but no traffic can pass through.

3. Looking at source code of latest stable kernel 3.8.2, I found that these two implementations don't agree on what's to be hashed in ESN case.
Talitos driver is more intuitive in that  "assoc (SPI, SN-hi, SN-low) + IV + payload" are hashed.
Kernel software crypto is counter-intuitive in that "hsg(SPI, SN-low) + sg(IV + payload) + tsg(SN-hi" are hashed.
I copy codelet from kernel 3.8.2 in the end.

Please let me know whether I read the code right. And which way is the right way.

Thanks

Chaoxing
 
Code from latest stable kernel 3.8.2

path: root/drivers/crypto/talitos.c

969: /* hmac data */
970:	desc->ptr[1].len = cpu_to_be16(areq->assoclen + ivsize);
	if (edesc->assoc_nents) {
		int tbl_off = edesc->src_nents + edesc->dst_nents + 2;
		struct talitos_ptr *tbl_ptr = &edesc->link_tbl[tbl_off];

		to_talitos_ptr(&desc->ptr[1], edesc->dma_link_tbl + tbl_off *
			       sizeof(struct talitos_ptr));
		desc->ptr[1].j_extent = DESC_PTR_LNKTBL_JUMP;

		/* assoc_nents - 1 entries for assoc, 1 for IV */
		sg_count = sg_to_link_tbl(areq->assoc, edesc->assoc_nents - 1,
					  areq->assoclen, tbl_ptr);

		/* add IV to link table */
		tbl_ptr += sg_count - 1;
		tbl_ptr->j_extent = 0;
		tbl_ptr++;
		to_talitos_ptr(tbl_ptr, edesc->iv_dma);
		tbl_ptr->len = cpu_to_be16(ivsize);
		tbl_ptr->j_extent = DESC_PTR_LNKTBL_RETURN;

		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
					   edesc->dma_len, DMA_BIDIRECTIONAL);
	} else {
		to_talitos_ptr(&desc->ptr[1], sg_dma_address(areq->assoc));
		desc->ptr[1].j_extent = 0;
996:	}



path: root/crypto/authencesn.c

372:	err = crypto_ahash_init(ahreq);
373:	if (err)
		return ERR_PTR(err);

	ahash_request_set_crypt(ahreq, areq_ctx->hsg, hash, areq_ctx->headlen);
	ahash_request_set_callback(ahreq, aead_request_flags(req) & flags,
				   areq_ctx->update_complete, req);

	err = crypto_ahash_update(ahreq);
	if (err)
		return ERR_PTR(err);

	ahash_request_set_crypt(ahreq, areq_ctx->sg, hash, areq_ctx->cryptlen);
	ahash_request_set_callback(ahreq, aead_request_flags(req) & flags,
				   areq_ctx->update_complete2, req);

	err = crypto_ahash_update(ahreq);
	if (err)
		return ERR_PTR(err);

	ahash_request_set_crypt(ahreq, areq_ctx->tsg, hash,
				areq_ctx->trailen);
	ahash_request_set_callback(ahreq, aead_request_flags(req) & flags,
				   areq_ctx->complete, req);

397:	err = crypto_ahash_finup(ahreq);
