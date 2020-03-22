Return-Path: <SRS0=0mOM=5H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4B0BC54EEB
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Mar 2020 10:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A09320714
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Mar 2020 10:12:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgCVKMr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Mar 2020 06:12:47 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:26475 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726895AbgCVKMr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Mar 2020 06:12:47 -0400
X-IronPort-AV: E=Sophos;i="5.72,292,1580770800"; 
   d="scan'208";a="441532903"
Received: from abo-173-121-68.mrs.modulonet.fr (HELO hadrien) ([85.68.121.173])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Mar 2020 11:12:44 +0100
Date:   Sun, 22 Mar 2020 11:12:44 +0100 (CET)
From:   Julia Lawall <julia.lawall@inria.fr>
X-X-Sender: jll@hadrien
To:     SrujanaChalla <schalla@marvell.com>
cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, kbuild-all@lists.01.org
Subject: [cryptodev:master 149/150] drivers/crypto/marvell/octeontx/otx_cptvf_algs.c:1213:7-10:
 ERROR: reference preceded by free on line 1172 (fwd)
Message-ID: <alpine.DEB.2.21.2003221111450.2325@hadrien>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

There seems to be a double free on lines 1172 and 1213.

julia

---------- Forwarded message ----------
Date: Sun, 22 Mar 2020 17:21:30 +0800
From: kbuild test robot <lkp@intel.com>
To: kbuild@lists.01.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [cryptodev:master 149/150]
    drivers/crypto/marvell/octeontx/otx_cptvf_algs.c:1213:7-10: ERROR: reference
     preceded by free on line 1172

CC: kbuild-all@lists.01.org
CC: linux-crypto@vger.kernel.org
TO: SrujanaChalla <schalla@marvell.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   f6913d040c8d2d8294d0a06c9d2a2aa4a02fb8c0
commit: 6482023b9d3350bf1b756ef36e1ea1a1c871879c [149/150] crypto: marvell - enable OcteonTX cpt options for build
:::::: branch date: 2 days ago
:::::: commit date: 2 days ago

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@lip6.fr>

>> drivers/crypto/marvell/octeontx/otx_cptvf_algs.c:1213:7-10: ERROR: reference preceded by free on line 1172

# https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=6482023b9d3350bf1b756ef36e1ea1a1c871879c
git remote add cryptodev https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
git remote update cryptodev
git checkout 6482023b9d3350bf1b756ef36e1ea1a1c871879c
vim +1213 drivers/crypto/marvell/octeontx/otx_cptvf_algs.c

