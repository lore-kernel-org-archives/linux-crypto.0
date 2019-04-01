Return-Path: <SRS0=dn2r=SD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04E55C43381
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Apr 2019 12:12:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30EEE2082C
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Apr 2019 12:12:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="S0x8H4Q1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbfDAMMp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Apr 2019 08:12:45 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.218]:22001 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbfDAMMp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Apr 2019 08:12:45 -0400
X-Greylist: delayed 742 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Apr 2019 08:12:44 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1554120763;
        s=strato-dkim-0002; d=chronox.de;
        h=Message-ID:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=Jjk4B17o64PyBrO0J5FIFA5ZcalxlXbHEBncBetjHns=;
        b=S0x8H4Q1UokbNZh4C3U50LdzRxgOXy/qfh1Iin+wNpVJzPo+7mLpmm6XDq2mDVdKR1
        vikqBL50C9GmDdC01cRByYDR6D3PPnKKVVBV+eM4YGg9qjknOmx6bvCbJ3t0O/52r+Ib
        GIcNjBhZGvkxLsa8dAenOw6hTj3MMLvQfJkrCD9mxQMSoq1fj7q+MhhpTMduZPqwUG+w
        UL6g2MYvRbcryHOs1/yaicaVz0q2Hki9v4dxu6pEN15jriKYaySOwDDMzQppQadeuOs6
        tb6uiwJkXPcOqp3L2mVb5KL73fyK5S7N4DGnByBURiHQV8UxKYN/DvzELzxquJiEpgDE
        FQJA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZIPSflnpF"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 44.18 DYNA|AUTH)
        with ESMTPSA id 205f78v31C0IcKf
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Mon, 1 Apr 2019 14:00:18 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     linux-crypto@vger.kernel.org
Subject: Block layer does not call add_disk_randomness any more
Date:   Mon, 01 Apr 2019 14:00:17 +0200
Message-ID: <2962106.tn8mTOXXUR@tauon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ted,

With the transition to 5.0, blk_update_bidi_request has been removed. This 
function used to call add_disk_randomness. I see no replacement in the block 
layer any more.

Thus, add_disk_randomness is now only invoked from the SCSI layer with 5.0. Is 
that intended?

Ciao
Stephan


