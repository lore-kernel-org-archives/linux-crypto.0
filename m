Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B442C4360C
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 02:54:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70D8B2083B
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 02:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571021682;
	bh=48D0pfDlW0dTXQ+0LTb9kUDYxV/ybbQLa9dcG0RTawk=;
	h=Date:From:To:Subject:References:In-Reply-To:List-ID:From;
	b=kcDP3XwQkOoILqXkAnfsrzt3mhBy1yLsmDzHkELm7G2t7bp/mcoK2rVPMFqTxLT6W
	 sQjXC39U/f+QXgQLgGKY7D6wLXRjR2ueu3BTKgYPzf674MCgXRF9Ugs3phAiubKZmU
	 9HFb6LqqFZeTukXO4NsVy3etVI6376PySdrJ0kVU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729577AbfJNCyl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Oct 2019 22:54:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729494AbfJNCyl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Oct 2019 22:54:41 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65C082067B;
        Mon, 14 Oct 2019 02:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571021680;
        bh=48D0pfDlW0dTXQ+0LTb9kUDYxV/ybbQLa9dcG0RTawk=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=OXRIpqVQg1Exeu0pu+Je/OhmchCeOsliNGjloznVqnzNh+YGEclruCcztfx21uRXh
         nUnsPWxrDutZFAec08ZYgmgbVj9icq5badrcsClTOD8MzBkV10DRAcic8qUIavvJH2
         q7vzYBYocYKToCGksOeFLS/qRL63k26eucfLOuPk=
Date:   Sun, 13 Oct 2019 19:54:38 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-crypto@vger.kernel.org, ard.biesheuvel@linaro.org
Subject: Re: [PATCH v4 0/5] BLAKE2b generic implementation
Message-ID: <20191014025438.GB10007@sol.localdomain>
Mail-Followup-To: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-crypto@vger.kernel.org, ard.biesheuvel@linaro.org
References: <cover.1570812094.git.dsterba@suse.com>
 <20191011175739.GA235973@gmail.com>
 <20191013195052.GM2751@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191013195052.GM2751@twin.jikos.cz>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Oct 13, 2019 at 09:50:52PM +0200, David Sterba wrote:
> On Fri, Oct 11, 2019 at 10:57:40AM -0700, Eric Biggers wrote:
> > The choice of data lengths seems a bit unusual, as they include every length in
> > two ranges but nothing in between.  Also, none of the lengths except 0 is a
> > multiple of the blake2b block size.  Instead, maybe use something like
> > [0, 1, 7, 15, 64, 247, 256]?
> 
> Just to clarify, do you mean the block size defined by BLAKE2B_BLOCKBYTES?
> That's 128, so that makes 0 and 256 the multiples.

Yes.

> 
> > Also, since the 4 variants share nearly all their code, it seems the tests would
> > be just as effective in practice if we cut the test vectors down by 4x by
> > distributing the key lengths among each variant.  Like:
> > 
> >           blake2b-160  blake2b-256  blake2b-384  blake2b-512
> >          ---------------------------------------------------
> > len=0   | klen=0       klen=1       klen=16      klen=32
> > len=1   | klen=16      klen=32      klen=0       klen=1
> > len=7   | klen=32      klen=0       klen=1       klen=16
> > len=15  | klen=1       klen=16      klen=32      klen=0
> > len=64  | klen=0       klen=1       klen=16      klen=32
> > len=247 | klen=16      klen=32      klen=0       klen=1
> > len=256 | klen=32      klen=0       klen=1       klen=16
> 
> That's clever. I assume the 32 key length refers to the default key,
> right? That's 64 bytes (BLAKE2B_KEYBYTES), so I'll use that value.
> 

Yes, I meant key lengths [0, 1, 32, 64].  I forgot that BLAKE2b has a max key
length of 64 bytes rather than 32.

- Eric
