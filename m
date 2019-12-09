Return-Path: <SRS0=S8oY=Z7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FE23C43603
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Dec 2019 15:46:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22FAA20836
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Dec 2019 15:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575906407;
	bh=FQT5qAplvWxm9rmIcDlCpOO8ikZGnr0otysWddS45n0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=rPbQW2T7YDu9bH1H5c8Q8YEdtwZpuGwvzmXj+tSkwdz/Xwc7wt5c/hp117r6n3aeC
	 o2rB3UihwVhF/grJf+K1/k0nqIK5/h2a5ILOc3Ls4+OlYFTc+5ENxN4K7IwXD6dMfq
	 nhmAZikbbcUVuLoWh5Gjc2mkHTkJ7PJltGHhXeQY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfLIPqq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Dec 2019 10:46:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:42582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726290AbfLIPqq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Dec 2019 10:46:46 -0500
Received: from localhost (unknown [89.205.132.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 246A92080D;
        Mon,  9 Dec 2019 15:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575906405;
        bh=FQT5qAplvWxm9rmIcDlCpOO8ikZGnr0otysWddS45n0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zj8HrSPvNcD7Gau13WsrTIo/Dzr98IgmMUia2nUncuM86n4sy+IRy/wInLYaYz1vr
         VvmXXQKkhx6ms8/b+kdepoibElCA433LpSFLi91B7PebT/USq+bxzEaKSJLpiTuYsW
         NoJ9jJI/xutnWVA/JCkMYKx2uEKNyJWWi6qzFz1M=
Date:   Mon, 9 Dec 2019 16:46:42 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Kim, David" <david.kim@ncipher.com>
Cc:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "Magee, Tim" <tim.magee@ncipher.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] drivers: staging: Add support for nCipher HSM devices
Message-ID: <20191209154642.GA1285695@kroah.com>
References: <1575899815003.20486@ncipher.com>
 <20191209153310.GD1280846@kroah.com>
 <1575906111248.24322@ncipher.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1575906111248.24322@ncipher.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Dec 09, 2019 at 03:41:51PM +0000, Kim, David wrote:
> Hi Greg,
> 
> Thanks for the speedy reply. I was hoping that setting my client to
> plain text only would actually do plain text only but I will try again
> with git send-email.
> 
> This is our first driver upstreaming and we targeted staging as a
> first entry point. If you feel it's more appropriate when I re-submit
> I can go directly to drivers/crypto instead.

Well why wouldn't it go to drivers/crypto instead?  What is wrong with
it that still needs to be done?  Only stuff that needs work belongs in
drivers/staging/.

thanks,

greg k-h
