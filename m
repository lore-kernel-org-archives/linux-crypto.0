Return-Path: <SRS0=kLV/=5W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 244F0C2BA19
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Apr 2020 14:43:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA41124673
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Apr 2020 14:43:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EWz72NLZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbgDFOnW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Apr 2020 10:43:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34002 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728668AbgDFOnW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Apr 2020 10:43:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036Edpv9187576;
        Mon, 6 Apr 2020 14:43:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=3JTK6B29U9Z8C+ffRU/KrPYw+PQqhMg60N6J9Q1RZuU=;
 b=EWz72NLZfBsbfOvQ/4H3R/QJCN3jDveo6LFdK9Txyn52WaV2A/x/DBtrbSVpgkkrxmBH
 oYTtp9z7+DUr9O6pOJoTDKnNs/lzqQxA3mDdouvmMh4b38CN8pbL2H3UjFKT10DkLjNs
 nJqfXv8t1BwfM2Con/NsVO9HEHWsVxMhMXcac2o9ibp0Kt7HKmQDeU4uTQzV5lecgtiu
 Ay3XnKIfYPiYERHK7XCRf2Hh7+xKyaG8wV0QyTBskCSnZUEj/x8+eW2OMB3cS1I5k2Hd
 NgfQc59vd2WFXY+GNxYc9w4CmZVzBg3I/nffZhKoLwdNy96I/VZsDslnaPE/dkjlN+cA VA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 306hnqy9y2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 14:43:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036EhFOD088141;
        Mon, 6 Apr 2020 14:43:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3073qd91s2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 14:43:17 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 036Eh9NH013386;
        Mon, 6 Apr 2020 14:43:09 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Apr 2020 07:43:09 -0700
Date:   Mon, 6 Apr 2020 17:43:02 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     schalla@marvell.com
Cc:     SrujanaChalla <schalla@marvell.com>, linux-crypto@vger.kernel.org
Subject: [bug report] crypto: marvell - add support for OCTEON TX CPT engine
Message-ID: <20200406144302.GC68494@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9582 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 mlxlogscore=795
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004060122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9582 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 mlxlogscore=848
 lowpriorityscore=0 spamscore=0 impostorscore=0 suspectscore=3
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004060121
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello SrujanaChalla,

This is a semi-automatic email about new static checker warnings.

The patch d9110b0b01ff: "crypto: marvell - add support for OCTEON TX 
CPT engine" from Mar 13, 2020, leads to the following Smatch 
complaint:

    drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c:1300 create_engine_group()
    error: we previously assumed 'mirrored_eng_grp' could be null (see line 1256)

drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
  1255		mirrored_eng_grp = find_mirrored_eng_grp(eng_grp);
  1256		if (mirrored_eng_grp) {
                    ^^^^^^^^^^^^^^^^
The patch adds a check

  1257			/* Setup mirroring */
  1258			setup_eng_grp_mirroring(eng_grp, mirrored_eng_grp);
  1259	
  1260			/*
  1261			 * Update count of requested engines because some
  1262			 * of them might be shared with mirrored group
  1263			 */
  1264			update_requested_engs(mirrored_eng_grp, engs, engs_cnt);
  1265		}
  1266	
  1267		/* Reserve engines */
  1268		ret = reserve_engines(dev, eng_grp, engs, engs_cnt);
  1269		if (ret)
  1270			goto err_ucode_unload;
  1271	
  1272		/* Update ucode pointers used by engines */
  1273		update_ucode_ptrs(eng_grp);
  1274	
  1275		/* Update engine masks used by this group */
  1276		ret = eng_grp_update_masks(dev, eng_grp);
  1277		if (ret)
  1278			goto err_release_engs;
  1279	
  1280		/* Create sysfs entry for engine group info */
  1281		ret = create_sysfs_eng_grps_info(dev, eng_grp);
  1282		if (ret)
  1283			goto err_release_engs;
  1284	
  1285		/* Enable engine group */
  1286		ret = enable_eng_grp(eng_grp, eng_grps->obj);
  1287		if (ret)
  1288			goto err_release_engs;
  1289	
  1290		/*
  1291		 * If this engine group mirrors another engine group
  1292		 * then we need to unload ucode as we will use ucode
  1293		 * from mirrored engine group
  1294		 */
  1295		if (eng_grp->mirror.is_ena)
  1296			ucode_unload(dev, &eng_grp->ucode[0]);
  1297	
  1298		eng_grp->is_enabled = true;
  1299		if (eng_grp->mirror.is_ena)
  1300			dev_info(dev,
  1301				 "Engine_group%d: reuse microcode %s from group %d",
  1302				 eng_grp->idx, mirrored_eng_grp->ucode[0].ver_str,
                                               ^^^^^^^^^^^^^^^^^^
and an unchecked dereference.

regards,
dan carpenter
