Return-Path: <SRS0=g3pl=VW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAA16C76190
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 21:26:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C671218F0
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 21:26:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bUJjptgb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbfGYVZv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Jul 2019 17:25:51 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48016 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726823AbfGYVZu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Jul 2019 17:25:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PLNeNL114664;
        Thu, 25 Jul 2019 21:25:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2018-07-02; bh=IPai2xsF8E8xSd7rHvxLpxsr4++8RGXtjXBuW8FKDdI=;
 b=bUJjptgb9jsi1xR5i/+k2yqI4hICd/ObZItpq4HZoj29/J2+cN59+fIHTEYcZb6Rq8Yf
 tdQhCbQt0qjYMFhjboeThqRyt6uCTIyCdd4JJfM5UsPWv01/okzbiVTI4ggKa3jD5Dk9
 AOA5P0RV9cM+u6wW5Uhvp3FsqnD5FBf3boT8CjgHp1lJLid00FN2kzZ9HskjYqMnnYBn
 6X1YW3MPAKmt3+KXxOb3kIbF/g33W7qB8D57xZduevgahhAz4zwjEbHUv97v7qOtCo5P
 rDJqesLtXzYI6f5i5k+9odtWrMfI9CdNom8etC/RrvUECAsKUdOpH/FUBCpFcbP2f+qc Sg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2tx61c6m6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 21:25:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PLNG84066946;
        Thu, 25 Jul 2019 21:25:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2tx60yj909-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 21:25:24 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6PLPHQI022669;
        Thu, 25 Jul 2019 21:25:23 GMT
