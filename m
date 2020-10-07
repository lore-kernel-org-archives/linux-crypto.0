Return-Path: <SRS0=WH6x=DO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 999FAC4363C
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Oct 2020 03:51:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52D3321481
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Oct 2020 03:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602042661;
	bh=RNFodyO24BpIYXMrNPDq0InBAX11+JUBpdE1Nim3iJk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=SwYGDDIFA1wmnErOgWXWnKwRCldwnw/NXTiW5YaQXHApjnFIwA1YLhIEmW8K4jnqq
	 36NKQaeox5PnBsxqZKby9y0ni4kqEPR8I2VISNEODu73+jurqo706wIaDb5krfRMlx
	 6UXhXg8l2FsUYohBX+HIiv+tnII7FXAJBq60Ac/A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgJGDvA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Oct 2020 23:51:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:46120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726137AbgJGDvA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Oct 2020 23:51:00 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08B80208C7;
        Wed,  7 Oct 2020 03:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602042660;
        bh=RNFodyO24BpIYXMrNPDq0InBAX11+JUBpdE1Nim3iJk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y/e1efedoOwMs+LURnzwzScfizgJh3uoQpwBocHnobgAobqORxiE7dlwgC2C9h4Nr
         eBvn75vENJdCb2ij44b/0U7hq0Pkq/CyCW30DV0h/w9cnMts6t0mzD1zT7ndt4OhQz
         gyKZtOKd01rDK+s6AoE/i4aP0B8fTa5mMbg4QDj0=
Date:   Tue, 6 Oct 2020 20:50:58 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH] random: remove dead code left over from blocking pool
Message-ID: <20201007035058.GC912@sol.localdomain>
References: <20200916043652.96640-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916043652.96640-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 15, 2020 at 09:36:52PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Remove some dead code that was left over following commit 90ea1c6436d2
> ("random: remove the blocking pool").
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Ping?
