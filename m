Return-Path: <SRS0=RCNv=7Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 162DBC433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 11:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8D45207D0
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 11:09:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gNkQFmyY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725859AbgFCLJq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jun 2020 07:09:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60502 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbgFCLJq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jun 2020 07:09:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 053B2k4m044142;
        Wed, 3 Jun 2020 11:09:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=/1lXnyJGE3rK0PHjfgcnam/gH7evUeSV7+Brat7xl18=;
 b=gNkQFmyY4NoTebljnZ3gEWxSdEnZIRjcnYCf7/cN6kgXeuxsQLF7IDFjkw1s0kY+PCUI
 EzfgzOcGQV2Y2oDKY0LGACOhyMrzKMlLRVYjmhrYaIQL792BRl9z5FwXcSdZGqxcC09B
 Ca97bvhy7EzqaGc4wmOfd8fsbU9yzBEzu/zBM6YvcQJg8AuE0U9qBg52qjjyWroX/00J
 a5t4e5a77EBat7KzEzyCyMgOCevsVr4p/rAaS9rM8hjNseVk88R+nDgQr+dx98d0Q+hl
 okXQrT0hdzgvxsq+giKHPBi9IY9lqzHkHwZQSAEzCMicfu5qq005FZ9DcDvSnSuXBxJ2 jA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31bfem8mch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 03 Jun 2020 11:09:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 053B42hO130012;
        Wed, 3 Jun 2020 11:09:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31dju32h3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jun 2020 11:09:31 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 053B9RT3020500;
        Wed, 3 Jun 2020 11:09:27 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 03 Jun 2020 04:09:26 -0700
Date:   Wed, 3 Jun 2020 14:09:19 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+2e635807decef724a1fa@syzkaller.appspotmail.com>
Subject: Re: [PATCH] crypto: DRBG - always try to free Jitter RNG instance
Message-ID: <20200603110919.GK30374@kadam>
References: <0000000000002a280b05a725cd93@google.com>
 <2583872.mvXUDI8C0e@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2583872.mvXUDI8C0e@positron.chronox.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006030087
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=2
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1011
 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006030087
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jun 03, 2020 at 10:08:56AM +0200, Stephan Müller wrote:
> The Jitter RNG is unconditionally allocated as a seed source follwoing
> the patch 97f2650e5040. Thus, the instance must always be deallocated.
> 
> Reported-by: syzbot+2e635807decef724a1fa@syzkaller.appspotmail.com
> Fixes: 97f2650e5040 ("crypto: drbg - always seeded with SP800-90B ...")
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  crypto/drbg.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/crypto/drbg.c b/crypto/drbg.c
> index 37526eb8c5d5..33d28016da2d 100644
> --- a/crypto/drbg.c
> +++ b/crypto/drbg.c
> @@ -1631,6 +1631,9 @@ static int drbg_uninstantiate(struct drbg_state *drbg)
>  	if (drbg->random_ready.func) {
>  		del_random_ready_callback(&drbg->random_ready);
>  		cancel_work_sync(&drbg->seed_work);
> +	}
> +
> +	if (drbg->jent) {
>  		crypto_free_rng(drbg->jent);
>  		drbg->jent = NULL;
>  	}

free_everything functions never work.  For example, "drbg->jent" can be
an error pointer at this point.

crypto/drbg.c
  1577          if (!drbg->core) {
  1578                  drbg->core = &drbg_cores[coreref];
  1579                  drbg->pr = pr;
  1580                  drbg->seeded = false;
  1581                  drbg->reseed_threshold = drbg_max_requests(drbg);
  1582  
  1583                  ret = drbg_alloc_state(drbg);
  1584                  if (ret)
  1585                          goto unlock;
  1586  
  1587                  ret = drbg_prepare_hrng(drbg);
  1588                  if (ret)
  1589                          goto free_everything;
                                ^^^^^^^^^^^^^^^^^^^^
If we hit two failures inside drbg_prepare_hrng() then "drbg->jent" can
be an error pointer.

  1590  
  1591                  if (IS_ERR(drbg->jent)) {
  1592                          ret = PTR_ERR(drbg->jent);
  1593                          drbg->jent = NULL;
  1594                          if (fips_enabled || ret != -ENOENT)
  1595                                  goto free_everything;
  1596                          pr_info("DRBG: Continuing without Jitter RNG\n");
  1597                  }
  1598  
  1599                  reseed = false;
  1600          }
  1601  
  1602          ret = drbg_seed(drbg, pers, reseed);
  1603  
  1604          if (ret && !reseed)
  1605                  goto free_everything;
  1606  
  1607          mutex_unlock(&drbg->drbg_mutex);
  1608          return ret;
  1609  
  1610  unlock:
  1611          mutex_unlock(&drbg->drbg_mutex);
  1612          return ret;
  1613  
  1614  free_everything:
  1615          mutex_unlock(&drbg->drbg_mutex);
  1616          drbg_uninstantiate(drbg);
                                   ^^^^
Leading to an Oops.

  1617          return ret;
  1618  }

regards,
dan carpenter

