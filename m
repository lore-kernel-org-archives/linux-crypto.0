From: Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH V3 6/6] crypto/nx: Add P9 NX support for 842 compression
 engine
Date: Mon, 24 Jul 2017 09:46:50 -0700
Message-ID: <20170724164650.GA5628@ram.oc3035372033.ibm.com>
References: <1500699702.23205.8.camel@hbabu-laptop>
Reply-To: Ram Pai <linuxram@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mpe@ellerman.id.au, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mikey@neuling.org, benh@kernel.crashing.org, suka@us.ibm.com,
        ddstreet@ieee.org, npiggin@gmail.com, hbabu@us.ibm.com
To: Haren Myneni <haren@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54418 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753780AbdGXQq7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jul 2017 12:46:59 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6OGiVAr073821
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jul 2017 12:46:59 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bwf5j8fq1-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jul 2017 12:46:59 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <linuxram@us.ibm.com>;
        Mon, 24 Jul 2017 10:46:58 -0600
Content-Disposition: inline
In-Reply-To: <1500699702.23205.8.camel@hbabu-laptop>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 21, 2017 at 10:01:42PM -0700, Haren Myneni wrote:
> 
> This patch adds P9 NX support for 842 compression engine. Virtual
> Accelerator Switchboard (VAS) is used to access 842 engine on P9.
> 
> For each NX engine per chip, setup receive window using
> vas_rx_win_open() which configures RxFIFo with FIFO address, lpid,
> pid and tid values. This unique (lpid, pid, tid) combination will
> be used to identify the target engine.
> 
> For crypto open request, open send window on the NX engine for
> the corresponding chip / cpu where the open request is executed.
> This send window will be closed upon crypto close request.
> 
> NX provides high and normal priority FIFOs. For compression /
> decompression requests, we use only hight priority FIFOs in kernel.
> 
> Each NX request will be communicated to VAS using copy/paste
> instructions with vas_copy_crb() / vas_paste_crb() functions.
> 

Reviewed-by: Ram Pai <linuxram@us.ibm.com>

> Signed-off-by: Haren Myneni <haren@us.ibm.com>
> ---
>  drivers/crypto/nx/Kconfig          |   1 +
>  drivers/crypto/nx/nx-842-powernv.c | 375 ++++++++++++++++++++++++++++++++++++-
>  drivers/crypto/nx/nx-842.c         |   2 +-
>  3 files changed, 371 insertions(+), 7 deletions(-)
