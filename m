Return-Path: <SRS0=8ziv=TJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	T_DKIMWL_WL_HIGH,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E87DC04AB1
	for <linux-crypto@archiver.kernel.org>; Thu,  9 May 2019 11:06:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2A02216C4
	for <linux-crypto@archiver.kernel.org>; Thu,  9 May 2019 11:06:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c1ZDTTQK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbfEILGa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 May 2019 07:06:30 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44986 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfEILGa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 May 2019 07:06:30 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x49B47KX004762
        for <linux-crypto@vger.kernel.org>; Thu, 9 May 2019 11:06:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : cc :
 subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=A3Vr8ruQRDku3+ZUP3l/urZCloRM+oO7cv6HXyuu4eI=;
 b=c1ZDTTQKVp1zrmFCMbIP85UXensDhyNi8l+7tdSvZM0lL73LMYi5wb7qogYyFo6LGPkQ
 NyYWpHdVUCosRmBSD+i3MkQLyUBuIiA8ne9/9PpmVjKsUDRvcUEXU77rKu7Q0b9VZGSk
 27tf2s1XFAPEPmwW7NvQ9GX4BuhgC3XPXygHv1HXaXJbXcaTdG2YraHgx3/7VBd5KAfm
 aVGJpZOA4xQ7wVLhHEqq+yjaX1J3VPm9kYOQfQM+1DZmcT8Vsw+tukFWTDWRL0/6XbmI
 ZPG1EfTQe0o2toKMwoKHyqIhQKSoLLGRk+SI8Fo4ga/ItOkoiwbCk+toUce99gOHVKrn dg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2s94bga119-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-crypto@vger.kernel.org>; Thu, 09 May 2019 11:06:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x49B5N36069848
        for <linux-crypto@vger.kernel.org>; Thu, 9 May 2019 11:06:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2s94agqgua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-crypto@vger.kernel.org>; Thu, 09 May 2019 11:06:28 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x49B6R7x009786
        for <linux-crypto@vger.kernel.org>; Thu, 9 May 2019 11:06:27 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 May 2019 04:06:27 -0700
Date:   Thu, 9 May 2019 14:06:22 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-crypto@vger.kernel.org
Subject: potential underfow in crypto/lrw.c setkey() setkey
Message-ID: <20190509110622.GA15580@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9251 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=880
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905090068
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9251 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=910 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905090068
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

crypto/lrw.c
    72  static int setkey(struct crypto_skcipher *parent, const u8 *key,
    73                    unsigned int keylen)
    74  {
    75          struct priv *ctx = crypto_skcipher_ctx(parent);
    76          struct crypto_skcipher *child = ctx->child;
    77          int err, bsize = LRW_BLOCK_SIZE;
    78          const u8 *tweak = key + keylen - bsize;
                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Smatch thinks that keylen is user controlled from zero to some upper
bound.  How do we know it's >= LRW_BLOCK_SIZE (16)?

I find the crypto code sort of hard to follow...  There are a bunch of
setkey pointers and they're sometimes called recursively.  Is there
some trick or hints?

    79          be128 tmp = { 0 };
    80          int i;
    81  
    82          crypto_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
    83          crypto_skcipher_set_flags(child, crypto_skcipher_get_flags(parent) &
    84                                           CRYPTO_TFM_REQ_MASK);
    85          err = crypto_skcipher_setkey(child, key, keylen - bsize);
    86          crypto_skcipher_set_flags(parent, crypto_skcipher_get_flags(child) &
    87                                            CRYPTO_TFM_RES_MASK);
    88          if (err)
    89                  return err;
    90  
    91          if (ctx->table)
    92                  gf128mul_free_64k(ctx->table);
    93  
    94          /* initialize multiplication table for Key2 */
    95          ctx->table = gf128mul_init_64k_bbe((be128 *)tweak);
    96          if (!ctx->table)
    97                  return -ENOMEM;
    98  
    99          /* initialize optimization table */
   100          for (i = 0; i < 128; i++) {
   101                  setbit128_bbe(&tmp, i);
   102                  ctx->mulinc[i] = tmp;
   103                  gf128mul_64k_bbe(&ctx->mulinc[i], ctx->table);
   104          }
   105  
   106          return 0;
   107  }

regards,
dan carpenter
