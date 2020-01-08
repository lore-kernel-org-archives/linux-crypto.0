Return-Path: <SRS0=xmdE=25=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ABB5C00523
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jan 2020 05:34:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CD7D20705
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jan 2020 05:34:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="resmubHV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbgAHFeb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jan 2020 00:34:31 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:44188 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgAHFeb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jan 2020 00:34:31 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0085Tp0H073092;
        Wed, 8 Jan 2020 05:34:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=N5tW9u6pMrtps+tsGYVekJ1wu4ABNOosTV0FBCKGqr8=;
 b=resmubHVnn1Ws9KdcVspIXKT3KxfWPXwmBo7iW3rk/RnVDTbWjguwdHjM3SzmPj/Ds6E
 tCs+GDi56t/BII5QCYTdY+DSIyCLwTEa1BQq9S1BCITwqvuEcJZ0Z3v7iYXmw466R53T
 q44ycGTWhF6F3N0EAm8Y6s38gOJurVbafuJhdT3QaeKzV69mT3WV/vub1wBGZJJipY1x
 RpJBQcvy6X1dsoINY5ACQESGa+N2YxUQtwrGOqUt75RGoAxZZj4gYENwjy65+KNTAmKJ
 PYcvLruPTlk033ZVcRq7xMY2WJUYr2KNJ2Ob6pKgGMHLOMkCixTQqmqxxm0722HyZrfD kQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xajnq1mu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jan 2020 05:34:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0085YIhp010446;
        Wed, 8 Jan 2020 05:34:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2xcpcrvfwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jan 2020 05:34:22 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0085Xx55010545;
        Wed, 8 Jan 2020 05:33:59 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jan 2020 21:33:59 -0800
Date:   Wed, 8 Jan 2020 08:33:53 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Janakarajan.Natarajan@amd.com
Cc:     linux-crypto@vger.kernel.org
Subject: [bug report] crypto: ccp - Add DOWNLOAD_FIRMWARE SEV command
Message-ID: <20200108053353.tkx2vqya6l3oeovc@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=776
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001080048
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=837 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001080048
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello Janakarajan Natarajan,

The patch edd303ff0e9e: "crypto: ccp - Add DOWNLOAD_FIRMWARE SEV
command" from May 25, 2018, leads to the following static checker
warning:

	drivers/crypto/ccp/sev-dev.c:530 sev_update_firmware()
	error: uninitialized symbol 'error'.

drivers/crypto/ccp/sev-dev.c
   522          data = page_address(p);
   523          memcpy(page_address(p) + data_size, firmware->data, firmware->size);
   524  
   525          data->address = __psp_pa(page_address(p) + data_size);
   526          data->len = firmware->size;
   527  
   528          ret = sev_do_cmd(SEV_CMD_DOWNLOAD_FIRMWARE, data, &error);
                                                                  ^^^^^^
If "psp_dead" is already true then error isn't set.

   529          if (ret)
   530                  dev_dbg(dev, "Failed to update SEV firmware: %#x\n", error);
   531          else
   532                  dev_info(dev, "SEV firmware update successful\n");
   533  
   534          __free_pages(p, order);


regards,
dan carpenter
