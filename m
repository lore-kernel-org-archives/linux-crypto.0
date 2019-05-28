Return-Path: <SRS0=c5Ty=T4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BB2DC04AB6
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 10:59:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D26F72070D
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 10:59:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yGLBRGFH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfE1K7W (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 May 2019 06:59:22 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:58998 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfE1K7V (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 May 2019 06:59:21 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4SAmnFc051794;
        Tue, 28 May 2019 10:59:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=Xrr8dZjVVWPnemFqGgwt1Gdv0kDCsmuTR340Iy0CgXs=;
 b=yGLBRGFHoyPVyCjHUcnlTIeYJEzeCcz4BXC/I/r1AzBkjti+IWc+J7FAyVEg0YFBJ9vu
 /+LkdpDWE0I/h3d+Y39dlf5/NivDaqpW3womAShH7Pfdjz0CKWF3/gVrNqdn2bNx1g74
 RIbcVCTxHViYKzd/mqy2rkfZJl3FsAZopz/sryGILmHe287zokqIA5wSH6hgooy3Neas
 QZyMu5+y3vpMjI4tkEhtnqVIplk65zv5x6e3/we6LVnnvqYjmFyQcTDVR8F/MqPqP0Hz
 uM6rag6wZLbJW0Sd5yLMgt8DDObxzLYMxMI+VsGF1FRQIG47VzHBaYzbMBEgNtYkVWy8 YQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2spu7dae8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 May 2019 10:59:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4SAu1c6058593;
        Tue, 28 May 2019 10:57:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2sr31ukdp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 May 2019 10:57:17 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4SAvGZq013216;
        Tue, 28 May 2019 10:57:16 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 May 2019 03:57:16 -0700
Date:   Tue, 28 May 2019 13:57:10 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     tadeusz.struk@intel.com
Cc:     qat-linux@intel.com, linux-crypto@vger.kernel.org
Subject: [bug report] crypto: qat - Intel(R) QAT driver framework
Message-ID: <20190528105709.GA3643@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9270 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905280072
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9270 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905280072
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello Tadeusz Struk,

The patch d8cba25d2c68: "crypto: qat - Intel(R) QAT driver framework"
from Jun 5, 2014, leads to the following static checker warning:

	drivers/crypto/qat/qat_common/adf_ctl_drv.c:159 adf_add_key_value_data()
	warn: 'adf_cfg_add_key_value_param' unterminated user string 'key_val->key'

drivers/crypto/qat/qat_common/adf_ctl_drv.c
   151  static int adf_add_key_value_data(struct adf_accel_dev *accel_dev,
   152                                    const char *section,
   153                                    const struct adf_user_cfg_key_val *key_val)
   154  {
   155          if (key_val->type == ADF_HEX) {
   156                  long *ptr = (long *)key_val->val;
   157                  long val = *ptr;
   158  
   159                  if (adf_cfg_add_key_value_param(accel_dev, section,
   160                                                  key_val->key, (void *)val,
                                                        ^^^^^^^^^^^^
Not terminated.  We end up adding the named item into a list.  Then we
look it up but when we're looking it up, we don't ensure that those
strings are NUL terminated either so there is a potential that it
overflows beyond the end of the array.

   161                                                  key_val->type)) {
   162                          dev_err(&GET_DEV(accel_dev),
   163                                  "failed to add hex keyvalue.\n");
   164                          return -EFAULT;
   165                  }
   166          } else {
   167                  if (adf_cfg_add_key_value_param(accel_dev, section,
   168                                                  key_val->key, key_val->val,
   169                                                  key_val->type)) {
   170                          dev_err(&GET_DEV(accel_dev),
   171                                  "failed to add keyvalue.\n");
   172                          return -EFAULT;
   173                  }
   174          }
   175          return 0;
   176  }

[ snip ]

   203                  while (params_head) {
   204                          if (copy_from_user(&key_val, (void __user *)params_head,
                                                   ^^^^^^^^
Gets set here.

   205                                             sizeof(key_val))) {
   206                                  dev_err(&GET_DEV(accel_dev),
   207                                          "Failed to copy keyvalue.\n");
   208                                  goto out_err;
   209                          }
   210                          if (adf_add_key_value_data(accel_dev, section.name,
   211                                                     &key_val)) {
   212                                  goto out_err;
   213                          }
   214                          params_head = key_val.next;
   215                  }

See also:
drivers/crypto/qat/qat_common/adf_ctl_drv.c:159 adf_add_key_value_data() warn: 'adf_cfg_add_key_value_param' unterminated user string 'key_val->key'
drivers/crypto/qat/qat_common/adf_ctl_drv.c:167 adf_add_key_value_data() warn: 'adf_cfg_add_key_value_param' unterminated user string 'key_val->key'
drivers/crypto/qat/qat_common/adf_ctl_drv.c:167 adf_add_key_value_data() warn: 'adf_cfg_add_key_value_param' unterminated user string 'key_val->val'
drivers/crypto/qat/qat_common/adf_ctl_drv.c:195 adf_copy_key_value_data() warn: 'adf_cfg_section_add' unterminated user string 'section.name'

regards,
dan carpenter