10b4f09491bfeb SrujanaChalla 2020-03-13  1130
10b4f09491bfeb SrujanaChalla 2020-03-13  1131  static inline u32 create_aead_null_output_list(struct aead_request *req,
10b4f09491bfeb SrujanaChalla 2020-03-13  1132  					       u32 enc, u32 mac_len)
10b4f09491bfeb SrujanaChalla 2020-03-13  1133  {
10b4f09491bfeb SrujanaChalla 2020-03-13  1134  	struct otx_cpt_req_ctx *rctx = aead_request_ctx(req);
10b4f09491bfeb SrujanaChalla 2020-03-13  1135  	struct otx_cpt_req_info *req_info =  &rctx->cpt_req;
10b4f09491bfeb SrujanaChalla 2020-03-13  1136  	struct scatterlist *dst;
10b4f09491bfeb SrujanaChalla 2020-03-13  1137  	u8 *ptr = NULL;
10b4f09491bfeb SrujanaChalla 2020-03-13  1138  	int argcnt = 0, status, offset;
10b4f09491bfeb SrujanaChalla 2020-03-13  1139  	u32 inputlen;
10b4f09491bfeb SrujanaChalla 2020-03-13  1140
10b4f09491bfeb SrujanaChalla 2020-03-13  1141  	if (enc)
10b4f09491bfeb SrujanaChalla 2020-03-13  1142  		inputlen =  req->cryptlen + req->assoclen;
10b4f09491bfeb SrujanaChalla 2020-03-13  1143  	else
10b4f09491bfeb SrujanaChalla 2020-03-13  1144  		inputlen =  req->cryptlen + req->assoclen - mac_len;
10b4f09491bfeb SrujanaChalla 2020-03-13  1145
10b4f09491bfeb SrujanaChalla 2020-03-13  1146  	/*
10b4f09491bfeb SrujanaChalla 2020-03-13  1147  	 * If source and destination are different
10b4f09491bfeb SrujanaChalla 2020-03-13  1148  	 * then copy payload to destination
10b4f09491bfeb SrujanaChalla 2020-03-13  1149  	 */
10b4f09491bfeb SrujanaChalla 2020-03-13  1150  	if (req->src != req->dst) {
10b4f09491bfeb SrujanaChalla 2020-03-13  1151
10b4f09491bfeb SrujanaChalla 2020-03-13  1152  		ptr = kmalloc(inputlen, (req_info->areq->flags &
10b4f09491bfeb SrujanaChalla 2020-03-13  1153  					 CRYPTO_TFM_REQ_MAY_SLEEP) ?
10b4f09491bfeb SrujanaChalla 2020-03-13  1154  					 GFP_KERNEL : GFP_ATOMIC);
10b4f09491bfeb SrujanaChalla 2020-03-13  1155  		if (!ptr) {
10b4f09491bfeb SrujanaChalla 2020-03-13  1156  			status = -ENOMEM;
10b4f09491bfeb SrujanaChalla 2020-03-13  1157  			goto error;
10b4f09491bfeb SrujanaChalla 2020-03-13  1158  		}
10b4f09491bfeb SrujanaChalla 2020-03-13  1159
10b4f09491bfeb SrujanaChalla 2020-03-13  1160  		status = sg_copy_to_buffer(req->src, sg_nents(req->src), ptr,
10b4f09491bfeb SrujanaChalla 2020-03-13  1161  					   inputlen);
10b4f09491bfeb SrujanaChalla 2020-03-13  1162  		if (status != inputlen) {
10b4f09491bfeb SrujanaChalla 2020-03-13  1163  			status = -EINVAL;
10b4f09491bfeb SrujanaChalla 2020-03-13  1164  			goto error;
10b4f09491bfeb SrujanaChalla 2020-03-13  1165  		}
10b4f09491bfeb SrujanaChalla 2020-03-13  1166  		status = sg_copy_from_buffer(req->dst, sg_nents(req->dst), ptr,
10b4f09491bfeb SrujanaChalla 2020-03-13  1167  					     inputlen);
10b4f09491bfeb SrujanaChalla 2020-03-13  1168  		if (status != inputlen) {
10b4f09491bfeb SrujanaChalla 2020-03-13  1169  			status = -EINVAL;
10b4f09491bfeb SrujanaChalla 2020-03-13  1170  			goto error;
10b4f09491bfeb SrujanaChalla 2020-03-13  1171  		}
10b4f09491bfeb SrujanaChalla 2020-03-13 @1172  		kfree(ptr);
10b4f09491bfeb SrujanaChalla 2020-03-13  1173  	}
10b4f09491bfeb SrujanaChalla 2020-03-13  1174
10b4f09491bfeb SrujanaChalla 2020-03-13  1175  	if (enc) {
10b4f09491bfeb SrujanaChalla 2020-03-13  1176  		/*
10b4f09491bfeb SrujanaChalla 2020-03-13  1177  		 * In an encryption scenario hmac needs
10b4f09491bfeb SrujanaChalla 2020-03-13  1178  		 * to be appended after payload
10b4f09491bfeb SrujanaChalla 2020-03-13  1179  		 */
10b4f09491bfeb SrujanaChalla 2020-03-13  1180  		dst = req->dst;
10b4f09491bfeb SrujanaChalla 2020-03-13  1181  		offset = inputlen;
10b4f09491bfeb SrujanaChalla 2020-03-13  1182  		while (offset >= dst->length) {
10b4f09491bfeb SrujanaChalla 2020-03-13  1183  			offset -= dst->length;
10b4f09491bfeb SrujanaChalla 2020-03-13  1184  			dst = sg_next(dst);
10b4f09491bfeb SrujanaChalla 2020-03-13  1185  			if (!dst) {
10b4f09491bfeb SrujanaChalla 2020-03-13  1186  				status = -ENOENT;
10b4f09491bfeb SrujanaChalla 2020-03-13  1187  				goto error;
10b4f09491bfeb SrujanaChalla 2020-03-13  1188  			}
10b4f09491bfeb SrujanaChalla 2020-03-13  1189  		}
10b4f09491bfeb SrujanaChalla 2020-03-13  1190
10b4f09491bfeb SrujanaChalla 2020-03-13  1191  		update_output_data(req_info, dst, offset, mac_len, &argcnt);
10b4f09491bfeb SrujanaChalla 2020-03-13  1192  	} else {
10b4f09491bfeb SrujanaChalla 2020-03-13  1193  		/*
10b4f09491bfeb SrujanaChalla 2020-03-13  1194  		 * In a decryption scenario calculated hmac for received
10b4f09491bfeb SrujanaChalla 2020-03-13  1195  		 * payload needs to be compare with hmac received
10b4f09491bfeb SrujanaChalla 2020-03-13  1196  		 */
10b4f09491bfeb SrujanaChalla 2020-03-13  1197  		status = sg_copy_buffer(req->src, sg_nents(req->src),
10b4f09491bfeb SrujanaChalla 2020-03-13  1198  					rctx->fctx.hmac.s.hmac_recv, mac_len,
10b4f09491bfeb SrujanaChalla 2020-03-13  1199  					inputlen, true);
10b4f09491bfeb SrujanaChalla 2020-03-13  1200  		if (status != mac_len) {
10b4f09491bfeb SrujanaChalla 2020-03-13  1201  			status = -EINVAL;
10b4f09491bfeb SrujanaChalla 2020-03-13  1202  			goto error;
10b4f09491bfeb SrujanaChalla 2020-03-13  1203  		}
10b4f09491bfeb SrujanaChalla 2020-03-13  1204
10b4f09491bfeb SrujanaChalla 2020-03-13  1205  		req_info->out[argcnt].vptr = rctx->fctx.hmac.s.hmac_calc;
10b4f09491bfeb SrujanaChalla 2020-03-13  1206  		req_info->out[argcnt].size = mac_len;
10b4f09491bfeb SrujanaChalla 2020-03-13  1207  		argcnt++;
10b4f09491bfeb SrujanaChalla 2020-03-13  1208  	}
10b4f09491bfeb SrujanaChalla 2020-03-13  1209
10b4f09491bfeb SrujanaChalla 2020-03-13  1210  	req_info->outcnt = argcnt;
10b4f09491bfeb SrujanaChalla 2020-03-13  1211  	return 0;
10b4f09491bfeb SrujanaChalla 2020-03-13  1212  error:
10b4f09491bfeb SrujanaChalla 2020-03-13 @1213  	kfree(ptr);
10b4f09491bfeb SrujanaChalla 2020-03-13  1214  	return status;
10b4f09491bfeb SrujanaChalla 2020-03-13  1215  }
10b4f09491bfeb SrujanaChalla 2020-03-13  1216

:::::: The code at line 1213 was first introduced by commit
:::::: 10b4f09491bfeb0b298cb2f49df585510ee6189a crypto: marvell - add the Virtual Function driver for CPT

:::::: TO: SrujanaChalla <schalla@marvell.com>
:::::: CC: Herbert Xu <herbert@gondor.apana.org.au>

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
