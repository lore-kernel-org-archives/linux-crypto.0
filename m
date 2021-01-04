Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 851D8C43381
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 18:56:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4802B21D1B
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 18:56:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbhADS4x (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Jan 2021 13:56:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:49946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727403AbhADS4x (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Jan 2021 13:56:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAF7622209;
        Mon,  4 Jan 2021 18:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609786572;
        bh=rU8ZItsBhe5AObUVY5KEh9sHnNYP1ec/eXKGKRMODN0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L3HQV0Rk1X8/VAFWbU/lkiAXJOymXxhAgJWkvATzJplDwXCOfuNz5V3VcJyMsPjM5
         pfR05HSC3PI5jA6q3TFYGj9YwLeIdnPySMUr0PkR/1vUrFN8np/NJH7r7ID54wSqGu
         bXE7XyV0yCuFCYFJm9SRERaW0TK4unw8CsKnakehBQD+p9GSboYzOnVsbyCPik7xSw
         2SlIGuSVApsSyJC6/mHAE4FYwF47A7W0jzY+dYmayh5hKYW4rjMtvyY4yvLBKM9Vml
         qgKRhfNz0YcDIDtZijxWxSeS51CbSGBXyRfEEehQxPNk0en+ZpIfXCutvExc175ENy
         JZzvAhHaJrFeA==
Date:   Mon, 4 Jan 2021 10:56:11 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] random: initialize ChaCha20 constants with correct
 endianness
Message-ID: <X/NkywjTmX4JTohB@sol.localdomain>
References: <20200916045013.142179-1-ebiggers@kernel.org>
 <20200918204207.GC80112@mit.edu>
 <20200918215705.GA126697@gmail.com>
 <20201007035145.GD912@sol.localdomain>
 <20201026163354.GB858@sol.localdomain>
 <X7gQhvFIuW9W0UyK@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X7gQhvFIuW9W0UyK@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 20, 2020 at 10:52:54AM -0800, Eric Biggers wrote:
> On Mon, Oct 26, 2020 at 09:33:54AM -0700, Eric Biggers wrote:
> > On Tue, Oct 06, 2020 at 08:51:45PM -0700, Eric Biggers wrote:
> > > On Fri, Sep 18, 2020 at 02:57:05PM -0700, Eric Biggers wrote:
> > > > On Fri, Sep 18, 2020 at 04:42:07PM -0400, Theodore Y. Ts'o wrote:
> > > 
> > > Ted, any further feedback on this?  Are you planning to apply this patch?
> > > 
> > > - Eric
> > 
> > Ping.
> 
> Ping.

Ping.
