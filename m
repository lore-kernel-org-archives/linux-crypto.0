Return-Path: <SRS0=0IUk=SK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3219C10F14
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 18:28:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8B1C20855
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 18:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554748082;
	bh=1uwiHjEa6EotDTSkRze2ILL+rxMsqsFwdUCIYELJ91I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=hdCxioRmj2mGa85at9enhJUSaSL5hKLy0IjHAMTi9j87JGejFNLyOxcWIvjNRvHET
	 Lj8OL1Z2DSk/T2ff5kpyp7cNeybqC0mLYhO+XAa/FWd7yA4rqZexUVe1eH88CEObLD
	 3dSex6s8VHi3U/r2D2F4K6NuRc8oDST/qdLo538A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729255AbfDHS2B (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Apr 2019 14:28:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729244AbfDHS2B (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Apr 2019 14:28:01 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5311320830;
        Mon,  8 Apr 2019 18:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554748080;
        bh=1uwiHjEa6EotDTSkRze2ILL+rxMsqsFwdUCIYELJ91I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OZUOmf98oufAbWaj0vjtI1XE8vrdicnZ2su8UoRaPdjhrL6V8iEw9/Bnfd8sLfsr2
         mBaAtbR6TnoONdRK/pq0n/hRpoZOqo+DbRMKgJNoEmfVpZpPuMFpa0Vbb/Mra5GNTC
         2sSHJo6xxQfTHfTyOrlaNuXDb/duyzrx0AmaHkYk=
Date:   Mon, 8 Apr 2019 11:27:58 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Zhang Zhijie <zhangzj@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Zain Wang <wzz@rock-chips.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Olof Johansson <olof@lixom.net>,
        "ezequiel@collabora.com" <ezequiel@collabora.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Tao Huang <huangtao@rock-chips.com>
Subject: Re: [Bug] Rockchip crypto driver sometimes produces wrong ciphertext
Message-ID: <20190408182757.GD9145@gmail.com>
References: <20190126210530.GB709@sol.localdomain>
 <CAKv+Gu-RKu9jt+2FnV2529zqyLGR8RSu8r4B8eOs-7Om-pL0aQ@mail.gmail.com>
 <1894799.pWIprST79S@phil>
 <f7a0d04c-339e-d9f8-7188-a27d55ad8b4d@rock-chips.com>
 <20190315033140.GB1671@sol.localdomain>
 <AM5PR0901MB115570ABE89DC1285AE07E60D2500@AM5PR0901MB1155.eurprd09.prod.outlook.com>
 <20190404171204.GA121392@gmail.com>
 <20190407124211.fv7pjsozxhnhw56i@gondor.apana.org.au>
 <AM6PR09MB352377D3A58CE6C12464414ED2530@AM6PR09MB3523.eurprd09.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR09MB352377D3A58CE6C12464414ED2530@AM6PR09MB3523.eurprd09.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Apr 07, 2019 at 07:12:43PM +0000, Pascal Van Leeuwen wrote:
> 
> Fact is, there are at least 2 hardware device drivers NOT doing this - and
> I want to bet a nice sum of money there will be more - and that this has
> not been noticed prior to adding these tests to testmgr, otherwise this
> would have been fixed by now. Which seems to confirm that there is no
> real use case for this functionality.
> 

I really shouldn't have to say this, but just because something hasn't been
reported doesn't mean it's not a real problem.  Someone could easily be affected
by one of these bugs where crypto drivers produce the wrong output, and never
notice it because their use case doesn't involve checking the output against
another implementation.  Or, perhaps they noticed but never reported it
upstream.  Or perhaps they didn't have the time or skill to debug the problem so
just they disabled the broken driver, or used No Crypto instead.

That's why we have tests -- so bugs can be detected immediately rather than
maybe years out in the field after causing critical security vulnerabilities.

- Eric
