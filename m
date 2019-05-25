Return-Path: <SRS0=62CE=TZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6215C282E1
	for <linux-crypto@archiver.kernel.org>; Sat, 25 May 2019 01:23:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B678821848
	for <linux-crypto@archiver.kernel.org>; Sat, 25 May 2019 01:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558747383;
	bh=n6cPJCtjp3TydMggbMsgaNK5Gjn/YqNDKIWPN8zQbSI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=2Jq+RdD70D3HDiCiTWoAN4EUoemMI8sKqUGCisPX48EngHq6c4UBFGdDaV+7A17Rh
	 NUvvLW7jYeYyEXgi/v0MPNtTp+8VKS6EC3a201FM/qCca1MVPCAUlPSwy5Woc+LXEV
	 UuM2t5UuDDxdGq6MN4Q3ounRLLDcTNVHS07/8b3A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfEYBXC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 21:23:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726220AbfEYBXC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 21:23:02 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68EA5217D7;
        Sat, 25 May 2019 01:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558747381;
        bh=n6cPJCtjp3TydMggbMsgaNK5Gjn/YqNDKIWPN8zQbSI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wBXFmcLZ1o4VWkDU6nBoT5MUFQkLZkusQ/mgPfnT9Hxd1j3IYUIdJHNr0IOzQk+v3
         zY+zDfHXFUW2hGqac4qlw8oEyd4DkMyP7t9TRd2Vfy509/+yfdTcL5dilqvLkVZK/s
         PdU/zfNuJAdBrRXJFuHPxHYwhAmyHS/kPSOsLC+w=
Date:   Fri, 24 May 2019 18:22:59 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: another testmgr question
Message-ID: <20190525012258.GC713@sol.localdomain>
References: <AM6PR09MB3523CED0B1587FCBDE4095A0D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523185833.GA243994@google.com>
 <AM6PR09MB3523749B0306103E8D2D8315D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523200557.GA248378@gmail.com>
 <AM6PR09MB3523DB255516D35B595AEA50D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523234853.GC248378@gmail.com>
 <AM6PR09MB3523CFCFE42A33621FE4ACC3D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <907eb6a5-dc76-d5ee-eccf-e7bd426a0868@c-s.fr>
 <AM6PR09MB3523D9D6D249701D020A3D74D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu_Pxv97rpt7Ju0EdtFnXqp3zoYfHtm1Q51oJSGEAZmyDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_Pxv97rpt7Ju0EdtFnXqp3zoYfHtm1Q51oJSGEAZmyDA@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 24, 2019 at 11:25:52AM +0200, Ard Biesheuvel wrote:
> 
> All userland clients of the in-kernel crypto use it specifically to
> access h/w accelerators, given that software crypto doesn't require
> the higher privilege level (no point in issuing those AES CPU
> instructions from the kernel if you can issue them in your program
> directly)

Unfortunately people also use AF_ALG because they're too lazy to use a userspace
crypto library, e.g. systemd uses it for HMAC-SHA256, and iproute2 uses it for
SHA-1.

- Eric
