Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E580EC433E9
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 13:43:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B593964F4F
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 13:43:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241450AbhCDNmn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Mar 2021 08:42:43 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:53476 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241446AbhCDNmX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Mar 2021 08:42:23 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 124Dcv04112866;
        Thu, 4 Mar 2021 13:40:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2020-01-29; bh=rHjv76kRhFAumZ6LENvywNWt8rScEIwcNyKKHdt6JPQ=;
 b=e5dp8s1K+Eg2iP3mxA13+ZirMuEp71g2h6+LrDGl603m1dGVfSHYwmuzCLxmQFxKXdBB
 WlJXXvct1zrnVQHmlQ9V5jMxSqY7ouJIVeGFalFkLeaT64beNozVnuYR24df0tjrZ0gb
 HbeNJSM0nb0oTcayWk3hpiYUxlhDYPWSdCiXeAFMsx+FzayGjnmbUHbGXxnFjSzdarj6
 9oSiddVQN046RgezqvZIQcLqqsa3kyzfnQvE4R3hqhJUmAp96sgiulXbH3CL+bk5gwZN
 RxlL2Oe83M+463BZyb4ArVZ0ItscJ3mo7SynjLdlANVg4vfb/A1uohoB6QhT/L/ywgen Sg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 36yeqn70ak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Mar 2021 13:40:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 124Defjg038681;
        Thu, 4 Mar 2021 13:40:43 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 36yyuuvdy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Mar 2021 13:40:42 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 124DeaCE005703;
        Thu, 4 Mar 2021 13:40:36 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 04 Mar 2021 05:40:35 -0800
Date:   Thu, 4 Mar 2021 16:40:26 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@lists.01.org, Hui Tang <tanghui20@huawei.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        marco.chiappero@intel.com, ebiggers@google.com,
        tomaszx.kowalik@intel.com
Cc:     lkp@intel.com, linux-crypto@vger.kernel.org, xuzaibo@huawei.com,
        wangzhou1@hisilicon.com, tanghui20@huawei.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: qat - fix use of 'dma_map_single'
Message-ID: <20210304134026.GC2087@kadam>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/iWRbSEcwh9lL8jf"
Content-Disposition: inline
In-Reply-To: <1614570058-38194-1-git-send-email-tanghui20@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9912 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103040064
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9912 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1011
 priorityscore=1501 mlxlogscore=999 suspectscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103040064
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--/iWRbSEcwh9lL8jf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Hui,

