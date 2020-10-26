Return-Path: <SRS0=A9yi=EB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C4B6C4363A
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 16:34:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9468206FB
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 16:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603730046;
	bh=EHri3hYEviU+njTGM+r5Hk0rdGjcRneO+qgWrAqY2uA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=s2zz0v3lcFz0jlwdrP51bPAoEexGjpKZFHlCV9kQ21cegAPTkG2+rovLhwceDJZ/t
	 KGPT7NgWdICsp/n41wEdDZ6HSBDkcLqXzJekK3EPQa3Ln+gixKEcqYpL+R/2R2HsZ5
	 ARBY7qY0zOlrEy+ZaTvf8U+2d7ublaYvycL6//cA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1786065AbgJZQeF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Oct 2020 12:34:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1786063AbgJZQeE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Oct 2020 12:34:04 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 835DD205ED;
        Mon, 26 Oct 2020 16:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603730044;
        bh=EHri3hYEviU+njTGM+r5Hk0rdGjcRneO+qgWrAqY2uA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qdi1sXROHc3kEUWtUoIWRE+5w5o1iXUnOPp3yHLf92aSL/WChI1b5djqI8mTihKV7
         ugUe40CD+UVnBmkaYqzIs4aUs4gS3dQVOK226ycMxg0ZARe+qBHDOv9RaZIDKog47m
         GRndaxiEdxw7/I6qYs+emcq4BaRsbY4AK03t3mhU=
Date:   Mon, 26 Oct 2020 09:34:03 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH] random: remove dead code left over from blocking pool
Message-ID: <20201026163403.GC858@sol.localdomain>
References: <20200916043652.96640-1-ebiggers@kernel.org>
 <20201007035058.GC912@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007035058.GC912@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 06, 2020 at 08:50:58PM -0700, Eric Biggers wrote:
> On Tue, Sep 15, 2020 at 09:36:52PM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Remove some dead code that was left over following commit 90ea1c6436d2
> > ("random: remove the blocking pool").
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Ping?

Ping.
