Return-Path: <SRS0=IdBJ=WE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4EBDC0650F
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 16:54:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 779FA2173C
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 16:54:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O0uGrzP7";
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xBpbslO0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732775AbfHHQyc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Aug 2019 12:54:32 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47870 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728289AbfHHQyc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Aug 2019 12:54:32 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x78Ggsx3013774;
        Thu, 8 Aug 2019 16:54:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=C9jaHyUKoycIogLugwiG86m+sk7Jd+CkQdnj1y9+j+k=;
 b=O0uGrzP7X5DNtOzwWilYrZzp5ALtY4d80Dq3TmMbfLUVnVGDkDKK13DdRdLI94f04Fgf
 fng6hIDM5EuhJzt3ICCjjF6e+6MtCEeBtY5oIjrJf95r+1+enlOMQKFW4GNizaivG9Pc
 lhYuEKeYZXfYUSX+bRDwVCFpID/G/QEbOh7i0L2OFglZPlG01lfTaHe3KSeaKCHxwb5D
 Klef2oZgqDDvbJwNOHgNBxGf4/dte+3Cu9/V3Dqtuu+lPzOfJpOBetyQ/0Uvbv8czIIJ
 yFdoRPC1VGNCNeU1h4tvwp4Nz67Ypaj03r6WUb6PM/jXHSO5p4oS2ueD0fFVLQkykYYL hQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=C9jaHyUKoycIogLugwiG86m+sk7Jd+CkQdnj1y9+j+k=;
 b=xBpbslO0XVXdP2lMdlzb5zAmKOTiLlareZWn/UA2VP7kubIYzrMdIrrikI7+DmZlYf6U
 fZU4O72Emd2uWVg7Zf5yJRcwLf0g6D0uJyt0AfxVfsZXSwK0dhNE+RXFc7zhpRz5piSD
 3ZRIIG6VzGbd0i57BApSZZGQRt5zO1l6mD/xiDK3eD18YKhOMa1DYgdwQiSn0YyGoLbc
 z2/PNNjdUx7Qisvn9GpOPQxegjD91jttKtw7+yBL67jSSvNG85XYnKcSQuGEC1gmVVkR
 GSLCckWONX1VyWiVwMxYT5ESAHLHG955DPi8xL/yJ3NSG6i5PrkEynhhIlObCg3Nybbn Fg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2u8hasajqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Aug 2019 16:54:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x78GXMl4044595;
        Thu, 8 Aug 2019 16:54:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2u75bxvu30-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Aug 2019 16:54:21 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x78GsK7b015927;
        Thu, 8 Aug 2019 16:54:20 GMT
Received: from [192.168.1.218] (/73.60.114.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Aug 2019 09:54:20 -0700
Subject: Re: [PATCH] padata: initialize pd->cpu with effective cpumask
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190808160535.27219-1-daniel.m.jordan@oracle.com>
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
Message-ID: <84c4dc26-856a-7641-db38-62fa62ce8034@oracle.com>
Date:   Thu, 8 Aug 2019 12:54:16 -0400
MIME-Version: 1.0
In-Reply-To: <20190808160535.27219-1-daniel.m.jordan@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9342 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=576
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908080153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9342 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=612 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908080153
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 8/8/19 12:05 PM, Daniel Jordan wrote:
> Fixes: 726e431130f3 ("padata: Replace delayed timer with immediate workqueue in padata_reorder")

Should be

	 6fc4dbcf0276 ("padata: Replace delayed timer with immediate workqueue in padata_reorder")