url:    https://github.com/0day-ci/linux/commits/Hui-Tang/crypto-qat-fix-use-of-dma_map_single/20210301-114717
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
config: i386-randconfig-m021-20210304 (attached as .config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

smatch warnings:
drivers/crypto/qat/qat_common/qat_algs.c:809 qat_alg_sgl_to_bufl() error: uninitialized symbol 'blp'.

vim +/blp +809 drivers/crypto/qat/qat_common/qat_algs.c

d370cec3219490 Tadeusz Struk       2014-06-05  711  static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
d370cec3219490 Tadeusz Struk       2014-06-05  712  			       struct scatterlist *sgl,
e19ab1211d2848 Herbert Xu          2015-07-30  713  			       struct scatterlist *sglout,
d370cec3219490 Tadeusz Struk       2014-06-05  714  			       struct qat_crypto_request *qat_req)
d370cec3219490 Tadeusz Struk       2014-06-05  715  {
d370cec3219490 Tadeusz Struk       2014-06-05  716  	struct device *dev = &GET_DEV(inst->accel_dev);
e19ab1211d2848 Herbert Xu          2015-07-30  717  	int i, sg_nctr = 0;
e19ab1211d2848 Herbert Xu          2015-07-30  718  	int n = sg_nents(sgl);
d370cec3219490 Tadeusz Struk       2014-06-05  719  	struct qat_alg_buf_list *bufl;
d370cec3219490 Tadeusz Struk       2014-06-05  720  	struct qat_alg_buf_list *buflout = NULL;
d370cec3219490 Tadeusz Struk       2014-06-05  721  	dma_addr_t blp;
                                                        ^^^^^^^^^^^^^^

d370cec3219490 Tadeusz Struk       2014-06-05  722  	dma_addr_t bloutp = 0;
d370cec3219490 Tadeusz Struk       2014-06-05  723  	struct scatterlist *sg;
1793d1aba19415 Gustavo A. R. Silva 2019-06-06  724  	size_t sz_out, sz = struct_size(bufl, bufers, n + 1);
d370cec3219490 Tadeusz Struk       2014-06-05  725  
d370cec3219490 Tadeusz Struk       2014-06-05  726  	if (unlikely(!n))
d370cec3219490 Tadeusz Struk       2014-06-05  727  		return -EINVAL;
d370cec3219490 Tadeusz Struk       2014-06-05  728  
82f82504b8f5f1 Tadeusz Struk       2014-12-08  729  	bufl = kzalloc_node(sz, GFP_ATOMIC,
09adc8789c4e89 Tadeusz Struk       2014-10-13  730  			    dev_to_node(&GET_DEV(inst->accel_dev)));
d370cec3219490 Tadeusz Struk       2014-06-05  731  	if (unlikely(!bufl))
d370cec3219490 Tadeusz Struk       2014-06-05  732  		return -ENOMEM;
d370cec3219490 Tadeusz Struk       2014-06-05  733  
d370cec3219490 Tadeusz Struk       2014-06-05  734  	for_each_sg(sgl, sg, n, i) {
e19ab1211d2848 Herbert Xu          2015-07-30  735  		int y = sg_nctr;
82f82504b8f5f1 Tadeusz Struk       2014-12-08  736  
82f82504b8f5f1 Tadeusz Struk       2014-12-08  737  		if (!sg->length)
82f82504b8f5f1 Tadeusz Struk       2014-12-08  738  			continue;
d65071ecde1ed1 Tadeusz Struk       2014-06-24  739  
d370cec3219490 Tadeusz Struk       2014-06-05  740  		bufl->bufers[y].addr = dma_map_single(dev, sg_virt(sg),
d370cec3219490 Tadeusz Struk       2014-06-05  741  						      sg->length,
d370cec3219490 Tadeusz Struk       2014-06-05  742  						      DMA_BIDIRECTIONAL);
d370cec3219490 Tadeusz Struk       2014-06-05  743  		bufl->bufers[y].len = sg->length;
d370cec3219490 Tadeusz Struk       2014-06-05  744  		if (unlikely(dma_mapping_error(dev, bufl->bufers[y].addr)))
72eed063767e13 Arnd Bergmann       2017-06-22  745  			goto err_in;

"blp" uninitialized at this goto.

82f82504b8f5f1 Tadeusz Struk       2014-12-08  746  		sg_nctr++;
d370cec3219490 Tadeusz Struk       2014-06-05  747  	}
e19ab1211d2848 Herbert Xu          2015-07-30  748  	bufl->num_bufs = sg_nctr;
54bc41cf4d0517 Hui Tang            2021-03-01  749  	blp = dma_map_single(dev, bufl, sz, DMA_TO_DEVICE);
                                                        ^^^^^^
Initialized here.

54bc41cf4d0517 Hui Tang            2021-03-01  750  	if (unlikely(dma_mapping_error(dev, blp)))
54bc41cf4d0517 Hui Tang            2021-03-01  751  		goto err_in;
d370cec3219490 Tadeusz Struk       2014-06-05  752  	qat_req->buf.bl = bufl;
d370cec3219490 Tadeusz Struk       2014-06-05  753  	qat_req->buf.blp = blp;
d370cec3219490 Tadeusz Struk       2014-06-05  754  	qat_req->buf.sz = sz;
d370cec3219490 Tadeusz Struk       2014-06-05  755  	/* Handle out of place operation */
d370cec3219490 Tadeusz Struk       2014-06-05  756  	if (sgl != sglout) {
d370cec3219490 Tadeusz Struk       2014-06-05  757  		struct qat_alg_buf *bufers;
d370cec3219490 Tadeusz Struk       2014-06-05  758  
82f82504b8f5f1 Tadeusz Struk       2014-12-08  759  		n = sg_nents(sglout);
1793d1aba19415 Gustavo A. R. Silva 2019-06-06  760  		sz_out = struct_size(buflout, bufers, n + 1);
82f82504b8f5f1 Tadeusz Struk       2014-12-08  761  		sg_nctr = 0;
82f82504b8f5f1 Tadeusz Struk       2014-12-08  762  		buflout = kzalloc_node(sz_out, GFP_ATOMIC,
09adc8789c4e89 Tadeusz Struk       2014-10-13  763  				       dev_to_node(&GET_DEV(inst->accel_dev)));
d370cec3219490 Tadeusz Struk       2014-06-05  764  		if (unlikely(!buflout))
72eed063767e13 Arnd Bergmann       2017-06-22  765  			goto err_in;
d370cec3219490 Tadeusz Struk       2014-06-05  766  		bufers = buflout->bufers;
d370cec3219490 Tadeusz Struk       2014-06-05  767  		for_each_sg(sglout, sg, n, i) {
e19ab1211d2848 Herbert Xu          2015-07-30  768  			int y = sg_nctr;
82f82504b8f5f1 Tadeusz Struk       2014-12-08  769  
82f82504b8f5f1 Tadeusz Struk       2014-12-08  770  			if (!sg->length)
82f82504b8f5f1 Tadeusz Struk       2014-12-08  771  				continue;
d65071ecde1ed1 Tadeusz Struk       2014-06-24  772  
d370cec3219490 Tadeusz Struk       2014-06-05  773  			bufers[y].addr = dma_map_single(dev, sg_virt(sg),
d370cec3219490 Tadeusz Struk       2014-06-05  774  							sg->length,
d370cec3219490 Tadeusz Struk       2014-06-05  775  							DMA_BIDIRECTIONAL);
d370cec3219490 Tadeusz Struk       2014-06-05  776  			if (unlikely(dma_mapping_error(dev, bufers[y].addr)))
72eed063767e13 Arnd Bergmann       2017-06-22  777  				goto err_out;
82f82504b8f5f1 Tadeusz Struk       2014-12-08  778  			bufers[y].len = sg->length;
82f82504b8f5f1 Tadeusz Struk       2014-12-08  779  			sg_nctr++;
d370cec3219490 Tadeusz Struk       2014-06-05  780  		}
e19ab1211d2848 Herbert Xu          2015-07-30  781  		buflout->num_bufs = sg_nctr;
82f82504b8f5f1 Tadeusz Struk       2014-12-08  782  		buflout->num_mapped_bufs = sg_nctr;
54bc41cf4d0517 Hui Tang            2021-03-01  783  		bloutp = dma_map_single(dev, buflout, sz_out, DMA_TO_DEVICE);
54bc41cf4d0517 Hui Tang            2021-03-01  784  		if (unlikely(dma_mapping_error(dev, bloutp)))
54bc41cf4d0517 Hui Tang            2021-03-01  785  			goto err_out;
d370cec3219490 Tadeusz Struk       2014-06-05  786  		qat_req->buf.blout = buflout;
d370cec3219490 Tadeusz Struk       2014-06-05  787  		qat_req->buf.bloutp = bloutp;
82f82504b8f5f1 Tadeusz Struk       2014-12-08  788  		qat_req->buf.sz_out = sz_out;
d370cec3219490 Tadeusz Struk       2014-06-05  789  	} else {
d370cec3219490 Tadeusz Struk       2014-06-05  790  		/* Otherwise set the src and dst to the same address */
d370cec3219490 Tadeusz Struk       2014-06-05  791  		qat_req->buf.bloutp = qat_req->buf.blp;
82f82504b8f5f1 Tadeusz Struk       2014-12-08  792  		qat_req->buf.sz_out = 0;
d370cec3219490 Tadeusz Struk       2014-06-05  793  	}
d370cec3219490 Tadeusz Struk       2014-06-05  794  	return 0;
82f82504b8f5f1 Tadeusz Struk       2014-12-08  795  
72eed063767e13 Arnd Bergmann       2017-06-22  796  err_out:
54bc41cf4d0517 Hui Tang            2021-03-01  797  	if (!dma_mapping_error(dev, bloutp))
54bc41cf4d0517 Hui Tang            2021-03-01  798  		dma_unmap_single(dev, bloutp, sz_out, DMA_TO_DEVICE);
54bc41cf4d0517 Hui Tang            2021-03-01  799  
82f82504b8f5f1 Tadeusz Struk       2014-12-08  800  	n = sg_nents(sglout);
e19ab1211d2848 Herbert Xu          2015-07-30  801  	for (i = 0; i < n; i++)
82f82504b8f5f1 Tadeusz Struk       2014-12-08  802  		if (!dma_mapping_error(dev, buflout->bufers[i].addr))
82f82504b8f5f1 Tadeusz Struk       2014-12-08  803  			dma_unmap_single(dev, buflout->bufers[i].addr,
82f82504b8f5f1 Tadeusz Struk       2014-12-08  804  					 buflout->bufers[i].len,
d370cec3219490 Tadeusz Struk       2014-06-05  805  					 DMA_BIDIRECTIONAL);
d370cec3219490 Tadeusz Struk       2014-06-05  806  	kfree(buflout);
72eed063767e13 Arnd Bergmann       2017-06-22  807  
72eed063767e13 Arnd Bergmann       2017-06-22  808  err_in:
54bc41cf4d0517 Hui Tang            2021-03-01 @809  	if (!dma_mapping_error(dev, blp))
                                                                                    ^^^
Uninitialized.

54bc41cf4d0517 Hui Tang            2021-03-01  810  		dma_unmap_single(dev, blp, sz, DMA_TO_DEVICE);
54bc41cf4d0517 Hui Tang            2021-03-01  811  
72eed063767e13 Arnd Bergmann       2017-06-22  812  	n = sg_nents(sgl);
72eed063767e13 Arnd Bergmann       2017-06-22  813  	for (i = 0; i < n; i++)
72eed063767e13 Arnd Bergmann       2017-06-22  814  		if (!dma_mapping_error(dev, bufl->bufers[i].addr))
72eed063767e13 Arnd Bergmann       2017-06-22  815  			dma_unmap_single(dev, bufl->bufers[i].addr,
72eed063767e13 Arnd Bergmann       2017-06-22  816  					 bufl->bufers[i].len,
72eed063767e13 Arnd Bergmann       2017-06-22  817  					 DMA_BIDIRECTIONAL);
72eed063767e13 Arnd Bergmann       2017-06-22  818  
72eed063767e13 Arnd Bergmann       2017-06-22  819  	kfree(bufl);
72eed063767e13 Arnd Bergmann       2017-06-22  820  
72eed063767e13 Arnd Bergmann       2017-06-22  821  	dev_err(dev, "Failed to map buf for dma\n");
d370cec3219490 Tadeusz Struk       2014-06-05  822  	return -ENOMEM;
d370cec3219490 Tadeusz Struk       2014-06-05  823  }

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--/iWRbSEcwh9lL8jf
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
SI1HxenF6yiI6NSW3n8BQVu5YxUDAgA=

--/iWRbSEcwh9lL8jf--
