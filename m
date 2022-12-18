Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6361DC4332F
	for <linux-crypto@archiver.kernel.org>; Sun, 18 Dec 2022 19:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiLRT60 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 18 Dec 2022 14:58:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiLRT6Z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 18 Dec 2022 14:58:25 -0500
Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66A36256;
        Sun, 18 Dec 2022 11:58:20 -0800 (PST)
Date:   Sun, 18 Dec 2022 19:58:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail3; t=1671393496; x=1671652696;
        bh=2oBFqBrjiA5PDPVogYmMd0bS4/q8x181uUhh5QhYmJU=;
        h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
        b=l//ulm89UpfPlPFCR7HxFH2jRVD2BjN3CKyU1E3UaTUTwQA/YxmGrTuSZLVtqSWEP
         Rd+a7SacWLbVEriIZOgWexOZW+LT14FfJZ6ZZnR0REGnnp8ryb0vHBYL9I93YoFplh
         LJ1OQ2C7AhkHnQESwk/Dz3CPJjhU/WX5DLvPsGK0PphNpAh5IwUagQxy5tqeN/Fxgu
         FzRNUpmw9KWWmzZcRwd6OqUtCZur/FzAU2Z4M5pRwUuieuDMbCn0Cdl1lawRS6ZUJz
         dPVS2vO4xnUpQbVNQGCUBY8fVTlIcdL4DxY8Mq1Oaf9NKl6KVwUrmBkZP0MjrbJpDE
         SarKQ5saIdupg==
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
From:   Jari Ruusu <jariruusu@protonmail.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Announce loop-AES-v3.7z file/swap crypto package
Message-ID: <u520xqIq5scEZfm3VfvhECFSe_AaptFqf2SesPq2DtSPLsEXyAlhRrU563ISkexJb9VQcT8zi810kzAOo0hsornFu4_IdlUhFTMHf9q4-Oc=@protonmail.com>
Feedback-ID: 22639318:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

loop-AES changes since previous release:
- Worked around non-exported blk_set_default_limits() on 6.0.11+ kernels.

bzip2 compressed tarball is here:

    https://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.7z.tar.bz2
    md5sum 6ddd7d22ae53d07fe4b2b5dfa403c44e

    https://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.7z.tar.bz2.sign

--
Jari Ruusu=C2=A0 4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD=C2=A0 ACDF F073 3C=
80 8132 F189

