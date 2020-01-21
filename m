Return-Path: <SRS0=kzJ7=3K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35412C2D0CE
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jan 2020 09:27:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0733324125
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jan 2020 09:27:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=seznam.cz header.i=@seznam.cz header.b="EeUMomcU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbgAUJ1k (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jan 2020 04:27:40 -0500
Received: from mxs2.seznam.cz ([77.75.76.125]:24951 "EHLO mxs2.seznam.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727360AbgAUJ1k (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jan 2020 04:27:40 -0500
Received: from email.seznam.cz
        by email-smtpc4a.ng.seznam.cz (email-smtpc4a.ng.seznam.cz [10.23.10.105])
        id 7f9a8daecac1ecbc7f93687d;
        Tue, 21 Jan 2020 10:26:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seznam.cz; s=beta;
        t=1579598787; bh=B98H5CD1TrItHXF6OHCM5qRVUqCXcpTVW1s6/kNp8NM=;
        h=Received:Reply-To:Subject:To:Cc:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=EeUMomcUvbdia5xMiMgS/ckb35431lCh8nixHcvjBtTu+akWDIIHtfpjIIqkdPWfO
         mHb+mXIlplyVziMXDJTSotOecBLgAZQm8Bm+UXXuO7eqSsOTiYpsbTe2k1WfGVsqPR
         f8b46TlZPtw0yCtNlo3bz7D7ITrE4H8W0THlTpVw=
Received: from [77.75.76.48] (unknown-62-130.xilinx.com [149.199.62.130])
        by email-relay18.ng.seznam.cz (Seznam SMTPD 1.3.108) with ESMTP;
        Tue, 21 Jan 2020 10:26:14 +0100 (CET)  
Reply-To: monstr@monstr.eu
Subject: Re: [PATCH V4 0/4] Add Xilinx's ZynqMP AES-GCM driver support
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Kalyani Akula <kalyania@xilinx.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        git <git@xilinx.com>, Harsh Jain <harshj@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Mohan Marutirao Dhanawade <mohand@xilinx.com>
References: <1574235842-7930-1-git-send-email-kalyani.akula@xilinx.com>
 <BN7PR02MB51241CCD25BD1269B4394D9AAF320@BN7PR02MB5124.namprd02.prod.outlook.com>
 <20200120075559.kra4dqdphbbnid5h@gondor.apana.org.au>
From:   Michal Simek <monstr@seznam.cz>
Message-ID: <1abdf222-9517-976e-b3d3-bfc1c92c4663@seznam.cz>
Date:   Tue, 21 Jan 2020 10:26:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200120075559.kra4dqdphbbnid5h@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

On 20. 01. 20 8:55, Herbert Xu wrote:
> On Mon, Jan 20, 2020 at 06:59:22AM +0000, Kalyani Akula wrote:
>> Hi Herbert,
>>
>> Any review comments on below patch set.
> 
> Please resubmit your patch series once you have acks for the
> non-crypto bits ready.  Please also state how you want it to
> be merged, i.e., whether only the crypto patch is meant  for
> the crypto tree or whether it needs to go in as a whole.

All these drivers which requires firmware interface extension can be
added via your tree or I can take them via arm-soc tree with your ack.

It is really up to you. I am happy to just ack patches out of crypto and
feel free to take them via your tree.
Or please let me know when you are done with review and I will take them.

Kalyani: Please fix that stuff I have reported and we are waiting for v5.

Thanks,
Michal

