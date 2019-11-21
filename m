Return-Path: <SRS0=AlHk=ZN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 550A0C432C3
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 14:36:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BCCF206D7
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 14:36:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Nw5dU8mL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfKUOgV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Nov 2019 09:36:21 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:35586 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbfKUOgV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Nov 2019 09:36:21 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xALEXxbg176360;
        Thu, 21 Nov 2019 14:36:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=M2ZTh/ffoJTAXhTWkUwqBgK4JVTx0Aie1A5Hh2zrp78=;
 b=Nw5dU8mLhMqxRSNdgBbulrptxP5HHvrlO+8tlOEr9Oho9bPZ17gTaLcYlnXYWNM0sd9S
 TmlbtL0vz3o3aNAtf3H4cEG8Jw9cgWNNOrYpWkNy2W5oZWlwERgy5GxSpgybzSiieVQ2
 vyyxDcd9dpnIWWycfLY2Wotq9FL4vpwMduvlqtF/LiXKNRAyQhQmXjc00kK6ewKZgsuE
 sdpKYPr/mofMLC55Q4wnU+d8K5ikPNNkO3Eqdvpba49j57TBFc6YOJlSIpCXCHC9FPJM
 8huAbbZjxJjUj281dU+dSfc5brdbgPBkaNC0kAZiAfSM/jX+UlQ4WKJDELccXfEOEjtl 9w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2wa8hu4qjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Nov 2019 14:36:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xALEYZH6166676;
        Thu, 21 Nov 2019 14:36:09 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2wda0643ft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Nov 2019 14:36:09 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xALEa7Gm016867;
        Thu, 21 Nov 2019 14:36:07 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 Nov 2019 06:36:06 -0800
Date:   Thu, 21 Nov 2019 09:36:13 -0500
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/4] padata: update documentation
Message-ID: <20191121143613.xofz7dkpy7e5wtqe@ca-dmjordan1.us.oracle.com>
References: <20191120185412.302-1-daniel.m.jordan@oracle.com>
 <20191120185412.302-2-daniel.m.jordan@oracle.com>
 <20191120121634.6d989088@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120121634.6d989088@lwn.net>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911210133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911210133
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 20, 2019 at 12:16:34PM -0700, Jonathan Corbet wrote:
> This all seems fine - it's better than not doing it - but can I put in a
> request or two?
> 
>  - This document is already formatted as RST, and your changes continue
>    that.  Can we please move it to Documentation/core-api/padata.rst and
>    add it to the TOC tree there?  Then it can become part of our formatted
>    docs.
> 
>  - The padata code seems to be nicely equipped with kerneldoc comments; it
>    would be awfully nice to pull them into the document directly rather
>    than replicating the API there.  (Why does the document do that now?
>    Blame the bozo who originally wrote it :)  That would make the document
>    more complete and easier to maintain going forward.

Ok.  It would be nice to preserve the how-to aspect of the original doc as
well, in other words, the order the interfaces should be called in.  Will do
both.

> For added goodness we could stick in an SPDX tag while we're at it.

I'll use the license from padata.c/h.
