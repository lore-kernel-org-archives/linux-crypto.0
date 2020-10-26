Return-Path: <SRS0=A9yi=EB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA69C4363A
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 16:33:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D98DA2224A
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 16:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603730037;
	bh=bWoNngAufiPIkjmarMtBMPFzySoJrh+DrRGpysC4MY8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=U9p8dyqJVVR9zBLjqxJfUwYNSA8pHjcnDZLeE7Mncyznvrmp+PLEOxeGD08YRuJSk
	 9w55TpxAVxlJsXrI2KAPRcHutGNuO4PyZhgsbMRz97Or1qxpefjNda+U5NL9PBlP8B
	 siyOpGlj3TILFVFUjEKawUbNjhP8R2hAFdWJqCxY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1786055AbgJZQd5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Oct 2020 12:33:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1420671AbgJZQd4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Oct 2020 12:33:56 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AE63205ED;
        Mon, 26 Oct 2020 16:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603730036;
        bh=bWoNngAufiPIkjmarMtBMPFzySoJrh+DrRGpysC4MY8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r8+OGZGK3tF65qryZdcaBl7eaZ7kySP9E1kTyIUN/dEK9j4zeyONQrbhPU2CtgrT0
         hT23WoJI3fYTEsxOODh4xyqAgfEvsYBn5366csXMJRR5kL8oHlWMEDMtS3Tyel2mOP
         MO+MdWKraAdASnyQStKwzKmId05aSpAo8UI7Km84=
Date:   Mon, 26 Oct 2020 09:33:54 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] random: initialize ChaCha20 constants with correct
 endianness
Message-ID: <20201026163354.GB858@sol.localdomain>
References: <20200916045013.142179-1-ebiggers@kernel.org>
 <20200918204207.GC80112@mit.edu>
 <20200918215705.GA126697@gmail.com>
 <20201007035145.GD912@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007035145.GD912@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 06, 2020 at 08:51:45PM -0700, Eric Biggers wrote:
> On Fri, Sep 18, 2020 at 02:57:05PM -0700, Eric Biggers wrote:
> > On Fri, Sep 18, 2020 at 04:42:07PM -0400, Theodore Y. Ts'o wrote:
> 
> Ted, any further feedback on this?  Are you planning to apply this patch?
> 
> - Eric

Ping.
