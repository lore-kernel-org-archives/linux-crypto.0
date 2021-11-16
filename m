Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 649B5C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 15:21:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45ACB61BFE
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 15:21:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237917AbhKPPYC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Nov 2021 10:24:02 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:50520 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237827AbhKPPYC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Nov 2021 10:24:02 -0500
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AGDcCsf017657;
        Tue, 16 Nov 2021 16:20:41 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=selector1;
 bh=QoQgYbIAYqqyndy0lpMG3AWVrk68VVjTmBAW9B7ADps=;
 b=Fc5c0QCnFHbqDnhYoeNR2fBkRjdgcJ8PhXDr+lPVffNKwrhbNStOGymy20c11kfkOMsn
 FJz65/diglwzHLsF4OPc+3P00RCuw7ewUV4/NO64rN2HRWTp1lw7up/TIh/I9iZw6Ukf
 3BhTEnHRzO/Iy0/0KOs1Yjb+n78uDbgnbz43D0I3DvDLtXDPI7zSA+v9aIhlOlvL/4PJ
 NfV3cUOmGyHoBsoO/jd12B5O19sBgcpkcIxOJJpQKhYKNsGC3182+ZD5Unwrww5KXGVG
 1KHULA/l6pAz+VEPcGue4z2Y8UyQVNKBnmh3F8yh8+21upvJWzL8iVWFkCMdDobmnn/0 5g== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3cc2u453x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Nov 2021 16:20:41 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 62BE210002A;
        Tue, 16 Nov 2021 16:20:39 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag2node2.st.com [10.75.127.5])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 1E2762350F0;
        Tue, 16 Nov 2021 16:20:39 +0100 (CET)
Received: from gnbcxd0088.gnb.st.com (10.75.127.46) by SFHDAG2NODE2.st.com
 (10.75.127.5) with Microsoft SMTP Server (TLS) id 15.0.1497.26; Tue, 16 Nov
 2021 16:20:38 +0100
Date:   Tue, 16 Nov 2021 16:20:28 +0100
From:   Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
X-X-Sender: toromano@gnbcxd0088.gnb.st.com
To:     Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Marek Vasut <marex@denx.de>, Ard Biesheuvel <ardb@kernel.org>,
        <linux-crypto@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 7/8] crypto: stm32/cryp - fix bugs and crash in
 tests
In-Reply-To: <20211102164729.9957-8-nicolas.toromanoff@foss.st.com>
Message-ID: <alpine.DEB.2.21.2111161614500.27385@gnbcxd0088.gnb.st.com>
References: <20211102164729.9957-1-nicolas.toromanoff@foss.st.com> <20211102164729.9957-8-nicolas.toromanoff@foss.st.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
X-Originating-IP: [10.75.127.46]
X-ClientProxiedBy: SFHDAG1NODE3.st.com (10.75.127.3) To SFHDAG2NODE2.st.com
 (10.75.127.5)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-16_03,2021-11-16_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


Hello,

> +static void stm32_cryp_write_ccm_first_header(struct stm32_cryp *cryp)
> +{
> [...]
> +	} else {
> +		/* Build the two first u32 of B1 */
> +		b8[0] = 0xFF;
> +		b8[1] = 0xFE;
> +		b8[2] = alen & 0xFF000000 >> 24;
> +		b8[3] = alen & 0x00FF0000 >> 16;
> +		b8[4] = alen & 0x0000FF00 >> 8;

Smatch found a bug here: "warn: shift has higher precedence than mask"

Regards,
Nicolas.
