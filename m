Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15ED1C4CECE
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 11:38:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD58E206A3
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 11:38:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A6Y/XG4D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730300AbfJNLiy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 07:38:54 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59008 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730178AbfJNLiy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 07:38:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9EBcq3W075595;
        Mon, 14 Oct 2019 11:38:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=Y+PT3sU0O11ZiX6hvCQrL5DQbDHmB4pL3D7aWV2pg9o=;
 b=A6Y/XG4DimU1NSZNLScdCGjQjmyRk1vlZgsXpO+PORo2/wj0ipyAJaYB6r7GGHN8rQtz
 GzbJH5JPhFbGUYvAo+/h/oWoWHe1218CHWSzzWBAjZmQw+qGl8BC5Pbk8QYBRWDXBc6l
 otzqeVmOEzjjrBLZwBpsxdXhSeG/S907D5gpxyqwjYqoyDJ8O92aDB0On1Xe53xDZekJ
 +hZ1liP2Zd2yWfo2mWseHzFtz63VeQ1uHbpWFa67LI+AI9r5IuVi7IE4z+9jNwvnTgme
 xa8UD/0Brx3nQqLBolYDbTCT55q6/J69Cq8mHiwS+dfiHXX7cL3VbgYYDv5oQBkZag5g 5A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2vk6sq89ng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Oct 2019 11:38:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9EBc9BK117778;
        Mon, 14 Oct 2019 11:38:52 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2vkrbjp53y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Oct 2019 11:38:52 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9EBcpmM003720;
        Mon, 14 Oct 2019 11:38:51 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Oct 2019 11:38:51 +0000
Date:   Mon, 14 Oct 2019 14:38:45 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     salvatore.benedetto@intel.com
Cc:     linux-crypto@vger.kernel.org
Subject: [bug report] crypto: dh - Add DH software implementation
Message-ID: <20191014113845.GA7830@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9409 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910140115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9409 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910140115
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello Salvatore Benedetto,

The patch 802c7f1c84e4: "crypto: dh - Add DH software implementation"
from Jun 22, 2016, leads to the following static checker warning:

	crypto/dh_helper.c:99 crypto_dh_decode_key()
	warn: potential overflow

crypto/dh_helper.c
    68  int crypto_dh_decode_key(const char *buf, unsigned int len, struct dh *params)
    69  {
    70          const u8 *ptr = buf;
    71          struct kpp_secret secret;
    72  
    73          if (unlikely(!buf || len < DH_KPP_SECRET_MIN_SIZE))
    74                  return -EINVAL;
    75  
    76          ptr = dh_unpack_data(&secret, ptr, sizeof(secret));
    77          if (secret.type != CRYPTO_KPP_SECRET_TYPE_DH)
    78                  return -EINVAL;
    79  
    80          ptr = dh_unpack_data(&params->key_size, ptr, sizeof(params->key_size));
    81          ptr = dh_unpack_data(&params->p_size, ptr, sizeof(params->p_size));
    82          ptr = dh_unpack_data(&params->q_size, ptr, sizeof(params->q_size));
    83          ptr = dh_unpack_data(&params->g_size, ptr, sizeof(params->g_size));
    84          if (secret.len != crypto_dh_key_len(params))

The largest parameter has to be "params->p_size" but it's a u32 from the
user.  So crypto_dh_key_len() can have an integer overflow and wrap back
to "secret.len".

    85                  return -EINVAL;
    86  
    87          /*
    88           * Don't permit the buffer for 'key' or 'g' to be larger than 'p', since
    89           * some drivers assume otherwise.
    90           */
    91          if (params->key_size > params->p_size ||
    92              params->g_size > params->p_size || params->q_size > params->p_size)

This ensures that "params->p_size" is the largest.

    93                  return -EINVAL;
    94  
    95          /* Don't allocate memory. Set pointers to data within
    96           * the given buffer
    97           */
    98          params->key = (void *)ptr;
    99          params->p = (void *)(ptr + params->key_size);
   100          params->q = (void *)(ptr + params->key_size + params->p_size);

This could wrap.

   101          params->g = (void *)(ptr + params->key_size + params->p_size +
   102                               params->q_size);
   103  
   104          /*
   105           * Don't permit 'p' to be 0.  It's not a prime number, and it's subject
   106           * to corner cases such as 'mod 0' being undefined or
   107           * crypto_kpp_maxsize() returning 0.
   108           */
   109          if (memchr_inv(params->p, 0, params->p_size) == NULL)

It would probably/hopefully lead to an Oops in memchr_inv().

   110                  return -EINVAL;
   111  
   112          /* It is permissible to not provide Q. */
   113          if (params->q_size == 0)
   114                  params->q = NULL;
   115  
   116          return 0;
   117  }

regards,
dan carpenter