Received: from localhost.localdomain (/73.60.114.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jul 2019 14:25:17 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [RFC 0/9] padata: use unbound workqueues for parallel jobs
Date:   Thu, 25 Jul 2019 17:24:56 -0400
Message-Id: <20190725212505.15055-1-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9329 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907250257
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9329 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907250257
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Padata binds the parallel part of a job to a single CPU.  Though the
serial parts rely on per-CPU queues for correct ordering, they're not
necessary for parallel work, and it improves performance to run the job
locally on NUMA machines and let the scheduler pick the CPU within a
node on a busy system.
  
This series makes parallel padata jobs run on unbound workqueues.

Any feedback is welcome, but I'm particularly hoping for comments on the
high-level approach.

       Thanks,
          Daniel


Patch    Description
-----    -----------

    1    Make a padata instance allocate its workqueue internally.

    2    Unconfine some recently-confined workqueue interfaces.

  3-6    Address recursive CPU hotplug locking issue.

         padata_alloc* requires its callers to hold this lock, but allocating
         an unbound workqueue and calling apply_workqueue_attrs also take it.
         Fix by removing the requirement for callers of padata_alloc*.

  7-8    Add a second workqueue for each padata instance that's dedicated to
         parallel jobs.

    9    Small cleanup.


Performance
-----------

Measurements are from a 2-socket, 20-core, 40-CPU Xeon server.

For repeatability, modprobe was bound to a CPU and the serial cpumasks
for both pencrypt and pdecrypt were also restricted to a CPU different
from modprobe's.

  # modprobe tcrypt alg="pcrypt(rfc4106(gcm(aes)))" type=3
  # modprobe tcrypt mode=211 sec=1
  # modprobe tcrypt mode=215 sec=1

Busy system (tcrypt run while 10 stress-ng tasks were burning 100% CPU)

                             base                test
                             ----------------    ---------------
speedup    key_sz  blk_sz    ops/sec    stdev    ops/sec   stdev

(pcrypt(rfc4106-gcm-aesni)) encryption (tcrypt mode=211)

 117.2x       160      16        960       30     112555   24775
 135.1x       160      64        845      246     114145   25124
 113.2x       160     256        993       17     112395   24714
 111.3x       160     512       1000        0     111252   23755
 110.0x       160    1024        983       16     108153   22374
 104.2x       160    2048        985       22     102563   20530
  98.5x       160    4096        998        3      98346   18777
  86.2x       160    8192       1000        0      86173   14480

(pcrypt(rfc4106-gcm-aesni)) decryption (tcrypt mode=211)

 127.2x       160      16        997        5     126834   24244
 128.4x       160      64       1000        0     128438   23261
 127.6x       160     256        992        7     126627   23493
 124.0x       160     512       1000        0     123958   22746
 122.8x       160    1024        989       20     121372   22632
 112.8x       160    2048        998        3     112602   18287
 106.9x       160    4096        994       10     106255   16111
  91.7x       160    8192       1000        0      91742   11670

multibuffer (pcrypt(rfc4106-gcm-aesni)) encryption (tcrypt mode=215)

 242.2x       160      16       2363      141     572189   16846
 242.1x       160      64       2397      151     580424   11923
 231.1x       160     256       2472       21     571387   16364
 237.6x       160     512       2429       24     577264    8692
 238.3x       160    1024       2384       97     568155    6621
 216.3x       160    2048       2453       74     530627    3480
 209.2x       160    4096       2381      206     498192   19177
 176.5x       160    8192       2323      157     410013    9903

multibuffer (pcrypt(rfc4106-gcm-aesni)) decryption (tcrypt mode=215)

 220.3x       160      16       2341      228     515733   91317
 216.6x       160      64       2467       33     534381  101262
 217.7x       160     256       2451       45     533443   85418
 213.8x       160     512       2485       26     531293   83767
 211.0x       160    1024       2472       28     521677   80339
 200.8x       160    2048       2459       67     493808   63587
 188.8x       160    4096       2491        9     470325   58055
 159.9x       160    8192       2459       51     393147   25756

Idle system (tcrypt run by itself)

                             base                test
                             ----------------    ---------------
speedup    key_sz  blk_sz    ops/sec    stdev    ops/sec   stdev

(pcrypt(rfc4106-gcm-aesni)) encryption (tcrypt mode=211)

   2.5x       160      16      63412    43075     161615    1034
   4.1x       160      64      39554    24006     161653     981
   6.0x       160     256      26504     1436     160110    1158
   6.2x       160     512      25500       40     157018     951
   5.9x       160    1024      25777     1094     151852     915
   5.8x       160    2048      24653      218     143756     508
   5.6x       160    4096      24333       20     136752     548
   5.0x       160    8192      23310       15     117660     481

(pcrypt(rfc4106-gcm-aesni)) decryption (tcrypt mode=211)

   2.4x       160      16      53471    48279     128047   31328
   3.4x       160      64      37712    20855     128187   31074
   4.5x       160     256      27911     4378     126430   31084
   4.9x       160     512      25346      175     123870   29099
   3.1x       160    1024      38452    23118     120817   26846
   4.7x       160    2048      24612      187     115036   23942
   4.5x       160    4096      24217      114     109583   21559
   4.2x       160    8192      23144      108      96850   16686

multibuffer (pcrypt(rfc4106-gcm-aesni)) encryption (tcrypt mode=215)

   1.0x       160      16     412157     3855     426973    1591
   1.0x       160      64     412600     4410     431920    4224
   1.1x       160     256     410352     3254     453691   17831
   1.2x       160     512     406293     4948     473491   39818
   1.2x       160    1024     395123     7804     478539   27660
   1.2x       160    2048     385144     7601     453720   17579
   1.2x       160    4096     371989     3631     449923   15331
   1.2x       160    8192     346723     1617     399824   18559

multibuffer (pcrypt(rfc4106-gcm-aesni)) decryption (tcrypt mode=215)

   1.1x       160      16     407317     1487     452619   14404
   1.1x       160      64     411821     4261     464059   23541
   1.2x       160     256     408941     4945     477483   36576
   1.2x       160     512     406451      611     472661   11038
   1.2x       160    1024     394813     2667     456357   11452
   1.2x       160    2048     390291     4175     448928    8957
   1.2x       160    4096     371904     1068     449344   14225
   1.2x       160    8192     344227     1973     404397   19540


Series based on recent mainline plus these two patches:
  https://lore.kernel.org/linux-crypto/20190718150146.bztw3uugd5sqhdvk@gondor.apana.org.au/
  https://lore.kernel.org/linux-crypto/20190719190444.15143-1-daniel.m.jordan@oracle.com/

Daniel Jordan (9):
  padata: allocate workqueue internally
  workqueue: unconfine alloc/apply/free_workqueue_attrs()
  workqueue: require CPU hotplug read exclusion for
    apply_workqueue_attrs
  padata: make padata_do_parallel find alternate callback CPU
  pcrypt: remove padata cpumask notifier
  padata, pcrypt: take CPU hotplug lock internally in
    padata_alloc_possible
  padata: use separate workqueues for parallel and serial work
  padata: unbind parallel jobs from specific CPUs
  padata: remove cpu_index from the parallel_queue

 Documentation/padata.txt  |  12 +--
 crypto/pcrypt.c           | 167 ++++-------------------------------
 include/linux/padata.h    |  17 ++--
 include/linux/workqueue.h |   4 +
 kernel/padata.c           | 180 ++++++++++++++++++++++----------------
 kernel/workqueue.c        |  25 ++++--
 6 files changed, 159 insertions(+), 246 deletions(-)

-- 
2.22.0

