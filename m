Return-Path: <SRS0=EtZ3=SR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D02F7C10F0E
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 09:45:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 923A220833
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 09:45:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=st.com header.i=@st.com header.b="I68OXgkD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbfDOJpf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Apr 2019 05:45:35 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:65248 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725939AbfDOJpf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Apr 2019 05:45:35 -0400
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3F9g0v1007436;
        Mon, 15 Apr 2019 11:45:26 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=STMicroelectronics;
 bh=rhnaL51MjEAfzdpqmPJd2H3gyloX9bknSdJyCUcRBuQ=;
 b=I68OXgkDaxU+cgAfb3Uxk4NQTc63ZD+rYDrpx8+0Unyq0owuIai9+skZo4MK5zsdWDg+
 j/Msa2GSn9z1KQQQmEqa05LyNTkh5Pw6HCp+1sQMrba/ThG9WS8BDeydcrwoEii7scYQ
 SlG7r46dx9U6eu9VRiZGTAYS/QlN7hP0DM0ckWKJoWEo2ds3/ZVT8m0QS4ynP0pNu4pv
 PrRuTRrBp78UpquL/BMCwRD/loop9Ga3LSdSWdqtSrBUNmqZ4BtQtcpxFLO48CRLGhbb
 mRA2pYxmLm96xKwYd4AAtHtKmE5ycrVjUTy64+R8EI4cbgXPIrDXJRr8Umta5ugtPk+1 AQ== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2ru57ysfrb-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 15 Apr 2019 11:45:26 +0200
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 747F964;
        Mon, 15 Apr 2019 09:45:25 +0000 (GMT)
Received: from Webmail-eu.st.com (sfhdag7node1.st.com [10.75.127.19])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id A5E8C121A;
        Mon, 15 Apr 2019 09:45:25 +0000 (GMT)
Received: from SFHDAG7NODE2.st.com (10.75.127.20) by SFHDAG7NODE1.st.com
 (10.75.127.19) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Mon, 15 Apr
 2019 11:45:25 +0200
Received: from SFHDAG7NODE2.st.com ([fe80::d548:6a8f:2ca4:2090]) by
 SFHDAG7NODE2.st.com ([fe80::d548:6a8f:2ca4:2090%20]) with mapi id
 15.00.1347.000; Mon, 15 Apr 2019 11:45:25 +0200
From:   Lionel DEBIEVE <lionel.debieve@st.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 21/24] crypto: stm32 - Forbid 2-key 3DES in FIPS mode
Thread-Topic: [PATCH 21/24] crypto: stm32 - Forbid 2-key 3DES in FIPS mode
Thread-Index: AQHU8TTFCRuds6k4ekSq1IliwMtfUA==
Date:   Mon, 15 Apr 2019 09:45:25 +0000
Message-ID: <5e71be34-7d60-cd8b-b07f-aada7964f0b3@st.com>
References: <20190411084707.h56mz2z7jxusnr7u@gondor.apana.org.au>
 <E1hEVQU-0006oc-Sr@gondobar> <a0be98ce-da8e-8b86-59a3-4fc837496f9b@st.com>
 <20190413135058.el26hvw7y7bcldm3@gondor.apana.org.au>
In-Reply-To: <20190413135058.el26hvw7y7bcldm3@gondor.apana.org.au>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.75.127.49]
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <68A04D6019AC6D42AEFF2DAE9D125327@st.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-15_04:,,
 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/13/19 3:50 PM, Herbert Xu wrote:

> On Fri, Apr 12, 2019 at 01:36:44PM +0000, Lionel DEBIEVE wrote:
>> I was currently going to send patches around des and tdes key verificati=
on. Is there any plan
>> to do the same factorization on des key check?
> If you have the time please do because I think some single DES
> drivers are missing the weak key check.  The existing des_ekey
> function should be sufficient for the check.

ok, will try to do it in the same way you've done it for 3des using existin=
g des_ekey function.
Trying to push it this week for all impacted drivers.

- Lionel

>
>> Acked-by: Lionel Debieve<lionel.debieve@st.com>
>> Tested-by: Lionel Debieve<lionel.debieve@st.com>
> Thanks,
>=
